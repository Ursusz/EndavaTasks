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
