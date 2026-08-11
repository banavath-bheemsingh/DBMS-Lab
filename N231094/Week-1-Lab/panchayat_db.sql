CREATE DATABASE grampanchayat;
USE grampanchayat;

CREATE TABLE Citizen(
	citizen_id INT PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    date_of_birth DATE NOT NULL,
    gender CHAR(1) CHECK( gender="M" OR gender="F"),
    mobile_number VARCHAR(15) UNIQUE NOT NULL,
    occupation VARCHAR(50),
    village_name VARCHAR(50) NOT NULL,
    is_active BOOLEAN NOT NULL
    );
    
    
INSERT INTO Citizen ()
VALUES
(101,"Ravi kumar",'1995-06-15','M',9876500001,"Farmer","Ramapuram",TRUE),
(102,"Lakshmi Devi",'1988-11-22','F',9876500002,"Tailor","Ramapuram",TRUE),
(103,"Suresh Babu",'1992-03-10','M',9876500003,"Farmer","Seethampeta",TRUE),
(104,"Anjali Rao",'2000-08-05','F',9876500004,"Student","Ramapuram",TRUE),
(105,"Kiran Kumar",'1985-01-18','M',9876500005,"Eletrician","Seethampeta",TRUE),
(106,"Meena Kumari",'1998-12-30','F',9876500006,"Teacher","Lakshmipuram",FALSE);

SELECT *FROM Citizen;

CREATE TABLE Certificate_Type(
	certificate_type_id INT PRIMARY KEY,
    certificate_name VARCHAR(100) UNIQUE NOT NULL,
    descrip VARCHAR(200) NOT NULL,
    processing_days INT NOT NULL,
    application_fee DECIMAL(8,2) NOT NULL,
    is_available BOOLEAN NOT NULL);
    
INSERT INTO Certificate_Type()
VALUES
(1,"Residence Certificate","Certifies the declared place of residence",7,30.00,TRUE),
(2,"Birth Record Request","Request for a locally maintain birth record",5,20.00,TRUE),
(3,"Death Record Request","Request for a locally maintain death record",5,20.00,TRUE),
(4,"Family Member Certificate","Records declared family member information",10,40.00,TRUE),
(5,"Property Certificate","Certificate Related to locally maintainedd property records",15,50.00,TRUE),
(6,"No-Dues Certificate","Indicates applicable local dues status",7,25.00,FALSE);

SELECT *FROM Certificate_Type;

CREATE TABLE Certificate_Application(
	application_id INT PRIMARY KEY,
    citizen_id INT NOT NULL,
    certificate_name VARCHAR(100) NOT NULL,
    application_date DATE NOT NULL,
    purpose VARCHAR(200) NOT NULL,
    application_status VARCHAR(30) NOT NULL,
    fee_paid DECIMAL(8,2) NOT NULL,
    reference_number VARCHAR(30) UNIQUE NOT NULL);
    
INSERT INTO Certificate_Application
VALUES
(1001,101,"Residence Certificate",'2026-07-01',"Bank account documentation","submitted",30.00,"GP20260001"),
(1002,102,"Family Member Certificate",'2026-07-02',"Welfare scheme application","Under Review",40.00,"GP20260002"),
(1003,103,"Property Certificate",'2026-07-03',"Property document","Submitted",50.00,"GP20260003"),
(1004,104,"Residence Certificate",'2026-07-04',"College Admission","Approved",30.00,"GP20260004"),
(1005,105,"No-Dues Certificate",'2026-07-05',"Local service requirement","Under law",25.00,"GP20260005"),
(1006,106,"Birth Record Request",'2026-07-06',"Personal documentation","Rejected",20.00,"GP20260006");

SELECT *FROM Certificate_Application;


