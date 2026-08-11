-- PART A Verify Week-1 Database
USE grampanchayat;
SHOW TABLES; 
SELECT * FROM citizen;
SELECT * FROM certificate_type;
SELECT * FROM certificate_application;
SELECT * FROM panchayat_office;

-- Activity 1
-- Removing the certificate_name column from certificate_name table
ALTER TABLE certificate_application
DROP COLUMN certificate_name;

-- Activity 2
-- Adding the columns in certificate_application table
ALTER TABLE certificate_application
ADD certificate_id INT ,
ADD office_id INT;

 -- Activity 3
UPDATE certificate_application
SET certificate_id=1
WHERE application_id IN (1001,1004);

UPDATE certificate_application
SET certificate_id=4
WHERE application_id IN (1002);

UPDATE certificate_application
SET certificate_id=5
WHERE application_id IN (1003,1005,1006);

UPDATE certificate_application
SET office_id=1
WHERE application_id IN (1001,1002,1003);

UPDATE certificate_application
SET office_id=2
WHERE application_id IN (1004,1005);

UPDATE certificate_application
SET office_id=3
WHERE application_id IN (1006);

-- Activity 4
-- Creating the foriegn key constraints

#Foreign Key constraints
ALTER TABLE certificate_application
ADD CONSTRAINT fk_citizen
FOREIGN KEY (citizen_id) REFERENCES citizen(citizen_id),
ADD CONSTRAINT fk_certificate
FOREIGN KEY (certificate_id) REFERENCES certificate_type(certificate_type_id),
ADD CONSTRAINT fk_office
FOREIGN KEY (office_id) REFERENCES Panchayat_office(office_id);

#Activity 5
-- Verifying the created foreign key constraints
SHOW CREATE TABLE certificate_application;

#Activity 6
-- Insert a certificate application with a non-existing citizen_id.
INSERT INTO certificate_application()
VALUES
(2001,999,'2026-08-01','Testing','Submitted',30.00,'GP20269999','2026-08-01',1,1);
-- Error Code: Cannot add or update a child row: a foreign key constraint fails

-- Insert a certificate application with a non-existing certificate_id.
INSERT INTO certificate_application()
VALUES
(2001,999,'2026-08-01','Testing','Submitted',30.00,'GP20269999','2026-08-01',99,1);
-- Error Code: Cannot add or update a child row: a foreign key constraint fails

-- Delete a citizen whose certificate applications already exist.
DELETE FROM citizen
WHERE citizen_id=101;
-- Error Code:Cannot delete or update a parent row: a foreign key constraint fails

-- Delete a certificate type that is referenced in the Certificate_Application table.
DELETE FROM certificate_type
WHERE certificate_type_id=1;
-- Error Code:Cannot delete or update a parent row: a foreign key constraint fails

# PART C
-- Level 0 Basic retrieval techniques
-- 1.Display all records from citizen table
SELECT *FROM citizen;

-- 2. Display all records from the Certificate_Application table.
SELECT *FROM certificate_application;

-- 3. Display the names of all citizens in ascending order.
SELECT full_name FROM citizen ORDER BY full_name Asc; 

-- 4. Display all unique villages using DISTINCT.
SELECT DISTINCT village_name FROM citizen;

-- 5.Display all Unique certificate_types using DISTINCT
SELECT DISTINCT certificate_name FROM certificate_type;

-- 6. Display all unique Panchayat Offices using DISTINCT.
SELECT DISTINCT office_name FROM panchayat_office;

-- 7.Display  certificate applications whose application_status is pending
SELECT *FROM certificate_application WHERE application_status="pending";  

-- 8. Display citizens belonging to Ramapuram village.
SELECT full_name FROM citizen WHERE village_name='Ramapuram';

-- 9. Display the certificate applications submitted during the year 2026
SELECT application_date,certificate_name FROM certificate_application WHERE YEAR(application_date)=2026;

-- 10. Display certificate applications ordered by Application_Date in descending order.
SELECT application_date,certificate_name FROM certificate_application ORDER BY application_date DESC;

