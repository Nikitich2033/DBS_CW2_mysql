-- Part 2.3 select.sql
--
-- Submitted by: Nikita Lyakhovoy, K20041405
-- 

-- DO NOT use these SQL commands in your submission(they will cause an 
--  error on the NMS database server):
-- CREATE SCHEMA 
-- USE 


-- 1. Average Female Salary

SELECT AVG(dailySalary) AS Average_Female_Salary
FROM Participant
WHERE gender = "Female";

-- 2. Coaching Report.

SELECT CoachName, CoachSurname, COUNT(idContender) AS No_Of_contenders_coached 
FROM Coach
LEFT JOIN Contender
ON Coach.idCoach = Contender.idCoach
GROUP BY CoachName,CoachSurname
ORDER BY COUNT(idContender);

-- 3. Coach Monthly Attendance Report

SELECT CoachName, CoachSurname, MONTHNAME(TVShow.ShowDate) as 'Month', COUNT(Coach.idCoach) AS No_Of_Shows_Attended
FROM Coach 
LEFT JOIN CoachInShow
ON Coach.idCoach = CoachInShow.idCoach
LEFT JOIN TVShow
ON TVShow.idShow = CoachInShow.idShow
GROUP BY CoachName, CoachSurname, MONTH(TVShow.ShowDate)
ORDER BY CoachName, CoachSurname;

-- 4. Most Expensive Contender
    

-- SELECT ONLY THE ENTRY WITH THE HIGHEST SALARY 
SELECT stageName, Total_Daily_Salary_Per_Contender as Highest_Total_Daily_Salary
FROM(
-- SELECT THE SUM OF SALARIES FOR EACH CONTENDER
    SELECT stageName, CONT_ID, SUM(Participant_Total_Daily_Salary) as Total_Daily_Salary_Per_Contender
        FROM(
-- SELECT TOTAL DAILY SALARIES OF ALL PARTICIPANTS
            SELECT stageName, PART_ID, CONT_ID,Total_Daily_Salary_Per_Contender_Participant.Total_Daily_Salary as Participant_Total_Daily_Salary
            FROM (
        
                SELECT stageName, Participant.idParticipant as PART_ID, Participant.idContender as CONT_ID, dailySalary * COUNT(TVShow.idShow) AS Total_Daily_Salary
                FROM Participant
                LEFT JOIN Contender
                ON Participant.idContender = Contender.idContender
                LEFT JOIN ContenderInShow
                ON Contender.idContender = ContenderInShow.idContender
                LEFT JOIN TVShow
                ON TVShow.idShow = ContenderInShow.idShow
                GROUP BY idParticipant) Total_Daily_Salary_Per_Contender_Participant
                GROUP BY PART_ID) TotalByParticipant
                GROUP BY stageName
) TotalByContender
-- COMPARE TO THE HIGHEST TOTAL SALARY OF A SINGLE CONTENDER
WHERE Total_Daily_Salary_Per_Contender = (SELECT MAX(Total_Daily_Salary_Per_Contender)
                                            FROM (
                                                SELECT stageName, CONT_ID, SUM(Participant_Total_Daily_Salary) as Total_Daily_Salary_Per_Contender
                                                FROM(
                                                    SELECT stageName, PART_ID, CONT_ID,Total_Daily_Salary_Per_Contender_Participant.Total_Daily_Salary as Participant_Total_Daily_Salary
                                                    FROM (
                                                
                                                        SELECT stageName, Participant.idParticipant as PART_ID, Participant.idContender as CONT_ID, dailySalary * COUNT(TVShow.idShow) AS Total_Daily_Salary
                                                        FROM Participant
                                                        LEFT JOIN Contender
                                                        ON Participant.idContender = Contender.idContender
                                                        LEFT JOIN ContenderInShow
                                                        ON Contender.idContender = ContenderInShow.idContender
                                                        LEFT JOIN TVShow
                                                        ON TVShow.idShow = ContenderInShow.idShow
                                                        GROUP BY idParticipant) Total_Daily_Salary_Per_Contender_Participant
                                                        GROUP BY PART_ID) TotalByParticipant
                                                        GROUP BY stageName
                                                        )TotalByContender );


-- 5. March Payment Report

-- Get all Show IDs from March
CREATE OR REPLACE VIEW ShowIDsInMarch
AS
SELECT ShowDate, idShow 
FROM TVShow
WHERE MONTHNAME(ShowDate) = "March";

-- Create a separate report view for coaches and their totals
CREATE OR REPLACE VIEW CoachReportMarch
AS
SELECT CoachName as Name, CoachSurname as Surname, dailySalary, 
        COUNT(ShowIDsInMarch.idShow) AS No_Of_Shows_Attended_In_March,  
        COUNT(ShowIDsInMarch.idShow) * dailySalary AS Total_Salary_for_March
    FROM Coach 
    LEFT JOIN CoachInShow
    ON Coach.idCoach = CoachInShow.idCoach
    LEFT JOIN ShowIDsInMarch
    ON ShowIDsInMarch.idShow = CoachInShow.idShow
    GROUP BY CoachName, CoachSurname
    ORDER BY CoachName, CoachSurname;

-- Create a separate report view for participants and their totals
CREATE OR REPLACE VIEW ParticipantReportMarch
AS
SELECT PartName, PartSurname, dailySalary, 
                COUNT(ShowIDsInMarch.idShow) AS No_Of_Shows_Attended_In_March,
                dailySalary * COUNT(ShowIDsInMarch.idShow) AS Total_Salary_for_March
    FROM Participant
    LEFT JOIN Contender
    ON Participant.idContender = Contender.idContender
    LEFT JOIN ContenderInShow
    ON Contender.idContender = ContenderInShow.idContender
    LEFT JOIN ShowIDsInMarch
    ON ShowIDsInMarch.idShow = ContenderInShow.idShow
    GROUP BY idParticipant;

-- Calculate the total for all participants
CREATE OR REPLACE VIEW TotalForParticipants 
AS 
SELECT SUM(ParticipantReportMarch.Total_Salary_for_March) as Total
FROM ParticipantReportMarch;

-- Calculate the total for all coaches
CREATE OR REPLACE VIEW TotalForCoaches 
AS 
SELECT SUM(CoachReportMarch.Total_Salary_for_March) as Total
FROM CoachReportMarch;

-- Output a tables with the final results and Total as the bottom row
SELECT * FROM CoachReportMarch
UNION
SELECT * FROM ParticipantReportMarch
UNION 
SELECT 'Total', NULL, NULL, NULL, (TotalForCoaches.Total + TotalForParticipants.Total)   
FROM TotalForCoaches, TotalForParticipants;



-- 6. Well Formed Groups!

CREATE OR REPLACE VIEW GetAllGroupIDS
AS
SELECT idContender
FROM Contender
WHERE ContType = "Group";

CREATE OR REPLACE VIEW CountParticipantInGroups
AS
SELECT Contender.idContender, COUNT(Participant.idContender)
FROM Contender, Participant
WHERE EXISTS
    (SELECT Contender.idContender FROM GetAllGroupIDS, Contender WHERE idContender = Participant.idContender);


SELECT * FROM GetAllGroupIDS;

SELECT * FROM CountParticipantInGroups;