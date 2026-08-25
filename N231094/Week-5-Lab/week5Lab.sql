USE grampanchayat;

SHOW TABLES;

SELECT * FROM citizen;

SELECT * FROM certificate_type;

SELECT * FROM panchayat_office;

SELECT * FROM certificate_application;
-- LEVEL 1 UNDERSTANDING 
-- Task-1 Display the total no of certificate applications
SELECT COUNT(*) AS total_applications
FROM certificate_application;

-- Task-2 Display the total no of citizens registered in the database
SELECT COUNT(*) AS total_citizens
FROM citizen;

-- Task-3 Display the total no of  different certificate types available 
SELECT COUNT(DISTINCT certificate_type_id) AS total_certificate_types
FROM certificate_type;

-- Task-4 Display the earliest application date recorded in the database
SELECT MIN(application_date) AS earliest_application_date
FROM certificate_application;

-- Task-5 Display the latest application date recorded in the database 
SELECT MAX(application_date) AS latest_application_date
FROM certificate_application;

-- LEVEL 2-Application
-- Task-1: Display the no of certificate applications for each application status
SELECT
application_status,
COUNT(*) AS total_applications
FROM certificate_application
GROUP BY application_status;

-- Task-2: Display the no of certificate applications for each application type
SELECT
certificate_id,
COUNT(*) AS total_applications
FROM certificate_application
GROUP BY certificate_id;

-- Task-3: Display the no of certificate applications submitted at each Panchayat office 
SELECT
office_id,
COUNT(*) AS total_applications
FROM certificate_application
GROUP BY office_id;

-- Task-4: Display the number of citizens in each village.
SELECT
village_name,
COUNT(*) AS total_citizens
FROM citizen
GROUP BY village_name;

-- Task-5: Display the no applications submitted on each application date
SELECT
application_date,
COUNT(*) AS total_applications
FROM certificate_application
GROUP BY application_date;

-- Task 6: Display the number of applications for each certificate
SELECT
certificate_id,
office_id,
COUNT(*) AS total_applications
FROM certificate_application
GROUP BY certificate_id, office_id;

-- Task 7: Display the number of applications for each certificate
SELECT
ct.certificate_name,
COUNT(*) AS total_applications
FROM certificate_application a
INNER JOIN certificate_type ct
ON a.certificate_id = ct.certificate_type_id
GROUP BY ct.certificate_name;

-- Task 8: Display the number of applications received by each Panchayat Office showing office name.
SELECT
p.office_name,
COUNT(*) AS total_applications
FROM certificate_application a
INNER JOIN panchayat_office p
ON a.office_id = p.office_id
GROUP BY p.office_name;

-- LEVEL 3 MEDIUM TO ADVANCED
-- Task 1: Display only those certificate types that have more than two applications.
SELECT
certificate_id,
COUNT(*) AS total_applications
FROM certificate_application
GROUP BY certificate_id
HAVING COUNT(*) > 2;

-- Task 2: Display only those Panchayat Offices that have received more than two applications.
SELECT
office_id,
COUNT(*) AS total_applications
FROM certificate_application
GROUP BY office_id
HAVING COUNT(*) > 2;

-- Task 3: Display certificate types in descending order of number of applications.
SELECT
certificate_id,
COUNT(*) AS total_applications
FROM certificate_application
GROUP BY certificate_id
ORDER BY total_applications DESC;

-- Task 4: Display Panchayat Offices in ascending order of number of applications received.
SELECT
office_id,
COUNT(*) AS total_applications
FROM certificate_application
GROUP BY office_id
ORDER BY total_applications ASC;

-- Task 5: Display certificate types having more than two applications and arrange them from highest to lowest.
SELECT
certificate_id,
COUNT(*) AS total_applications
FROM certificate_application
GROUP BY certificate_id
HAVING COUNT(*) > 2
ORDER BY total_applications DESC;

-- Task 6: Display the certificate type and Panchayat Office combination having the highest applications.
SELECT
certificate_id,
office_id,
COUNT(*) AS total_applications
FROM certificate_application
GROUP BY certificate_id, office_id
ORDER BY total_applications DESC
LIMIT 1;

-- Task 7: Display the application status having the highest number of applications.
SELECT
application_status,
COUNT(*) AS total_applications
FROM certificate_application
GROUP BY application_status
ORDER BY total_applications DESC
LIMIT 1;

-- Task 8: Display the application status having the lowest number of applications.
SELECT
application_status,
COUNT(*) AS total_applications
FROM certificate_application
GROUP BY application_status
ORDER BY total_applications ASC
LIMIT 1;

-- Real World Analysis
-- Task 1: Identify the most frequently requested certificate type.
SELECT
ct.certificate_name,
COUNT(*) AS total_applications
FROM certificate_application a
INNER JOIN certificate_type ct
ON a.certificate_id = ct.certificate_type_id
GROUP BY ct.certificate_name
ORDER BY total_applications DESC
LIMIT 1;

-- Task 2: Identify the Panchayat Office that received the highest number of applications.
SELECT
p.office_name,
COUNT(*) AS total_applications
FROM certificate_application a
INNER JOIN panchayat_office p
ON a.office_id = p.office_id
GROUP BY p.office_name
ORDER BY total_applications DESC
LIMIT 1;

-- Task 3: Identify the application status with the highest number of applications.
SELECT
application_status,
COUNT(*) AS total_applications
FROM certificate_application
GROUP BY application_status
ORDER BY total_applications DESC
LIMIT 1;

-- Task 4: Display certificate types having more than two applications.
SELECT
ct.certificate_name,
COUNT(*) AS total_applications
FROM certificate_application a
INNER JOIN certificate_type ct
ON a.certificate_id = ct.certificate_type_id
GROUP BY ct.certificate_name
HAVING COUNT(*) > 2;

-- Task 5: Display Panchayat Offices having more than two applications.
SELECT
p.office_name,
COUNT(*) AS total_applications
FROM certificate_application a
INNER JOIN panchayat_office p
ON a.office_id = p.office_id
GROUP BY p.office_name
HAVING COUNT(*) > 2;

-- Task 6: Generate Certificate Application Summary Report.
SELECT
ct.certificate_name,
COUNT(*) AS total_applications,
MIN(a.application_date) AS earliest_application_date,
MAX(a.application_date) AS latest_application_date
FROM certificate_application a
INNER JOIN certificate_type ct
ON a.certificate_id = ct.certificate_type_id
GROUP BY ct.certificate_name;

-- Task 7: Generate Panchayat Office Application Summary.
SELECT
p.office_name,
COUNT(*) AS total_applications,
COUNT(DISTINCT a.certificate_id) AS different_certificate_types
FROM certificate_application a
INNER JOIN panchayat_office p
ON a.office_id = p.office_id
GROUP BY p.office_name;
