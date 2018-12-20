-- MUST EDIT THIS FILE to create the proper database and permissions
-- WILL NOT WORK UNTIL YOU UNCOMMENT NEXT LINE WITH A PASSWORD OF YOUR CHOICE

-- CREATE USER 'devsecops'@'localhost' IDENTIFIED BY 'REPLACE_PASSWORD_HERE!' 
DROP schema IF EXISTS devsecops_soc;
CREATE DATABASE devsecops_soc; -- same as create schema
USE devsecops_soc;
GRANT ALL PRIVILEGES ON devsecops_soc . * TO 'devsecops'@'localhost' WITH GRANT OPTION;
