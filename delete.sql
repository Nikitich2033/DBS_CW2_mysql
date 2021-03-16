-- Part 2.5 delete.sql
--
-- Submitted by: Nikita Lyakhovoy, K20041405
-- 

-- DO NOT use these SQL commands in your submission(they will cause an 
--  error on the NMS database server):
-- CREATE SCHEMA 
-- USE 



-- Remove contender with the lowest total salary

CREATE OR REPLACE VIEW Total_Daily_Salary_By_idParticipant
AS
SELECT stageName, Participant.idParticipant as PART_ID, 
                Participant.idContender as CONT_ID, 
                hourlyPayment * COUNT(TVShow.idShow) * 4 AS Total_Daily_Salary
        FROM Participant
        LEFT JOIN Contender
        ON Participant.idContender = Contender.idContender
        LEFT JOIN ContenderInShow
        ON Contender.idContender = ContenderInShow.idContender
        LEFT JOIN TVShow
        ON TVShow.idShow = ContenderInShow.idShow
        GROUP BY idParticipant;

-- SELECT TOTAL DAILY SALARY OF EACH PARTICIPANT 
CREATE OR REPLACE VIEW TotalByParticipant
AS 
SELECT stageName, PART_ID, CONT_ID,Total_Daily_Salary_By_idParticipant.Total_Daily_Salary as Participant_Total_Daily_Salary
FROM Total_Daily_Salary_By_idParticipant
GROUP BY PART_ID;

CREATE OR REPLACE VIEW TotalByContender
AS
-- SELECT THE SUM OF SALARIES FOR EACH CONTENDER
SELECT stageName, CONT_ID, SUM(Participant_Total_Daily_Salary) as Total_Daily_Salary_Per_Contender
FROM TotalByParticipant
-- SELECT TOTAL DAILY SALARIES OF ALL PARTICIPANTS     
GROUP BY stageName;



CREATE OR REPLACE VIEW LowestTotalSalary
AS
SELECT TotalByContender.stageName, idContender, 
       Total_Daily_Salary_Per_Contender as Highest_Total_Daily_Salary
FROM TotalByContender, Contender
WHERE Total_Daily_Salary_Per_Contender = (SELECT MIN(Total_Daily_Salary_Per_Contender)
                                            FROM TotalByContender) 
AND TotalByContender.stageName = Contender.stageName;


--Delete only from Contender, entries in ContenderInShow and Participant 
-- are deleted automatically because of ON DELETE CASCADE 
DELETE Contender
FROM  Contender, LowestTotalSalary
WHERE Contender.idContender = LowestTotalSalary.idContender;

SELECT * FROM Participant;
SELECT * FROM Contender;
SELECT * FROM ContenderInShow;
