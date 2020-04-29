# Time-series of student population affected by School Closures during the COVID-19 Epidemics
This repository shows how we constructed a daily time-series of school closures and the affecte student population at the  school, school district, county and state level. These data is part of a joint project advanced by me, **Felipe Lozano-Rojas** with **Prof. Kosali Simon and the Health Economics team at the O'Neill School of Public and Environmental Affairs in Indiana University**.

The project uses information from [Education Week](https://www.edweek.org/ew/section/multimedia/map-coronavirus-and-school-closures.html) on dates of closures at different levels of governments. When we did not have information at the state level from Education Week, we update their records with information from the [University of Washington](), this happened for the state closures of Iowa and Nebraska. 

These data is merged with [NCES Common Core Data](https://nces.ed.gov/ccd/files.asp#Fiscal:1,LevelId:5,SchoolYearId:31,Page:1) Membership files to assess the number and percentage of students that were affected by each closing decision. 
A summary figure of how students got affected is presented below. 
 <img src="https://github.com/flozanor82/SchoolClosures_EdWeek/blob/master/Figures/StudentsTime.png" width="420" height="330" />   <img src="https://github.com/flozanor82/SchoolClosures_EdWeek/blob/master/Figures/SudentTime_State.png" width="420" height="280" />

School closures happened as early as late February. Before the first date of any state closure, on Friday Mar 13th, schools and districts had mad closing decisions affecting 1.97 million students (4.33% of enrollment in K12). By Monday, March 16th, 24 states plus the District of Columbia and Puerto Rico closed their schools and the student population affected jumped to 23 million students (50.5% of enrollment). By next Monday, March 23rd states and school districts decisions had affected more than 99.9% of the student population. 

The repository proceeds as follows. After the Inquiries and the Data Usage Agreement, we generally describe the data sources. procedure (Procedure Description). First, an index to the code that we include here in the File Structure section. We follow by notes describing each of the code files. The final section of this README includes dictionaries for the final files.

# Final Files and Dictionaries
In all files, there was a total of 1,909,304 students affected by March 13 (the Friday before massive state closures started), previous to any state closure, and 1,976,490 including LEAs and school closures.  
#### SchoolDist_daily_ctyfp.dta: Lea/School District level time-series. 
var leaid 		 &rarr; LEA NCES ID <br>
var lea_name 		 &rarr; LEA Name <br>
var state 		 &rarr; State 2L abbreviation <br>
var statefips 		 &rarr; State FIPS code <br>
var Statename 		 &rarr; State name <br>
var countyid16 		 &rarr; County FIPS code <br>
var student_count 	 &rarr; LEA enrollment <br>
var county_enroll 	 &rarr; County enrollment <br>
var students_off 	 &rarr; Number of students from the LEA not attending school in the date <br>
var students_off_pct 	 &rarr; % of students from the LEA not attending school in the date <br>
var sch_earlyclose 	 &rarr; No. schools in LEA with earlier than LEA closures <br>
var dist_off 		 &rarr; After LEA closure==1 <br>
var stclose_date 	 &rarr; State closure date <br>
var distclose_date 	 &rarr; LEA closure date <br>
var studoff_onlydist	 &rarr; Students affected do to LEA or State closure <br>
var studoff_onlysch 	 &rarr; Students affected do to early School closure only <br>
var state_enroll 	 &rarr; State Enrollment <br>
var enroll_shr 		 &rarr; Share on state's enrollment	<br>	 							

#### County_daily.dta: County level time-series.
var students_off 	&rarr; Number of students from the LEA not attending school in the date <br>
var studoff_onlydist	&rarr; Students affected do to LEA or State closure <br>
var studoff_onlysch 	&rarr; Students affected do to early School closure only <br>
var dist_earlyclose	&rarr; No. LEAs closing earlier than state in county <br>
var sch_earlyclose 	&rarr; No. Schools in county with earlier than LEA closures <br>
var county_enroll 	&rarr; County enrollment <br>
var cty_studoff_pct	&rarr; Percentage of enrolled students affected by closure in county <br>

#### State_daily.dta: State Level Time series
lab var st2 		 &rarr;	State Abbrviation numerically coded <br>
lab var state 		 &rarr; State 2L abbreviation <br>
lab var stclose_date &rarr;	State closure date <br>
lab var state_enroll &rarr; State Enrollment <br>
lab var week_end 	 &rarr; Matches UI Claims weekly variable <br>
lab var stclose_week &rarr; Matches state closure to the weekly time variable <br>


# Inquiries

If you have technical questions about the data collection, please contact Felipe Lozano-Rojas at [flozanor@iu.edu](flozanor@iu.edu). If you have any further questions about this dataset please contact Kosali Simon at [simonkos@iu.edu](simonkos@iu.edu).

# Data Usage Agreement (If we have any)
This dataset is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International Public License (CC BY-NC-SA 4.0). By using this dataset, you agree to abide by the stipulations in the license, remain in compliance with Google’s Terms of Service.

# Notes about the data
### Education Week
The data can be downloaded as an excel spreadsheet (eg. as of today, 4/15/20) only at state level. Before tracking of closures happened at the school level and at the school district level. The code below organized and structured Education Week data and merged it with the NCES Common Core Data files on enrollment. 
### NCES Common Core Data
Department of Education data on the universe of schools and of Local Education Authorities (Local Education Authorities, School Districts). Par tof the [Common Core Data](https://nces.ed.gov/ccd/files.asp#Fiscal:1,LevelId:5,SchoolYearId:31,Page:1), the membership files contain enrollment at the school or school district level. 
### SEDA Files
To create a county file, we use SEDA files that have cross-walks of LEAs to counties to retrieve the county fips code.

# Procedure General Description
We received archived version of EdWeek files, the version as of 3/13 is the first that tracked district level decisions up to then only schools with clean identifiers. We then update every day from then to 3/23. After 3/23 there is pretty much no variation since then once most of the state rulings have been accounted for. We completed the infromation of states still missing from a mandate/recommendation using information from the University of Washington state policies. We were able to retrieve most of the information pertaining the school files as the project moved along using fuzzy matching, which included: state and school names keys, first, followed by retrieved NCESIDs from the Education Week files.

A step-by-step description can be found in the next section to the references to the code.Here a general description of the steps to clean and produce the time-series files. 

1) Clean Education Week level <br>
Apart from importing and leaving variables ready for use, the most important decision at this level, is that school closures are a measure of students affected by a closure. Once a school district is closed, it is assumed that it remains closed.  This decision allows for a cleaner programming. Eye-balling the dates of reopening, several dates for reopening are in conflict with the state school closure mandate, or the openings were postponed in later files.


2) Merge EdWeek data with NCES information <br>
This provides complete information about the district and about the geography of the school district. Enrollment data is used from NCES as has complete information from all schools and calculating shares can be done relative to the entire geography in question.
Keeping only K12 grades and the proper categories in the LEA file from NCES renders 46’7 million students in the LEA data. For the setting of the daily data we keep the EdWeek school districts for a while. The SEDA File is used to retrieve the countyfips information.


3) Merge EdWeek enriched data with the EdWeek Data for State Closures <br>
We checked this on April 9 to make sure that all data was coming from EdWeek. Tow states did not have state mandate/recommended closures in the Education Week files as per Apr10: Iowa and Nebraska. We included the information for these states from Univeristy of Washington. 

