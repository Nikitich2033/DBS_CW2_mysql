-- Part 2.1 schema.sql
--
-- Submitted by: Nikita Lyakhovoy, K20041405
-- 

-- DO NOT use these SQL commands in your submission(they will cause an 
--  error on the NMS database server):
-- CREATE SCHEMA 
-- USE 
-- vim change
CREATE TABLE Coach(
     CoachName VARCHAR (15) NOT NULL,
     CoachSurname VARCHAR(15) NOT NULL,
     DoB DATE NOT NULL,
     idCoach INT UNIQUE NOT NULL,
     phone VARCHAR (10) UNIQUE NOT NULL,
     dailySalary DECIMAL(10,2) NOT NULL,
     gender VARCHAR(6) NOT NULL,
     PRIMARY KEY(idCoach)            
);

CREATE TABLE Contender(
    stageName VARCHAR(25) UNIQUE NOT NULL,
    ContType VARCHAR (10) NOT NULL,
    idContender INT UNIQUE NOT NULL,
    coach INT NOT NULL,
    PRIMARY KEY(idContender),
    FOREIGN KEY(coach) 
        REFERENCES Coach(idCoach)
        ON DELETE RESTRICT
        ON UPDATE CASCADE 
    
);

CREATE TABLE Participant(
    PartName VARCHAR (15) NOT NULL,
    PartSurname VARCHAR(15) NOT NULL,
    DoB DATE NOT NULL,
    idParticipant INT UNIQUE NOT NULL,
    phone VARCHAR(10) UNIQUE NOT NULL,
    dailySalary DECIMAL(10,2) NOT NULL,
    gender VARCHAR(6) NOT NULL,
    idContender INT NOT NULL,
    PRIMARY KEY(idParticipant),
    FOREIGN KEY(idContender) 
        REFERENCES Contender(idContender)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
);
##location can be NULL when it takes place in the TV studio
CREATE TABLE TVShow(
    
    location VARCHAR(15),
    ShowDate DATE NOT NULL,
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
        ON DELETE CASCADE
        ON UPDATE CASCADE,

    FOREIGN KEY (idShow) 
        REFERENCES TVShow(idShow)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
);

CREATE TABLE ContenderInShow(
    idContender INT NOT NULL,
    idShow INT NOT NULL,
    PRIMARY KEY(idContender,idShow),
    FOREIGN KEY (idShow) 
		REFERENCES TVShow(idShow)
		ON DELETE RESTRICT
        ON UPDATE CASCADE,
    FOREIGN KEY (idContender)
		REFERENCES Contender(idContender)
		ON DELETE RESTRICT
        ON UPDATE CASCADE
);