-- 11.Display all applications procssed by Nuzvid panchayat office
SELECT ca.* FROM certificate_application ca JOIN panchayat_office po
ON ca.office_id=po.office_id WHERE po.office_name="Nuzvid panchayat office"; 

-- 12. Display the names of citizens who applied for an Income Certificate.
SELECT c.full_name FROM citizen c JOIN certificate_application ca
ON c.citizen_id=ca.citizen_id JOIN certificate_type ct
ON ca.certificate_id=ct.certificate_type_id
WHERE ct.certificate_name="Income certificate";
        
#LEVEL 1
-- 13.Display the names of citizens who applied for either an Income certificate or a residance certificate
SELECT c.full_name FROM citizen c JOIN certificate_application ca
ON c.citizen_id=ca.citizen_id JOIN certificate_type ct
ON ca.certificate_id=ct.certificate_type_id
WHERE ct.certificate_name='Income certificate'
UNION
SELECT c.full_name FROM citizen c JOIN certificate_application ca
ON c.citizen_id JOIN certificate_type ct
ON ca.certificate_id=ct.certificate_type_id
WHERE ct.certificate_name='Residance certificate';

-- 14. Display certificate applications submitted during Januar and February using union
SELECT *FROM certificate_application
WHERE MONTH(application_date)='1'
UNION
SELECT * FROM certificate_application
WHERE MONTH(application_date)='2';

-- 15.Display citizens belonging to ramapuram and lakshmipuram villages using UNION
SELECT full_name FROM citizen
WHERE village_name="Ramapuram"
UNION
SELECT full_name FROM citizen
WHERE village_name="Lakshmipuram";

-- 16. Display citizens who have applied for Both Income Certificate and a Residence Certificate using intersect
SELECT c.full_name FROM citizen c JOIN certificate_application ca
ON c.citizen_id=ca.citizen_id JOIN certificate_type ct 
ON ca.certificate_id=ct.certificate_type_id
WHERE ct.certificate_name='Income certificate'
AND c.citizen_id IN(
SELECT ca.citizen_id FROM certificate_application ca
JOIN certificate_type ct ON ca.certificate_id=ct.certificate_type_id
WHERE ct.certificate_name='Residance certificate');

-- 17.Display citizens who submitted certificate applications during both 2025 and 2026 using INTERSECT
SELECT c.full_name FROM citizen c JOIN certificate_application ca
ON c.citizen_id=ca.citizen_id
WHERE YEAR(ca.application_date)=2025
AND 
c.citizen_id IN(
SELECT citizen_id FROM certificate_application
WHERE YEAR(application_date)=2026);

-- 18. Display citizens who applied for an Income Certificate but not for a Residence Certificate using EXCEPT (MINUS).
SELECT citizen_id FROM certificate_application
WHERE certificate_id=(
SELECT certificate_type_id FROM certificate_type
WHERE certificate_name='Income certificate')
AND citizen_id NOT IN (
SELECT citizen_id FROM certificate_application
WHERE certificate_id=(
SELECT certificate_type_id FROM certificate_type
WHERE certificate_name='Residence Certificate'));

-- 19.Display certificate applications submitted during 2026 but not during 2025 using Except(MINUS)
SELECT * FROM certificate_application
WHERE YEAR(application_date)=2026
AND citizen_id NOT IN (
SELECT citizen_id FROM certificate_application
WHERE YEAR(application_date)=2025);

/*20 .Attempt to insert a certificate application using an invalid citizen_id.
Record the system-generated error and explain why the insertion is rejected.
*/
INSERT INTO certificate_application()
VALUES
(3001,999,'Testing','2026-08-05','Testing FK','Submitted',30.00,'GP20263001',1,1);
-- Error Code: 1452. Cannot add or update a child row.
-- when we try to insert an invalid citizenId it shows error because of the connection between parent and child tables

