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