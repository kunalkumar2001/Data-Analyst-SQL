-- Q1. Group participants by gender and find the average age for each group.

SELECT gender, AVG(age) FROM heart_details
GROUP BY gender;

-- Q2. Find genders with an average cholesterol level above 200.

select gender, avg(totChol) from heart_details
group by gender
having avg(totChol)>200

-- Q3. Calculate the percentage of participants with high cholesterol (above 240) out of the total number of participants.

SELECT 
    (COUNT(*) * 100.0 / (SELECT COUNT(*) FROM heart_details)) AS percentage_high_cholesterol
FROM heart_details
WHERE totChol > 240;

-- Q4.Find the number of distinct age values among males in the table.

select count(distinct(age)) as age_distinct_value
from heart_details
where gender = 'male'

-- Q5.Find the participant(s) with the highest cholesterol level

select gender, age, totChol from heart_details
where totChol = (select max(totChol) from heart_details)

-- Q6. calculate their rank based on cholesterol level within their age group.

SELECT age, totChol,
       RANK() OVER (PARTITION BY age ORDER BY totChol DESC) AS cholesterol_rank
FROM heart_details;

-- Q7. Find the count of individuals with high blood_pressure (above 140) for each age group.

select age, count(*) as high_blood_pressure
from heart_details
where sysBP > 140
group by age

-- Q8. For each gender and age group, find the average cholesterol level for participants who have either a high blood pressure (above 140) or a high BMI (over 25).

SELECT 
    gender, 
    age, 
    AVG(totChol) AS avg_cholesterol
FROM heart_details
WHERE sysBP > 140 OR bmi > 25
GROUP BY gender, age;


-- Q9. Find the participant with the maximum cholesterol in each age group, and  then identify the age group and eduaction background with the highest average cholesterol among these participants.

WITH max_cholesterol_per_age_group AS (
    SELECT 
        age,education,
        MAX(totChol) AS max_cholesterol
    FROM heart_details
    GROUP BY age,education
)
SELECT age, education, AVG(max_cholesterol) AS avg_max_cholesterol
FROM max_cholesterol_per_age_group
GROUP BY age,education
ORDER BY avg_max_cholesterol DESC
LIMIT 1;

-- Q10. count of participants in each cholesterol range (low, medium, high) for each age group.

SELECT 
    age,
    COUNT(CASE WHEN totChol < 200 THEN 1 END) AS low_cholesterol,
    COUNT(CASE WHEN totChol BETWEEN 200 AND 240 THEN 1 END) AS medium_cholesterol,
    COUNT(CASE WHEN totChol > 240 THEN 1 END) AS high_cholesterol
FROM heart_details
GROUP BY age
order by age desc

