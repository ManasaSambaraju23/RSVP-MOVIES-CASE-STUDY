USE imdb;

/* Now that you have imported the data sets, let’s explore some of the tables. 
 To begin with, it is beneficial to know the shape of the tables and whether any column has null values.
 Further in this segment, you will take a look at 'movies' and 'genre' tables.*/



-- Segment 1:




-- Q1. Find the total number of rows in each table of the schema?
-- Type your code below:
SELECT 
    COUNT(*) AS MOVIE_ROW_COUNT 
FROM 
    MOVIE;
SELECT 
    COUNT(*) AS GENRE_ROW_COUNT 
FROM 
    GENRE;
SELECT 
    COUNT(*) AS DIRECTOR_MAPPING_ROW_COUNT 
FROM 
    DIRECTOR_MAPPING;
SELECT 
    COUNT(*) AS NAMES_ROW_COUNT 
FROM 
    NAMES;
SELECT 
    COUNT(*) AS RATINGS_ROW_COUNT 
FROM 
    RATINGS;
SELECT 
    COUNT(*) AS ROLE_MAPPING_ROW_COUNT 
FROM 
    ROLE_MAPPING;

-- Q2. Which columns in the movie table have null values?
-- Type your code below:
SELECT 
    COUNT(CASE WHEN ID IS NULL THEN 1 ELSE NULL END) AS ID_NULL,
    COUNT(CASE WHEN TITLE IS NULL THEN 1 ELSE NULL END) AS TITLE_NULL,
    COUNT(CASE WHEN YEAR IS NULL THEN 1 ELSE NULL END) AS YEAR_NULL,
    COUNT(CASE WHEN DATE_PUBLISHED IS NULL THEN 1 ELSE NULL END) AS DATE_PUBLISHED_NULL,
    COUNT(CASE WHEN DURATION IS NULL THEN 1 ELSE NULL END) AS DURATION_NULL,
    COUNT(CASE WHEN COUNTRY IS NULL THEN 1 ELSE NULL END) AS COUNTRY_NULL,
    COUNT(CASE WHEN WORLWIDE_GROSS_INCOME IS NULL THEN 1 ELSE NULL END) AS WORLWIDE_GROSS_INCOME_NULL,
    COUNT(CASE WHEN LANGUAGES IS NULL THEN 1 ELSE NULL END) AS LANGUAGES_NULL,
    COUNT(CASE WHEN PRODUCTION_COMPANY IS NULL THEN 1 ELSE NULL END) AS PRODUCTION_COMPANY_NULL
FROM 
    MOVIE;
		

-- Now as you can see four columns of the movie table COUNTRY,WORLWIDE_GROSS_INCOME,LANGUAGES,PRODUCTION_COMPANY
-- has null values. Let's look at the at the movies released each year. 

-- Q3. Find the total number of movies released each year? How does the trend look month wise? (Output expected)

/* Output format for the first part:

+---------------+-------------------+
| Year			|	number_of_movies|
+-------------------+----------------
|	2017		|	2134			|
|	2018		|		.			|
|	2019		|		.			|
+---------------+-------------------+


Output format for the second part of the question:
+---------------+-------------------+
|	month_num	|	number_of_movies|
+---------------+----------------
|	1			|	 134			|
|	2			|	 231			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
SELECT YEAR,
     COUNT(DISTINCT(ID)) AS NUMBER_OF_MOVIES 
FROM 
     MOVIE
GROUP BY YEAR;

SELECT 
      MONTH(DATE_PUBLISHED) AS MONTH_NUM,
	  COUNT(DISTINCT(ID)) AS NUMBER_OF_MOVIES
FROM 
      MOVIE
GROUP BY MONTH(DATE_PUBLISHED)
ORDER BY MONTH_NUM ;

/*The highest number of movies is produced in the month of March.
So, now that you have understood the month-wise trend of movies, let’s take a look at the other details in the movies table. 
We know USA and India produces huge number of movies each year. Lets find the number of movies produced by USA or India for the last year.*/  
-- Q4. How many movies were produced in the USA or India in the year 2019??
-- Type your code below:
SELECT 
     COUNT(DISTINCT(ID)) AS MOVIE_COUNT_IN_INDIA_USA
