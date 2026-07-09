/*
H06_Create_Festivals
*/
USE Retail_SQL_Bootcamp;

DROP TABLE IF EXISTS H_Festivals;

CREATE TABLE H_Festivals
(
    FestivalID INT AUTO_INCREMENT PRIMARY KEY,
    FestivalName VARCHAR(50),
    FestivalMonth TINYINT,
    SalesMultiplier DECIMAL(4,2)
);

/*
Load Festivals
*/
INSERT INTO H_Festivals
(FestivalName,FestivalMonth,SalesMultiplier)

VALUES
('Republic Day',1,1.20),
('Holi',3,1.30),
('Raksha Bandhan',8,1.25),
('Ganesh Chaturthi',9,1.25),
('Dussehra',10,1.40),
('Diwali',11,2.20),
('Christmas',12,1.80),
('New Year',1,1.60);