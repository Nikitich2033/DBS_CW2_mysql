-- Part 2.5 delete.sql
--
-- Submitted by: Nikita Lyakhovoy, K20041405
-- 

-- DO NOT use these SQL commands in your submission(they will cause an 
--  error on the NMS database server):
-- CREATE SCHEMA 
-- USE 



-- Remove contender with the lowest total salary
-- A view with total salaries of every contender already exists: TotalByContender.
-- It was made to get the contender with the highest salary.

SELECT TotalByContender.stageName, idContender, 
       Total_Daily_Salary_Per_Contender as Highest_Total_Daily_Salary
FROM TotalByContender, Contender
WHERE Total_Daily_Salary_Per_Contender = (SELECT MIN(Total_Daily_Salary_Per_Contender)
                                            FROM TotalByContender) 
AND TotalByContender.stageName = Contender.stageName;