FROM 
     MOVIE 
WHERE 
     COUNTRY = 'USA' OR COUNTRY = 'INDIA'
AND  
     YEAR = 2019;

/* USA and India produced more than a thousand movies(you know the exact number!) in the year 2019.
Exploring table Genre would be fun!! 
Let’s find out the different genres in the dataset.*/
-- Q5. Find the unique list of the genres present in the data set?
-- Type your code below:
SELECT 
     DISTINCT(GENRE) AS GENRE_LIST
FROM 
     GENRE;

/* So, RSVP Movies plans to make a movie of one of these genres.
Now, wouldn’t you want to know which genre had the highest number of movies produced in the last year?
Combining both the movie and genres table can give more interesting insights. */

-- Q6.Which genre had the highest number of movies produced overall?
-- Type your code below:
SELECT 
     G.GENRE AS TOP_GENRE, 
     COUNT(M.ID) AS NO_OF_MOVIES 
FROM 
     GENRE G
INNER JOIN 
     MOVIE M
ON 
    G.MOVIE_ID = M.ID
GROUP BY G.GENRE 
ORDER BY NO_OF_MOVIES DESC
LIMIT 1;

/* So, based on the insight that you just drew, RSVP Movies should focus on the ‘Drama’ genre. 
But wait, it is too early to decide. A movie can belong to two or more genres. 
So, let’s find out the count of movies that belong to only one genre.*/
-- Q7. How many movies belong to only one genre?
-- Type your code below:

WITH SINGLE_GENRE AS (
    SELECT MOVIE_ID
    FROM GENRE
    GROUP BY MOVIE_ID
    HAVING COUNT(GENRE) = 1
) 
SELECT 
     COUNT(*) AS SINGLE_GENRE_MOVIES 
FROM 
     SINGLE_GENRE;

/* There are more than three thousand movies which has only one genre associated with them.
So, this figure appears significant. 
Now, let's find out the possible duration of RSVP Movies’ next project.*/

-- Q8.What is the average duration of movies in each genre? 
-- (Note: The same movie can belong to multiple genres.)

/* Output format:

+---------------+-------------------+
| genre			|	avg_duration	|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
SELECT 
     G.GENRE,
     ROUND(AVG(M.DURATION),2) AS AVG_DURATION
FROM 
     GENRE G
INNER JOIN 
     MOVIE M
ON 
    G.MOVIE_ID = M.ID
GROUP BY G.GENRE;
/* Now you know, movies of genre 'Drama' (produced highest in number in 2019) has the average duration of 106.77 mins.
Lets find where the movies of genre 'thriller' on the basis of number of movies.*/

-- Q9.What is the rank of the ‘thriller’ genre of movies among all the genres in terms of number of movies produced? 
-- (Hint: Use the Rank function)


/* Output format:
+---------------+-------------------+---------------------+
| genre			|		movie_count	|		genre_rank    |	
+---------------+-------------------+---------------------+
|drama			|	2312			|			2		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:
WITH RANK_OF_GENRE AS(
SELECT 
       G.GENRE,
       COUNT(M.ID) AS MOVIE_COUNT,
       RANK() OVER (ORDER BY COUNT(M.ID) DESC) AS GENRE_RANK
FROM 
      GENRE G
INNER JOIN 
      MOVIE M
ON 
      G.MOVIE_ID = M.ID
GROUP BY 
      G.GENRE
)
SELECT 
     GENRE,
     MOVIE_COUNT,
     GENRE_RANK
FROM 
     RANK_OF_GENRE
WHERE 
    GENRE='Thriller'; 
     

/*Thriller movies is in top 3 among all genres in terms of number of movies
 In the previous segment, you analysed the movies and genres tables. 
 In this segment, you will analyse the ratings table as well.
To start with lets get the min and max values of different columns in the table*/
-- Segment 2:

