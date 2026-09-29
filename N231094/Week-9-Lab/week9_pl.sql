USE grampanchayat;
SHOW TABLES;
SELECT * FROM Citizen;
SELECT * FROM Certificate_Type;
SELECT * FROM Panchayat_Office;
SELECT * FROM Certificate_Application;

-- Task 2:

DELIMITER //
CREATE PROCEDURE welcome_panchayat()
BEGIN
SELECT 'Welcome to Gram Panchayat Certificate System';
END //
DELIMITER ;
CALL welcome_panchayat() ;

DELIMITER //
CREATE PROCEDURE get_citizen_name(
	IN p_citizen_id INT
)
BEGIN
DECLARE v_name varchar(100);
SELECT full_name INTO v_name FROM citizen 
WHERE citizen_id=p_citizen_id;
SELECT v_name As citizen_name;
END //
DELIMITER ;
CALL get_citizen_name(101);

