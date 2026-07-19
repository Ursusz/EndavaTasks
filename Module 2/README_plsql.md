# Module 2 

## PL SQL
Task: Develop a modular debugging framework for PL/SQL, designed to monitor, trace, and diagnose errors and execution flows in medium and large-scale applications.

The essential components are:  
    - Logging Table ([debug_log](/Module%202/DebugPackage/debug_log.sql))  
    ![Debug Log Img](/Module%202/static/debug_log.png)  
    - Utility Package ([debug_pkg](/Module%202/DebugPackage/debug_pkg_body.sql))  

Desired Features:  
    - Dynamic enabling/desabling of debug mode  
        -> I have used a boolean flag g_debug_mode in the debug_pkg.  
    - Conditional logging based on global flag g_debug_mode  
        -> IF branch verifying if the global flag is enabled.  
    - Logging of module name, line number, and current session 
        -> Custom made insert clauses in each logging procedure.   
    - Ability to extend the framework with logging levels (INFO, WARN, ERROR)
        -> LOG_LEVEL attribute in debug_log table, global constants for each log level.  
 
 [Part two](/Module%202/DebugPackage/task.sql). Objective: Create a PL/SQL procedure that updates employee salaries based on the commission_pct value.  
 Behavior:  
 1. For each employee:
    * If commission_pct has a defined value (not NULL), the salary will be incresed proportionally by that percentage.
    * If commission_pct is NULL, the salary will be increased by 2% of the current value  
2. The procedure must use the debugging package so that:  
    * At each important step (reading data, calculation, update), a log message recorded only if debug mode is active.  

Optional: Logging Levels  
YOu may add log levels (DEBUG, INFO, WARN, ERROR) and flags to enable/disable them at runtime.  
