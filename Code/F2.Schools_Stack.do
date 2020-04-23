******************************************** NCES School File 
import delimited "$Input\NCES CCD\ccd_sch_029_1819_w_0a_04082019.csv", clear 
duplicates report ncessch
save "$Input\NCES CCD\NCES_Schools.dta", replace
**********************************************************
import excel "$root\FromFelipe\EdWeek_UW_Validation\ResolvingAcrossDifferentSources_v2.xlsx", sheet("StateClosingVariable") clear firstrow
drop  D E
format %td stclose_date
save "$root\FromFelipe\Clean Files\State_Policy.dta", replace
******************************************************/
******* 1. APPEND FILES AT SCH LEV ED WEEK ***********
******************************************************
local folder "$root\FromFelipe\"
import excel "$Input\coronavirus-school-closures-3.14.2020-v1.xlsx", sheet("Infogram W NCES") firstrow clear
drop if SchoolName==""
drop if SchoolName=="0"
gen file=14
tempfile Mar14File
save `Mar14File'

import excel "$Input\coronavirus-school-closures-data-3.13.20-v3.xlsx", sheet("Infogram") firstrow clear
drop if SchoolName==""
drop if SchoolName=="0"
tostring Enrollment, replace 
gen file=13
append using `Mar14File'
gsort -file
duplicates drop SchoolName State City, force
sort State SchoolName
tab file
tempfile Mar13File
save `Mar13File'

import excel "$Input\coronavirus-school-closures-data-3.12.20-v2.xlsx", sheet("Infogram") firstrow clear
drop if SchoolName==""
drop if SchoolName=="0"
tostring NumberofSchools, replace
gen file=		 12
append using `Mar13File'
gsort -file
duplicates drop SchoolName State City, force
sort State SchoolName
tab file
tempfile Mar12File
save 	`Mar12File'

import excel "$Input\coronavirus-school-closures-data-3.11.20-v2.xlsx", sheet("Infogram") firstrow clear
drop if SchoolName==""
drop if SchoolName=="0"
tostring NumberofSchools, replace
gen file=		 11
append using `Mar12File'
gsort -file
duplicates drop SchoolName State City, force
sort State SchoolName
tab file
tempfile Mar11File
save 	`Mar11File'

import excel "$Input\coronavirus-school-closures-data-3.10.20.xlsx", sheet("Infogram") firstrow clear
drop if SchoolName==""
drop if SchoolName=="0"
tostring NumberofSchools, replace
gen file=		 10
append using `Mar11File'
gsort -file
duplicates drop SchoolName State City, force
sort State SchoolName
tab file
tempfile Mar10File
save 	`Mar10File'

import excel "$Input\coronavirus-school-closures-data.xlsx", sheet("Sheet1") firstrow clear
drop if SchoolName==""
drop if SchoolName=="0"
tostring NumberofSchools, replace
gen file=		 9
append using `Mar10File'
gsort -file
duplicates drop SchoolName State City, force
sort State SchoolName
tab file
******************************************************
*********** 2. Compare with state policy ************
******************************************************
rename SchoolName sch_name
rename State state
replace state = subinstr(st," ","",.)  
merge m:1 state using "$root\FromFelipe\Clean Files\State_Policy.dta"
keep if _merge==3  /*intersted only in additional schools-- 197 Schools*/
drop _merge  

qui gen 	DatesClosed2= subinstr(DatesClosed,"Closed starting","",.)
qui replace DatesClosed2= subinstr(DatesClosed2,"Closed","",.)
qui replace DatesClosed2 = substr(DatesClosed2, 1, 10)
qui replace DatesClosed2= subinstr(DatesClosed2," t","",.)
qui replace DatesClosed2= subinstr(DatesClosed2," a","",.)
generate schclose_date = date(DatesClosed2, "MDY")
format %td schclose_date
keep if schclose_date<stclose_date  /*No obs deleted*/

******* Rescued by hand using -->  https://nces.ed.gov/ccd/schoolsearch/school_detail.asp
replace sch_name = "NEW ROCHELLE HIGH SCHOOL" if sch_name=="New Rochelle High School" & state=="NY"
*duplicates tag state sch_name, gen(dup)
duplicates drop state sch_name, force
order state Enrollment sch_name

gen EdWeek_id =_n
*** Statistics of Schools without by hand rescue - comment that part
qui replace Enrollment= subinstr(Enrollment,",","",.)
destring Enrollment, gen(Enroll2) force
sum Enroll2 if sch_name=="NEW ROCHELLE HIGH SCHOOL" 
return list
sum Enroll2
return list 
tab state
/*After appending all 189 (+5 empty enroll) 168,222 Students to recover*/
******************************************************
***** 3.1 Merge based on School Name and State *******
******************************************************
rename state st
merge 1:m st sch_name using "$Input\NCES CCD\NCES_Schools.dta"
gsort st -Enrollment  

