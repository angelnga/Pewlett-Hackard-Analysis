-- Creating tables for PH-EmployeeDB
CREATE TABLE departments (
     dept_no VARCHAR NOT NULL,
     dept_name VARCHAR(40) NOT NULL,
     PRIMARY KEY (dept_no),
     UNIQUE (dept_name)
);

SELECT * FROM departments;

CREATE TABLE employees (
	emp_no INT NOT NULL,
     birth_date DATE NOT NULL,
     first_name VARCHAR NOT NULL,
     last_name VARCHAR NOT NULL,
     gender VARCHAR NOT NULL,
     hire_date DATE NOT NULL,
     PRIMARY KEY (emp_no)
);

CREATE TABLE dept_manager (
dept_no VARCHAR NOT NULL,
    emp_no INT NOT NULL,
    from_date DATE NOT NULL,
    to_date DATE NOT NULL,
FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
FOREIGN KEY (dept_no) REFERENCES departments (dept_no),
    PRIMARY KEY (emp_no, dept_no)
);

CREATE TABLE salaries (
  emp_no INT NOT NULL,
  salary INT NOT NULL,
  from_date DATE NOT NULL,
  to_date DATE NOT NULL,
  FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
  PRIMARY KEY (emp_no)
);


CREATE TABLE dept_emp (
	emp_no INT NOT NULL,
	dept_no VARCHAR NOT NULL,
	from_date DATE NOT NULL,
	to_date DATE NOT NULL,
	FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
	FOREIGN KEY (dept_no) REFERENCES departments (dept_no),
	PRIMARY KEY (emp_no,dept_no)
	);
	
CREATE TABLE titles (
	emp_no INT NOT NULL,
	title VARCHAR(50) NOT NULL,
	from_date DATE NOT NULL,
	to_date DATE NOT NULL,
	FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
	PRIMARY KEY (emp_no, title, from_date)
	);


DROP TABLE titles CASCADE;


SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1952-01-01' AND '1955-12-31';

-- Retirement eligibility
SELECT emp_no, first_name, last_name
INTO retirement_info
FROM employees
WHERE birth_date BETWEEN '1952-01-01' AND '1955-12-31'
AND hire_date BETWEEN '1985-01-01'AND '1988-12-31';

SELECT * FROM retirement_info


-- Number of employee
SELECT COUNT (emp_no)
FROM employees
WHERE birth_date BETWEEN '1952-01-01' AND '1955-12-31'
AND hire_date BETWEEN '1985-01-01'AND '1988-12-31';
-- Or 
SELECT COUNT (emp_no)
FROM retirement_info;

-- Selecting current employees
SELECT ri.emp_no, ri.first_name, ri.last_name
INTO current_emp
FROM retirement_info AS ri
LEFT JOIN dept_emp AS de
ON ri.emp_no=de.emp_no
WHERE de.to_date = '9999-01-01';

-- Employee count by department number
SELECT COUNT(ce.emp_no), de.dept_no
FROM current_emp as ce
LEFT JOIN dept_emp as de on ce.emp_no=de.emp_no
GROUP BY de.dept_no
ORDER BY de.dept_no;

-- Employee list with gender and salary 
SELECT e.emp_no, e.first_name, e.last_name, s.salary, de.to_date
INTO emp_info
FROM employees AS e
INNER JOIN salaries as s on e.emp_no=s.emp_no
INNER JOIN dept_emp as de on e.emp_no=de.emp_no
WHERE (e.birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (e.hire_date BETWEEN '1985-01-01'AND '1988-12-31')
AND (de.to_date = '9999-01-01');

SELECT * FROM emp_info;

-- List of managers per departments
SELECT dm.dept_no, d.dept_name, dm.emp_no, ce.last_name, ce.first_name, dm.from_date, dm.to_date
INTO manager_info
FROM dept_manager as dm
INNER JOIN departments as d on (dm.dept_no=d.dept_no)
INNER JOIN current_emp as ce on (dm.emp_no=ce.emp_no);

-- List of employees with departments
SELECT ce.emp_no, ce.first_name, ce.last_name, d.dept_name
INTO dept_info
FROM current_emp as ce
INNER JOIN dept_emp as de on (ce.emp_no=de.emp_no)
INNER JOIN departments as d on (de.dept_no=d.dept_no);

-- List of Sales Employee
SELECT ce.emp_no, ce.first_name, ce.last_name, d.dept_name
INTO sales_info
FROM current_emp as ce 
INNER JOIN dept_emp as de on (ce.emp_no=de.emp_no)
INNER JOIN departments as d on (de.dept_no=d.dept_no)
WHERE d.dept_name='Sales';

-- List of sales and department
SELECT ce.emp_no, ce.first_name, ce.last_name, d.dept_name
INTO sales_dev
FROM current_emp as ce
INNER JOIN dept_emp as de on (ce.emp_no=de.emp_no)
INNER JOIN departments as d on (de.dept_no=d.dept_no)
WHERE d.dept_name in ('Sales','Development')
ORDER BY ce.emp_no;

-- Number of titles retiring
SELECT ce.emp_no, ce.first_name, ce.last_name, ti.title, ti.from_date, ti.to_date
INTO ret_titles
FROM current_emp as ce
INNER JOIN titles as ti on (ce.emp_no=ti.emp_no)
ORDER BY ce.emp_no;

-- Retirement_titles.csv
SELECT * FROM ret_titles
ORDER BY emp_no

-- Partition the data to show only most recent title per employee
SELECT emp_no, first_name, last_name, to_date, title
INTO unique_titles
FROM (SELECT emp_no, first_name, last_name, to_date, title, ROW_NUMBER()OVER
			(PARTITION BY (emp_no)
	ORDER BY to_date DESC) rn
	FROM ret_titles)
	tmp WHERE rn=1
	ORDER BY emp_no;

-- Unique_titles.csv
SELECT * from unique_titles
ORDER BY emp_no;

-- Counting the number of employee titles
SELECT COUNT(title), title
INTO retiring_titles
FROM unique_titles
GROUP BY title
ORDER BY COUNT DESC;

-- retiring_titles.csv
SELECT * FROM retiring_titles;

--Creating a list of employees eligitable for potential mentorship program
SELECT e.emp_no, e.first_name, e.last_name, e.birth_date, de.from_date, de.to_date, ti.title
INTO mentorship
FROM employees as e
INNER JOIN dept_emp as de on (e.emp_no=de.emp_no)
INNER JOIN titles as ti on (e.emp_no=ti.emp_no)
WHERE (de.to_date = '9999-01-01')
AND (e.birth_date BETWEEN '1965-01-01' AND '1965-12-31')
ORDER BY e.emp_no;

-- mentorship_eligibilty.csv
SELECT DISTINCT ON (emp_no) * FROM mentorship
ORDER BY emp_no;


-- Testing: Retirement employee and titles
SELECT ret.*, t.title
FROM retirement_info AS ret LEFT JOIN titles AS t on (ret.emp_no=t.emp_no)
WHERE t.to_date = '9999-01-01'


