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


-- 2. Add new fields to the attendance table to register when coaches and contenders arrive to and leave the shows.


ALTER TABLE CoachInShow
ADD COLUMN ArriveTime TIME NOT NULL,
ADD COLUMN LeaveTime TIME NOT NULL;

ALTER TABLE ContenderInShow
ADD COLUMN ArriveTime TIME NOT NULL,
ADD COLUMN LeaveTime TIME NOT NULL;


-- 3. Set the arrival time to one hour before the show started and the departure time to one hour after the end time.


-- As mentioned in the specification, we only need to update Arrival and Departure times
-- for the past shows, that is why there is a comparison to the current date
-- all the future shows remain dafaulted at 00:0000
UPDATE CoachInShow,
        TVShow
SET ArriveTime = TVShow.startTime - INTERVAL 1 HOUR,
    LeaveTime = TVShow.endTime + INTERVAL 1 HOUR  
WHERE CoachInShow.idShow = TVShow.idShow
AND TVShow.ShowDate < CAST(CURRENT_TIMESTAMP AS DATE);

UPDATE ContenderInShow,
        TVShow
SET ArriveTime = TVShow.startTime - INTERVAL 1 HOUR,
    LeaveTime = TVShow.endTime + INTERVAL 1 HOUR  
WHERE ContenderInShow.idShow = TVShow.idShow
AND TVShow.ShowDate < CAST(CURRENT_TIMESTAMP AS DATE);