drop if _merge==2
duplicates tag st sch_name  _merge, gen(dup)
tab dup
/*Woodland Middle School based on NCESID in EdWeek and in ncessch in NCES*/
drop if dup==1 & ncessch==130282003415 
drop if dup==1 & ncessch==130029000175
drop if dup==1 & ncessch==530693001021
drop if dup==2 & ncessch==530708001053
drop if dup==2 & ncessch==530585000867

drop dup

preserve
	keep if _merge==3   /*Recovers 47 schools - 39180 students*/
	drop _merge
	sum Enroll2
	return list
	tab st	
*	sum Enroll2 if sch_name=="Lowell High" | sch_name=="Parlier High " | sch_name == "Murrieta Valley High"
*	sum Enroll2 if sch_name=="NEW ROCHELLE HIGH SCHOOL" 
	tempfile FirstMatch
	save `FirstMatch'
restore
keep if _merge==1
drop _merge
drop school_year fipst statename lea_name state_agency_no union st_leaid leaid st_schid ncessch schid mstreet1 mstreet2 mstreet3 mcity mstate mzip mzip4 lstreet1 lstreet2 lstreet3 lcity lstate lzip lzip4 phone website sy_status sy_status_text updated_status updated_status_text effective_date sch_type_text sch_type recon_status out_of_state_flag charter_text chartauth1 chartauthn1 chartauth2 chartauthn2 nogrades g_pk_offered g_kg_offered g_1_offered g_2_offered g_3_offered g_4_offered g_5_offered g_6_offered g_7_offered g_8_offered g_9_offered g_10_offered g_11_offered g_12_offered g_13_offered g_ug_offered g_ae_offered gslo gshi level igoffere
******************************************************
**** 3.2 Merge based on NCESID Aiming to ncessch *****
******************************************************
gsort st sch_name  /*_merge==2 & st=="CA"*/
qui replace NCESID= subinstr(NCESID,"A","",.)
qui replace NCESID= subinstr(NCESID,"n/a","",.)
qui replace NCESID= subinstr(NCESID,"BB","",.)
qui replace NCESID= subinstr(NCESID,"B","",.)
qui replace NCESID= subinstr(NCESID,"K","",.)
qui gen d_No = length(NCESID)
order  NCESID d_No

destring  NCESID, replace
format %15.0g NCESID
preserve
	keep if NCESID==.		/*31 Scholls left*/
	d
	tempfile StillMiss
	save `StillMiss'				/*Rescue information missing*/
restore
d /*--> 148 schools with information*/
drop if NCESID ==. /*31 Scholls left*/

rename NCESID ncessch
merge 1:1 ncessch st using "$Input\NCES CCD\NCES_Schools.dta"

preserve
	keep if _merge==3 /*Recovers 49 schools - 41,285 students*/
	drop _merge
	sum Enroll2 
	return list
	tempfile SecndMatch
	save `SecndMatch'
restore

rename  ncessch NCESID
keep if _merge==1
drop _merge
drop school_year fipst statename lea_name state_agency_no union st_leaid leaid st_schid schid mstreet1 mstreet2 mstreet3 mcity mstate mzip mzip4 lstreet1 lstreet2 lstreet3 lcity lstate lzip lzip4 phone website sy_status sy_status_text updated_status updated_status_text effective_date sch_type_text sch_type recon_status out_of_state_flag charter_text chartauth1 chartauthn1 chartauth2 chartauthn2 nogrades g_pk_offered g_kg_offered g_1_offered g_2_offered g_3_offered g_4_offered g_5_offered g_6_offered g_7_offered g_8_offered g_9_offered g_10_offered g_11_offered g_12_offered g_13_offered g_ug_offered g_ae_offered gslo gshi level igoffere
******************************************************
*****3.3 Merge based on NCESID Aiming to schid *******
******************************************************
rename NCESID schid
merge 1:1 schid st using "$Input\NCES CCD\NCES_Schools.dta"
compress 

preserve
	keep if _merge==3
	drop _merge
	sum Enroll2 
	return list
	tempfile ThrdMatch
	save `ThrdMatch'
restore
rename schid NCESID

keep if _merge==1
drop school_year fipst statename lea_name state_agency_no union st_leaid leaid st_schid ncessch mstreet1 mstreet2 mstreet3 mcity mstate mzip mzip4 lstreet1 lstreet2 lstreet3 lcity lstate lzip lzip4 phone website sy_status sy_status_text updated_status updated_status_text effective_date sch_type_text sch_type recon_status out_of_state_flag charter_text chartauth1 chartauthn1 chartauth2 chartauthn2 nogrades g_pk_offered g_kg_offered g_1_offered g_2_offered g_3_offered g_4_offered g_5_offered g_6_offered g_7_offered g_8_offered g_9_offered g_10_offered g_11_offered g_12_offered g_13_offered g_ug_offered g_ae_offered gslo gshi level igoffere

