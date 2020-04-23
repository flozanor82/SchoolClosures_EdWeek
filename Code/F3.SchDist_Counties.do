***************************************************************************************
************************ 1. School District Closures **********************************
***************************************************************************************
use "$root\FromFelipe\SchoolDist_Closures_v2.dta", clear
***** Districts w/o Early Closures panel
sum distclose_date
loc start = r(min)
loc end = r(max)

preserve
	keep if distclose_date==.
	gen date = .
	gen students_off = .
	tempfile NoEarly
	save `NoEarly'
	
	forvalues dt = `start'(1)`end'{
		use `NoEarly', clear
		replace date =`dt'
		replace students_off = 0 if date<stclose_date 
		replace students_off = 1 if date>=stclose_date 
		tempfile NE_`dt'	
		save `NE_`dt''	
	}
restore

preserve
	keep if distclose_date==.
	gen date = .
	gen students_off = .
	
	forvalues dt = `start'(1)`end'{	
		append using   `NE_`dt''	
	}
	drop if  date==.
	sort leaid date
	order leaid date students_off stclose_date 
	tempfile NE_Final
	save `NE_Final'
restore

***** Districts with Early Closures panel
preserve
	keep if distclose_date!=.
	gen date = .
	gen students_off = .
	tempfile EarlyDist
	save `EarlyDist'
	
	forvalues dt = `start'(1)`end'{
		use `EarlyDist', clear
		replace date =`dt'
		replace students_off = 0 if date< distclose_date 
		replace students_off = 1 if date>=distclose_date	
		tempfile ED_`dt'	
		save 	`ED_`dt''	
	}
restore

preserve
	keep if distclose_date!=.
	gen date = .
	gen students_off = .
	
	forvalues dt = `start'(1)`end'{	
		append using   `ED_`dt''	
	}
	drop if  date==.
	tempfile ED_Final
	save 	`ED_Final'
restore

use `ED_Final', clear
append using `NE_Final'
rename students_off dist_off
format %td date
sort leaid date
order leaid date student_count stclose_date distclose_date

preserve
keep if date==td(23mar2020)
replace date=.
tempfile appd
save `appd'
restore  

****Data now bounded by school closures dates. Now up to state closures plus 5 (Apr 8)
sum date
local strt = r(max) + 1
sum stclose_date
local end = r(max) + 5

local t=21998
forvalues t = `strt'(1)`end'{
append using `appd'
replace date = `t' if date==.
replace dist_off=1 if date>=stclose_date 
}
sort leaid date
save "$root\FromFelipe\SchoolDist_daily.dta", replace
***************************************************************************************
************************ 1. SEDA Step **********************************
***************************************************************************************
use "$root\SEDA\seda_crosswalk_v30_smaller_just2vars.dta", clear
rename leaid_orig leaid
replace countyid16 = int(countyid16)
merge 1:m leaid using "$root\FromFelipe\SchoolDist_daily.dta"

/*This numbers crom from merging SEDA with SchoolDist_Closures*
* Review - Districts lost to the lack of info out of 1677 total  
* From EdWeek District   - 29 School Districts   - 1858 students
sum student_count if _merge==2  
return list
* Review - Districts lost to the lack of info out of 197 before Mar13
* From EdWeek District   - 0 School Districts   -  0 students
sum student_count if _merge==2  & distclose_date<=td(13mar2020)
return list

* Review - Districts lost to the lack of info out of 1,352 with closing dates before state
* From EdWeek District   -3 School Districts   - 605 students
sum student_count if _merge==2  & distclose_date<stclose_date
return list*/

drop if leaid==. 

bysort leaid: gen count_sd=_n==1
count if count_sd==1  /*17642 School districts*/
count if count_sd==1 & _merge==1  /*329 Sch Dist only in SEDA*/
drop if _merge==1
count if count_sd==1 & _merge==2  /*582 Sch Dist only in NCES*/
count if count_sd==1 & _merge==3  /*16,732 Sch Dist in both*/

count if count_sd==1 & countyid==.  /*693 sch dist w/o county*/
count if count_sd==1 & countyid==. & distclose!=. /*29 sch dist w/o county with EdWeek info and no county*/
count if count_sd==1 & countyid==. & distclose<=td(13mar2020) /*0 sch dist w/o county with EdWeek info and no county*/
count if count_sd==1 & countyid==. & distclose<stclose_date /*3 sch dist w/o county with EdWeek info and no county*/

drop _merge count_sd

