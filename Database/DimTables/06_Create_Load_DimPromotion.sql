/******************************************************************************
Project : Retail ERP Data Warehouse
Script  : 06_Create_DimPromotion.sql
******************************************************************************/

USE Retail_SQL_Bootcamp;

DROP TABLE IF EXISTS DimPromotion;

CREATE TABLE DimPromotion
(
    PromotionKey       INT AUTO_INCREMENT PRIMARY KEY,

    PromotionID        VARCHAR(20) NOT NULL UNIQUE,

    PromotionName      VARCHAR(100) NOT NULL,

    PromotionType      VARCHAR(30) NOT NULL,

    DiscountPercent    DECIMAL(5,2) NOT NULL,

    StartDate          DATE NOT NULL,

    EndDate            DATE NOT NULL,

    IsActive           BOOLEAN DEFAULT TRUE,

    CreatedDate        TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

/*
create Index
*/
CREATE INDEX IX_DimPromotion_Type
ON DimPromotion(PromotionType);

CREATE INDEX IX_DimPromotion_StartDate
ON DimPromotion(StartDate);

CREATE INDEX IX_DimPromotion_EndDate
ON DimPromotion(EndDate);

CREATE INDEX IX_DimPromotion_IsActive
ON DimPromotion(IsActive);

/*
Load Dim Promotion
*/
USE Retail_SQL_Bootcamp;

SET SQL_SAFE_UPDATES = 0;

TRUNCATE TABLE DimPromotion;

INSERT INTO DimPromotion
(
PromotionID,
PromotionName,
PromotionType,
DiscountPercent,
StartDate,
EndDate,
IsActive
)

VALUES

('PROMO001','New Year Sale','Festival',15,'2023-01-01','2023-01-10',1),
('PROMO002','Republic Day Offer','Festival',12,'2023-01-20','2023-01-26',1),
('PROMO003','Valentine Special','Seasonal',10,'2023-02-07','2023-02-14',1),
('PROMO004','Holi Bonanza','Festival',20,'2023-03-01','2023-03-10',1),
('PROMO005','Summer Sale','Seasonal',18,'2023-04-15','2023-05-15',1),

('PROMO006','Monsoon Deals','Seasonal',12,'2023-07-01','2023-07-31',1),
('PROMO007','Independence Day Sale','Festival',18,'2023-08-10','2023-08-15',1),
('PROMO008','Raksha Bandhan Offer','Festival',15,'2023-08-20','2023-08-31',1),
('PROMO009','Ganesh Festival','Festival',20,'2023-09-10','2023-09-20',1),
('PROMO010','Dussehra Mega Sale','Festival',25,'2023-10-15','2023-10-25',1),

('PROMO011','Diwali Dhamaka','Festival',35,'2023-11-01','2023-11-15',1),
('PROMO012','Children Day Offer','Seasonal',10,'2023-11-14','2023-11-20',1),
('PROMO013','Black Friday','Special',30,'2023-11-24','2023-11-24',1),
('PROMO014','Cyber Monday','Special',28,'2023-11-27','2023-11-27',1),
('PROMO015','Christmas Carnival','Festival',25,'2023-12-20','2023-12-31',1),

('PROMO016','Weekend Offer','Regular',8,'2023-01-01','2023-12-31',1),
('PROMO017','Clearance Sale','Clearance',40,'2023-06-01','2023-06-15',1),
('PROMO018','Buy More Save More','Quantity',15,'2023-01-01','2023-12-31',1),
('PROMO019','Loyalty Member Discount','Loyalty',10,'2023-01-01','2023-12-31',1),
('PROMO020','No Promotion','None',0,'2023-01-01','2023-12-31',1);