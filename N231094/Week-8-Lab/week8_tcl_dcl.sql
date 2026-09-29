#PART-A
USE grampanchayat;
select *from Citizen;
select *from Certificate_Application;
select *from Certificate_Type;
select *from Panchayat_Office;
alter  table Certificate_Application add remarks varchar(100);
#PART-B 
#1
SET AUTOCOMMIT=0;
SELECT @@autocommit;
START TRANSACTION;
UPDATE Certificate_Application
SET application_status="Under Review"
WHERE application_id="1001";
SELECT *FROM Certificate_Application WHERE application_id="1001";


#2
UPDATE Certificate_Application
SET application_status="Approved",remarks="Approved after the verification"
WHERE application_id="1001";
COMMIT;
SELECT *FROM Certificate_Application WHERE application_id="1001";

#3
START TRANSACTION;
UPDATE Certificate_Application
SET application_status="Rejected", remarks="Incorrectly Rejected"
WHERE application_id="1001";
ROLLBACK;
SELECT *FROM Certificate_Application WHERE application_id="1001";

#4
START TRANSACTION;
INSERT INTO Certificate_Application VALUE(999,1,"2026-09-01","To Test","Pending","40.00","GP20260999", null, null, null,"Test Entry for RollBack");
SELECT *FROM Certificate_Application WHERE application_id="999";
ROLLBACK;
SELECT *FROM Certificate_Application WHERE application_id="999";

#5
START TRANSACTION;
DELETE FROM Certificate_Application WHERE application_id="1001";
SELECT *FROM Certificate_Application WHERE application_id="1001";
ROLLBACK;
SELECT *FROM Certificate_Application WHERE application_id="1001";

#6
START TRANSACTION;
UPDATE Certificate_Application
SET remarks="Verified Resident details"
WHERE application_id="1002";
INSERT INTO Certificate_Application VALUES(100,2,"2026-09-01","Second Test","Pending","20.00","GP2026100",null,null,null,"New joint Submission");
COMMIT;
SELECT *FROM Certificate_Application WHERE application_id IN (2,100);

#PART-C 
#1
START TRANSACTION;
UPDATE Certificate_Application 
SET application_status="Approved" WHERE application_id="1001";
SAVEPOINT sp_app1;
UPDATE Certificate_Application
SET application_status="Rejectd" WHERE application_id="1002";
ROLLBACK TO SAVEPOINT sp_app1;
COMMIT;
SELECT application_id,application_status FROM Certificate_Application WHERE application_id IN (1001,1002);

#2
START TRANSACTION;
INSERT INTO Certificate_Application VALUES(101,11,"2026-09-01","Third test","Pending","10.00","GP2026101",null,null,null,"Savepoint task insert");
SAVEPOINT sp_insert;
UPDATE Certificate_Application 
SET application_status="Rejected" WHERE application_id="1001";
ROLLBACK TO SAVEPOINT sp_insert;
SELECT *FROM Certificate_Application WHERE application_id IN (101,1001);

#3
START TRANSACTION;
UPDATE Certificate_Application 
SET remarks="First milestone" WHERE application_id="1001";
SAVEPOINT sp_one;
UPDATE Certificate_Application 
SET remarks="Second milestone" WHERE application_id="1002";
SAVEPOINT sp_two;
UPDATE Certificate_Application 
SET remarks="Third milestone" WHERE application_id="100";
ROLLBACK TO SAVEPOINT sp_one;

#4
START TRANSACTION;
INSERT INTO Certificate_Application VALUES (102, 2,"2026-09-01","Third Test",'Pending',"10.00","GP2026102",null,null,null,'Valid submission');
UPDATE Certificate_Application SET remarks ='Valid update' WHERE application_id = "1001";
SAVEPOINT sp_valid_changes;
DELETE FROM Certificate_Application WHERE application_id ="1002";
ROLLBACK TO SAVEPOINT sp_valid_changes;
COMMIT;
SELECT *FROM Certificate_Application WHERE application_id IN(102,1002);

#5
START TRANSACTION;
UPDATE Certificate_Application SET remarks = 'Testing release' WHERE application_id = "1001";
SAVEPOINT sp_temp;
RELEASE SAVEPOINT sp_temp;
COMMIT;

#6

START TRANSACTION;
UPDATE Certificate_Application SET application_status = 'Approved' WHERE application_id = "1001";
SAVEPOINT sp_diff;
UPDATE Certificate_Application SET application_status = 'Rejected' WHERE application_id = "1002";
ROLLBACK TO SAVEPOINT sp_diff;
COMMIT;