/*3 sch dist w/o county with EdWeek info and no county*/
replace countyid16=31015 if state=="NE" & lea_name=="BOYD COUNTY SCHOOLS"
replace countyid16=36061 if state=="NY" & lea_name=="NEW YORK CITY CHARTER SCHOOL OF THE ARTS"
replace countyid16=48201 if state=="TX" & lea_name=="A+ UNLIMITED POTENTIAL"
/*GA & IN-- From : https://nces.ed.gov/ccd/schoolsearch/school_detail.asp*/
replace countyid16=13063 if state=="GA" & leaid==1300232  /*Clayton County*/
replace countyid16=13021 if state=="GA" & leaid==1300239  /*Bibb County*/
replace countyid16=18097 if state=="IN" & leaid==1800098  /*Marion County*/
replace countyid16=18057 if state=="IN" & leaid==1800106  /*Hamilton County*/
replace countyid16=18057 if state=="IN" & leaid==1800179  /*Hamilton County*/
replace countyid16=18057 if state=="IN" & leaid==1800186  /*Hamilton County*/

gegen county_enroll = sum(student_count), by(state countyid16 date)

gsort state leaid -countyid16 date
order state leaid countyid16 date stclose_date distclose_date student_count dist_off county_enroll

*****************************************************************************************
*************************** 3. Merge to School Contribution ***************************
*****************************************************************************************
sort leaid date
**** Include School information
merge 1:1 leaid date using "$Input\schools_only\Schools_Contrib_2SchDist.dta"						  
gsort leaid -date
foreach var of varlist countyid16 stclose_date distclose_date student_count dist_off statefips  county_enroll state_enroll enroll_shr {
	qui replace `var' = `var'[_n-1] if _merge==2 & `var'==.   /*for leaid==5305910 that had closures since late Feb*/
}
gsort leaid date
gen students_off=student_count if dist_off==1
replace students_off=0 if students_off==.
order leaid countyid16 date student_count county_enroll students_off Enroll2 stclose_date distclose_date
gegen sch_earlyclose2=mean(sch_earlyclose), by(leaid date)
drop sch_earlyclose
rename sch_earlyclose2 sch_earlyclose

gen students_off2 = students_off + Enroll2 if Enroll2!=.
replace students_off2 = students_off if students_off2 ==.

rename Enroll2 studoff_onlysch
rename students_off studoff_onlydist 
rename students_off2 students_off
gen students_off_pct = students_off / student_count

order leaid lea_name state statefips Statename countyid16 date student_count county_enroll students_off students_off_pct sch_earlyclose dist_off stclose_date distclose_date 
lab var leaid 		"LEA NCES ID"
lab var lea_name 	"LEA Name"
lab var state 		"State 2L abbreviation"
lab var statefips 	"State FIPS code"
lab var Statename 	"State name"
lab var countyid16 "County FIPS code"
lab var student_count "LEA enrollment"
lab var county_enroll "County enrollment"
lab var students_off "Number of students from the LEA not attending school in the date"
lab var students_off_pct "% of students from the LEA not attending school in the date"
lab var sch_earlyclose "No. schools in LEA with earlier than LEA closures"
lab var dist_off 		"After LEA closure==1"
lab var stclose_date 	"State closure date"
lab var distclose_date 	"LEA closure date"
lab var studoff_onlydist 	"Students affected do to LEA or State closure"
lab var studoff_onlysch 	"Students affected do to early School closure only"
lab var state_enroll 	"State Enrollment"
lab var enroll_shr 		"Share on state's enrollment"
replace sch_earlyclose=0 if   sch_earlyclose==.
drop _merge

compress
*****************************************************************************************
*************************** 4. SD/LEA and County files  ***************************
*****************************************************************************************
save "$root\FromFelipe\SchoolDist_daily_ctyfp.dta", replace 
sum students_off studoff_onlyd studoff_onlys
*****************************************************************************************
use  "$root\FromFelipe\SchoolDist_daily_ctyfp.dta", clear
gen dist_earlyclose = 1 if distclose_date<stclose_date
sort leaid date
gcollapse (sum) students_off studoff_onlyd studoff_onlys dist_earlyclose sch_earlyclose (mean) county_enroll, by(state statefips countyid16 stclose_date date)
gen cty_studoff_pct = students_off / county_enroll
gen cty_studoff2_pct = studoff_onlyd / county_enroll
gen P_before = cty_studoff2_pct>=.5
gen P_now = cty_studoff2_pct>=.5

sort countyid16 date
order state statefips countyid16 date
compress
drop P_before P_now 

lab var students_off 		"Number of students from the LEA not attending school in the date"
lab var studoff_onlydist 	"Students affected do to LEA or State closure"
lab var studoff_onlysch 	"Students affected do to early School closure only"
lab var dist_earlyclose		"No. LEAs closing earlier than state in county"
lab var sch_earlyclose 		"No. Schools in county with earlier than LEA closures"
lab var county_enroll 		"County enrollment"
lab var cty_studoff_pct	"Percentage of enrolled students affected by closure in county"
drop 	cty_studoff2_pct
save "$root\FromFelipe\Clean Files\County_daily.dta", replace




