# Time-series of student population affected by School Closures during the COVID-19 Epidemics
This repository shows how we constructed a daily time-series of school closures and the affecte student population at the  school, school district, county and state level. These data is part of a joint project advanced by me, **Felipe Lozano-Rojas** with **Prof. Kosali Simon and the Health Economics team at the O'Neill School of Public and Environmental Affairs in Indiana University**.

The project uses information from [Education Week](https://www.edweek.org/ew/section/multimedia/map-coronavirus-and-school-closures.html) on dates of closures at different levels of governments. When we did not have information at the state level from Education Week, we update their records with information from the [University of Washington](), this happened for the state closures of Iowa and Nebraska. 

These data is merged with [NCES Common Core Data](https://nces.ed.gov/ccd/files.asp#Fiscal:1,LevelId:5,SchoolYearId:31,Page:1) Membership files to assess the number and percentage of students that were affected by each closing decision. 
A summary figure of how students got affected is presented below. 
 <img src="https://github.com/flozanor82/SchoolClosures_EdWeek/blob/master/Figures/StudentsTime.png" width="420" height="330" />   <img src="https://github.com/flozanor82/SchoolClosures_EdWeek/blob/master/Figures/SudentTime_State.png" width="420" height="280" />

School closures happened as early as late February. Before the first date of any state closure, on Friday Mar 13th, schools and districts had mad closing decisions affecting 1.97 million students (4.33% of enrollment in K12). By Monday, March 16th, 24 states plus the District of Columbia and Puerto Rico closed their schools and the student population affected jumped to 23 million students (50.5% of enrollment). By next Monday, March 23rd states and school districts decisions had affected more than 99.9% of the student population. 

The repository proceeds as follows. After the Inquiries and the Data Usage Agreement, we generally describe the data sources. procedure (Procedure Description). First, an index to the code that we include here in the File Structure section. We follow by notes describing each of the code files. The final section of this README includes dictionaries for the final files.

# Final Files and Dictionaries
#### SchoolDist_daily_ctyfp.dta: Lea/School District level time-series. 
var leaid 		&rarr; LEA NCES ID
var lea_name 		&rarr; LEA Name
var state 		&rarr; State 2L abbreviation
var statefips 		&rarr; State FIPS code
var Statename 		&rarr; State name
var countyid16 		&rarr; County FIPS code
var student_count 	&rarr; LEA enrollment
var county_enroll 	&rarr; County enrollment
var students_off 	&rarr; Number of students from the LEA not attending school in the date
var students_off_pct 	&rarr; % of students from the LEA not attending school in the date
var sch_earlyclose 	&rarr; No. schools in LEA with earlier than LEA closures
var dist_off 		&rarr; After LEA closure==1
var stclose_date 	&rarr; State closure date
var distclose_date 	&rarr; LEA closure date
var studoff_onlydist 	&rarr; Students affected do to LEA or State closure
var studoff_onlysch  	&rarr; Students affected do to early School closure only
var state_enroll 	&rarr; State Enrollment
var enroll_shr 		&rarr; Share on state's enrollment							

#### County_daily.dta: County level time-series.
var students_off 	&rarr; Number of students from the LEA not attending school in the date
var studoff_onlydist	&rarr; Students affected do to LEA or State closure
var studoff_onlysch 	&rarr; Students affected do to early School closure only
var dist_earlyclose	&rarr; No. LEAs closing earlier than state in county
var sch_earlyclose 	&rarr; No. Schools in county with earlier than LEA closures
var county_enroll 	&rarr; County enrollment
var cty_studoff_pct	&rarr; Percentage of enrolled students affected by closure in county

#### State_daily.dta: State Level Time series
var st2   "State Abbrviation numerically coded"
var state "State 2L abbreviation"
var stclose_date 	"State closure date"
var state_enroll 	"State Enrollment"
var week_end      "Matches UI Claims weekly variable"
var stclose_week  "Matches state closure to the weekly time variable


# Inquiries

If you have technical questions about the data collection, please contact Felipe Lozano-Rojas at [flozanor@iu.edu](flozanor@iu.edu). If you have any further questions about this dataset please contact Kosali Simon at simonkos[at]iu[dot]edu.

# Data Usage Agreement
This dataset is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International Public License (CC BY-NC-SA 4.0). By using this dataset, you agree to abide by the stipulations in the license, remain in compliance with Google’s Terms of Service.

# Notes about the data
### Education Week
The data can be downloaded as an excel spreadsheet (eg. as of today, 4/15/20) only at state level. Before tracking of closures happened at the school level and at the school district level. The code below organized and structured Education Week data and merged it with the NCES Common Core Data files on enrollment. 
### NCES Common Core Data
Department of Education data on the universe of schools and of Local Education Authorities (Local Education Authorities, School Districts). Par tof the [Common Core Data](https://nces.ed.gov/ccd/files.asp#Fiscal:1,LevelId:5,SchoolYearId:31,Page:1), the membership files contain enrollment at the school or school district level. 
### SEDA Files
In this procedure we use SEDA files that have cross-walks of LEAs to counties.

# Procedure Description
We received archived version of EdWeek files, the version as of 3/13 is the first that tracked district level decisions up to then only schools with clean identifiers. We then update every day from then to 3/23. After 3/23 there is pretty much no variation since then once most of the state rulings have been accounted for. We completed the infromation of states still missing from a mandate/recommendation using information from the University of Washington state policies.

We were able to retrieve most of the information pertaining the school files as the project moved along using fuzzy matching, which included: state and school names keys, first, followed by retrieved NCESIDs from the EdWeek files.

So, we have a file that is at district level, another one at the county level and another one at the state level.


# File Structure
- F0.SchDist_Stack.do	
1)Data is merged with NCES LEA files. Enrollment from NCES Early School Closures file count 9.07 million from 1,677 LEAs,	1.91 mll by march13.
2) Compares to state policy. Netting state mandates leave early school closures affecting 8 million students (1,352 LEAs), 1.91 mll by March 13 (197 LEAs) 
3) Generates 1 file School_Dist_Closures_v2.dta*

