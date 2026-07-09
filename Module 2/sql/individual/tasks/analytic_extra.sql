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