# Time-series of student population affected by School Closures during the COVID-19 Epidemics
This repository shows how we constructed a daily time-series of school closures and the affecte student population at the  school, school district, county and state level. These data is part of a joint project advanced by me, **Felipe Lozano-Rojas** with **Prof. Kosali Simon and the Health Economics team at the O'Neill School of Public and Environmental Affairs in Indiana University**.

The project uses information from [EdWeek](https://www.edweek.org/ew/section/multimedia/map-coronavirus-and-school-closures.html) on dates of closures at different levels of governments. Whenever we did not have access to information at the state level from EdWeek, we update our records with information from the [University of Washington](), this happened for the state closures of Iowa and Nebraska. 

These data is merged with [NCES Common Core Data](https://nces.ed.gov/ccd/files.asp#Fiscal:1,LevelId:5,SchoolYearId:31,Page:1) Membership files to assess the number and percentage of students that were affected by each closing decision. 
A summary figure of how students got affected is presented below. 
 <img src="https://github.com/flozanor82/SchoolClosures_EdWeek/blob/master/Figures/StudentsTime.png" width="420" height="330" />   <img src="https://github.com/flozanor82/SchoolClosures_EdWeek/blob/master/Figures/SudentTime_State.png" width="420" height="280" />

School closures happened as early as late February. Before the first date of any state closure, on Friday Mar 13th, schools and districts had mad closing decisions affecting 1.97 million students (4.33% of enrollment in K12). By Monday, March 16th, 24 states plus the District of Columbia and Puerto Rico closed their schools and the student population affected jumped to 23 million students (50.5% of enrollment). By next Monday, March 23rd states and school districts decisions had affected more than 99.9% of the student population. 

The repository proceeds as follows. After the Inquiries and the Data Usage Agreement, we generally describe the data sources. procedure (Procedure Description). First, an index to the code that we include here in the File Structure section. We follow by notes describing each of the code files. The final section of this README includes dictionaries for the final files.

# Inquiries

If you have technical questions about the data collection, please contact Felipe Lozano-Rojas at [flozanor@iu.edu](flozanor@iu.edu). If you have any further questions about this dataset please contact Kosali Simon at simonkos[at]iu[dot]edu.

# Data Usage Agreement
This dataset is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International Public License (CC BY-NC-SA 4.0). By using this dataset, you agree to abide by the stipulations in the license, remain in compliance with Google’s Terms of Service.

# Notes about the data
### EdWeek
### NCES

# Procedure Description
We received archived version of EdWeek files, the version as of 3/13 is the first that tracked district level decisions up to then only schools with clean identifiers. We then update every day from then to 3/23. After 3/23 there is pretty much no variation since then once most of the state rulings have been accounted for. We completed the infromation of states still missing from a mandate/recommendation using information from the University of Washington state policies.

We were able to retrieve most of the information pertaining the school files as the project moved along using fuzzy matching, which included: state and school names keys, first, followed by retrieved NCESIDs from the EdWeek files.

So, we have a file that is at district level, another one at the county level and another one at the state level.


# File Structure







