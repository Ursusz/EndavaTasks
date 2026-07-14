CREATE OR REPLACE PACKAGE debug_pkg AS
	c_debug 	constant number(1) := 1;
	c_info 		constant number(1) := 2;
	c_warn 		constant number(1) := 3;
	c_error 	constant number(1) := 4;

	g_debug_mode 	boolean := TRUE;
	g_debug_level	number(1) := c_debug;

	PROCEDURE enable_debug;
	PROCEDURE disable_debug;
	PROCEDURE set_debug_level(p_level number);
	
	PROCEDURE log_msg(
		p_module_name varchar2, 
		p_line NUMBER, 
		p_level NUMBER, 
		p_message varchar2
	);
	
	PROCEDURE log_variable(
		p_module_name varchar2, 
		p_line NUMBER, 
		p_level NUMBER, 
		p_name varchar2, 
		p_value varchar2
	);
	
	PROCEDURE log_error(
		p_module_name varchar2, 
		p_line NUMBER, 
		p_proc varchar2, 
		p_err varchar2,
		p_level NUMBER DEFAULT c_error
	);
	
	PROCEDURE show_debug_level;
END debug_pkg;