-- 21. Delete a citizen whose certificate application already exist.Record the system generated error
DELETE FROM citizen WHERE citizen_id = 101;
SELECT full_name FROM citizen 
WHERE citizen_id IN (
    SELECT citizen_id 
    FROM certificate_application
);
-- Error Code: 1451. Cannot delete or update a parent row: a foreign key constraint fails 


-- 22. Short note on foreign key
/* Foreign key constraints maintain referential integrity between related tables.
They ensure that a child table cannot contain values that do not exist in the parent table.
They also prevent deletion of parent records that are still referenced by child records ,helping to avoid inconsistent or invalid data in the database
*/

-- 23.Display the names of citizens who have submitted atleast one certificate application USING IN
SELECT full_name 
FROM citizen 
WHERE citizen_id IN (
    SELECT citizen_id 
    FROM certificate_application
);
-- 24.Display citizens who have not submitted any certificate application using NOT IN
SELECT * 
FROM citizen 
WHERE citizen_id NOT IN (
    SELECT citizen_id 
    FROM certificate_application
);

-- 25.Display panchayat offices that have not processed any certificate applications using NOT 
SELECT * 
FROM panchayat_office 
WHERE office_id NOT IN (
    SELECT office_id 
    FROM certificate_application
);

-- 26.Display citizens for whom atleast one certificate application exists using exists
SELECT full_name 
FROM citizen c 
WHERE EXISTS (
    SELECT 1 
    FROM certificate_application ca 
    WHERE ca.citizen_id = c.citizen_id
);

-- 27.Display certificate types that have been requested by atleast one citizen using exists
SELECT certificate_name 
FROM certificate_type ct 
WHERE EXISTS (
    SELECT 1 
    FROM certificate_application ca 
    WHERE ca.certificate_id = ct.certificate_type_id
);

-- 28.Display citizens who donot have any certificate applications using NOT EXISTS
SELECT full_name 
FROM citizen c 
WHERE NOT EXISTS (
    SELECT 1 
    FROM certificate_application ca 
    WHERE ca.citizen_id = c.citizen_id
);

-- 29. Display certificate types that have been requested using NOT EXISTS
SELECT  certificate_name FROM certificate_type ct
WHERE NOT EXISTS(
SELECT 1 FROM certificate_application ca
WHERE ca.certificate_id=ct.certificate_type_id);

-- 30.Display citizens whose age is greater than ANY citizen belonging to ramapuram using ANY 
SELECT full_name FROM citizen WHERE date_of_birth>ANY(
SELECT date_of_birth FROM citizen
WHERE village_name="Ramapuram");

-- 32. Display citizens who has submitted the highest number of certificate applications
SELECT 
    c.full_name, 
    COUNT(*) AS total_applications
FROM 
    citizen c 
JOIN 
    certificate_application ca ON c.citizen_id = ca.citizen_id 
GROUP BY 
    c.citizen_id, 
    c.full_name
HAVING 
    COUNT(*) = (
        SELECT MAX(app_count) 
        FROM (
            SELECT COUNT(*) AS app_count
            FROM certificate_application
            GROUP BY citizen_id
        ) AS t
    );
    
 -- 33.Display the panchayat office that has processed the maximum number of certificate applications
 SELECT 
    p.office_name, 
    COUNT(*) AS total
FROM 
    panchayat_office p 
JOIN 
    certificate_application ca ON p.office_id = ca.office_id
GROUP BY 
    p.office_id, 
    p.office_name
ORDER BY 
    total DESC;

-- 34.Display certificate types for which morethan five applications have been submitted
SELECT 
    ct.certificate_name, 
    COUNT(*) AS total
FROM 
    certificate_type ct 
JOIN 
    certificate_application ca ON ct.certificate_type_id = ca.certificate_id
GROUP BY 
    ct.certificate_type_id, 
    ct.certificate_name
HAVING 
    COUNT(*) > 5;
    
-- 35.Display villages from which no certificate applications have been recieved
SELECT DISTINCT 
    village_name 
FROM 
    citizen
WHERE 
    citizen_id NOT IN (
        SELECT citizen_id FROM certificate_application
    );