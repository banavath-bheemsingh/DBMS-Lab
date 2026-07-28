USE grampanchayat;
SHOW TABLES;

-- Level 1 (Understanding)

-- 1. Displaying all citizen names in uppercase
SELECT UPPER(full_name)
FROM Citizen;

-- 2.Displaying all village names in lowercase
SELECT LOWER(village_name)
FROM Citizen;

-- 3.Length of each citizen's full name
SELECT length(full_name)
FROM Citizen;

-- 4.Displaying the 1st four characters of every reference number.
SELECT substring(reference_number,1,4)
FROM certificate_application; 

-- 5.Concatenating the citizen name with village name
SELECT concat(full_name,'-',village_name)
FROM Citizen;

-- LEVEL 2 (APPLICATION)

-- 6.Replacing the word "Certificate" with "Cert". in Certificate names
SELECT replace(Certificate_name,"Certificate","Cert")
FROM certificate_application;

-- 7.Removing leading or trailing spaces from certificate names
SELECT trim(Certificate_name)
FROM certificate_application;

-- 8.Displaying only the first name of every citizen
SELECT substring_index(full_name,' ',1) as 'first name'
FROM Citizen;

-- Level 3 (Advanced)

-- 9
SELECT concat('Citizen : ',full_name,"\n",' Village : ',village_name)
FROM Citizen; 

-- 10. Displaying all applications whose reference number begins with "GP2026"
SELECT *FROM certificate_application
WHERE substring(reference_number,1,6)="GP2026";

-- Part C (Built-in Numeric Functions)
-- Level 1

-- 1.Rounding every application fee
SELECT round(application_fee)
FROM certificate_type; 

-- 2.Displaying hte absolute values of processing days
SELECT abs(processing_days-10)
FROM Certificate_type;

-- 3.Displaying the square of processing days
SELECT pow(processing_days,2)
FROM Certificate_type;

-- LEVEL2

-- 4. Finding Remainder when processing days are divided by 3
SELECT mod(processing_days,3)
FROM Certificate_type; 

-- 5.Rounding application fees to one decimal place
SELECT round(application_fee,1)
FROM Certificate_type;

-- 6  Displaying the ceiling and floor values of application fees
SELECT ceil(application_fee)
FROM Certificate_type;
SELECT floor(application_fee)
FROM Certificate_type;

-- LEVEL 3 

-- 7.Generating a random integer from 1 and 100
SELECT round((rand()*100)+1) AS Random_num;

-- 8.Displaying the square root of processing days
SELECT sqrt(processing_days)
FROM certificate_type;

-- 9.Calculate processing_days x 2 for every certificate
SELECT processing_days*2
FROM certificate_type;

-- PART D (DATE FUNCTIONS)
-- LEVEL 1

-- 1.Displaying today's date
SELECT now() As todays_date;

-- 2.Displaying current date and time
SELECT curdate() As "current_date" ,curtime() As "current_time";

-- 3.Displaying only the year from every application date
SELECT year(application_date)
FROM certificate_application;

-- 4.Displaying only the month from every application date
SELECT month(application_date)
FROM certificate_application;

-- 5.Displaying only the day of month
SELECT dayofmonth(application_date)
FROM certificate_application;

-- LEVEL 2
-- 6.Display the expected certificate issue date by adding the processing day to the application date.
SELECT a.application_date ,p.processing_days,
DATE_ADD(a.application_date,INTERVAL p.processing_days DAY) AS
expected_issue_date FROM certificate_application a
JOIN certificate_type p
ON a.certificate_name = p.certificate_name;

-- 7.Displaying the application date after 30 days
SELECT application_date,
date_add(application_date,interval 30 DAY )
FROM certificate_application;

-- Displaying the application date before subtracting 7 days
SELECT application_date,
date_sub(application_date,interval 7 DAY )
FROM certificate_application;

-- LEVEL 3
-- 9. Calculate the number of days between today's date and the application date.
SELECT DATEDIFF(application_date , NOW()) AS 'No.of days Different'
FROM certificate_application;

-- 10. Display applications submitted within the current year.
SELECT * FROM certificate_application 
WHERE YEAR(application_date) = YEAR(CURDATE());

# Part E – Conversion Functions
# LEVEL 1

-- 1. Convert application_fee into INTEGER.
SELECT CAST( application_fee AS SIGNED) AS application_feeInt
FROM certificate_type;

-- 2. Convert processing_days into CHAR.
SELECT CAST(processing_days AS CHAR) AS processing_daysChar
FROM certificate_type;

# Level 2
-- 3. Convert application_date into DATETIME.
SELECT CAST(application_date AS DATETIME) AS application_date
FROM certificate_application;

-- 4. Convert processing_days into DECIMAL.
SELECT CAST(processing_days AS DECIMAL) as processing_daysDecimal
FROM certificate_type;

# LEVEL 3
-- 5. Display application fees as character strings.
SELECT CAST(application_fee AS CHARACTER) AS application_fee
FROM certificate_type;

-- 6. Convert numeric values before performing arithmetic operations.
SELECT CAST(application_fee AS SIGNED ) + 10 AS 'application_fee + 10'
FROM certificate_type;

SELECT CAST(processing_days AS DECIMAL(10,2)) + 7 AS 'Processing_days + 7'
FROM certificate_type;




