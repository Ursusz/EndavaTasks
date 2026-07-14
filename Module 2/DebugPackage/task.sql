CREATE OR REPLACE PROCEDURE update_emp_sal_with_commission
IS
	c_default_commission NUMBER := 0.2;
	v_current_commission NUMBER;
	v_msg_lcl varchar2(4000);
	v_salary_result NUMBER;
BEGIN
	IF 1=1 THEN
		debug_pkg.enable_debug();
	ELSE
		debug_pkg.disable_debug();
	END IF;

	/*
	TASK: Using dynamic SQL or an explicit cursor, depending on your preference"
	I chose to use an implicit cursor  [for cu in (select ...) loop] while updating the employee.
	However, below is an example of how an explicit cursor could be used to accomplish the same task.

	First, the cursor must be declare between the IS and BEGIN sections
	
	CURSOR cu IS
	select person_number, first_name, last_name, salary, commission_pct from employee for update;

	Then, the loop would look something like this:
	
	OPEN cu;
	LOOP
		fetch cu into ...
		exit when cu%NOTFOUND;

		update employee
		set salary = ...
		where current of cu;
	END LOOP;

	close cu;
	*/

	FOR cu IN (SELECT person_number, first_name, last_name, salary, commission_pct FROM employee) LOOP
		v_msg_lcl := 'Current employee read - ' || cu.first_name || ' ' || cu.last_name || ' (' || cu.person_number || ')';
		debug_pkg.log_msg(
			'[READ]update_emp_sal_with_commission', 
			null, 
			debug_pkg.c_info,
			v_msg_lcl
		);
		
		v_current_commission := COALESCE(cu.commission_pct, c_default_commission);
		v_msg_lcl := 'Current salary: ' || cu.salary || ' (commission pct: ' || v_current_commission || ')';
		IF cu.commission_pct IS NULL THEN
			v_msg_lcl := v_msg_lcl || '[DEFAULT] - before update';
		END IF;
		debug_pkg.log_msg(
			'[COMMISSION]update_emp_sal_with_commission', 
			null, 
			debug_pkg.c_info,
			v_msg_lcl
		);
		
		UPDATE employee
		SET salary = cu.salary + cu.salary * v_current_commission
		WHERE person_number = cu.person_number;
		COMMIT;
		
		SELECT salary
		INTO v_salary_result
		FROM employee
		WHERE person_number = cu.person_number;
		
		v_msg_lcl := 'Update complete. New salary: ' || v_salary_result || ' (Employee code: ' || cu.person_number || ')';
		debug_pkg.log_msg(
			'[UPDATE]update_emp_sal_with_commission',
			null,
			debug_pkg.c_info,
			v_msg_lcl
		);
	END LOOP;	
	EXCEPTION
		WHEN no_data_found OR too_many_rows OR value_error OR program_error THEN
			debug_pkg.log_error(
				'[ERROR]update_emp_sal_with_commission',
				null,
				'update employee salary',
				'ERROR while updating employee salary: ' || SQLERRM
			);
		WHEN OTHERS THEN
			debug_pkg.log_error(
				'[WARN]update_emp_sal_with_commission',
				null,
				'update employee salary',
				'WARNING while updating employee salary: ' || SQLERRM,
				debug_pkg.c_warn
			);
END update_emp_sal_with_commission;