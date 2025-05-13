
-- Data Exploration Project


-- Exploring the SELECT Statement with a FROM Clause

SELECT
	*
FROM
	employees;
    

SELECT
	dept_no
FROM
	departments;

-- Introducing the WHERE Clause in a SELECT Statement

SELECT
	* 
FROM
	employees
WHERE
	first_name = 'Saniya';

-- Using the AND keyword

SELECT
	* 
FROM 
    employees 
WHERE 
	gender = 'F'
	AND last_name = 'Bamford';

-- Using the OR keyword

SELECT
	* 
FROM
	employees
WHERE
	first_name = 'Bezalel'
    OR first_name = 'Anneke';


-- Using IN and NOT IN

SELECT
	*
FROM
	employees
WHERE
	first_name IN ('Parto', 'Georgi');

SELECT
	*
FROM
	employees
WHERE 
	first_name NOT IN ('Georgi', 'Parto', 'Anneke');

-- Using the LIKE and NOT LIKE Operators

SELECT
	*
FROM 
	employees
WHERE hire_date LIKE '1989%';

SELECT
	*
FROM
	employees
WHERE
	first_name NOT LIKE 'S%';

-- Using BETWEEN & AND to filter tables

SELECT
	*
FROM
	salaries
WHERE
	salary BETWEEN 71000 AND 79000;

-- using IS NULL and IS NOT NULL Conditions in a SELECT Statement

SELECT
	emp_no,
    first_name
FROM
	employees
WHERE
	first_name IS NOT NULL;

-- Using Comparison Operators in the WHERE Clause

SELECT
	*
FROM
	salaries
WHERE
	salary > 90392;
    
-- Writing a SELECT DISTINCT Statement

SELECT 
	DISTINCT to_date
FROM
	titles;

-- Sorting Results with ORDER BY in a SELECT Statement

SELECT
	*
FROM
	employees
ORDER BY
	birth_date DESC;
    
-- Using an Alias in a SELECT List
 
 SELECT
	title,
    COUNT(emp_no) AS emps_with_same_job_title
FROM
	titles
WHERE
	to_date = '9999-01-01'
GROUP BY title;

-- Filtering Results with a HAVING Clause

SELECT
	emp_no,
    AVG(salary)
FROM
	salaries
GROUP BY
	emp_no
HAVING AVG(salary) > 70000
ORDER BY emp_no ASC;

-- Combining a WHERE and a HAVING Clause in a SELECT Statement

SELECT
	emp_no
FROM
	salaries
WHERE
	to_date > '1990-01-01'
ORDER BY emp_no ASC;

-- Controlling Returned Rows with a LIMIT Clause

SELECT
	*
FROM
	dept_emp
ORDER BY
	emp_no DESC
LIMIT 5;

-- Applying ROUND() to Format Values in SELECT Statements

SELECT
	ROUND(AVG(salary),0)
FROM
	salaries
WHERE
	from_date <= '1994-11-29';
    
-- Using COALESCE() in SELECT Statements

SELECT
	mp_no,
    birth_date,
    COALESCE(first_name, last_name) as name
FROM
	employees;

-- Data Selection with INNER JOIN

SELECT
	emp_no,
	from_date,
    dept_name
FROM
	dept_emp
INNER JOIN
	departments ON dept_emp.dept_no = departments.dept_no;

-- Data Selection with LEFT JOIN

SELECT
	e.emp_no, 
	first_name, 
	last_name, 
	dept_no, 
	from_date 
FROM
	employees e 
LEFT JOIN
	dept_manager d on e.emp_no = d.emp_no 
WHERE 
	last_name = 'Bamford'
ORDER BY 
	d.dept_no DESC;

-- Data Selection with RIGHT JOIN

SELECT
	e.emp_no, 
	first_name, 
	last_name, 
	dept_no, 
	from_date 
FROM
	employees e
RIGHT JOIN
	dept_manager d on e.emp_no = d.emp_no 
WHERE
	last_name = 'Bamford'
ORDER BY
	d.dept_no desc;

-- complex join query

SELECT
	first_name,
    last_name,
    hire_date,
    title,
    de.from_date,
    dept_name
FROM
	employees e
JOIN
	titles t ON e.emp_no = t.emp_no
JOIN
	dept_emp de ON t.emp_no = de.emp_no
JOIN
	departments d on de.dept_no = d.dept_no
WHERE
	t.title = 'Senior Engineer';
    
-- Using UNION in a SELECT Statement

SELECT
	emp_no,
	first_name,
    last_name
FROM
	employees
WHERE
	last_name ='Bamford'
UNION
SELECT
	dept_no, 
    from_date
FROM
	dept_manager;
    
-- An SQL Subquery with an IN Operator

SELECT
	emp_no,
    dept_no,
    from_date
FROM
    dept_manager
WHERE
emp_no IN 
	(SELECT
		emp_no
	FROM
		employees
	WHERE
		birth_date >= '1955-01-01');
        
-- Exploring Nested Subqueries

SELECT 
    t.emp_no,
    t.title,
    (SELECT 
            ROUND(AVG(s.salary), 2)
        FROM
            salaries s
        WHERE
            s.emp_no = t.emp_no) AS avg_salary
FROM
    (SELECT 
        emp_no, title
    FROM
        titles t
    WHERE
        title = 'Staff' OR title = 'Engineer') as t
ORDER BY avg_salary DESC;
  
  -- Using the EXISTS keyword
  
  SELECT 
    *
FROM
    salaries s
