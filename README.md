# Time-series of student population affected by School Closures during the COVID-19 Epidemics
This repository shows how we produced a time-series of district with daily school, school district, county and state level school closures. This data is part of a joint project with Prof. Kosali Simon and the Health Economics team at the O'Neill School of Public and Environmental Affairs in Indiana University.

The project uses information from [EdWeek](https://www.edweek.org/ew/section/multimedia/map-coronavirus-and-school-closures.html) on dates of closures at diffrrent levels of governments. Whenever we did not have access to information at the state level from EdWeek, we update our records with information from the University of [Washington](), this happened for the state closures of Iowa and Nebraska. 

These data is merged with [NCES Common Core Data](https://nces.ed.gov/ccd/files.asp#Fiscal:1,LevelId:5,SchoolYearId:31,Page:1) Mempbership files to assess the number and percentage of students that were affected by each closing decision. 
A summary figure of how students got affected is presented below. 


School closures happened as early as late February. Before the first date of any state closure, on Friday Mar 13th, schools and districts had mad closing decisions affecting XX students (% of enrollment). By Monday, March 16th 24 states plus the District of Columbia and Puerto Rico closed their schools and the student population affected jumped to XX students (% of enrollment). By next Modany, March 23rd states and school districts decisions had affected more than 99% of the students. 

The repository proceeds as follows, an index to the code that we present here followed by notes describing each of the code files.


# File Structure



# Notes about the data

A few notes about this data:
- The file [**0.GT_States.py**](0.GT_StateQuery.py) pulls queries from Google Trends API based on state identifiers and on a set of prespecified keywords. We provide the firle for replication purposes, however, the API key and other acess information has been removed to protect restricted data access.  

# Data Usage Agreement
This dataset is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International Public License (CC BY-NC-SA 4.0). By using this dataset, you agree to abide by the stipulations in the license, remain in compliance with Google’s Terms of Service.

# Inquiries

If you have technical questions about the data collection, please contact Thuy Nguyen at thdnguye[at]iu[dot]edu or Felipe Lozano-Rojas at flozanor[at]iu[dot]edu.

If you have any further questions about this dataset please contact Ana Bento at abento[at]iu[dot]edu or Kosali Simon at simonkos[at]iu[dot]edu
