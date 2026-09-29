#PART-A
USE grampanchayat;
SHOW TABLES;
SELECT *FROM Citizen;
SELECT *FROM Certificate_Application;
SELECT *FROM Certificate_Type;
SELECT *FROM Panchayat_office;
#PART-B 
#1 
SELECT (SELECT MAX(application_date) FROM Certificate_Application) AS latest_application_date;
#2
SELECT (SELECT MIN(application_date) FROM Certificate_Application) AS earlist_application_date;
#3
SELECT *FROM Certificate_Application
WHERE application_date=
				(SELECT MAX(application_date) FROM Certificate_Application);
                
#4
SELECT *FROM Certificate_Application
WHERE application_date=
					(SELECT MIN(application_date) FROM Certificate_Application);

#5
SELECT *FROM Citizen
WHERE citizen_id IN 
				(SELECT citizen_id FROM Certificate_Application WHERE application_status='Approved');

#LEVEL-2
#1
SELECT *FROM Certificate_Application
WHERE application_date >
					(SELECT MIN(application_date) FROM Certificate_Application);
#2
SELECT *FROM Certificate_Application
WHERE application_date <
					(SELECT MAX(application_date) FROM Certificate_Application);
#3
SELECT *FROM Citizen 
WHERE citizen_id IN
				(SELECT citizen_id FROM Certificate_Application);
##4
SELECT *FROM Citizen 
WHERE citizen_id  NOT IN
				(SELECT citizen_id FROM Certificate_Application WHERE application_status='Approved');

##5
SELECT *FROM Certificate_Type 
WHERE certificate_type_id IN
				(SELECT certificate_type_id FROM Certificate_Application
                WHERE application_status='Approved');
#6
SELECT *FROM Certificate_Type 
WHERE certificate_type_id NOT IN
				(SELECT certificate_type_id FROM Certificate_Application
                WHERE application_status='Approved');

#7
SELECT *FROM Certificate_Application
WHERE application_date>
					(SELECT MIN(application_date) FROM Certificate_Application);
#8
SELECT c.certificate_name,a.application_date
FROM Certificate_Application a
JOIN Certificate_Type C ON a.certificate_id=c.certificate_type_id
WHERE A.application_date=
					(SELECT MAX(application_date) FROM Certificate_Application);
#LEVEL-3
#1
SELECT certificate_name 
FROM Certificate_Type 
WHERE certificate_type_id = (
    SELECT certificate_id FROM Certificate_Application 
    GROUP BY certificate_id 
    ORDER BY COUNT(*) ASC 
    LIMIT 1);
#2
SELECT office_name 
FROM Panchayat_Office 
WHERE office_id = (
    SELECT office_id FROM Certificate_Application 
    GROUP BY office_id 
    ORDER BY COUNT(*) DESC 
    LIMIT 1);
#3
SELECT certificate_id, COUNT(*) AS app_count
FROM Certificate_Application
GROUP BY certificate_id
HAVING COUNT(*) > (
    SELECT AVG(cnt)FROM (SELECT COUNT(*) AS cnt FROM Certificate_Application 
        GROUP BY certificate_id
    ) AS avg_counts);
#4
SELECT office_id, COUNT(*) AS total_apps
FROM Certificate_Application
GROUP BY office_id
HAVING COUNT(*) > ANY (SELECT COUNT(*) FROM Certificate_Application 
    GROUP BY office_id);
#5
SELECT office_id, COUNT(*) AS total_apps
FROM Certificate_Application
GROUP BY office_id
HAVING COUNT(*) >= ALL (
    SELECT COUNT(*) FROM Certificate_Application 
    GROUP BY office_id);
#6
SELECT C.certificate_name
FROM Certificate_Type C
JOIN Certificate_Application A ON C.certificate_type_id = A.certificate_id
WHERE A.application_date = (
    SELECT MAX(application_date) FROM Certificate_Application);
#7
SELECT * 
FROM Citizen 
WHERE citizen_id IN (
    SELECT citizen_id FROM Certificate_Application 
    GROUP BY citizen_id 
    HAVING COUNT(*) > 1);
#8
SELECT application_status, COUNT(*) AS status_count
FROM Certificate_Application
GROUP BY application_status
HAVING COUNT(*) = (
    SELECT MAX(status_count)
    FROM (
        SELECT COUNT(*) AS status_count FROM Certificate_Application
        GROUP BY application_status
    ) AS max_status);