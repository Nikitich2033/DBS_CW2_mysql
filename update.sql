-- Part 2.4 update.sql
--
-- Submitted by: Nikita Lyakhovoy, K20041405
-- 

-- DO NOT use these SQL commands in your submission(they will cause an 
--  error on the NMS database server):
-- CREATE SCHEMA 
-- USE 



-- 1. Hourly Payment instead 

ALTER TABLE Coach 
RENAME COLUMN dailySalary to hourlyPayment;

ALTER TABLE Participant
RENAME COLUMN dailySalary hourlyPayment;

UPDATE Coach 
SET hourlyPayment = hourlyPayment/4;

UPDATE Participant
SET hourlyPayment = hourlyPayment/4;


select * from Coach;
select * from Participant;
