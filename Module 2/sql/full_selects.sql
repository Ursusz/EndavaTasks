-- view task
-- employee timecards dashboard (i.e /existing-timecards/view-summary in oracle)
-- but it's computed for ALL employees
-- get the starting day, ending day, status, reported hours, scheduled hours, absence hours, total hours, submission date and exception
-- (all the data in the actual page)
-- in one place for all employees, ready to be delivered
-- can be filtered on person_number to display each individual's timecards
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

-- materialized view task + group by + left join
-- for each department, print the id and the name, the number of employees in that respective dep, and the number of projects
-- also, aggregate min salary, max salary and average salary over each dep
-- the need of this materialized view is that it could be used in a dashboard, and when the number of employees and projects start to increase
-- the overall computational power needed to aggregatet all data and join the tables will get too high
-- also, the dashboard could be accessed by multiple people at the same time so we have a snapshot of the data ready to be sent to the frontend
-- instead of being re-computed each time
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

-- analytic function
-- for each employee, print the department id and name in which they belong to,
-- his salary, the rank he owns in his department based on the salary desc
-- and the difference between his salary and the employee before him
SELECT e.department_id, d.department_name, e.first_name || ' ' || e.last_name AS emp_name,
e.salary,
rank() OVER (PARTITION BY e.department_id ORDER BY e.salary desc) AS rank_in_dep,
lag(e.salary) OVER (ORDER BY e.salary desc) - e.salary AS diff_from_prev
FROM employee e
LEFT JOIN department d ON e.department_id = d.department_id
ORDER BY d.department_id, rank_in_dep;

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