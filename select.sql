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


-- SELECT TOTAL DAILY SALARY OF EACH PARTICIPANT 
CREATE OR REPLACE VIEW Total_Daily_Salary_By_idParticipant
AS
SELECT stageName, Participant.idParticipant as PART_ID, 
                Participant.idContender as CONT_ID, 
                dailySalary * COUNT(TVShow.idShow) AS Total_Daily_Salary
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


-- SELECT ONLY THE ENTRY WITH THE HIGHEST SALARY 
SELECT stageName, Total_Daily_Salary_Per_Contender as Highest_Total_Daily_Salary
FROM TotalByContender
-- COMPARE TO THE HIGHEST TOTAL SALARY OF A SINGLE CONTENDER THAT EXISTS
WHERE Total_Daily_Salary_Per_Contender = (SELECT MAX(Total_Daily_Salary_Per_Contender)
                                            FROM TotalByContender);


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
SELECT GetAllGroupIDS.idContender AS CONT_ID, COUNT(Participant.idContender) as No_Of_Participants_In_Group
FROM GetAllGroupIDS, Participant
WHERE Participant.idContender = GetAllGroupIDS.idContender
GROUP BY CONT_ID;

CREATE OR REPLACE VIEW OnlyWellFormedGroups
AS
SELECT CONT_ID, No_Of_Participants_In_Group
FROM CountParticipantInGroups
WHERE No_Of_Participants_In_Group > 1;


-- TEST BEFORE INSERTING A NON WELL FORMED GROUP
-- Compare the number of rows in the 2 views and see if they are the same
SELECT  
     CASE WHEN (SELECT COUNT(*) FROM OnlyWellFormedGroups) = (SELECT COUNT(*) FROM CountParticipantInGroups)
-- Comparison in SQL returns Boolean in the form of 1/0, but I have changed it to True/False as the question said so
     THEN "True" 
     ELSE "False"
     END AS All_Groups_Are_WellFormed;


INSERT INTO Contender VALUES ("FakeGroup",'Group',9,2);   
INSERT INTO Participant VALUES ("Fake","Guy",'1993-10-13',11,"2745763957",100.00,"Male",9);              


-- TEST AFTER INSERTING A NON WELL FORMED GROUP
-- Compare the number of rows in the 2 views and see if they are the same
SELECT  
     CASE WHEN (SELECT COUNT(*) FROM OnlyWellFormedGroups) = (SELECT COUNT(*) FROM CountParticipantInGroups)
-- Comparison in SQL returns Boolean in the form of 1/0, but I have changed it to True/False as the question said so
     THEN "True" 
     ELSE "False"
     END AS All_Groups_Are_WellFormed;

-- DELETING THE ENTRIES INSERTED FOR TESTING
DELETE FROM Participant WHERE PartName = "Fake";
DELETE FROM Contender WHERE stageName = "FakeGroup";

