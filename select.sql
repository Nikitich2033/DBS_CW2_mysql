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
    

#SELECT ONLY THE ENTRY WITH THE HIGHEST SALARY 
SELECT stageName, Total_Daily_Salary_Per_Contender as Highest_Total_Daily_Salary
FROM(
#SELECT THE SUM OF SALARIES FOR EACH CONTENDER
    SELECT stageName, CONT_ID, SUM(Participant_Total_Daily_Salary) as Total_Daily_Salary_Per_Contender
        FROM(
#SELECT TOTAL DAILY SALARIES OF ALL PARTICIPANTS
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
#COMPARE TO THE HIGHEST TOTAL SALARY OF A SINGLE CONTENDER
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

CREATE OR REPLACE VIEW ShowIDsInMarch
AS
SELECT ShowDate, idShow 
FROM TVShow
WHERE MONTHNAME(ShowDate) = "April";

SELECT CoachName, CoachSurname, dailySalary, COUNT(ShowIDsInMarch.idShow) AS No_Of_Shows_Attended
FROM Coach 
LEFT JOIN CoachInShow
ON Coach.idCoach = CoachInShow.idCoach
LEFT JOIN ShowIDsInMarch
ON ShowIDsInMarch.idShow = CoachInShow.idShow
GROUP BY CoachName, CoachSurname
ORDER BY CoachName, CoachSurname;


-- 6. Well Formed Groups!

