-- Part 2.4 update.sql
--
-- Submitted by: Nikita Lyakhovoy, K20041405
-- 

-- DO NOT use these SQL commands in your submission(they will cause an 
--  error on the NMS database server):
-- CREATE SCHEMA 
-- USE 



-- 1. Hourly Payment instead 

-- Rename the daily salary column, to hourly salary
ALTER TABLE Coach 
CHANGE COLUMN dailySalary 
                hourlyPayment
                DECIMAL(10,2) NOT NULL;

ALTER TABLE Participant
CHANGE COLUMN dailySalary 
                hourlyPayment
                DECIMAL(10,2) NOT NULL;

UPDATE Coach 
SET hourlyPayment = hourlyPayment/4;

UPDATE Participant
SET hourlyPayment = hourlyPayment/4;


select * from Coach;
select * from Participant;

-- 2. Add new fields to the attendance table to register when coaches and contenders arrive to and leave the shows.


ALTER TABLE CoachInShow
ADD COLUMN ArriveTime TIME NOT NULL;

ALTER TABLE ContenderInShow
ADD COLUMN ArriveTime TIME NOT NULL;

select * from CoachInShow;
select * from ContenderInShow;