-- Q10.  Find the minimum and maximum values in  each column of the ratings table except the movie_id column?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
| min_avg_rating|	max_avg_rating	|	min_total_votes   |	max_total_votes 	 |min_median_rating|min_median_rating|
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
|		0		|			5		|	       177		  |	   2000	    		 |		0	       |	8			 |
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+*/
-- Type your code below:

SELECT 
       MIN(AVG_RATING) AS MIN_AVG_RATING,
       MAX(AVG_RATING) AS MAX_AVG_RATING,
       MIN(TOTAL_VOTES) AS MIN_TOTAL_VOTES,
       MAX(TOTAL_VOTES) AS MAX_TOTAL_VOTES,
	   MIN(MEDIAN_RATING) AS MIN_MEDIAN_RATING,
       MAX(MEDIAN_RATING) AS MAX_MEDIAN_RATING
FROM 
       RATINGS;

/* So, the minimum and maximum values in each column of the ratings table are in the expected range. 
This implies there are no outliers in the table. 
Now, let’s find out the top 10 movies based on average rating.*/

-- Q11. Which are the top 10 movies based on average rating?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		movie_rank    |
+---------------+-------------------+---------------------+
| Fan			|		9.6			|			5	  	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:
-- Keep in mind that multiple movies can be at the same rank. You only have to find out the top 10 movies (if there are more than one movies at the 10th place, consider them all.)
WITH MOVIERANKS AS (
SELECT 
       M.TITLE , 
       R.AVG_RATING,
       RANK() OVER(ORDER BY R.AVG_RATING DESC) AS MOVIE_RANK
FROM  
      RATINGS R
INNER JOIN 
      MOVIE M
ON 
     R.MOVIE_ID = M.ID
)
SELECT 
     TITLE,
     AVG_RATING,
     MOVIE_RANK
FROM 
     MOVIERANKS
WHERE
     MOVIE_RANK<=10;

/* Do you find you favourite movie FAN in the top 10 movies with an average rating of 9.6? If not, please check your code again!!
So, now that you know the top 10 movies, do you think character actors and filler actors can be from these movies?
Summarising the ratings table based on the movie counts by median rating can give an excellent insight.*/

-- Q12. Summarise the ratings table based on the movie counts by median ratings.
/* Output format:

+---------------+-------------------+
| median_rating	|	movie_count		|
+-------------------+----------------
|	1			|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
-- Order by is good to have
SELECT MEDIAN_RATING,
       COUNT(MOVIE_ID) AS MOVIE_COUNT
FROM 
      RATINGS
GROUP BY 
      MEDIAN_RATING
ORDER BY 
      MOVIE_COUNT DESC;

/* Movies with a median rating of 7 is highest in number. 
Now, let's find out the production house with which RSVP Movies can partner for its next project.*/

-- Q13. Which production house has produced the most number of hit movies (average rating > 8)??
/* Output format:
+------------------+-------------------+---------------------+
|production_company|movie_count	       |	prod_company_rank|
+------------------+-------------------+---------------------+
| The Archers	   |		1		   |			1	  	 |
+------------------+-------------------+---------------------+*/
-- Type your code below:
SELECT 
    M.PRODUCTION_COMPANY,
    COUNT(M.ID) AS MOVIE_COUNT,
    RANK() OVER (ORDER BY COUNT(M.ID) DESC) AS PROD_COMPANY_RANK
FROM 
    MOVIE M
INNER JOIN 
    RATINGS R 
ON 
    M.ID = R.MOVIE_ID
GROUP BY 
    M.PRODUCTION_COMPANY
HAVING 
    AVG(R.AVG_RATING) > 8
LIMIT 1;

-- It's ok if RANK() or DENSE_RANK() is used too
-- Answer can be Dream Warrior Pictures or National Theatre Live or both

