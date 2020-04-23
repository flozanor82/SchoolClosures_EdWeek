*******************************************************************************
*********** 1 - State Policies and Merge into School District Info ************
*******************************************************************************
import excel "$root\FromFelipe\EdWeek_UW_Validation\ResolvingAcrossDifferentSources_v2.xlsx", sheet("StateClosingVariable") clear firstrow
drop  D E
format %td stclose_date
merge 1:m state using "$root\FromFelipe\Closed_SchoolsDist.dta"
* tab state if _merge==1 --> no school closure states
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
*******************************************************************************
*********** 2 - Panel of States and NCES Merger ************
*******************************************************************************
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
************************************ Up to here District_County.do and this fiel are the same
gcollapse (mean) studoff pct_studoff state_enroll, by(st2 state stclose_date distclose_date)
replace distclose_ = stclose_ if distclose==.
rename  distclose_ date
tsset st2 date
tsfill, full

gegen stclose_date2 = mean(stclose_date), by(st2)
drop stclose_date
rename stclose_date2 stclose_date
format %td stclose_date

sort st2 date
bysort st2: replace state=state[_n-1] if state==""
bysort st2: replace studoff=studoff[_n-1] if studoff==.
bysort st2: replace pct_studoff=pct_studoff[_n-1] if pct_studoff==.

gsort st2 -date
bysort st2: replace state=state[_n-1] if state==""
replace  studoff=0 if studoff==.
replace  pct_studoff=0 if pct_studoff==.

sum studoff if date==td(13mar2020)
return list
* 1909304
sort st2 date

drop state_enroll 
merge m:1 state using "$Input\NCES CCD\State_Enrollment.dta"
keep if _merge==3
drop _merge
replace studoff = state_enroll if date>=stclose_date
replace pct_studoff = 1 if date>=stclose_date
sort state date

gen     week_end = td(7mar2020)  if date<=td(7mar2020)
replace week_end = td(14mar2020) if date>td(7mar2020)  & date<=td(14mar2020)
replace week_end = td(21mar2020) if date>td(14mar2020) & date<=td(21mar2020)
replace week_end = td(28mar2020) if date>td(21mar2020) & date<=td(28mar2020)
format %td week_end 

gen     stclose_week = td(7mar2020)  if stclose_date<=td(7mar2020)
replace stclose_week = td(14mar2020) if stclose_date>td(7mar2020)  & stclose_date<=td(14mar2020)
replace stclose_week = td(21mar2020) if stclose_date>td(14mar2020) & stclose_date<=td(21mar2020)
replace stclose_week = td(28mar2020) if stclose_date>td(21mar2020) & stclose_date<=td(28mar2020)
format %td stclose_week

****Data now bounded by school closures dates. Now up to state closures plus 5 (Apr 8)
preserve
keep if date==td(23mar2020)
replace date=.
tempfile appd
save `appd'
restore  

sum date
local strt = r(max) + 1
sum stclose_date
local end = r(max) + 5

local t=21998
forvalues t = `strt'(1)`end'{
append using `appd'
replace date = `t' if date==.
replace pct_studoff=1 if date>=stclose_date 
replace studoff=state_enroll if date>=stclose_date 
}
********************************************************************
*********** 3 - Merge to School Level contribution only ************
********************************************************************
merge 1:1 state date using "$Input\schools_only\Schools_Contrib_2Stt.dta"
replace st2=49 if _merge==2
gsort state -date
foreach var of varlist stclose_date state_enroll week_end stclose_week {
	replace `var' = `var'[_n-1] if _merge==2 & `var'==.   /*for leaid==5305910*/
}
drop _merge
replace studoff=0 if studoff==.
replace pct_studoff=0 if pct_studoff==.
gen studoff2= studoff + Enroll2
replace studoff2 = studoff if studoff2==. 
gen pct_studoff2= studoff2/state_enroll
drop studoff pct_studoff
rename (studoff2 pct_studoff2)(studoff pct_studoff)

drop if date==td(7mar2020)  | date==td(8mar2020)  | ///
		date==td(14mar2020) | date==td(15mar2020) | ///
		date==td(21mar2020) | date==td(22mar2020) | ///
		date==td(28mar2020) | date==td(29mar2020) | ///
		date==td(4apr2020) | date==td(5apr2020)

lab var st2 "State Abbrviation numerically coded"
lab var state "State 2L abbreviation"
lab var stclose_date 	"State closure date"
lab var state_enroll 	"State Enrollment"
lab var week_end "Matches UI Claims weekly variable"
lab var stclose_week "Matches state closure to the weekly time variable"
drop Enroll2 sch_earlyclose
	
compress
save "$root\FromFelipe\Clean Files\State_daily.dta", replace 
********************************************************************
*********** 3 - Merge to School Level contribution only ************
********************************************************************
/*This is the file to link to other education data updated up to Mar 28*/ 				
*****************************************************************
use "$root\FromFelipe\Clean Files\State_daily.dta", replace
tab stclose_date if state=="AL"
tab stclose_date if state=="WY"
tab stclose_date if state=="ME"
tab stclose_date if state=="IA"

gcollapse (mean) studoff pct_studoff stclose_date stclose_week, by(state week_end)

replace stclose_week=td(28mar2020) if state=="IA"  /* 97.3% as of Mar 28 - April 3*/ 
replace stclose_week=td(28mar2020) if state=="NE"  /* 99.9% as of Mar 28 - April 3*/

 /*This is the file to link to other education data updated up to Mar 28*/ 
save "$root\FromFelipe\Clean Files\State_SchoolClosures.dta", replace  