WHERE
    EXISTS( SELECT 
            *
        FROM
            titles t
        WHERE
            t.emp_no = s.emp_no
                AND title = 'Engineer');

-- Practicing MySQL Self Joins

SELECT 
    e2.*
FROM
    emp_manager e1
        JOIN
    emp_manager e2 ON e1.emp_no = e2.manager_no
WHERE
    e2.emp_no IN (SELECT 
            manager_no
        FROM
            emp_manager);
            
-- Adding a CASE Statement to a SELECT List

SELECT     dm.emp_no,
	e.first_name,
    e.last_name,
    e.hire_date,
    MIN(s.salary) AS min_salary,
    MAX(s.salary) AS max_salary,
    MAX(s.salary) - MIN(s.salary) AS salary_difference,
    CASE
		WHEN MAX(s.salary) - MIN(s.salary) <= 10000 AND MAX(s.salary) - MIN(s.salary) > 0 THEN 'insignificant'
        WHEN MAX(s.salary) - MIN(s.salary) > 10000 THEN 'significant'
        ELSE 'salary decrease'
	END as salary_raise
FROM 
dept_manager dm
JOIN
employees e ON dm.emp_no = e.emp_no
JOIN
salaries s ON s.emp_no = dm.emp_no
WHERE dm.emp_no > 10005
GROUP BY s.emp_no, e.first_name, e.last_name, e.hire_date
ORDER BY dm.emp_no;

-- Using ROW_NUMBER() in a SELECT Statement

SELECT 
	  emp_no, 
	  first_name, 
	  last_name,
	  ROW_NUMBER() OVER (PARTITION BY last_name ORDER BY emp_no) AS row_num
FROM
	  employees;
      
-- Using multiple Window Functions in a Query 
    
SELECT 
	ROW_NUMBER() OVER () AS row_num1,
	t.emp_no, 
	t.title,
	s.salary, 
  ROW_NUMBER() OVER (PARTITION BY t.emp_no ORDER BY salary DESC) AS row_num2
FROM
	titles t
    JOIN  
    salaries s ON t.emp_no = s.emp_no
WHERE t.title = 'Staff' AND t.emp_no < 10007
ORDER BY t.emp_no ASC, s.salary ASC, row_num1 ASC;

-- Mastering PARTITION BY 

SELECT a.emp_no, 
	a.salary as third_max_salary FROM (
	SELECT 
		s.emp_no, salary, ROW_NUMBER() OVER w AS row_num
	FROM
		dept_manager dm 
	JOIN 
	    salaries s ON s.emp_no = dm.emp_no 
	WINDOW w AS (PARTITION BY s.emp_no ORDER BY salary DESC)) a
WHERE a.row_num = 3;

-- Exploring the Interaction Between Ranking Window Functions and SQL JOINs

SELECT 
    e.emp_no,
    DENSE_RANK() OVER w as employee_salary_ranking,
    s.salary,
    e.hire_date,
    s.from_date
FROM
	employees e 
		JOIN 
    salaries s ON s.emp_no = e.emp_no
    AND s.from_date < '2000-01-01'
WHERE e.emp_no BETWEEN 10001 AND 10003
WINDOW w as (PARTITION BY e.emp_no ORDER BY s.salary DESC)
ORDER BY e.emp_no ASC;

-- Using LAG() and LEAD() to Calculate Salary Differences

SELECT 
	emp_no,
  salary, 
  LAG(salary) OVER w AS previous_salary,
  LEAD(salary) OVER w AS next_salary,
  salary - LAG(salary) OVER w AS diff_salary_current_previous,
	LEAD(salary) OVER w - salary AS diff_salary_next_current
FROM
	salaries
    WHERE salary < 70000 AND emp_no BETWEEN 10003 AND 10008
WINDOW w AS (PARTITION BY emp_no ORDER BY salary);

-- Adapting Aggregate Functions for Use in Window Functions

SELECT 
    DISTINCT a.dept_no,
    a.dept_name,
    MIN(a.salary) OVER w AS min_salary,
    MAX(a.salary) OVER w AS max_salary,
    ROUND((AVG(a.salary) OVER w)) AS avg_salary
FROM (
    SELECT 
        de.dept_no,
        d.dept_name,
        s.salary
    FROM 
        salaries s
    JOIN 
        dept_emp de ON s.emp_no = de.emp_no
    JOIN 
        departments d ON de.dept_no = d.dept_no
) a
WINDOW w AS (PARTITION BY a.dept_no ORDER BY a.dept_no ASC);

-- 

WITH cte AS (
SELECT AVG(salary) AS avg_salary FROM salaries
)
SELECT
SUM(CASE WHEN s.salary < c.avg_salary THEN 1 ELSE 0 END) AS no_f_salaries_below_avg,
COUNT(s.salary) AS no_of_f_salary_contracts
FROM salaries s JOIN employees e ON s.emp_no = e.emp_no AND e.gender = 'F' JOIN cte c;

-- A WITH Clause with Multiple Subclauses

WITH cte AS (
    SELECT AVG(salary) AS avg_salary FROM salaries
),
cte2 AS (
    SELECT COUNT(salary) AS total_no_of_salary_contracts FROM salaries
)
SELECT
    SUM(CASE WHEN s.salary < c.avg_salary THEN 1 ELSE 0 END) AS no_f_salaries_below_avg,
    (SELECT total_no_of_salary_contracts FROM cte2) AS total_no_of_salary_contracts
FROM salaries s
JOIN employees e ON s.emp_no = e.emp_no AND e.gender = 'F'
JOIN cte c;

