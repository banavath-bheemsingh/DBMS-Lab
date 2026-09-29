USE  grampanchayat;
#PART A
SHOW TABLES;
SELECT *FROM Citizen;
SELECT *FROM Certificate_Application;
SELECT *FROM Panchayat_office;
SELECT *FROM Certificate_Type;
#PART B
#LEVEL 1
#1
CREATE VIEW ALL_Certificate_Applications AS 
SELECT *FROM Certificate_Application;

#2
CREATE VIEW Application_Status_View AS 
SELECT application_id,citizen_id,application_status
FROM Certificate_Application;
select *from Application_Status_View;

#3
CREATE VIEW Approved_Applications AS 
SELECT application_id,citizen_id,application_status
FROM Certificate_Application
WHERE application_status='Approved';
#4
SELECT *FROM Approved_Applications;

#5
SHOW FULL TABLES 
WHERE Table_type='VIEW';

#LEVEL 2
#1
CREATE VIEW Certificate_Application_Date_View AS 
SELECT c.certificate_name,a.application_date
FROM Certificate_Application a 
JOIN Certificate_Type c ON a.certificate_id=c.certificate_type_id;
select *from Certificate_Application_Date_View;

#2 
CREATE VIEW Citizen_Application_Status_View AS 
SELECT cit.full_name,a.application_status
FROM Certificate_Application a
JOIN  Citizen cit ON a.citizen_id=cit.citizen_id;
select *from Citizen_Application_Status_View;

#3
CREATE VIEW Office_Applications_View AS 
SELECT p.office_name,a.application_id,a.citizen_id,a.certificate_id,a.application_status,a.application_date
FROM Certificate_Application a 
JOIN Panchayat_office p ON a.office_id=p.office_id;
select *from Office_Applications_View;

#4
CREATE VIEW Total_Applications_Per_Certificate_View AS 
SELECT certificate_id,COUNT(*) AS total_applications
FROM Certificate_Application
GROUP BY certificate_id;
select *from Total_Applications_Per_Certificate_View;

#5
CREATE VIEW Total_Applications_Per_Office_View AS 
SELECT office_id,COUNT(*) AS total_applications
FROM Certificate_Application
GROUP BY office_id;
select *from Total_Applications_Per_Office_View;

#6
CREATE VIEW Pending_Applications_With_Cert_View AS 
SELECT a.application_id,c.certificate_name,a.application_status,a.application_date
FROM Certificate_Application a 
JOIN Certificate_Type c ON a.certificate_id=c.certificate_type_id
WHERE a.application_status='Pending';
select *from Pending_Applications_With_Cert_View;

#7
SELECT certificate_name,application_date
FROM Certificate_Application_Date_View
WHERE application_date>'2025-01-01';

#8
SHOW CREATE VIEW Pending_Applications_With_Cert_View;
#LEVEL 3
#1
CREATE VIEW Certificate_Application_Date AS 
SELECT C.certificate_name,COUNT(A.application_date) AS total_applications		
FROM Certificate_Type C
LEFT JOIN Certificate_Application A ON C.certificate_type_id=A.certificate_id
GROUP BY C.certificate_type_id,C.certificate_name;
select *from Certificate_Application_Date;

#2
CREATE VIEW Offices_Mutiple_Applications_View AS
SELECT p.office_id,p.office_name,COUNT(a.application_id) AS total_applications
FROM Panchayat_Office p 
JOIN Certificate_Application a ON p.office_id=a.office_id
GROUP BY p.office_id,p.office_name
HAVING COUNT(a.application_id)>1;
select *from Offices_Mutiple_Applications_View;

#3
CREATE VIEW Certificate_Application_Date_Range_View AS 
SELECT c.certificate_name,
     MIN(a.application_date) AS earliest_application,
     MAX(a.application_date) AS latest_application
FROM Certificate_Type c 
JOIN Certificate_Application a ON c.certificate_type_id=a.certificate_id
GROUP BY c.certificate_type_id,c.certificate_name;
select *from Certificate_Application_Date_Range_View;

#4
CREATE VIEW Citizen_Applications_Count_View AS 
SELECT cit.full_name,COUNT(a.application_id) AS total_applications
FROM Citizen cit 
LEFT JOIN Certificate_Application a ON cit.citizen_id=a.citizen_id
GROUP BY cit.citizen_id,cit.full_name;
select *from Citizen_Applications_Count_View;

#5
CREATE VIEW Full_Application_Details_View AS 
SELECT a.application_id,cit.full_name,c.certificate_name,a.application_date,a.application_status
FROM Certificate_Application a 
JOIN Citizen cit ON  a.citizen_id=cit.citizen_id
JOIN Certificate_Type c ON a.certificate_id=c.certificate_type_id;
select *from Full_Application_Details_View;

#6
CREATE VIEW UnderReview_Applications_Detailed AS
SELECT A.application_id, cit.full_name, C.certificate_name, A.application_status
FROM Certificate_Application A
JOIN Citizen cit ON A.citizen_id = cit.citizen_id
JOIN Certificate_Type C ON A.certificate_id = C.certificate_type_id
WHERE A.application_status = 'Under Review';
select *from UnderReview_Applications_Detailed;

#7
SELECT *FROM Full_Application_Details_View 
WHERE application_status='Submitted'
ORDER BY application_date DESC;

#8
DROP VIEW ALL_Certificate_Applications;
SHOW FULL TABLES WHERE Table_type='VIEW';