local folder "$root\FromFelipe"
********************************************************************************
***************** 1. Merging with nces lea information *************************
********************************************************************************
*Enrollment - source: https://nces.ed.gov/ccd/files.asp#Fiscal:2,LevelId:5,SchoolYearId:32,Page:1   scroll down membership
import delimited "$Input\NCES CCD\ccd_lea_052_1718_l_1a_083118.csv", clear
drop if grade=="Adult Education" | grade =="Kindergarten" | grade =="No Category Codes" | grade =="Not Specified" | grade =="Pre-Kindergarten" | grade =="Ungraded"
keep if sex == "Female" | sex=="Male" | sex =="Not Specified"
*table grade sex, c(sum student_count) row col
drop school_year statename
rename (fipst st)(statefips state)

gcollapse (sum) student_count, by(statefips state lea_name leaid)  /*options: grade / sex / ethnicity, race*/
bysort state: gegen state_enroll = sum(student_count)
gen enroll_shr = student_count/state_enroll
tempfile Enrollment
save `Enrollment'
save "$Input\NCES CCD\LEA_Enrollment.dta", replace
gcollapse (mean) state_enroll, by(state)
save "$Input\NCES CCD\State_Enrollment.dta", replace
**********************************************************
use using "$Input\StackedClosures_Mar23.dta", clear

merge 1:1 leaid using "$Input\NCES CCD\LEA_Enrollment.dta"
bysort leaid: gen count=_n==1
tab count if _merge==1 /*172 districts closing early w/o info: CA23; TX3 NY29)*/
tab state if _merge==1
tab count if _merge==3 /*1039 districts closing early with info: CA158; TX 154l NY144)*/
tab state if _merge==3
keep if _merge==3
drop DatesClosed _merge CurrentStatus statefips
order state distclose_date student_count state_enroll enroll_shr 
sort state distclose_date

save "$root\FromFelipe\Closed_SchoolsDist.dta", replace
sum student_count if distclose<=td(13mar2020)
return list
/* 197 districts
- r(sum) 1909304  students off by march13
*/
sum student_count
return list
/* 1,677 districts
- r(sum) 9067416  students off by march13
*/
********************************************************************************
***************** 2. Compare to state policy *************************
********************************************************************************
import excel "$root\FromFelipe\\EdWeek_UW_Validation\ResolvingAcrossDifferentSources_v2.xlsx", sheet("StateClosingVariable") clear firstrow
drop  D E
format %td stclose_date
merge 1:m state using "$root\FromFelipe\Closed_SchoolsDist.dta"
* tab state if _merge==1 --> no early school closure states
drop if state=="AS" | state=="BI" | state=="GU" | state=="VI" | state==""

capture drop pct_studoff studoff stclose_date2
sort state distclose_date
*bound at the state level
gen pct_studoff=1 if stclose_date<=distclose_date | distclose_date==.
gen studoff=state_enroll if stclose_date<=distclose_date | distclose_date==.

sort  state  stclose_date distclose_date
order state  stclose_date distclose_date student_count studoff state_enroll pct_studoff 

gen 	stclose_date2=stclose_date if stclose_date>=distclose_date 
format %td 			  stclose_date2
order state stclose_date stclose_date stclose_date2
******************* Change on April 12
bysort state: replace stclose_date2=distclose_date if distclose_date<stclose_date

local st_early "AK AR AZ CA CO CT DC GA IA ID IL IN KS KY MA ME MI MN MO MS NC NE NH NJ NY OH OK PA SD TN TX UT VA WA WI WY" 
loc st "CA"
foreach st of loc st_early{
	tab stclose_date2 if state=="`st'", matrow(A)
	local rows =rowsof(A)
	local i = 1
	forvalues i=1/`rows'{
		local dt = A[`i',1]
		sum student_count if state=="`st'" & stclose_date2<=`dt'
		local stud = r(sum)
		replace studoff = `stud' if state=="`st'" & stclose_date2<=`dt' & studoff==.
	}
}

* Review - per early before March 13
* From EdWeek District   - 197 School Districts   - 1,909,304 students
sum student_count if distclose_date<=td(13mar2020)
return list

* Review - per early School Dist before State Mandate
* From EdWeek District   - 1,352 School Districts - 8,003,767 students
sum student_count if distclose_date<stclose_date
return list

replace pct_studoff=studoff/state_enroll if pct_studoff==.
sum distclose
loc strt = r(min)
loc end =r(max)
encode state, gen(st2)

drop stclose_date2
sort state distclose_date
************************************ Up to here State.do and this file are the same
drop _merge
merge m:1 state using "$Input\NCES CCD\State_Enrollment.dta"
* _merge==2 /*state==AS BI GU VI*/
keep if _merge==3
drop _merge
save "$root\FromFelipe\\SchoolDist_Closures.dta", replace
********************************************************************* Back to all Enrollment*
************* 3. School District Incomplete panel *******************************************
*********************************************************************************************
use "$root\FromFelipe\\SchoolDist_Closures.dta", replace
merge 1:1 leaid lea_name state using "$Input\NCES CCD\LEA_Enrollment.dta"
drop if state=="BI" | state=="AS" | state=="GU" | state=="VI"
* _merge==1 /*States only*/ _merge==2 /*All other LEAs*/
drop _merge
sort leaid student_count

drop st2
encode state, gen(st2)
tab st2, matrow(ST)
gen stclose_date2=.
loc stts = rowsof(ST)

loc st=1
forvalues st = 1/`stts'{
	sum stclose_date if st2==ST[`st',1]
	replace stclose_date2 = r(mean) if st2==ST[`st',1]

	sum statefips if st2==ST[`st',1]
	replace statefips = r(mean) if st2==ST[`st',1]
}
drop stclose_date
rename stclose_date2 stclose_date

keep leaid lea_name stclose_date distclose_date student_count state_enroll enroll_shr state statefips Statename

format %td stclose_date

sort state leaid

order leaid lea_name state statefips stclose_date distclose_date student_count  state_enroll enroll_shr state statefips Statename

sort statefips
by statefips: replace Statename = Statename[_n-1] if Statename ==""
gsort -state
replace Statename = Statename[_n-1] if Statename ==""
sort statefips 
drop if leaid==.

* Review - per early before March 13
* From EdWeek District   - 197 School Districts   - 1,909,304 students
sum student_count if distclose_date<=td(13mar2020)
return list

* Review - per early School Dist before State Mandate
* From EdWeek District   - 1,352 School Districts - 8,003,767 students
sum student_count if distclose_date<stclose_date
return list
save "$root\FromFelipe\SchoolDist_Closures_v2.dta", replace



