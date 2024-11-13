create table dataset(
    Name VARCHAR(255),
    Age INT,
    Gender VARCHAR(10),
    Blood_Type VARCHAR(5),
    Medical_Condition VARCHAR(255),
    Date_of_Admission DATE,
    Doctor VARCHAR(255),
    Hospital VARCHAR(255),
    Insurance_Provider VARCHAR(255),
    Billing_Amount DECIMAL(10, 2),
    Room_Number INT,
    Admission_Type VARCHAR(50),
    Discharge_Date DATE,
    Medication VARCHAR(255),
    Test_Results VARCHAR(50)
);



-- Q1.  Counting Total Record in Database
SELECT COUNT(*) FROM dataset;		

-- Q2. Finding maximum age of patient admitted.
select max(age) as Maximum_Age from dataset;

-- Q3. Finding Average age of hospitalized patients.
select round(avg(age),0) as Average_Age from dataset;	

-- Q4. Calculating Patients Hospitalized Age-wise from Maximum to Minimum
SELECT AGE, COUNT(AGE) AS Total
FROM dataset
GROUP BY age
ORDER BY AGE DESC;
    
-- Q5. Calculating Maximum Count of patients on basis of total patients hospitalized with respect to age.
SELECT AGE, COUNT(AGE) AS Total
FROM dataset
GROUP BY age
ORDER BY Total DESC,age DESC;

-- 6. Ranking Age on the number of patients Hospitalized   
SELECT AGE, COUNT(AGE) As Total, dense_RANK() OVER(ORDER BY COUNT(AGE) DESC, age DESC) as Ranking_Admitted 
FROM dataset
GROUP BY age
HAVING Total > Avg(age);

-- 7. Finding Count of Medical Condition of patients and lisitng it by maximum no of patients.
SELECT Medical_Condition, COUNT(Medical_Condition) as Total_Patients 
FROM dataset
GROUP BY Medical_Condition
ORDER BY Total_patients DESC;

-- 8. Finding Rank & Maximum number of medicines recommended to patients based on Medical Condition pertaining to them.    
SELECT Medical_Condition, Medication, COUNT(medication) as Total_Medications_to_Patients, RANK() OVER(PARTITION BY Medical_Condition ORDER BY COUNT(medication) DESC) as Rank_Medicine
FROM dataset
GROUP BY 1,2
ORDER BY 1;     

-- 9. Most preffered Insurance Provide  by Patients Hospatilized
SELECT Insurance_Provider, COUNT(Insurance_Provider) AS Total 
FROM dataset
GROUP BY Insurance_Provider
ORDER BY Total DESC;    

-- 10. Finding out most preffered Hospital 
SELECT Hospital, COUNT(hospital) AS Total 
FROM dataset
GROUP BY Hospital
ORDER BY Total DESC;
    

-- 11. Identifying Average Billing Amount by Medical Condition.
SELECT Medical_Condition, ROUND(AVG(Billing_Amount),2) AS Avg_Billing_Amount
FROM dataset
GROUP BY Medical_Condition;    

-- 12. Finding Billing Amount of patients admitted and number of days spent in respective hospital.
SELECT Medical_Condition, Name, Hospital, DATEDIFF(Discharge_date,Date_of_Admission) as Number_of_Days, 
SUM(ROUND(Billing_Amount,2)) OVER(Partition by Hospital ORDER BY Hospital DESC) AS Total_Amount
FROM dataset
ORDER BY Medical_Condition;
 
 
-- 13. Finding Total number of days sepnt by patient in an hospital for given medical condition
SELECT Name, Medical_Condition, ROUND(Billing_Amount,2) as Billing_Amount, Hospital, DATEDIFF(Discharge_Date, Date_of_Admission) as Total_Hospitalized_days
FROM dataset;


-- 14. Finding Hospitals which were successful in discharging patients after having test results as 'Normal' with count of days taken to get results to Normal
SELECT Medical_Condition, Hospital, DATEDIFF(Discharge_Date, Date_of_Admission) as Total_Hospitalized_days,Test_results
FROM dataset
WHERE Test_results LIKE 'Normal'
ORDER BY Medical_Condition, Hospital;

-- 15. Calculate number of blood types of patients which lies betwwen age 20 to 45
SELECT Age, Blood_type, COUNT(Blood_Type) as Count_Blood_Type
FROM dataset
WHERE AGE BETWEEN 20 AND 45
GROUP BY 1,2
ORDER BY Blood_Type DESC;    

-- 16. Find how many of patient are Universal Blood Donor and Universal Blood reciever
SELECT DISTINCT (SELECT Count(Blood_Type) FROM healthcare WHERE Blood_Type IN ('O-')) AS Universal_Blood_Donor, 
(SELECT Count(Blood_Type) FROM healthcare WHERE Blood_Type  IN ('AB+')) as Universal_Blood_reciever
FROM dataset; 

-- Q17. Provide a list of hospitals along with the count of patients admitted in the year 2024 AND 2025?
SELECT DISTINCT Hospital, Count(*) as Total_Admitted
FROM dataset
WHERE YEAR(Date_of_Admission) IN (2024, 2025)
GROUP BY 1
ORDER by Total_Admitted DESC;     
    
-- Q18. Find the average, minimum and maximum billing amount for each insurance provider?
SELECT Insurance_Provider, ROUND(AVG(Billing_Amount),0) as Average_Amount, ROUND(Min(Billing_Amount),0) as Minimum_Amount, ROUND(Max(Billing_Amount),0) as Maximum_Amount
FROM dataset
GROUP BY 1;

-- Q19. Create a new column that categorizes patients as high, medium, or low risk based on their medical condition.
SELECT Name, Medical_Condition, Test_Results,
CASE 
		WHEN Test_Results = 'Inconclusive' THEN 'Need More Checks / CANNOT be Discharged'
        WHEN Test_Results = 'Normal' THEN 'Can take discharge, But need to follow Prescribed medications timely' 
        WHEN Test_Results =  'Abnormal' THEN 'Needs more attention and more tests'
        END AS 'Status', Hospital, Doctor
FROM dataset;
