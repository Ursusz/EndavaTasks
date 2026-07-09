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