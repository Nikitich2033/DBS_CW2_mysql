-- Part 2.1 schema.sql
--
-- Submitted by: Nikita Lyakhovoy, K20041405
-- 

-- DO NOT use these SQL commands in your submission(they will cause an 
-- error on the NMS database server):
-- CREATE SCHEMA 
-- USE 


CREATE TABLE Coach(
     CoachName VARCHAR (15) NOT NULL,
     CoachSurname VARCHAR(15) NOT NULL,
     DoB DATE NOT NULL,
     idCoach INT UNIQUE NOT NULL,
-- Phone number is just a sequence of 10 numbers without a country code
     phone VARCHAR(10) UNIQUE NOT NULL,
-- Salary is defined as a decimal with 10 numbers in front and 2 numbers 
-- after the decimal point, because salaries are highly unlikely to exceed that
     dailySalary DECIMAL(10,2) NOT NULL,
     gender VARCHAR(6) NOT NULL,
     PRIMARY KEY(idCoach)            
);

CREATE TABLE Contender(
    stageName VARCHAR(25) UNIQUE NOT NULL,
    ContType VARCHAR (10) NOT NULL,
    idContender INT UNIQUE NOT NULL,
    idCoach INT NOT NULL,
    PRIMARY KEY(idContender),
    FOREIGN KEY(idCoach) 
        REFERENCES Coach(idCoach)
-- could not implement setting a new coach if the previuos one is deleted
-- But if I was to delete a coach,I would just set ON DELETE to SET DEFAULT 
-- and alter the Default value of idCoach to a random avaliable coach from the table.
        ON DELETE RESTRICT
        ON UPDATE CASCADE 
    
);

CREATE TABLE Participant(
    PartName VARCHAR (15) NOT NULL,
    PartSurname VARCHAR(15) NOT NULL,
    DoB DATE NOT NULL,
    idParticipant INT UNIQUE NOT NULL,
-- Phone number is just a sequence of 10 numbers without a country code
    phone VARCHAR(10) UNIQUE NOT NULL,
    dailySalary DECIMAL(10,2) NOT NULL,
    gender VARCHAR(6) NOT NULL,
    idContender INT NOT NULL,
    PRIMARY KEY(idParticipant),
    FOREIGN KEY(idContender) 
        REFERENCES Contender(idContender)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

-- location can be NULL when it takes place in the TV studio
-- Location can be anything, so it is just a varchar with a 25 character limit.
CREATE TABLE TVShow(
    
    ShowDate DATE NOT NULL,
    location VARCHAR(25),
    idShow INT UNIQUE NOT NULL,
    startTime TIME NOT NULL,
    endTime TIME NOT NULL,
    PRIMARY KEY(idShow)
);

CREATE TABLE CoachInShow(
    idCoach INT NOT NULL,
    idShow INT NOT NULL,
    PRIMARY KEY(idCoach,idShow),
    FOREIGN KEY (idCoach) 
		REFERENCES Coach(idCoach)
-- When a coach is deleted, occurences of that coach are deleted.
        ON DELETE CASCADE
        ON UPDATE CASCADE,

    FOREIGN KEY (idShow) 
        REFERENCES TVShow(idShow)
-- When a show is deleted, occurences of that show are deleted.
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

CREATE TABLE ContenderInShow(
    idContender INT NOT NULL,
    idShow INT NOT NULL,
    PRIMARY KEY(idContender,idShow),
    FOREIGN KEY (idShow) 
		REFERENCES TVShow(idShow)
-- When a show is deleted, occurences of that show are deleted.
		ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (idContender)
		REFERENCES Contender(idContender)
-- When a contender is deleted, occurences of that contender are also deleted.
		ON DELETE CASCADE
        ON UPDATE CASCADE
);
