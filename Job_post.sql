DROP DATABASE IF EXISTS Job_Post;
CREATE DATABASE Job_Post;
USE Job_Post;

-- Design and execute CREATE TABLE commands:
CREATE TABLE IF NOT EXISTS `Company` (
	`Company_ID` INT,
    `Company_Name` VARCHAR(200) DEFAULT NULL,
    `Company_State` VARCHAR(100) DEFAULT NULL,
    `Company_url` VARCHAR(200) DEFAULT NULL,
	PRIMARY KEY (`Company_ID`)
);

CREATE TABLE IF NOT EXISTS `Sponsored_job` (
	`Job_ID` INT,
    `FK_Company_ID` INT DEFAULT NULL,
	`Title` VARCHAR(200) DEFAULT NULL,
    `Work_Type` VARCHAR(50) DEFAULT NULL,
    `Remote_Allowed` VARCHAR(10) DEFAULT NULL,
    `Application_Type` VARCHAR(50) DEFAULT NULL,
    `Experience_Level` VARCHAR(50) DEFAULT NULL,
    `Job_url` VARCHAR(200) DEFAULT NULL,
    `Description` TEXT DEFAULT NULL, 
     PRIMARY KEY (`Job_ID`),
     FOREIGN KEY (`FK_Company_ID`) REFERENCES `Company` (`Company_ID`)
);

CREATE TABLE IF NOT EXISTS `Time` (
	`FK_Job_ID` INT,
    `Listed_Time` VARCHAR(50),
    `Closed` VARCHAR(50) DEFAULT NULL,
    `Expired` VARCHAR(50) DEFAULT NULL,
    FOREIGN KEY (`FK_Job_ID`) REFERENCES `Sponsored_job`(`Job_ID`)
);


CREATE TABLE IF NOT EXISTS `Counts` (
	`FK_Job_ID` INT,
    `Applies` INT DEFAULT NULL,
    `Views` INT DEFAULT NULL,
    FOREIGN KEY (`FK_Job_ID`) REFERENCES `Sponsored_job`(`Job_ID`)
);

CREATE TABLE IF NOT EXISTS `Salary` (
	`FK_Job_ID` INT,
    `Currency` VARCHAR(50) DEFAULT NULL,
    `Max_Salary` INT DEFAULT NULL,
    `Med_Salary` INT DEFAULT NULL,
    `Min_Salary` INT DEFAULT NULL,
    `Pay_Period` VARCHAR(50) DEFAULT NULL,
    `Compensation_Type` VARCHAR(50) DEFAULT NULL,
    FOREIGN KEY (`FK_Job_ID`) REFERENCES `Sponsored_job`(`Job_ID`)
);

-- Design and execute SELECT TABLE commands:

-- 1. Mean Salaries of Top 5 Sponsored Job:
use Job_Post;
SELECT b.job_id, b.company_id, c.company_name, b.title,
       ((max_salary + min_salary) / 2) AS Avg_salary
FROM Salary s
JOIN Sponsored_job b on b.job_id=s.FK_job_id
JOIN Company c ON c.company_id = b.FK_company_id
ORDER BY Avg_salary DESC
LIMIT 5;


-- 2. top 5 company posting jobs
SELECT b.company_id, c.company_name, c.company_state, 
COUNT(*) AS company_post_count,
c. company_url
FROM Sponsored_job b
JOIN Company c ON c.company_id = b.FK_company_id
JOIN Salary s ON s.FK_job_id = b.job_id
WHERE s.min_salary > 50000
GROUP BY FK_company_id
ORDER BY company_post_count DESC
LIMIT 5;


-- 3. Remote Work Salary 
-- First, count the number of entries where remote_allowed is "1"
SELECT count(*) FROM Sponsored_job b
WHERE b.remote_allowed = "1";

-- Then, select the top 5 job entries with the maximum salary where remote_allowed is "1"
SELECT b.job_id, b.company_id, c.Company_name,b.title, b.remote_allowed, s.max_salary, s.min_salary  
FROM Sponsored_job b
JOIN Salary s ON s.FK_job_id = b.job_id
JOIN Company c ON c.company_id = b.FK_company_id
WHERE b.remote_allowed = "1"
ORDER BY s.max_salary DESC
LIMIT 5;

-- 4. work type distribution
SELECT work_type, COUNT(*) AS work_type_count
FROM Sponsored_job 
GROUP BY work_type;


-- 5. Top 5 apllied jobs and their salaries 
SELECT b.Job_ID,
       b.Title,
       b.Company_ID,
       c.Company_name,
       ct.applies,
       s.max_salary, 
       s.min_salary  
FROM Sponsored_job b
JOIN Company c ON c.company_id = b.FK_company_id
JOIN Counts ct  ON ct.FK_job_id = b.job_id
JOIN Salary s ON s.FK_job_id = b.job_id
ORDER BY ct.applies DESC
LIMIT 5;


-- Design and execute INSERT TABLE commands:
-- A company posting a new job
-- if it's a brand new company
INSERT INTO Company (Company_ID, Company_Name, Company_State, Company_url)
VALUES (87654321, 'NEW Company', 'CA', 'https://www.newcompany.com');

-- if posting a new job
INSERT INTO Sponsored_Job (Job_ID, Company_ID, Title, Work_Type, Remote_Allowed, Application_Type, Experience_Level, Job_url)
VALUES (32345678, 87654321, 'Software Engineer', 'Full-time', '1', 'Online', 'Mid-Level', 'https://www.newcompany.com/job/software-engineer');

INSERT INTO Time (Job_ID, Listed_Time, Closed, Expired)
VALUES (32345678, '2023-12-10 08:00:00', NULL, NULL);

INSERT INTO Counts (Job_ID, Applies, Views)
VALUES (32345678, 0, 0);

INSERT INTO Salary (Job_ID, Currency, Max_Salary, Med_Salary, Min_Salary, Pay_Period, Compensation_Type)
VALUES (32345678, 'USD', 120000, 100000, 80000, 'Yearly', 'Fixed');

-- fetching job details along with the company information:
SELECT b.Title, b.Work_Type, b.Remote_Allowed, b.Application_Type, b.Experience_Level,
 c.Company_Name, c.Company_State, c.Company_Size
FROM Sponsored_Job b
INNER JOIN Company c ON c.Company_ID = b.FK_Company_ID
WHERE b.Job_ID = job_id_value;