-- Q14. How many movies released in each genre during March 2017 in the USA had more than 1,000 votes?
/* Output format:

+---------------+-------------------+
| genre			|	movie_count		|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
SELECT 
     G.GENRE,
     COUNT(G.MOVIE_ID) AS MOVIE_COUNT
FROM 
     GENRE G
INNER JOIN 
     MOVIE M
ON 
	G.MOVIE_ID=M.ID
INNER JOIN 
    RATINGS R
ON 
    M.ID=R.MOVIE_ID
WHERE 
	M.YEAR = 2017 AND 
    MONTH(M.DATE_PUBLISHED) = 3 
    AND R.TOTAL_VOTES > 1000
GROUP BY G.GENRE 
ORDER BY MOVIE_COUNT DESC;

-- Lets try to analyse with a unique problem statement.
-- Q15. Find movies of each genre that start with the word ‘The’ and which have an average rating > 8?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		genre	      |
+---------------+-------------------+---------------------+
| Theeran		|		8.3			|		Thriller	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:
SELECT 
     DISTINCT(M.TITLE) AS TITLE,
     R.AVG_RATING,
     G.GENRE
FROM 
     GENRE G
INNER JOIN 
     MOVIE M
ON
     G.MOVIE_ID=M.ID
INNER JOIN 
	 RATINGS R
ON 
     M.ID=R.MOVIE_ID
WHERE  
     M.TITLE LIKE 'The%' 
AND  
     R.AVG_RATING >8;

-- You should also try your hand at median rating and check whether the ‘median rating’ column gives any significant insights.
-- Q16. Of the movies released between 1 April 2018 and 1 April 2019, how many were given a median rating of 8?
-- Type your code below:

SELECT 
     COUNT(M.ID) AS MOVIES_OF_MEDIAN_RATING_8
FROM 
     MOVIE M
INNER JOIN 
     RATINGS R
ON 
     M.ID=R.MOVIE_ID
WHERE 
     M.DATE_PUBLISHED BETWEEN ('2018-04-01') AND ('2019-04-01')
AND 
     R.MEDIAN_RATING >8;
-- Once again, try to solve the problem given below.
-- Q17. Do German movies get more votes than Italian movies? 
-- Hint: Here you have to find the total number of votes for both German and Italian movies.
-- Type your code below:
WITH TOTALVOTES AS (
SELECT 
      M.COUNTRY,
      SUM(R.TOTAL_VOTES) AS TOTAL_VOTES
FROM 
      MOVIE M
INNER JOIN
      RATINGS R 
ON 
      M.ID=R.MOVIE_ID
WHERE 
      M.COUNTRY IN ('Germany','Italy')
GROUP BY M.COUNTRY
)
SELECT 
     CASE 
         WHEN (SELECT TOTAL_VOTES FROM TOTALVOTES WHERE COUNTRY = 'Germany') > 
         (SELECT TOTAL_VOTES FROM TOTALVOTES WHERE COUNTRY = 'Italy') 
         THEN 'YES' 
         ELSE 'NO'
     END AS GERMANY_MOVIES_VOTECOUNT_GREATER_THAN_ITALY;


-- Answer is Yes

/* Now that you have analysed the movies, genres and ratings tables, let us now analyse another table, the names table. 
Let’s begin by searching for null values in the tables.*/

-- Segment 3:

-- Q18. Which columns in the names table have null values??
/*Hint: You can find null values for individual columns or follow below output format
+---------------+-------------------+---------------------+----------------------+
| name_nulls	|	height_nulls	|date_of_birth_nulls  |known_for_movies_nulls|
+---------------+-------------------+---------------------+----------------------+
|		0		|			123		|	       1234		  |	   12345	    	 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:
SELECT 
    COUNT(CASE WHEN NAME IS NULL THEN 1 ELSE NULL END) AS NAME_NULL,
    COUNT(CASE WHEN HEIGHT IS NULL THEN 1 ELSE NULL END) AS HEIGHT_NULL,
	COUNT(CASE WHEN DATE_OF_BIRTH IS NULL THEN 1 ELSE NULL END) AS DATE_OF_BIRTH_NULLS,
    COUNT(CASE WHEN KNOWN_FOR_MOVIES IS NULL THEN 1 ELSE NULL END) AS KNOWN_FOR_MOVIES_NULL
FROM NAMES;

/* There are no Null value in the column 'name'.
The director is the most important person in a movie crew. 
Let’s find out the top three directors in the top three genres who can be hired by RSVP Movies.*/