#PART-D
#1
DROP USER IF EXISTS 'clerk1'@'localhost';
CREATE USER 'clerk1'@'localhost' IDENTIFIED BY 'Clerk@123';
SELECT User, Host FROM mysql.user WHERE User = 'clerk1';
#2
GRANT SELECT ON gram_panchayat_db.Certificate_Application TO 'clerk1'@'localhost';
SHOW GRANTS FOR 'clerk1'@'localhost';
#3
GRANT INSERT ON gram_panchayat_db.Certificate_Application TO 'clerk1'@'localhost';
SHOW GRANTS FOR 'clerk1'@'localhost';
#INSERT INTO gram_panchayat_db.Certificate_Application (application_id, citizen_id, certificate_type_id, office_id, application_date, application_status, remarks)
-- VALUES (103, 1, 1, 1, '2026-09-01', 'Pending', 'Clerk submission');
#4
UPDATE gram_panchayat_db.Certificate_Application SET application_status = 'Approved' WHERE application_id = 103;
#5
GRANT SELECT ON gram_panchayat_db.Approved_Applications TO 'clerk1'@'localhost';
SHOW GRANTS FOR 'clerk1'@'localhost';
SELECT * FROM gram_panchayat_db.Approved_Applications;
#6
REVOKE INSERT ON gram_panchayat_db.Certificate_Application FROM 'clerk1'@'localhost';
SHOW GRANTS FOR 'clerk1'@'localhost';
#PART-E 
#1
DROP USER IF EXISTS 'panchayat_clerk'@'localhost';
CREATE USER 'panchayat_clerk'@'localhost' IDENTIFIED BY 'ClerkPass@123';
GRANT SELECT, INSERT ON gram_panchayat_db.Certificate_Application TO 'panchayat_clerk'@'localhost';
#2
DROP USER IF EXISTS 'officer1'@'localhost';
CREATE USER 'officer1'@'localhost' IDENTIFIED BY 'Officer@123';
GRANT SELECT, INSERT, UPDATE ON gram_panchayat_db.Certificate_Application TO 'officer1'@'localhost';
#3
GRANT SELECT ON gram_panchayat_db.Approved_Applications TO 'officer1'@'localhost';
#4
GRANT SELECT, INSERT, UPDATE ON gram_panchayat_db.Certificate_Application TO 'clerk1'@'localhost';
REVOKE UPDATE ON gram_panchayat_db.Certificate_Application FROM 'clerk1'@'localhost';
SHOW GRANTS FOR 'clerk1'@'localhost';
#5
SHOW GRANTS FOR 'clerk1'@'localhost';
SHOW GRANTS FOR 'officer1'@'localhost';
#6
DROP USER IF EXISTS 'strict_clerk'@'localhost';
CREATE USER 'strict_clerk'@'localhost' IDENTIFIED BY 'StrictClerk@123';
GRANT SELECT, INSERT ON gram_panchayat_db.Certificate_Application TO 'strict_clerk'@'localhost';
#PART-F 
#1
START TRANSACTION;
INSERT INTO Certificate_Application VALUES (104, 1, '2026-09-01',"To Test", "Pending","20.00","GP20260144",null,null,null,"Official citizen submission'");
SELECT * FROM Certificate_Application WHERE application_id = 104;
COMMIT;
#2
START TRANSACTION;
UPDATE Certificate_Application SET application_status = 'Rejected', remarks = 'Wrongly rejected' WHERE application_id = 104;
ROLLBACK;
SELECT * FROM Certificate_Application WHERE application_id = 104;
#3
START TRANSACTION;
UPDATE Certificate_Application SET remarks = 'Valid officer verification note' WHERE application_id = 104;
SAVEPOINT sp_verified;
UPDATE Certificate_Application SET application_status = 'Cancelled' WHERE application_id = 104; -- Mistake
ROLLBACK TO SAVEPOINT sp_verified;
COMMIT;
#4
DROP USER IF EXISTS 'lab_clerk'@'localhost';
CREATE USER 'lab_clerk'@'localhost' IDENTIFIED BY 'LabClerk@123';
GRANT SELECT, INSERT ON gram_panchayat_db.Certificate_Application TO 'lab_clerk'@'localhost';
SHOW GRANTS FOR 'lab_clerk'@'localhost';
#5
REVOKE ALL PRIVILEGES, GRANT OPTION FROM 'lab_clerk'@'localhost';
GRANT SELECT ON gram_panchayat_db.Approved_Applications TO 'lab_clerk'@'localhost';
#6
REVOKE SELECT ON gram_panchayat_db.Approved_Applications FROM 'lab_clerk'@'localhost';
SHOW GRANTS FOR 'lab_clerk'@'localhost';


#for the cleanup
DROP USER IF EXISTS 'clerk1'@'localhost';
DROP USER IF EXISTS 'officer1'@'localhost';
DROP USER IF EXISTS 'panchayat_clerk'@'localhost';
DROP USER IF EXISTS 'strict_clerk'@'localhost';
DROP USER IF EXISTS 'lab_clerk'@'localhost';