CREATE TABLE Panchayat_Office(
	office_id INT PRIMARY KEY,
    office_name VARCHAR(100) NOT NULL,
    village_name VARCHAR(50) NOT NULL,
    pincode VARCHAR(50) NOT NULL,
    contact_number VARCHAR(15) UNIQUE,
    office_email VARCHAR(100) UNIQUE,
    opening_time TIME NOT NULL,
    is_operational BOOLEAN NOT NULL);
    
INSERT INTO Panchayat_Office()
VALUES
(1,"Ramapuram Grampanchayat","Ramapuram",'521101','0866000001',"ramapuram@gp.example",'09:00:00',TRUE),
(2,"Seethampeta Gram Panchayat","Seethampeta",'521102','0866000002',"seethampeta@gp.example",'09:30:00',TRUE),
(3,"Lakshmipuram Grampanchayat","Lakshmipuram",'521103','0866000003',"lakshmipuram@gp.example",'09:00:00',TRUE),
(4,"Krishnapuram Grampanchayat","Krishnapuram",'521104','0866000004',"krishnapuram@gp.example",'10:00:00',TRUE),
(5,"Venkatapuram Grampanchayat","Venkatapuram",'521105','0866000005',"venkatapuram@gp.example",'09:00:00',TRUE),
(6,"Gopalapuram Grampanchayat","Gopalapuram",'521106','0866000006',"gopalapuram@gp.example",'09:00:00',FALSE);

 

INSERT INTO Citizen()
VALUES
(107,"Bheemsingh",'2007-09-04','M',8309507602,"Student","Nalgonda",TRUE);

INSERT INTO Certificate_Type()
VALUES
(7,"Income Certificate","Indicates yearly income",7,75.00,TRUE);

UPDATE Certificate_Application SET application_status="Under Review" WHERE application_id=1001;
UPDATE Certificate_Application SET application_status="Approved" WHERE application_id=1002;

UPDATE Citizen SET occupation="Electrical Technician" WHERE citizen_id=105;

UPDATE Certificate_Type SET processing_days=12 WHERE certificate_name="Property Certificate";
UPDATE Certificate_Type SET is_available=TRUE WHERE certificate_name="No-Dues Certificate";

DELETE FROM Citizen WHERE citizen_id=107;

ALTER TABLE Citizen ADD address VARCHAR(100);

ALTER TABLE Certificate_Application ADD issued_date DATE;
ALTER TABLE Certificate_Application MODIFY COLUMN purpose VARCHAR(500) NOT NULL;
DESC Certificate_Application;

ALTER TABLE Panchayat_Office ADD closing_time DATE;

CREATE TABLE Temporary_request(
	request_id VARCHAR(10) PRIMARY KEY,
    request_name CHAR(100) NOT NULL,
    request_date DATE NOT NULL);
    
INSERT INTO Temporary_request()
VALUES
("N231094","consider as RGUKT NUZVID Student","2026-07-18"),
("N231054","consider as RGUKT NUZVID Student","2026-07-18"),
("N230185","consider as RGUKT NUZVID Student","2026-07-18");

SELECT *FROM Temporary_request;
DROP TABLE Temporary_request;

INSERT INTO Citizen()
VALUES
(101,"Bheemsingh","2007-09-04","M",'8309507602',"Student","Nalgonda",TRUE,"Telangana");
-- Error Code: 1062. Duplicate entry '101' for key 'citizen.PRIMARY'

INSERT INTO Citizen()
VALUES
(107,"Bheemsingh","2007-09-04","M",'9876500001',"Student","Nalgonda",TRUE,"Telangana");
--  Error Code: 1062. Duplicate entry '9876500001' for key 'citizen.mobile_number'	

INSERT INTO Certificate_Type()
VALUES
(1,"Certifies the declared place of residence",7,30.00,TRUE);
-- Error Code: 1136. Column count doesn't match value count at row 1

INSERT INTO Certificate_Application
VALUES
(1010,110,"Residence Certificate",'2026-07-01',"Bank account documentation","submitted",30.00,"GP20260001");
-- Error Code: 1136. Column count doesn't match value count at row 1