-- Q19. Who are the top three directors in the top three genres whose movies have an average rating > 8?
-- (Hint: The top three genres would have the most number of movies with an average rating > 8.)
/* Output format:

+---------------+-------------------+
| director_name	|	movie_count		|
+---------------+-------------------|
|James Mangold	|		4			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
WITH Top_Three_Genre AS (
    SELECT
        genre,
        COUNT(m.id) AS Movie_count
    FROM
        movie m
    INNER JOIN
        genre g ON m.id = g.movie_id
    INNER JOIN
        ratings r ON r.movie_id = m.id
    WHERE
        avg_rating > 8
    GROUP BY
        genre
    ORDER BY
        Movie_count DESC
    LIMIT 3
)
SELECT
    n.name AS director_name,
    COUNT(m.id) AS Movie_count
FROM
    movie m
INNER JOIN
    director_mapping d ON m.id = d.movie_id
INNER JOIN
    names n ON n.id = d.name_id
INNER JOIN
    genre g ON g.movie_id = m.id
INNER JOIN
    ratings r ON m.id = r.movie_id
WHERE
    g.genre IN (SELECT genre FROM Top_Three_Genre)
    AND avg_rating > 8
GROUP BY
    director_name
ORDER BY
    Movie_count DESC
LIMIT 9;

/* James Mangold can be hired as the director for RSVP's next project. Do you remeber his movies, 'Logan' and 'The Wolverine'. 
Now, let’s find out the top two actors.*/

-- Q20. Who are the top two actors whose movies have a median rating >= 8?
/* Output format:

+---------------+-------------------+
| actor_name	|	movie_count		|
+-------------------+----------------
|Christain Bale	|		10			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
SELECT 
     N.NAME AS ACTOR_NAME,
     COUNT(RM.MOVIE_ID) AS MOVIE_COUNT
FROM 
     NAMES N
INNER JOIN 
     ROLE_MAPPING RM 
ON 
     RM.NAME_ID = N.ID
INNER JOIN 
     RATINGS R
ON 
     RM.MOVIE_ID = R.MOVIE_ID
WHERE 
     R.MEDIAN_RATING>=8
GROUP BY N.ID,N.NAME
ORDER BY MOVIE_COUNT DESC
LIMIT 2;
/* Have you find your favourite actor 'Mohanlal' in the list. If no, please check your code again. 
RSVP Movies plans to partner with other global production houses. 
Let’s find out the top three production houses in the world.*/

-- Q21. Which are the top three production houses based on the number of votes received by their movies?
/* Output format:
+------------------+--------------------+---------------------+
|production_company|vote_count			|		prod_comp_rank|
+------------------+--------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:
WITH RANK_OF_PROD_COMPANIES AS
(
SELECT 
     M.PRODUCTION_COMPANY,
     SUM(R.TOTAL_VOTES) AS VOTE_COUNT,
     RANK() OVER (ORDER BY SUM(R.TOTAL_VOTES) DESC) AS PROD_COMP_RANK
FROM 
     MOVIE M
INNER JOIN 
     RATINGS R 
ON  
    M.ID=R.MOVIE_ID
GROUP BY  
    M.PRODUCTION_COMPANY
)
SELECT 
     PRODUCTION_COMPANY, 
	VOTE_COUNT, 
     PROD_COMP_RANK
FROM RANK_OF_PROD_COMPANIES
WHERE PROD_COMP_RANK <= 3;

/*Yes Marvel Studios rules the movie world.
So, these are the top three production houses based on the number of votes received by the movies they have produced.

Since RSVP Movies is based out of Mumbai, India also wants to woo its local audience. 
RSVP Movies also wants to hire a few Indian actors for its upcoming project to give a regional feel. 
Let’s find who these actors could be.*/

