DECLARE
	TYPE t_table_names IS TABLE OF varchar2(30 char);
	v_table_names t_table_names := t_table_names(
		'WORK_ENTRY',
		'TIMECARD_ENTRY',
		'TIMECARD',
		'PROJECT',
		'EMPLOYEE',
		'DEPARTMENT'
	);
BEGIN	
	FOR i IN 1..v_table_names.count LOOP
		EXECUTE IMMEDIATE 'DROP TABLE IF EXISTS ' || v_table_names(i) || ' CASCADE CONSTRAINTS';
	END LOOP;
END;
/