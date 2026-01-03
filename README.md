# Enterprise Attendence Management System
This project is an enterprise attendance and clock-in management system based on SQL Server.
It was developed as a course project by a sophomore majoring in Software Engineering.

## Features
1.Department and employee management
2.Clock-in / clock-out attendance records
3.Automatic daily attendance generation using triggers
4.Late arrival, absence, and absenteeism detection
5.Leave management
6.Overtime calculation
7.Monthly and weekly statistics by employee and department

## Project Structure
SQL/
01_create_database.sql   -- Create database and log files
02_create_tables.sql     -- Create core tables
03_seed_data.sql         -- Insert sample data
04_triggers.sql          -- Triggers for attendance logic
05_procedures.sql        -- Stored procedures for statistics
06_views.sql             -- Views for summary queries
07_demo_queries.sql      -- Demo queries and usage examples

## How to Run
1.Execute scripts in order from 01 to 07 in SQL Server
2.Ensure file paths in '01_create_database.sql' match your local environment
3.Run demo queries to view attendance results

## Notes
This is the author's first GitHub repository.
Suggestions and improvements are welcome.