4) Organize information <br>
A double iteration is performed: 1) for each state with an early school district closure, for each early closing date, the number of students affected are tagged and a variable for the cumulative number of students affected is created (stud_off). This is done until the available early closing dates within a state are finished or until the state mandate is in effect. 

5) Re-merge NCES information
Finally, we merge with the NCES data again, and now we have information for the entirety of school districts. If they have an early closure, they will have that date reported (distclose_date), but all school districts have also the state mandated date (stclose_date). At district level, unless they have an early school-only closure,  the shared of students affected jumps from 0 to 1, and all its students get affected after a decision is made. A final iteration keeps the information for each school district intact until the date that the state mandated the closing. 

At the county and state levels, school district early closures affect only a proportion of students. These proportions (pct_stud_off) are calculated from the school_count of each district within a county or a state (county_enroll) (state_enroll). Before calculating the proportions, a collapse of the data is performed to the desired geographic level (county, state). So, we have a file that is at district level, another one at the county level and another one at the state level.



# File Structure
- [F0.SchDist_Stack.do](/Code/F0.SchDist_Stack.do)	<br>
1) Data is merged with NCES LEA files. Enrollment from NCES Early School Closures file count 9.07 million from 1,677 LEAs,	1.91 mll by march13. <br>
2) Compares to state policy. Netting state mandates leave early school closures affecting 8 million students (1,352 LEAs), 1.91 mll by March 13 (197 LEAs) <br>
3) Generates 1 file School_Dist_Closures_v2.dta <br>