-- Q22. Rank actors with movies released in India based on their average ratings. Which actor is at the top of the list?
-- Note: The actor should have acted in at least five Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actor_name	|	total_votes		|	movie_count		  |	actor_avg_rating 	 |actor_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Yogi Babu	|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:
WITH ActorVotes AS (
    SELECT N.NAME AS ACTOR_NAME,
           SUM(R.TOTAL_VOTES) AS TOTAL_VOTES,
           COUNT(R.MOVIE_ID) AS MOVIE_COUNT,
           ROUND((SUM(r.avg_rating*r.total_votes)/SUM(r.total_votes)),2) AS ACTOR_AVG_RATING
    FROM 
          MOVIE M
    INNER JOIN 
         RATINGS R 
	ON M.ID = R.MOVIE_ID
    INNER JOIN 
         ROLE_MAPPING RM 
	ON R.MOVIE_ID = RM.MOVIE_ID
    INNER JOIN 
        NAMES N 
	ON N.ID = RM.NAME_ID
    WHERE M.COUNTRY='India'
    GROUP BY N.ID, N.NAME
    HAVING COUNT(R.MOVIE_ID) >= 5
)
SELECT ACTOR_NAME, 
       TOTAL_VOTES, 
       MOVIE_COUNT,
       ACTOR_AVG_RATING,
 --      AVG(r.avg_rating) OVER() AS ACTOR_AVG_RATING,
       RANK() OVER (ORDER BY ACTOR_AVG_RATING DESC,TOTAL_VOTES DESC ) AS ACTOR_RANK
FROM ActorVotes
 LIMIT 1
;
-- Top actor is Vijay Sethupathi

-- Q23.Find out the top five actresses in Hindi movies released in India based on their average ratings? 
-- Note: The actresses should have acted in at least three Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |	actress_avg_rating 	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Tabu		|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:
WITH ActressVotes AS (
    SELECT N.NAME AS ACTRESS_NAME,
           SUM(R.TOTAL_VOTES) AS TOTAL_VOTES,
           COUNT(R.MOVIE_ID) AS MOVIE_COUNT,
           ROUND((SUM(r.avg_rating*r.total_votes)/SUM(r.total_votes)),2) AS ACTRESS_AVG_RATING
    FROM MOVIE M
    INNER JOIN RATINGS R ON M.ID = R.MOVIE_ID
    INNER JOIN ROLE_MAPPING RM ON R.MOVIE_ID = RM.MOVIE_ID
    INNER JOIN NAMES N ON N.ID = RM.NAME_ID
    WHERE M.COUNTRY='India'AND M.LANGUAGES= 'Hindi' AND RM.CATEGORY='actress'
    GROUP BY N.ID, N.NAME
    HAVING COUNT(R.MOVIE_ID) >= 3
)
SELECT ACTRESS_NAME, 
       TOTAL_VOTES, 
       MOVIE_COUNT,
       ACTRESS_AVG_RATING,
       RANK() OVER (ORDER BY ACTRESS_AVG_RATING DESC,TOTAL_VOTES DESC ) AS ACTOR_RANK
FROM ActRESSVotes
LIMIT 5;
/* Taapsee Pannu tops with average rating 7.74. 
Now let us divide all the thriller movies in the following categories and find out their numbers.*/

/* Q24. Consider thriller movies having at least 25,000 votes. Classify them according to their average ratings in
   the following categories:  

			Rating > 8: Superhit
			Rating between 7 and 8: Hit
			Rating between 5 and 7: One-time-watch
			Rating < 5: Flop
	
    Note: Sort the output by average ratings (desc).
--------------------------------------------------------------------------------------------*/
/* Output format:
+---------------+-------------------+
| movie_name	|	movie_category	|
+---------------+-------------------+
|	Get Out		|			Hit		|
|		.		|			.		|
|		.		|			.		|
+---------------+-------------------+*/

-- Type your code below:
SELECT M.TITLE AS MOVIE_NAME,
CASE 
WHEN R.AVG_RATING>8 THEN 'Superhit'
WHEN R.AVG_RATING BETWEEN 7 AND 8 THEN 'Hit'
WHEN R.AVG_RATING BETWEEN 5 AND 7 THEN 'One-Time-Watch'
ELSE 'Flop'
END AS MOVIE_CATEGORY
FROM MOVIE M 
INNER JOIN GENRE G 
ON M.ID=G.MOVIE_ID
INNER JOIN RATINGS R 
ON G.MOVIE_ID=R.MOVIE_ID
WHERE G.GENRE='Thriller' AND R.TOTAL_VOTES>=25000
ORDER BY R.AVG_RATING DESC;

