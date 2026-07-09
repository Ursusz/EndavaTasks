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