- [F1.SchoolDistrict_Clean.do](/Code/F1.SchoolDistrict_Clean.do)	<br>
1) Data is merged with NCES LEA files. Enrollment from NCES Early School Closures file count 9.07 million from 1,677 LEAs, 1.91 mll by March 13 (Friday before States started closing massively).<br>
2) Compares to state policy. Netting state mandates leave early school closures affecting 8 million students (1,352 LEAs), 1.91 mll by March 13 (197 LEAs). <br>
3) Generates 2 intermediate file School_Dist_Closures.dta and School_Dist_Closures_v2.dta. <br>

- [F2.Schools_Stack.do](/Code/F2.Schools_Stack.do) <br>
1) Stacks EdWeek School Only Files; <br>
2) compares it to the State Policy from EdWeek Enriched with UW (File: ResolvingAcrossDifferentSources_v2.xlsx) <br>
3) Matches to NCES Data by <br>
    i)School name and state and by NCESID <br>
   ii) By NCESID of the School <br>
4) Once the leaid is retrieved a match is done with the school district (School_Dist_Closures_v2.dta)  <br>
5) Generates 3 files with only the students affected by early school closures: <br>
   i) 	Schools_Contrution.dta with the time series, for only schools with early school closures. School level info. <br>
  ii) Schools_Contrib_2SchDist.dta. School district level info <br>
 iii) Schools_Contrib_2Stt.dta. State level info. <br>
The addition of school closures after merging and controling for distric and state closings accounts for additional 77,644 additional students, who were affected by early school closures previous to district and state level mandates.

- [F3.SchDist_Counties.do](/Code/F3.SchDist_Counties.do)	<br>
Starting from School_Dist_Closures_v2.dta: <br>
1) Generates a complete panel for all school districts, from the first date of closure to the last district closure. Generates variables that indicare when the district was closed based on its own date or the state date. <br>
2) We feed the county fips from the crosswalk of SEDA. <br>
	- 16,732 LEAs matched <br>
	- 329 LEAs from SEDA with no county information (discarded) <br>
	- 582 LEAS with no county information. <br>
	- 3 LEAs with dates before state. Wescued by hand, including their fips <br>
 The latter are included in the school district file. In the county file they remain unassigned. <br>
3) Merge to School Contribution district level (Schools_Contrib_2SchDist.dta) <br>
4) Produces 2 Files: <br>
	i. SchoolDist_daily_ctyfp.dta: LEA level time-series.<br>
	ii. County_daily.dta: County level time-series. <br>

- [F4.State_File.do](F4.State_File.do)
Starts with State Policy and merged into Closed_SchoolsDist.dta (from:F1) <br>
1) Panel of states, merging with NCES data States_Enrollment.dta (from:F1) <br>
2) Merge of Schools_Contrib_2Stt.dta (from: F2) <br>
3) Produces 2 files: <br>
	i.  State_daily.dta.<br>
	ii. State_weekly.dta. Weekly state information. <br>
