*************************************************************************************************************
* This file imports, cleans and stacks the source files from EdWeek
* - Each new file is stacked and kep only the most recent information. This assumes that the later the files
*   the more correct the information is.
* - The time of closing referes to the firt date of closing. This is an affected measure and does not switch on 
*	and off.
*************************************************************************************************************
*Mar 14*/
import excel "$Input\coronavirus-school-closures-3.14.2020-v1.xlsx", sheet("Infogram W NCES") firstrow clear
gen file=td(14mar2020)
format %td file
replace NCESID = subinstr(NCESID,"A","",.) 
destring NCESID, gen(leaid) force
drop NCESID NumberofSchools SchoolName PublicPrivate
tempfile mar14
save 	`mar14'
*Mar 15*
import excel "$Input\Coronavirus-state-district-closures-3.15.2020-v2.xlsx", sheet("Infogram - district") firstrow clear
gen file=td(15mar2020)
format %td file
rename NCESID leaid
drop NumberofSchools 
append using `mar14'
gsort -file
duplicates drop leaid, force
tempfile mar15
save 	`mar15'
*Mar 16*
import excel "$Input\Coronavirus-state-district-closures-3.16.2020-v4.xlsx", sheet("Districts") firstrow clear
drop J K
drop State
rename StateAbbrev State
qui replace State= subinstr(State," ","",.)
gen file=td(16mar2020)
format %td file
rename NCESID leaid
drop NumberofSchools 
append using `mar15'
gsort -file
duplicates drop leaid, force
tempfile mar16
save 	`mar16'
*Mar 17*
import excel "$Input\Coronavirus-state-district-closures-3.17.2020-v2.xlsx", sheet("Districts") firstrow clear
drop State
rename StateAbbrev State
qui replace State= subinstr(State," ","",.)
gen file=td(17mar2020)
format %td file
rename NCESID leaid
drop NumberofSchools 
append using `mar16'
gsort -file
duplicates drop leaid, force
tempfile mar17
save 	`mar17'
*Mar 18*
import excel "$Input\Coronavirus-state-district-closures-3.18.2020-v2.xlsx", sheet("Districts") firstrow clear
drop State
rename StateAbbrev State
qui replace State= subinstr(State," ","",.)
drop J K
gen file=td(18mar2020)
format %td file
rename NCESID leaid
drop NumberofSchools 
append using `mar17'
gsort -file
duplicates drop leaid, force
tempfile mar18
save 	`mar18'
*Mar 19*
import excel "$Input\Coronavirus-state-district-closures-3.19.2020-v2.xlsx", sheet("Districts") firstrow clear
drop State
rename StateAbbrev State
qui replace State= subinstr(State," ","",.)
drop J K
gen file=td(19mar2020)
format %td file
rename NCESID leaid
drop NumberofSchools 
append using `mar18'
gsort -file
duplicates drop leaid, force
tempfile mar19
save 	`mar19'
*Mar 20*
import excel "$Input\Coronavirus-state-district-closures-3.20.2020-v2.xlsx", sheet("Districts") firstrow clear
drop State
rename StateAbbrev State
qui replace State= subinstr(State," ","",.)
drop J K
gen file=td(20mar2020)
format %td file
rename NCESID leaid
drop NumberofSchools 
append using `mar19'
gsort -file
duplicates drop leaid, force
tempfile mar20
save 	`mar20'
*Mar 21*
import excel "$Input\Coronavirus-state-district-closures-3.21.2020.xlsx", sheet("Infogram - district") firstrow clear
drop State
rename StateAbbrev State
qui replace State= subinstr(State," ","",.)
gen file=td(21mar2020)
format %td file
rename NCESID leaid
drop NumberofSchools 
append using `mar20'
gsort -file
duplicates drop leaid, force
tempfile mar21
save 	`mar21'
*Mar 22*
import excel "$Input\Coronavirus-state-district-closures-3.22.2020-v1.xlsx", sheet("Districts") firstrow clear
drop State
rename StateAbbrev State
qui replace State= subinstr(State," ","",.)
drop J K
gen file=td(22mar2020)
format %td file
rename NCESID leaid
drop NumberofSchools 
append using `mar21'
gsort -file
duplicates drop leaid, force
tempfile mar22
save 	`mar22'
*Mar 22*
import excel "$Input\Coronavirus-state-district-closures-3.23.2020-v1.xlsx", sheet("Districts") firstrow clear
drop State
rename StateAbbrev State
qui replace State= subinstr(State," ","",.)
drop J K
gen file=td(23mar2020)
format %td file
rename NCESID leaid
drop NumberofSchools 
append using `mar22'
gsort -file
duplicates drop leaid, force
tempfile mar23
save 	`mar23'

qui replace DatesClosed= subinstr(DatesClosed,"Closed starting","",.)
qui replace DatesClosed= subinstr(DatesClosed,"Closed","",.)
qui replace DatesClosed= subinstr(DatesClosed,"Closed 3/2/2020 and 3/17/2020 onward","3/2/2020",.)
qui replace DatesClosed= subinstr(DatesClosed,"Closed 3/2/2020 and 3/23/2020 onward","3/2/2020",.)
qui replace DatesClosed= subinstr(DatesClosed,"3/11/2020 to 3/13/2020 and 3/17/2020 onward","3/11/2020",.)
qui replace DatesClosed= subinstr(DatesClosed,"11/11/1900","3/11/2020",.)   /*inputted based on the 11th information*/

generate distclose_date_1 = date(DatesClosed, "MDY")
qui replace DatesClosed = substr(DatesClosed, 1, 10) if distclose_date_1==.
qui replace DatesClosed= subinstr(DatesClosed,"a","",.)
qui replace DatesClosed= subinstr(DatesClosed,"t","",.)
drop distclose_date_1
generate distclose_date = date(DatesClosed, "MDY")
drop if distclose_date==.
format %td file distclose_date
rename State state

order leaid state
qui replace state= subinstr(state," ","",.)
tab state
save "$Input\StackedClosures_Mar23.dta", replace


	

