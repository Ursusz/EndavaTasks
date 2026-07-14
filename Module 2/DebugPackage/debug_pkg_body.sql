CREATE OR REPLACE PACKAGE BODY debug_pkg AS
	PROCEDURE enable_debug IS
	BEGIN
		IF NOT g_debug_mode THEN
			g_debug_mode := TRUE;
			log_msg('debug_pkg body', 6, c_info, 'Debug mode enabled.');
		ELSE 
			log_msg('debug_pkg body', 8, c_info, 'Debug mode already enabled.');
		END IF;
	END enable_debug;
	
	PROCEDURE disable_debug IS
	BEGIN
		IF g_debug_mode THEN
			log_msg('debug_pkg body', 16, c_info, 'Debug mode disabled.');
			g_debug_mode := FALSE;
		ELSE
			log_msg('debug_pkg body', 18, c_info, 'Debug mode already disabled.');
		END IF;
	END disable_debug;
	
	PROCEDURE set_debug_level(p_level number) IS
	BEGIN
		IF p_level IN (c_debug, c_info, c_warn, c_error) THEN
			g_debug_level := p_level;
		END IF;
	END set_debug_level;
	
	PROCEDURE log_msg(p_module_name varchar2, p_line NUMBER, p_level number, p_message varchar2) IS
	BEGIN
		IF g_debug_mode AND p_level >= g_debug_level THEN
			INSERT INTO debug_log(module_name, line_no, log_message, log_level)
			VALUES(
				p_module_name, 
				p_line, 
				p_message, 
				p_level
			);
			COMMIT;
		END IF;
	END log_msg;
	
	PROCEDURE log_variable(p_module_name varchar2, p_line NUMBER, p_level NUMBER, p_name varchar2, p_value varchar2) IS
	BEGIN
		IF g_debug_mode AND p_level >= g_debug_level THEN
			INSERT INTO debug_log(module_name, line_no, log_message, log_level)
			VALUES(
				p_module_name, 
				p_line, 
				'VAL ' || p_name || ' = ' || p_value, 
				p_level
			);
		COMMIT;
		END IF;
	END log_variable;
	
	PROCEDURE log_error(p_module_name varchar2, p_line NUMBER, p_proc varchar2, p_err varchar2, p_level NUMBER default c_error) IS
	BEGIN
		IF g_debug_mode AND p_level >= g_debug_level THEN
			INSERT INTO debug_log(module_name, line_no, log_message, log_level)
			VALUES(
				p_module_name,
				p_line,
				'ERROR at ' || p_proc || ' : ' || p_err, 
				p_level
			);
		COMMIT;
		END IF;
	END log_error;
	
	PROCEDURE show_debug_level IS
	BEGIN
		INSERT INTO debug_log(module_name, line_no, log_message, log_level)
		values(
			'system',
			NULL,
			CASE g_debug_level
				WHEN c_debug THEN 'debug level'
				WHEN c_info THEN 'info level'
				WHEN c_warn THEN 'warning level'
				WHEN c_error THEN 'error level'
			END,
			c_info
		);
		COMMIT;
	END show_debug_level;
END debug_pkg;