/* Until now, you have analysed various tables of the data set. 
Now, you will perform some tasks that will give you a broader understanding of the data in this segment.*/

-- Segment 4:

-- Q25. What is the genre-wise running total and moving average of the average movie duration? 
-- (Note: You need to show the output table in the question.) 
/* Output format:
+---------------+-------------------+---------------------+----------------------+
| genre			|	avg_duration	|running_total_duration|moving_avg_duration  |
+---------------+-------------------+---------------------+----------------------+
|	comdy		|			145		|	       106.2	  |	   128.42	    	 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:
WITH GenreDurations AS (
    SELECT G.GENRE,
           ROUND(AVG(M.DURATION),2) AS avg_duration
    FROM MOVIE M
    INNER JOIN GENRE G ON M.ID = G.MOVIE_ID
    GROUP BY G.GENRE
)
SELECT GENRE,
       avg_duration,
       ROUND(SUM(avg_duration) OVER (ORDER BY GENRE ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW),2) AS running_total_duration,
       ROUND(AVG(avg_duration) OVER (ORDER BY GENRE ROWS BETWEEN 4 PRECEDING AND CURRENT ROW),2) AS moving_avg_duration
FROM GenreDurations
ORDER BY GENRE;


-- Round is good to have and not a must have; Same thing applies to sorting


-- Let us find top 5 movies of each year with top 3 genres.

-- Q26. Which are the five highest-grossing movies of each year that belong to the top three genres? 
-- (Note: The top 3 genres would have the most number of movies.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| genre			|	year			|	movie_name		  |worldwide_gross_income|movie_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	comedy		|			2017	|	       indian	  |	   $103244842	     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

-- Top 3 Genres based on most number of movies
WITH TopGenres AS (
    SELECT G.GENRE,
           COUNT(M.ID) AS MOVIE_COUNT
    FROM GENRE G
    INNER JOIN MOVIE M ON G.MOVIE_ID = M.ID
    GROUP BY G.GENRE
    ORDER BY MOVIE_COUNT DESC
    LIMIT 3
),
MovieRanks AS (
    SELECT G.GENRE, 
           M.TITLE AS movie_name, 
           M.YEAR,
           M.WORLWIDE_GROSS_INCOME,
           RANK() OVER (PARTITION BY G.GENRE, M.YEAR ORDER BY CAST(SUBSTRING(M.WORLWIDE_GROSS_INCOME, 2) AS DECIMAL(15, 2)) DESC) AS movie_rank
    FROM MOVIE M
    INNER JOIN GENRE G ON M.ID = G.MOVIE_ID
    INNER JOIN TopGenres TG ON G.GENRE = TG.GENRE
)
SELECT GENRE, 
       YEAR,
       movie_name,
       WORLWIDE_GROSS_INCOME,
       movie_rank
FROM MovieRanks
WHERE movie_rank <= 5
ORDER BY GENRE, YEAR, movie_rank;


-- Finally, let’s find out the names of the top two production houses that have produced the highest number of hits among multilingual movies.
-- Q27.  Which are the top two production houses that have produced the highest number of hits (median rating >= 8) among multilingual movies?
/* Output format:
+-------------------+-------------------+---------------------+
|production_company |movie_count		|		prod_comp_rank|
+-------------------+-------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:
SELECT M.PRODUCTION_COMPANY,
       COUNT(ID) AS MOVIE_COUNT,
       RANK() OVER(ORDER BY COUNT(ID) DESC) AS PROD_COMP_RANK
FROM MOVIE M 
INNER JOIN RATINGS R 
ON M.ID = R.MOVIE_ID 
WHERE POSITION(',' IN M.languages)>0 AND R.MEDIAN_RATING>=8 AND M.PRODUCTION_COMPANY IS NOT NULL
GROUP BY M.PRODUCTION_COMPANY
LIMIT 2;



-- Multilingual is the important piece in the above question. It was created using POSITION(',' IN languages)>0 logic
-- If there is a comma, that means the movie is of more than one language


-- Q28. Who are the top 3 actresses based on the number of Super Hit movies (Superhit movie: average rating of movie > 8) in 'drama' genre?

-- Note: Consider only superhit movies to calculate the actress average ratings.
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes
-- should act as the tie breaker. If number of votes are same, sort alphabetically by actress name.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |	  actress_avg_rating |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Laura Dern	|			1016	|	       1		  |	   9.6000		     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/

-- Type your code below:

WITH ActressVotes AS (
    SELECT N.NAME AS ACTRESS_NAME,
           SUM(R.TOTAL_VOTES) AS TOTAL_VOTES,
           COUNT(R.MOVIE_ID) AS MOVIE_COUNT,
           ROUND((SUM(r.avg_rating*r.total_votes)/SUM(r.total_votes)),2) AS ACTRESS_AVG_RATING
    FROM NAMES N
    INNER JOIN ROLE_MAPPING RM ON N.ID = RM.NAME_ID
    INNER JOIN RATINGS R ON RM.MOVIE_ID = R.MOVIE_ID
    INNER JOIN GENRE G ON G.MOVIE_ID=R.MOVIE_ID
    WHERE RM.CATEGORY = 'Actress' and G.GENRE='Drama' AND R.AVG_RATING >8
    GROUP BY N.ID, N.NAME
)
SELECT ACTRESS_NAME, 
       TOTAL_VOTES, 
       MOVIE_COUNT,
       ACTRESS_AVG_RATING,
       RANK() OVER (ORDER BY ACTRESS_AVG_RATING DESC,TOTAL_VOTES DESC ) AS ACTRESS_RANK
FROM ActressVotes
LIMIT 3;






/* Q29. Get the following details for top 9 directors (based on number of movies)
Director id
Name
Number of movies
Average inter movie duration in days
Average movie ratings
Total votes
Min rating
Max rating
total movie durations

Format:
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
| director_id	|	director_name	|	number_of_movies  |	avg_inter_movie_days |	avg_rating	| total_votes  | min_rating	| max_rating | total_duration |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
|nm1777967		|	A.L. Vijay		|			5		  |	       177			 |	   5.65	    |	1754	   |	3.7		|	6.9		 |		613		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+

--------------------------------------------------------------------------------------------*/
-- Type you code below:
WITH DirectorMovies AS (
    SELECT 
        N.ID AS director_id,
        N.NAME AS director_name,
        M.ID AS movie_id,
        M.DATE_PUBLISHED,
        DATEDIFF(M.DATE_PUBLISHED, LAG(M.DATE_PUBLISHED) OVER (PARTITION BY N.ID ORDER BY M.DATE_PUBLISHED)) AS inter_movie_days
    FROM 
        NAMES N
        INNER JOIN DIRECTOR_MAPPING DM ON N.ID = DM.NAME_ID
        INNER JOIN MOVIE M ON DM.MOVIE_ID = M.ID
),
DirectorStats AS (
    SELECT 
        DM.director_id,
        DM.director_name,
        COUNT(DM.movie_id) AS number_of_movies,
        AVG(DM.inter_movie_days) AS avg_inter_movie_days,
        AVG(R.AVG_RATING) AS avg_rating,
        SUM(R.TOTAL_VOTES) AS total_votes,
        MIN(R.AVG_RATING) AS min_rating,
        MAX(R.AVG_RATING) AS max_rating,
        SUM(M.DURATION) AS total_duration
    FROM 
        DirectorMovies DM
        INNER JOIN RATINGS R ON DM.movie_id = R.MOVIE_ID
        INNER JOIN MOVIE M ON DM.movie_id = M.ID
    GROUP BY 
        DM.director_id, DM.director_name
)
SELECT 
    director_id,
    director_name,
    number_of_movies,
    ROUND(avg_inter_movie_days, 2) AS avg_inter_movie_days,
    ROUND(avg_rating, 2) AS avg_rating,
    total_votes,
    ROUND(min_rating, 2) AS min_rating,
    ROUND(max_rating, 2) AS max_rating,
    total_duration
FROM 
    DirectorStats
ORDER BY 
    number_of_movies DESC
LIMIT 9;
