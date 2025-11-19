-- Netflix Data Analysis using SQL
-- Solutions of 15 business problems
--1.count the number of movies and tv shows
SELECT 
type,COUNT(*) as total_count 
FROM netflix GROUP BY type;
--2.find the most common rating for movies and tv shows
SELECT type,rating FROM(
SELECT type,rating,COUNT(*),
DENSE_RANK() OVER(PARTITION BY 
type ORDER BY COUNT(*) DESC) as ranks FROM netflix 
GROUP BY type,rating
) AS ranked
WHERE ranks=1;
--3.list all the movies released in a particular year (e.g., 2020)
SELECT * FROM netflix WHERE 
type = "Movie" AND release_year = 2020;
--4.find the top 5 countries with most content on netflix and 
--split countries if multiple countries are listed
SELECT country,COUNT(*) AS total_count FROM netflix
GROUP BY country
ORDER BY total_count DESC
LIMIT 5;
--5.identify the longest movie available on netflix
SELECT * FROM netflix WHERE type = "Movie"
AND duration = (SELECT MAX(duration) FROM netflix);
--6.find content added in the last 5 years
 SELECT * FROM netflix
 WHERE STR_TO_DATE(date_added, '%M %d, %Y') >= 
 DATE_SUB(CURRENT_DATE(), INTERVAL 5 YEAR);
--7.find all the movies / tv shows directed by a specific director (e.g., "rajiv chilaka")
SELECT * FROM netflix 
WHERE director LIKE "%Rajiv Chilaka%";
--8.list all the tv shows with more than 5 seasons
SELECT * FROM netflix 
WHERE type = "TV Show" AND
SUBSTRING_INDEX(duration,' ',1) > 5;
--9.find each year and the average number of content released by india on netflix
-- and return top 5 years with highest average content released
SELECT 
EXTRACT(YEAR FROM STR_TO_DATE(date_added, '%M %d, %Y')) AS added_date,
COUNT(*),
COUNT(*)/(SELECT COUNT(*) FROM netflix WHERE country = "India") * 100 AS avg_content
FROM netflix
WHERE country = "India"
GROUP BY 1
ORDER BY COUNT(*) DESC
LIMIT 5;
--10.list all movies that are documentaries
SELECT * FROM netflix 
WHERE type = "Movie" AND listed_in LIKE "%Documentaries%";

--11.find all content without a  director listed
SELECT * FROM netflix WHERE director IS NULL;
--12.find how many movies actor "salman khan" appears in last 10 years
SELECT * FROM netflix 
WHERE cast LIKE "%Salman Khan%"
AND release_year >= YEAR(CURRENT_DATE()) - 10;
--13.Categorize the content based on the presence of the keywords 'kill' and 'violence' in 
--the description field. Label content containing these keywords as 'Bad' and all other 
--content as 'Good'. Count how many items fall into each category.
WITH  badorgood AS(
SELECT *,
CASE 
    WHEN description LIKE "%kill%" OR description LIKE "%violence%" THEN "Bad"
    ELSE "Good"
END AS content_category
FROM netflix
)
SELECT content_category,COUNT(*) AS total_count
FROM badorgood
GROUP BY 1;
--14.List 20 random titles (quick sample).
SELECT title, type, release_year
FROM netflix
ORDER BY RAND()
LIMIT 20;

--15.Using REGEXP to find titles that start with a number
SELECT title
FROM netflix
WHERE title REGEXP '^[0-9]';


