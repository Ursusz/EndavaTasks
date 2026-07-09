# Module 2 

## Generic RDBMS
Task: Create a database for a employee timecard system. Define and implement specific queries on it.

## Table of Contents
- [Project Overview](#project-overview)
- [Implemented Features Overview](#implemented-features-overview)
    - [Constraints](#constraints)
    - [JSON Column](#json-column)
    - [Additional Indexes](#indexes)
    - [View](#view)
    - [Materialized View, GROUP BY and LEFT JOIN](#materialized-view-group-by-and-left-join)
    - [Analytic Functions](#analytic-functions-query)
    - [Extras](#extras)

**Logical Database Diagram** | The diagram was made using https://dbdiagram.io/
**NOTE THAT** at the moment when I have made the database diagram (and lost the code) employee metadata wasn't implemented yet and the absences column in timecard_entry was varchar instead of number.

![DatabaseDiagram](/Module%202/static/database_diagram.png)

### Project overview
This database models a simple employee time tracking system. Employees belong to departments, departments own projects,
employees submit weekly timecards, and every timecard contains project-specific work entries. The database also includes business rules
enforced through triggers, helper PL/SQL procedures and functions, JSON data amd reporting queries.

## Implemented features overview
## constraints
* Task: Include at least one example of each type of constraint presented during the course.
Constraints implemented:
- Primary Keys
- Foreign Keys
- Check Constraints
- JSON validation (employee_metadata IS JSON)
- Triggers: 
    > - project department validation (the project in the timecard should be withing the department of the employee)  
    > - employee age validation (each employee has to be 18 years old at the moment of hire date)  
    > - task validation (prevents completing a task that does not belong to the project)
    > - timecard edit and insert (prevents inserting timecard entries or updating after submitted)
    > - work day validation (stop time must be after start time)
- Bonus: stored procedures and functions.
    > - td(/\*p_date varchar2\*/) receives a date in char format and returns default database format DATE value
    > - tdt(/\*p_datetime varchar2\*/) receives a datetime in char and returns default database format DATE value with hours,mins,sec
    > - insert_work_entry(/\*p_working_date IN varchar2, p_start_time IN varchar2, p_stop_time IN varchar2, p_worked_hours IN number, p_timecard_entry_id IN number\*/)
    > receives working date (calendaristic date), start hour, end hour, number of worked hours, timecard row id (entry id) and inserts automatically 
    > formated data into the table.

## JSON Column
* Task : Include at least one column containing semi-structured data (JSON or XML).  
Implemented: Employees.employee_metadata
This column stores employee specific metadata (i.e. phone number, social media profiles, spoken languages, emergency contacts)
```sql
UPDATE EMPLOYEE e
SET employee_metadata = '{
	"phone": "+4077123456",
	"linkedin": "linkedin.com/in/placeholder",
	"languages": ["Romanian", "English"],
	"emergencyContact": {
		"name": "placeholder",
		"phone": "+4077456123"
	}
}'
WHERE e.LAST_NAME = 'Ursu';
```

## Indexes
* Task: Include additional indexed fields besides foreign keys and primary keys.  
Implemented: IX_Employee_birthdate
```sql
CREATE INDEX IX_Employee_birthdate ON employee(birth_date);
```
#### No indexed field filter:
![NoIndex](/Module%202/static/noindex.png)
#### Indexed field filter:
![Index](/Module%202/static/index.png)

To have a better insight into ratio ratio I have scripted a short code snippet to compute it.
```sql
DECLARE
	v_filtered_count NUMBER;
	v_unfiltered_count NUMBER;
	v_procent NUMBER;
BEGIN
	SELECT count(*)
	INTO v_filtered_count
	FROM(
		SELECT * FROM employee
		WHERE birth_date BETWEEN td('24-08-1980') AND td('18-09-1980')
	);

	SELECT count(*)
	INTO v_unfiltered_count
	FROM employee;
	
	v_procent := round(v_filtered_count / v_unfiltered_count * 100, 2);
	
	dbms_output.put_line('The ratio between unfiltered and filtered employees based on birth_date: ' || v_procent || '%');
END;
```
**The ratio between unfiltered and filtered employees based on birth_date: 3.25%**
As we can see, the database engine decided to use the indexed scan instead of full table scan because
the employees born between those two dates represented only 3.25% of all the available entries.

## View
* Task: Include at least one view.  
Implemented: vw_employee_timecards
```sql
CREATE OR REPLACE VIEW vw_employee_timecards
AS
SELECT e.person_number, e.last_name || ' ' || e.first_name AS emp_name,
to_char(t.start_date, 'FMMM/DD/YY') AS period_start,
to_char(t.start_date + 6, 'FMMM/DD/YY') AS period_end,
initcap(t.status) AS status,
(SELECT sum(we.worked_hours) FROM timecard_entry te JOIN work_entry we ON te.id = we.timecard_entry_id WHERE te.timecard_id = t.id) AS worked_hours,
'40' AS scheduled_hours, -- for scheduled hours to be correctly calculated we would need a table with holidays in order to account them
nvl((SELECT sum(te.absences) FROM timecard_entry te WHERE te.timecard_id = t.id), 0) AS absence_hours,
'40' AS total_hours, -- i am not sure what this is
to_char(t.submission_date, 'FMMM/DD/YY') AS submission_date,
NULL AS exception
FROM employee e JOIN timecard t ON e.person_number = t.employee_id
ORDER BY emp_name, period_start DESC;

-- employee timecards dashboard (i.e /existing-timecards/view-summary in oracle)
-- but it's computed for ALL employees
-- get the starting day, ending day, status, reported hours, scheduled hours, absence hours, total hours, submission date and exception
-- (all the data in the actual page)
-- in one place for all employees, ready to be delivered
-- can be filtered on person_number to display each individual's timecards
```
## Materialized View, GROUP BY and LEFT JOIN
* Task:  
Include at least one materialized view.  
Include at least one SELECT query using GROUP BY.  
Include at least one SELECT query using a LEFT JOIN.
```sql
CREATE MATERIALIZED VIEW vw_department_statistics
build IMMEDIATE
refresh complete ON demand
enable query rewrite
AS
SELECT d.department_id AS id_dep, d.department_name AS dep_name,
count(DISTINCT e.person_number) AS emp_count,
count(DISTINCT p.project_id) AS proj_count,
count(DISTINCT t.id) AS timecard_count,
min(e.salary) AS sal_min,
max(e.salary) AS sal_max,
round(avg(e.salary), 2) AS sal_avg
FROM department d 
LEFT JOIN employee e ON e.department_id = d.department_id
LEFT JOIN timecard t ON e.person_number = t.employee_id
LEFT JOIN project p ON p.department_id = d.department_id
GROUP BY d.department_name, d.department_id;

-- for each department, print the id and the name, the number of employees in that respective dep, and the number of projects
-- also, aggregate min salary, max salary and average salary over each dep
-- the need of this materialized view is that it could be used in a dashboard, and when the number of employees and projects start to increase
-- the overall computational power needed to aggregatet all data and join the tables will get too high
-- also, the dashboard could be accessed by multiple people at the same time so we have a snapshot of the data ready to be sent to the frontend
-- instead of being re-computed each time
```

## Analytic functions query
* Task: Include at least one SELECT query using an analytic function other than ROW_NUMBER.
Implemented: rank() and lag()
```sql
SELECT e.department_id, d.department_name, e.first_name || ' ' || e.last_name AS emp_name,
e.salary,
rank() OVER (PARTITION BY e.department_id ORDER BY e.salary desc) AS rank_in_dep,
lag(e.salary) OVER (ORDER BY e.salary desc) - e.salary AS diff_from_prev
FROM employee e
LEFT JOIN department d ON e.department_id = d.department_id
ORDER BY d.department_id, rank_in_dep;

-- for each employee, print the department id and name in which they belong to,
-- his salary, the rank he owns in his department based on the salary desc
-- and the difference between his salary and the employee before him
```

## Extras
* EXTRAS
```sql
-- extra group by
-- For each department that has at least 400 employees and the average salary is greater or equal than 2400
-- it's calculated the employee count, the minimum salary in that department, the maximum salary and the average salary
-- group by task
SELECT d.department_name AS dep_name,
count(DISTINCT person_number) AS emp_count,
min(e.salary) AS sal_min,
max(e.salary) AS sal_max,
round(avg(e.salary), 2) AS sal_avg,
FROM department d
LEFT JOIN employee e ON e.department_id = d.department_id
GROUP BY d.department_id, d.department_name
HAVING emp_count > 400 AND sal_avg >= 2400;

-- extra left join
-- print the project code, project name, the department name in which that project belongs to
-- and the total number of hours spent working by all employees on that project
SELECT p.project_code, p.project_name, d.department_name,
nvl(sum(we.worked_hours), 0) AS total_worked_hours
FROM project p 
LEFT JOIN department d ON p.department_id = d.department_id
LEFT JOIN timecard_entry te ON te.project_id = p.project_id
LEFT JOIN work_entry we ON te.id = we.timecard_entry_id
GROUP BY p.project_code, p.project_name, d.department_name;

-- extra analytic function
-- for each employee print the number of worked hours each day in chronologic order,
-- and the running total of working hours until that moment
SELECT e.person_number, e.last_name || ' ' || e.first_name AS emp_name,
to_char(we.work_date, 'FMMM/DD/YY') AS last_worked_day,
we.worked_hours AS current_day_worked_hours,
sum(we.worked_hours) OVER (PARTITION BY e.person_number ORDER BY we.work_date) AS worked_until_date
FROM employee e
JOIN timecard t ON e.person_number = t.employee_id
JOIN timecard_entry te ON t.id = te.timecard_id
JOIN work_entry we ON te.id = we.timecard_entry_id
ORDER BY e.last_name, e.first_name, we.work_date;
```