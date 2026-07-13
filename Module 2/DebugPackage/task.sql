CREATE OR REPLACE PROCEDURE update_emp_sal_with_commission
IS
	c_default_commission NUMBER := 0.2;
	v_current_commission NUMBER;
	v_msg_lcl varchar2(4000);
BEGIN
	IF 1=1 THEN
		debug_pkg.enable_debug();
	ELSE
		debug_pkg.disable_debug();
	END IF;

	FOR cu IN (SELECT person_number, first_name, last_name, salary, commission_pct FROM employee) LOOP
		v_msg_lcl := 'Current employee read - ' || cu.first_name || ' ' || cu.last_name || ' (' || cu.person_number || ')'
		debug_pkg.log_msg(
			'update_emp_sal_with_commission', 
			12, 
			debug_pkg.c_info,
			v_msg_lcl
		);
		
		v_current_commission := COALESCE(cu.commission_pct, c_default_commission);
		v_msg_lcl := 'Current salary: ' || cu.salary || ' (commission pct: ' || v_current_commission || ')'
		IF cu.commission_pct IS NULL THEN
			v_msg_lcl := v_msg_lcl || '[DEFAULT] - before update';
		END IF;
		debug_pkg.log_msg(
			'update_emp_sal_with_commission', 
			24, 
			debug_pkg.c_info,
			v_msg_lcl
		);
		
		UPDATE employee
		SET salary = cu.salary + cu.salary * v_current_commission
		WHERE person_number = cu.person_number;
		COMMIT;
		
		-- todo
	END LOOP;	
END;