******************************************************
************ Schools Still Missing ******************
******************************************************
append using `StillMiss'
tab _merge, m
sum Enroll2
return list
drop file d_No _merge

table st, c(N EdWeek_id sum Enroll2)
save 					"$Input\schools_only\Schools_Missing_Apr13.dta", replace
export delimited using 	"$Input\schools_only\Schools_Missing_Apr13.csv", replace
******************************************************
************ Schools with information ****************
******************************************************
clear
use `ThrdMatch'
gen Mtch=3
append using `SecndMatch'
replace Mtch=2 if Mtch==.
append using `FirstMatch'
replace Mtch=1 if Mtch==.
rename st state
tab Mtch
table Mtch, c(N EdWeek_id sum Enroll2)
table state, c(N EdWeek_id sum Enroll2)

keep state leaid schid ncessch sch_name schclose_date Enroll2 level g_pk_offered g_kg_offered g_1_offered g_2_offered g_3_offered g_4_offered g_5_offered g_6_offered g_7_offered g_8_offered g_9_offered g_10_offered g_11_offered g_12_offered schclose_date EdWeek_id

save 				   "$Input\\schools_only\Schools_Found_Apr13.dta", replace
export delimited using "$Input\\Schools_Found_Apr13.csv", replace

******************************************************
********* 4. Compare to School Districts *************
******************************************************
use 	  "$root\FromFelipe\SchoolDist_Closures_v2.dta", clear 
merge 1:m leaid using "$Input\schools_only\Schools_Found_Apr13.dta"
keep if _merge==3  /*lost 2 schools - 426 students in CA*/
tab state if distclose_date>schclose_date /*All schools closed before their districts*/

order leaid lea_name state sch_name level schid ncessch schclose_date distclose_date stclose_date Enroll2 student_count
gen example = Enroll2 / student_count
replace Enroll2 = student_count if example>1
drop example

tab schid, matrow(Schools)
loc itera = rowsof(Schools)

duplicates report leaid
drop _merge

duplicates drop schid, force
sum Enroll2		/*77644*/
return list

table schid, c(mean Enroll2)

tab schclose_date

local it=1
gen date=.
forvalues it = 1/`itera'{
	preserve	
		keep if schid==Schools[`it',1]
		tempfile unit
		save `unit'	
		
		qui replace date = schclose_date
		
		sum schclose_date
		loc strt = r(mean) +1
		sum distclose_date
		if `r(N)'!=0{
			loc end = r(mean) - 1
		}
		else{
			sum stclose_date
			loc end = r(mean) - 1
		}
		local t = `strt'
		forvalues t = `strt'/`end'{
			append using `unit' 
			replace date = `t' if date ==.
			order date schclose_date distclose_date stclose_date
		}
		format %td date
		order state leaid lea_name state sch_name level schid ncessch date  schclose_date distclose_date stclose_date Enroll2 student_count
		tempfile file`it'
		save `file`it''
	restore
}

use `file1', clear
forvalues it = 2/`itera'{
	append using `file`it''
}

order state leaid lea_name state sch_name level schid ncessch date  schclose_date distclose_date stclose_date Enroll2 student_count
save "$Input\schools_only\Schools_Contribution.dta", replace 
sort schid date
capture drop prueba
bysort schid: gen prueba=_n==1
sum Enroll2 if prueba==1
return list

use "$Input\schools_only\Schools_Contribution.dta", clear
tab date
gen sch_earlyclose=1
sort schid
bysort schid: gen prueba=_n==1
sort date leaid schid
order state leaid schid date Enroll2 prueba

gegen Enroll_D=sum(Enroll2), by(state leaid date)
order state leaid schid date Enroll2 Enroll_D prueba


gcollapse (sum) Enroll2  sch_earlyclose, by(date leaid state)
sort leaid date

capture drop prueba
bysort leaid: gen prueba=_n==1
sum Enroll2 if prueba==1
return list			/*70416 Students -- I lost 7200 students*/
drop prueba
save "$Input\schools_only\Schools_Contrib_2SchDist.dta", replace 

use "$Input\schools_only\Schools_Contrib_2SchDist.dta", replace 
gcollapse (sum) Enroll2  sch_earlyclose, by(date state)
save "$Input\schools_only\Schools_Contrib_2Stt.dta", replace 

*** To rescue the other LEAs in _merge==2
* 1) https://nces.ed.gov/ccd/schoolsearch/index.asp  
* 2) Look up the county and rescue its ctyfips from a directory