- F1.SchoolDistrict_Clean.do	
1) Data is merged with NCES LEA files. Enrollment from NCES Early School Closures file count 9.07 million from 1,677 LEAs, 1.91 mll by March 13 (Friday before States started closing massively).
2) Compares to state policy. Netting state mandates leave early school closures affecting 8 million students (1,352 LEAs), 1.91 mll by March 13 (197 LEAs). 
3) Generates 1 file School_Dist_Closures_v2.dta

- F2.Schools_Stack.do
1)Stacks EdWeek School Only Files; 
2)compares it to the State Policy from EdWeek Enriched with UW (File: ResolvingAcrossDifferentSources_v2.xlsx)
3) Matches to NCES Data by 
    i)School name and state and by NCESID
   ii) By NCESID of the School
4) Once the leaid is retrieved a match is done with the school district (School_Dist_Closures_v2.dta) 
5) Generates 3 files with only the students affected by early school closures: 
			 i) 	Schools_Contrution.dta with the time series, for only schools with early school closures. School level info.
		 ii) Schools_Contrib_2SchDist.dta. School district level info
	 iii) Schools_Contrib_2Stt.dta. State level info.
		The addition of school closurs after merging and controling for distric and state closings accounts for additional 77,644 additional students, who were affected by early school closures previous to district and state level mandates.

- F3.SchDist_Counties.do	
Starting from School_Dist_Closures_v2.dta
1) Generates a complete panel for all school districts, from the first date	of closure to the last district closure. Generates variables that indicare when the district was closed based on its own date or the state date.
2) We feed the county fips from the crosswalk of SEDA.
			- 16,732 LEAs matched
			- 329 LEAs from SEDA with no county information (discarded)
			- 582 LEAS with no county information.
			- 3 LEAs with dates before state. Wescued by hand, including their fips
			The latter are included in the school district file. In the county file they remain unassigned.
3) Merge to School Contribution district level (Schools_Contrib_2SchDist.dta) 
4) Produces 2 Files: 
			i. SchoolDist_daily_ctyfp.dta: LEA level time-series.
  ii. County_daily.dta: County level time-series.

- F4.State_File.do
Starts with State Policy and merged into Closed_SchoolsDist.dta (from:F1)
1) Panel of states, merging with NCES data States_Enrollment.dta (from:F1)
2) Merge of Schools_Contrib_2Stt.dta (from: F2)
3) Produces 2 files: 
  i.  State_daily.dta.
  ii. State_weekly.dta. Weekly state information.
