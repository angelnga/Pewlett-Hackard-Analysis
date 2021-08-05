# Pewlett-Hackard-Analysis
Pewlett Hackard is offering retirement package for those who meet the certain criteria. And starting to think about which position need to be filled in the near future. The number of upcoming retirements will leave thousands of job openings. This analysis will help future proof Pewlett Hackard by generating a list of all employees eligible for retirement package. The employee data is only in available in form of six CSV file because Pewlett Hackard has been mainly using Excel and VBA to work with their data. This task is to use SQL to build an employee database by applying data modeling, engineering and analysis skills.

## Project Overview
Determine the number of retiring employees per title, and identify employees who are eligible to participate in a mentorship program. Then, write a report that summarizes your analysis and helps prepare for the “silver tsunami” as many current employees reach retirement age.
1. Retiring employees are identified by birth year (1952-1955)
2. Mentorship eligibility is determined by birth year (1965)
3. Current employees have a to_date of "9999-01-01"

    <a href = "https://github.com/angelnga/Pewlett-Hackard-Analysis/blob/main/Queries/Employee_Database_challenge.sql">  Employee_Database_challenge.sql </a> <br>

## Deliverable 1: The Number of Retiring Employees by Title <br>
Create a Retirement Titles table that holds all the titles of current employees who were born between January 1, 1952 and December 31, 1955. 

![Retirement_titles](/Data/Retirement_titles.png)
There are duplicate entries for some employees because they have switched titles over the years.<br>

![Unique_titles](/Data/Unique_titles.png)
Use PARTITION BY (emp_no) to show only most recent title per employee. 33118 employees is shown in the result. <br>

![retiring_titles](/Data/retiring_titles.png)<br>
Count the number of employee and group by titles.


## Deliverable 2: The Employees Eligible for the Mentorship Program <br>
![mentorship_eligibilty](/Data/mentorship_eligibilty.png)
1549 employees are elegible for the program. 


## Summary
- How many roles will need to be filled as the "silver tsunami" begins to make an impact?<br>
Pewlett Hackard cuurently has 240,124 employees and 33,118 of them are at retirement age. Which means 33,118 of position will need to be filled. 

- Are there enough qualified, retirement-ready employees in the departments to mentor the next generation of Pewlett Hackard employees?<br>
It depends on the department and how many employees can a mentor handle. In result, there are 1549 employees qualified for mentorship program. Each of them will supposed to provide mentorship for 22 new employees. 
However, titles like "senior engineer" will have 13,851 new employees and only 169 mentors, which means each mentor will need to handle over 80 new employees, that might cause work overload. <br>
![mentorship_titles](/Data/mentorship_titles.png)<br>

The other reliable way to look at qualification of the mentorship would be determined by experience, "hire_date" rather than "birth_date".

