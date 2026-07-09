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
