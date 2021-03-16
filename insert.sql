-- Part 2.2 insert.sql
--
-- Submitted by: Nikita Lyakhovoy, K20041405
-- 

-- DO NOT use these SQL commands in your submission(they will cause an 
--  error on the NMS database server):
-- CREATE SCHEMA 
-- USE 

INSERT INTO Coach VALUES
       ("Keanu","Reeves",'1964-09-02',1, "7324456765",250.00, "Male"),

       ("Barack","Obama",'1961-08-04',2, "7324312387",300.00, "Male"),

       ("Dua","Lipa",'1995-08-22',3, "7324412396",150.00, "Female");


INSERT INTO Contender VALUES
              ("Knoxxy",'Individual',1,2),   

              ("Sandra Johnson",'Individual',2,1),

              ("Dobsaurus",'Individual',3,2),

              ("Buster Master",'Individual',4,2),

              ("Silk",'Individual',5,1),

              ("The Undead",'Group',6,1),

              ("Karamel",'Individual',7,2),

              ("Inner Ear",'Individual',8,1);


INSERT INTO Participant VALUES
              ("Johnny","Knoxville",'1993-09-13',1,"2749573957",100.00,"Male",1),

              ("Sandra","Johnson",'1986-08-03',2,"7495723423",115.50,"Female",2),

              ("Gus","Dobson",'1987-11-29',3,"7395123456",140.15,"Male",3),

              ("Arnold","Buster",'1993-04-22',4,"2643512957",200.45,"Male",4),

              ("Mary","Silk",'1993-09-13',5,"2498936457",240,"Female",5),

              ("Martha","Bonjo",'1976-02-23',6,"2742345957",122.00,"Female",6),

              ("Andrew","Squid",'1995-12-25',7,"2742342345",110.00,"Male",6),

              ("Karim","Bun",'1965-11-21',8,"3492345357",315.5,"Male",6),

              ("Bam","Revell",'1984-05-12',9,"6779373853",90.7,"Male",7),

              ("Anna","Burton",'1978-06-24',10,"2923543423",210.00,"Female",8);


INSERT INTO TVShow VALUES
              ('2021-03-06',NULL,1,'14:00','16:00'),

              ('2021-03-07',NULL,2,'16:00','18:00'),

              ('2021-03-13',"Heathrow Hangar",3,'12:00','14:00'),

              ('2021-03-14',NULL,4,'08:00','10:00'),

              ('2021-03-20',NULL,5,'14:00','16:00'),

              ('2021-03-21',NULL,6,'14:00','16:00'),

              ('2021-03-27',"Borough Market",7,'19:00','21:00'),

              ('2021-03-28',NULL,8,'11:00','13:00'),

              ('2021-04-03',NULL,9,'15:00','17:00'),

              ('2021-04-04',NULL,10,'07:00','09:00'),

              ('2021-04-10',NULL,11,'20:00','22:00'),

              ('2021-04-11',NULL,12,'15:00','17:00'),

              ('2021-04-17',NULL,13,'10:00','12:00'),

              ('2021-04-18',NULL,14,'06:00','08:00'),

              ('2021-04-24',NULL,15,'17:00','19:00'),

              ('2021-04-25',NULL,16,'13:00','15:00');

INSERT INTO CoachInShow VALUES
              (1,1), (2,1),
              (1,2), (3,2),
              (2,3), (1,3),
              (3,4), (1,4),
              (2,5), (3,5),
              (2,6), (1,6),
              (3,7), (2,7),
              (1,8), (2,8),
              (3,9), (2,9),
              (1,10), (3,10),
              (2,11), (1,11),
              (3,12), (2,12),
              (1,13), (3,13),
              (2,14), (1,14),
              (3,15), (2,15),
              (1,16), (2,16);

INSERT INTO ContenderInShow VALUES
              (1,1),(2,1),(5,1),(4,1),
              (6,2),(5,2),(2,2),
              (7,3),(3,3),(6,3),
              (4,4),(6,4),(8,4),
              (7,5),(4,5),(1,5),
              (5,6),(6,6),(2,6),
              (3,7),(4,7),(7,7),
              (2,8),(3,8),(6,8),
              (7,9),(4,9),(3,9),
              (2,10),(5,10),(8,10),
              (1,11),(4,11),(6,11),
              (3,12),(7,12),(1,12),
              (5,13),(2,13),(8,13),
              (2,14),(5,14),(7,14),
              (4,15),(1,15),(3,15),
              (6,16),(8,16),(2,16);



SELECT * from Coach;
SELECT * FROM TVShow;
SELECT * FROM Participant;
SELECT * FROM Contender;
SELECT * FROM ContenderInShow;
SELECT * FROM CoachInShow;






