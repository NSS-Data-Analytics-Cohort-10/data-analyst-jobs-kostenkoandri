
-- 1. How many rows are in the data_analyst_jobs table?
SELECT COUNT(*) AS count_rows
FROM data_analyst_jobs;

-- 2. Write a query to look at just the first 10 rows. What company is associated with the job posting on the 10th row?
SELECT * FROM data_analyst_jobs
LIMIT 10;

-- 3. How many postings are in Tennessee? How many are there in either Tennessee or Kentucky?
-- 27
SELECT COUNT(*) as count_tn_ky
FROM data_analyst_jobs
WHERE location IN ('TN', 'KY');

-- 4. How many postings in Tennessee have a star rating above 4?
-- 1
SELECT COUNT(*) as count_tn_rat4
FROM data_analyst_jobs
WHERE location IN ('TN') AND star_rating = 4;
-- 5. How many postings in the dataset have a review count between 500 and 1000?
-- 1
SELECT COUNT(*) as count_tn_rev_500_1000
FROM data_analyst_jobs
WHERE location IN ('TN') AND review_count BETWEEN 500 AND 1000;

-- 6. Show the average star rating for companies in each state. The output should show the state as state and the average rating for the state as avg_rating. Which state shows the highest average rating?
-- NE
SELECT location, AVG(star_rating) as avg_rating
FROM data_analyst_jobs
GROUP BY location
ORDER BY avg_rating DESC;

-- 7. Select unique job titles from the data_analyst_jobs table. How many are there?
-- 881
SELECT DISTINCT(title)
FROM data_analyst_jobs;

-- 8. How many unique job titles are there for California companies?
-- 230
SELECT COUNT(DISTINCT(title))
FROM data_analyst_jobs
WHERE location='CA';

-- 9. Find the name of each company and its average star rating for all companies that have more than 5000 reviews across all locations. How many companies are there with more that 5000 reviews across all locations?

					-- select company, avg(star_rating) from(
					-- 	SELECT company, location, star_rating
					-- 		, sum(review_count) over(partition by company) as location_sum
					-- 	from data_analyst_jobs
					-- 	--group by company, location, location_avg
					-- 	order by company, location
					-- )
					-- where location_sum > 5000
					-- group by company;

select company, avg(star_rating), sum(review_count)
from data_analyst_jobs
group by company
having sum(review_count) > 5000;
-- 10. Add the code to order the query in #9 from highest to lowest average star rating. Which company with more than 5000 reviews across all locations in the dataset has the highest star rating? What is that rating?
-- GOOGLE

					-- select company, avg(star_rating) from(
					-- 	SELECT company, location, star_rating
					-- 		, sum(review_count) over(partition by company) as location_sum
					-- 	from data_analyst_jobs
					-- 	--group by company, location, location_avg
					-- 	order by company, location
					-- )
					-- where location_sum > 5000
					-- group by company
					-- order by avg(star_rating) DESC;

select company, avg(star_rating), sum(review_count)
from data_analyst_jobs
group by company
having sum(review_count) > 5000
order by avg(star_rating) DESC;

-- 11. Find all the job titles that contain the word ‘Analyst’. How many different job titles are there?
-- 320

select distinct(title)
from data_analyst_jobs
where title like '%Analyst';

-- 12. How many different job titles do not contain either the word ‘Analyst’ or the word ‘Analytics’? What word do these positions have in common?
-- Common word is Tableau
select distinct(title)
from data_analyst_jobs
where title not ilike '%Analyst%'
	and title not ilike '%Analytics%';

-- BONUS: You want to understand which jobs requiring SQL are hard to fill. Find the number of jobs by industry (domain) that require SQL and have been posted longer than 3 weeks.
select domain, count(*) as num_of_jobs
from data_analyst_jobs
where skill ilike '%sql%' 
	and days_since_posting > 21
	and domain is not null
group by domain
order by num_of_jobs desc;

-- Disregard any postings where the domain is NULL.
-- Order your results so that the domain with the greatest number of hard to fill jobs is at the top.
-- Which three industries are in the top 4 on this list? How many jobs have been listed for more than 3 weeks for each of the top 4?