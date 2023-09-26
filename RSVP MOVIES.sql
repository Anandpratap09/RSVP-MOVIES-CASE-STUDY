USE imdb;
SHOW TABLES;

/* Now that you have imported the data sets, let’s explore some of the tables. 
 To begin with, it is beneficial to know the shape of the tables and whether any column has null values.
 Further in this segment, you will take a look at 'movies' and 'genre' tables.*/



-- Segment 1:




-- Q1. Find the total number of rows in each table of the schema?
-- Type your code below:
SELECT 
     Count(*) AS total_no_of_rows
FROM   
     director_mapping;  
--
SELECT 
    Count(*) AS total_no_of_rows
FROM  
    genre;  
--
SELECT 
    Count(*) AS total_no_of_rows
FROM  
    movie; 
--
SELECT 
    Count(*) AS total_no_of_rows
FROM  
    names; 
--
SELECT 
    Count(*) AS total_no_of_rows
FROM  
    ratings; 
--
SELECT 
    Count(*) AS total_no_of_rows
FROM  
    role_mapping; 
-- CONCLUSION:-
-- DIRECTOR MAPPING TOTAL_NUMBER_OF_ROWS :- 3867
-- GENRE TOTAL_NUMBER_OF_ROWS :- 14662
-- MOVIE TOTAL_NUMBER_OF_ROWS :- 7997
-- NAMES TOTAL_NUMBER_OF_ROWS :-  25735
-- RATINGS TOTAL_NUMBER_OF_ROWS :-  7997
-- ROLE_MAPPING TOTAL_NUMBER_OF_ROWS :-  15615
-- -------------------------------------------------------------------------------------------------------------------------------------------------
-- ---------------------------------------------------------------------------------------------------------------------------------------
-- Q2. Which columns in the movie table have null values?
-- Type your code below:
SELECT 
    id
FROM   
    movie
WHERE  id IS NULL; 

SELECT 
    title
FROM   
    movie
WHERE  title IS NULL; 

SELECT 
    year
FROM   
    movie
WHERE  year IS NULL;  

SELECT 
    date_published
FROM   
    movie
WHERE  date_published IS NULL;

SELECT 
    duration
FROM   
    movie
WHERE  duration IS NULL;

SELECT 
    country
FROM   
    movie
WHERE  country IS NULL;

SELECT 
    worlwide_gross_income
FROM   
    movie
WHERE  worlwide_gross_income IS NULL;

SELECT 
    languages
FROM   
    movie
WHERE  languages IS NULL;
SELECT * from movie ; 
SELECT 
    production_company
FROM   
    movie
WHERE  production_company IS NULL;

-- CONCLUSION
-- COLUMN HAVING NULL VALUES:
           -- COUNTRY
           -- WORLWIDE_GROSS_INCOME
           -- LANGUAGES
           -- PRODUCTION_COMPANY
/*
    THESE COLUMNS HAVE NULL VALUES LIKE COUNTRY, WORLWIDE_GROSS_INCOME, LANGUAGES, PRODUCTION_COMPANY
    WHERE AS ID, TITLE, YEAR, DATE_PUBLISHED, DURATION HAVE NON NULL VALUES
*/

-- Now as you can see four columns of the movie table has null values. Let's look at the at the movies released each year. 
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
SELECT DISTINCT year,
                Count(id) AS no_of_movies
FROM   movie
GROUP  BY year;
/*Output:-
+---------------+-------------------+
| Year			|	number_of_movies|
+-------------------+----------------
|	2017		|	3052			|
|	2018		|	2944	.		|
|	2019		|	2001	.		|
+---------------+-------------------+
-- CONCLUSION  
    -- MOST NUMBER OF MOVIES ARE RELEASED IN YEAR 2017 AROUND 3052
    --  LEAST NUMBER OF MOVIES ARE RELEASED IN YEAR 2019 AROUND 2001
*/
SELECT Month(date_published) month_num,
       Count(id)             number_of_movies
FROM   movie
GROUP  BY month_num
ORDER  BY month_num; 
/*Output:- 
+---------------+-------------------+
|	month_num	|	number_of_movies|
+---------------+----------------
|	1			|	 804			|
|	2			|	 640			|
|	3			|	 824	.		|
|   4           |    680            |
|	5			|	 625	.		|
|   6           |    580            |
|	7			|	 493	.		|
|   8           |    678            |
|	9			|	 809	.		|
|   10          |    801            |
|   11          |    625            |
|   12          |    438            |
+---------------+-------------------+ 
-- CONCLUSION  
-- MARCH HAS THE HIGHEST NUMBER OF MOVIES  FOLLOWED BY SEPTEMBER AND  JANNUARY 
*/

/*The highest number of movies is produced in the month of March.
So, now that you have understood the month-wise trend of movies, let’s take a look at the other details in the movies table. 
We know USA and India produces huge number of movies each year. Lets find the number of movies produced by USA or India for the last year.*/
  
-- Q4. How many movies were produced in the USA or India in the year 2019??
-- Type your code below:
SELECT Count(DISTINCT id) no_of_movies,
       year
FROM   movie
WHERE  year = 2019
   AND ( country LIKE "%usa%"
          OR country LIKE "%india%" ); 
-- CONCLUSION 
-- SINCE, AS PER THE QUESTION IT SAYS USA OR INDIA AND IN DATASET WITH USA OTHER COUNTRY ALSO THEREFORE WE HAVE TO TAKE LIKE CONDITION, 
-- 1059 MOVIES IS THE EXACT NUMBER WERE PRODUCED IN THE USA OR INDIA IN THE YEAR 2019 

/* USA and India produced more than a thousand movies(you know the exact number!) in the year 2019.
Exploring table Genre would be fun!! 
Let’s find out the different genres in the dataset.*/

-- Q5. Find the unique list of the genres present in the data set?
-- Type your code below:
SELECT DISTINCT( genre )
FROM   genre; -- FOR UNIQUE VALUES WE NEED TO USED DISTINCT FUNCTION 
show tables;
-- CONCLUSION 
       -- MOVIES BELONG TO 13 GENRES ARE MENTIONED IN THE DATASET.

/* So, RSVP Movies plans to make a movie of one of these genres.
Now, wouldn’t you want to know which genre had the highest number of movies produced in the last year?
Combining both the movie and genres table can give more interesting insights. */

-- Q6.Which genre had the highest number of movies produced overall?
-- Type your code below:
SELECT genre,
       COUNT(id) no_of_movies
FROM   movie m
       JOIN genre g
         ON m.id = g.movie_id
GROUP  BY genre
ORDER  BY no_of_movies DESC
LIMIT  1; 
-- CONCLUSION 
	-- DRAMA HAS THE HIGHEST NUMBER OF MOVIES FOLLOWED BY COMEDY AND TRILLER 
    
/* So, based on the insight that you just drew, RSVP Movies should focus on the ‘Drama’ genre. 
But wait, it is too early to decide. A movie can belong to two or more genres. 
So, let’s find out the count of movies that belong to only one genre.*/

-- Q7. How many movies belong to only one genre?
-- Type your code below:
WITH movie_genre_count AS ( 
                             SELECT movie_id
                             FROM   genre
                             GROUP  BY movie_id
                             HAVING Count(DISTINCT genre) = 1
)
SELECT Count(*)
FROM   movie_genre_count; 
-- CONCLUSION 
	-- 3289 IS THE EXACT NUMBER OF MOVIES HAS ONLY ONE GENRE

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

SELECT genre,
       Round(Avg(duration), 2) avg_duration
FROM   movie m
       JOIN genre g
         ON m.id = g.movie_id
GROUP  BY genre
ORDER  BY avg_duration DESC; 
/* Output:-
+---------------+-------------------+
| genre			|	avg_duration	|
+-------------------+----------------
|	Action   	|		112.88		|
|	Romance		|		109.53		|
|	Crime		|		107.05		|
|	Drama		|		106.77		|
|	Fantasy		|		105.14		|
|	Comedy		|		102.62		|
|	Adventure	|		101.87		|
|	Mystery		|		101.80		|
|	Thriller	|		101.58		|
|	Family		|		100.97  	|
|	Others		|		100.16  	|
|	Sci-Fi		|		97.94   	|
|	Horror		|		92.72   	|
+---------------+-------------------+ 
* CONCLUSION:-
ACTION HAS THE  AVERAGE_DURATION OF 112.88 MINS FOLLOWED.*
*/

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
WITH genre_rank
     AS (SELECT genre,
                Count(movie_id)  movie_count,
                RANK() OVER( ORDER BY Count(movie_id) DESC) genre_rank
         FROM   genre
         GROUP  BY genre)
SELECT *
FROM   genre_rank
WHERE  genre = "thriller"; 
/* Output:-
+---------------+-------------------+---------------------+
| genre			|		movie_count	|		genre_rank    |	
+---------------+-------------------+---------------------+
|Thriller		|	1484			|			3		  |
+---------------+-------------------+---------------------+*/
/*
CONCLUSION:- 
 Thriller has the movie count of 1484 with 3  rank .*/
 
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

SELECT Min(avg_rating)    min_avg_rating,
       Max(avg_rating),
       Min(total_votes)   min_total_votes,
       Max(total_votes)   max_total_votes,
       Min(median_rating) min_median_rating,
       Max(median_rating) min_median_rating
FROM   ratings; 
/* Output :-
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
| min_avg_rating|	max_avg_rating	|	min_total_votes   |	max_total_votes 	 |min_median_rating|min_median_rating|
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
|		1.0		|			10.0	|	       100		  |	   725138	    	 |		1	       |	10			 |
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+*/

-- CONCLUSION 
-- MINIMUM VALUE FOR AVERAGE RATING IS 1 AND MAXIMUM IS 10
-- FOR TOTAL VOTES MINIMUM VALUE IS 100 AND MAXIMUM IS 725138
-- MINIMUM VALUE FOR MEDIAN RATING IS 1 AND MAXIMUM IS 10					

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
-- It's ok if RANK() or DENSE_RANK() is used too

WITH avg_movie_rank AS (
                SELECT title,
                avg_rating,
                DENSE_RANK() OVER ( ORDER BY avg_rating DESC) movie_rank
                FROM   movie m
                JOIN ratings r
                ON m.id = r.movie_id
)
SELECT *
FROM   avg_movie_rank
WHERE  movie_rank <= 10; 
/* Output:-
+---------------+-------------------+-------------------------+
| title			     |		avg_rating	|		movie_rank    |
+---------------+-------------------+-------------------------+
| Kirket		     |		10.0		|			1	  	  |
|Love in Kilnerry	 |		10.0        |			1	  	  |			  
|Gini Helida Kathe	 |		9.8			|			2		  |
|Runam			     |		9.7			|			3		  |
|Fan			     |		9.6			|			4		  |
|Android 5.25	     |		9.6			|			4		  |
|Yeh Suhaagraat	     |		9.5			|			5		  |
|Safe			     |		9.5			|			5		  |
|The Brighton	     |		9.5			|			5		  |
|Miracle     	     |		9.5			|			5		  |
|Shibu      	     |		9.4			|			6		  |
|Our Little 	     |		9.4			|			6		  |
|Haven      	     |		9.4			|			6		  |
|Zana       	     |		9.4			|			6		  |
|Family       	     |		9.4			|			6		  |
|Ananthu       	     |		9.4			|			6		  |
|Eghantham     	     |		9.3			|			7		  |
|Wheels       	     |		9.3			|			7		  |
|Turnover      	     |		9.2			|			8		  |
|Digbhayam     	     |		9.2			|			8		  |
|Tõde         	     |		9.2			|			8		  |
|Ekvtime     	     |		9.2			|			8		  |
|Leera       	     |		9.2			|			8		  |
|AA BB      	     |		9.2			|			8		  |
|Peranbu     	     |		9.2			|			8		  |
|Dokyala     	     |		9.2			|			8		  |
|Ardaas     	     |		9.2			|			8		  |
|Kuasha     	     |		9.1			|			9		  |
|Oththa 7     	     |		9.1			|			9		  |
|Seruppu 7     	     |		9.1			|			9		  |
|Adutha     	     |		9.1			|			9		  |
|The Colour    	     |		9.1			|			9		  |
|Aloko      	     |		9.1			|			9		  |
|C/o Kancha    	     |		9.1			|			9		  |
|Nagarkirtan   	     |		9.1			|			9		  |
|Jelita      	     |		9.1			|			9		  |
|Shindisi   	     |		9.0			|			10		  |
|Officer    	     |		9.0			|			10		  |
|Oskars     	     |		9.0			|			10		  |
|Delaware   	     |		9.0			|			10		  |
|Abstruse   	     |		9.0			|			10		  |
|National   	     |		9.0			|			10		  |
|Innocent   	     |		9.0			|			10		  |
+---------------+-------------------+--------------------------+*/
 
/* CONCLUSION:- 
	KIRKET AND LOVE IN KILNERRY HAVE THE HIGHEST RATING OF 10 ARE AT 1ST RANK FOLLWED BY GINI HELIDA KATHE AND RUNAM WITH SECOND AND THRIRD RANK*
    AND YES WE FOUND THE MOVIE FAN WITH TOP AVG_RATING 9.6*/

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

SELECT median_rating,
       Count(movie_id) movie_count
FROM   ratings
GROUP  BY median_rating
ORDER  BY movie_count DESC; 
/* Output :

+---------------+-------------------+
| median_rating	|	movie_count		|
+-------------------+----------------
|	7			|		2257		|
|	6			|		1975		|
|	8			|		1030		|
|	5			|		985		    |
|	4			|		479  		|
|	9			|		429  		|
|	10			|		346 		|
|	3			|		283 		|
|	2			|		119 		|
|	1			|		94  		|
+---------------+-------------------+ */
-- CONCLUSION  
        -- MOVIE OF MEDIAN RATING 7 IS THE HIGHEST WITH MOVIE COUNT OF 2257.
	
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
WITH most_number_of_hit_movies AS ( 
                                    SELECT m.production_company,
                                    Count(m.id)   movie_count,
                                    RANK() OVER ( ORDER BY Count(m.id) DESC) AS prod_company_rank
                                    FROM   movie m
                                    JOIN ratings r
                                    ON m.id = r.movie_id
                                    WHERE  r.avg_rating > 8 AND production_company IS NOT NULL
                                    GROUP  BY m.production_company)
                SELECT *
                FROM   most_number_of_hit_movies
                WHERE  prod_company_rank = 1; 
/* Output format:
+---------------------------+-------------------+------------------------+
|production_company         |movie_count	       |	prod_company_rank|
+---------------------------+-------------------+------------------------+
| Dream Warrior Pictures    |		3		       |			1	  	 |
+---------------------------+-------------------+------------------------+
| National Theatre Live     |		3		       |			1	  	 |
+---------------------------+-------------------+------------------------+*/

/* CONCLUSION
 'DREAM WARRIOR PICTURES' AND NATIONAL THEATRE AS PRODUCED THE MOST NUMBER OF HIT MOVIES WITH AVERAGE RATING GREATER THAN 8 .*/

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
SELECT genre,
       Count(id) movie_count
FROM   genre g
       JOIN movie m
         ON g.movie_id = m.id
       JOIN ratings r
         ON m.id = r.movie_id
WHERE  year = 2017
   AND Month(date_published) = 3
   AND country LIKE "%usa%"
   AND total_votes > 1000
GROUP  BY genre
ORDER  BY movie_count DESC; 
/* Output :

+---------------+-------------------+
| genre			|	movie_count		|
+-------------------+----------------
|	Drama    	|		24			|
|	Comedy  	|		9			|
|	Action		|		8			|
|	Thriller	|		8			|
|	Sci-Fi		|		7			|
|	Crime		|		6			|
|	Horror		|		6			|
|	Mystery		|		4			|
|	Romance		|		4			|
|	Fantasy		|		3			|
|	Adventure	|		3			|
|	Family	    |		1			|
+---------------+-------------------+ */
/* CONSLUSION  
-- WE ARE USING COUNTRY LIKE '%USA%' BECAUSE AS THE QUESTION  SAYS "IN", IF IT HAD SAID ONLY IN USA THE CONDITION WOULD HAVE CHANGED.
SO WE PER THE QUESTION DRAMA HAS THE HIGHEST MOVIE_COUNT IN 2017 AND IN THE MONTH OF MARCH AND WITH MORE THAN 1000 VOTES 

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
SELECT title,
       avg_rating,
       genre
FROM   movie m
       JOIN genre g
         ON m.id = g.movie_id
       JOIN ratings r
         ON g.movie_id = r.movie_id
WHERE  title LIKE "the%"
   AND avg_rating > 8
ORDER  BY avg_rating DESC; 
/* Output :
+-----------------------------------------------+-------------------+---------------------+
| title			                                |		avg_rating	|		genre	      |
+-----------------------------------------------+-------------------+---------------------+
| The Brighton Miracle                          |		9.5  		|		Drama    	  |
| The Colour of Darkness			            |		9.1			|		Drama		  |
| The Blue Elephant 2                           |		8.8			|		Drama		  |
| The Blue Elephant 2                           |		8.8			|		Horror		  |
| The Blue Elephant 2                           |		8.8			|		Mystery		  |
| The Irishman			                        |		8.7			|		Crime		  |
| The Irishman			                        |		8.7			|		Drama		  |
| The Mystery of Godliness: The Sequel          |		8.5			|		Drama		  |
| The Gambinos                                  |		8.4			|		Crime		  |
| The Gambinos                                  |		8.4			|		Drama		  |
| Theeran Adhigaaram Ondru                      |		8.3			|		Action		  |
| Theeran Adhigaaram Ondru                      |		8.3			|		Crime		  |
| Theeran Adhigaaram Ondru                      |		8.3			|		Thriller	  |
| The King and I                                |		8.2			|		Drama		  |
| The King and I                                |		8.2			|		Romance		  |
+-----------------------------------------------+-------------------+---------------------+*/
/*-- CONCLUSION 
	DRAMA GENRE HAS THE HIGHEST AVG_RATING OF 9.5 WHICH STARTS WITH THE LETTER  "THE"*/

-- You should also try your hand at median rating and check whether the ‘median rating’ column gives any significant insights.
-- Q16. Of the movies released between 1 April 2018 and 1 April 2019, how many were given a median rating of 8?
-- Type your code below:

SELECT median_rating,
       Count(*) movies_list
FROM   movie m
       JOIN ratings r
         ON m.id = r.movie_id
WHERE  date_published BETWEEN '2018-04-01' AND '2019-04-01'
   AND median_rating = 8; 
/* Output:- 
+---------------+-------------------+
| median_rating	|		movies_list	|	
+---------------+-------------------+
| 8		        |		361			|		
+---------------+-------------------+/*
/* CONCLUSION 
	MOVIES WITH RATING 8 FROM APRIL 2018 TO APRIL 2019 ARE 361. */
    
-- Once again, try to solve the problem given below.
-- Q17. Do German movies get more votes than Italian movies? 
-- Hint: Here you have to find the total number of votes for both German and Italian movies.
-- Type your code below:
SELECT country,
       Sum(total_votes) votes
FROM   movie m
       JOIN ratings r
         ON m.id = r.movie_id
WHERE  country LIKE 'germany'
    OR country LIKE 'italy'
GROUP  BY country; 
/* Output:- 
+---------------+-------------------+
| median_rating	|		movies_list	|	
+---------------+-------------------+
| Germany       |		106710	    |
+---------------+-------------------+
| Italy         |		77965	    |		
+---------------+-------------------+/*
/*CONCLUSION
--  --SINCE WE HAVE CHECKED USING BOTH COUNTRY  IN THIS  CASES WE CAN  CONCLUDE THAT GERMANY HAS MORE VOTES THAN ITALY.*/
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
SELECT Sum(CASE
             WHEN NAME IS NULL THEN 1
             ELSE 0
           END) AS name_nulls,
       Sum(CASE
             WHEN height IS NULL THEN 1
             ELSE 0
           END) AS height_nulls,
       Sum(CASE
             WHEN date_of_birth IS NULL THEN 1
             ELSE 0
           END) AS date_of_birth_nulls,
       Sum(CASE
             WHEN known_for_movies IS NULL THEN 1
             ELSE 0
           END) AS known_for_movies_nulls
FROM   names; 
/*Output:-
+---------------+-------------------+---------------------+----------------------+
| name_nulls	|	height_nulls	|date_of_birth_nulls  |known_for_movies_nulls|
+---------------+-------------------+---------------------+----------------------+
|		0		|	   17335	    |	      13431		  |	   15226	    	 |
+---------------+-------------------+---------------------+----------------------+*/

/* CONCLUSION 
	- TOTAL NUMBER OF NULLS IN NAME COLUMN IS 0
    - TOTAL NUMBER OF NULLS IN HEIGHT COLUMN IS 17335 
    - TOTAL NUMBER OF NULLS IN DATE_OF_BIRTH COLUMN IS 13431
    - TOTAL NUMBER OF NULLS IN KNOWN_FOR_MOVIES COLUMN IS 15226
*/			

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

WITH genre_movie_count AS (
                           SELECT     genre,
                                      Count(movie_id) AS movie_count
                           FROM       genre           AS g
                           INNER JOIN ratings         AS r
                           using      (movie_id)
                           WHERE      avg_rating > 8
                           GROUP BY   genre
                           ORDER BY   Count(movie_id) DESC limit 3 ), directors_name_rank AS
(
                           SELECT     n.NAME,
                                      Count(dm.movie_id)                            AS movie_count,
                                      Rank() OVER(ORDER BY Count(dm.movie_id) DESC)    dict_rank
                           FROM       names n
                           INNER JOIN director_mapping dm
                           ON         n.id = dm.name_id
                           INNER JOIN ratings r
                           ON         r.movie_id = dm.movie_id
                           INNER JOIN genre g
                           ON         g.movie_id = dm.movie_id
                           WHERE      r.avg_rating > 8
                           AND        genre IN
(
                             SELECT genre
                             FROM   genre_movie_count)
                            GROUP BY   NAME
                            ORDER BY   movie_count DESC
)
SELECT NAME AS director_name,
       movie_count
FROM   directors_name_rank
WHERE  dict_rank <= 3;
/* Output :-

+---------------+-------------------+
| director_name	|	movie_count		|
+---------------+-------------------|
|James Mangold	|		4			|
|Anthony Russo	|		3			|
|Joe Russo		|		3			|
|Soubin Shahir	|		3			|
+---------------+-------------------+ */
-- CONCLUSION 
-- 	- JAMES MANGOLD HAS THE MOST NUMBER OF MOVIE COUNT WITH AVERAGE MOVIE RATING OF ABOVE 8 
--  - FOLLOWED BY ANTHONY RUSSO 3 AND JOE RUSSO 3  

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


 WITH top_two_actors as 
( 
SELECT 
	n.name as actor_name ,
    COUNT(r.movie_id) as movie_count,
    RANK() over(order by count(r.movie_id)desc) as movie_rank
FROM 
	names as n 
    INNER JOIN 
    ROLE_mapping as rm
	on n.id= rm.name_id
    INNER JOIN 
    ratings as r 
    on r.movie_id=rm.movie_id
WHERE 
	category = 'actor' 
    AND
	r.median_rating >= 8
GROUP BY 
	actor_name
)
	SELECT 
		actor_name,
        movie_count
	FROM 
		top_two_actors
	WHERE 
    movie_rank<=2;
    /* Output :-

+---------------+-------------------+
| actor_name	|	movie_count		|
+-------------------+----------------
|Mammootty  	|		8			|
|Mohanlal		|		5			|
+---------------+-------------------+ */
/* CONCLUSION 
	- MAMMOOTTY IS AMONG THE TOP ACTOR WITH MOVIE COUNT OF 8 AND MEDIAN RATING >= 8
    - FOLLOWED BY MOHANLAL WITH MOVIE_COUNT 5
*/

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
WITH top_three_production_house
     AS (SELECT production_company,
                Sum(total_votes)                    vote_count,
                Dense_rank()
                  OVER(
                    ORDER BY Sum(total_votes) DESC) prod_comp_rank
         FROM   movie m
                JOIN ratings r
                  ON m.id = r.movie_id
         GROUP  BY production_company)
SELECT *
FROM   top_three_production_house
WHERE  prod_comp_rank < 4; 
/* Output :-
+-----------------------+--------------------+--------------------+
|production_company     |vote_count			|		prod_comp_rank|
+-----------------------+--------------------+--------------------+
| Marvel Studios	    |	2656967		    |		1	  		  |
| Twentieth Century Fox	|	2411163 		|		2			  |
| Warner Bros.		    |	2396057			|		3			  |
+-----------------------+-------------------+---------------------+*/
/* CONCLUSION
	- MARVEL STUDIOS AMONG THE TOP PRODUCTION COMPANY WITH TOTAL VOTE COUNT OF 2656967 
	- FOLLOWED BY TWENTIETH CENTURY FOX 2411163 AND WARNER BROS. 2396057
    - SINCE NULL VALUES WERE FOUND SO REMOVED IT.
*/

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
-- ANSWER
-- WE ARE LOOKING FOR ACTOR IN INDIA WITH CONDITION OF ACTED IN 5 FLIMS 

SELECT NAME
       AS
       actor_name,
       Sum(total_votes)
       AS total_votes,
       Count(DISTINCT movie_id)
       AS movie_count,
       Round(Sum(avg_rating * total_votes) / Sum(total_votes), 2)
       AS actor_avg_rating,
       Dense_rank()
         OVER (
           ORDER BY Round(Sum(avg_rating*total_votes)/Sum(total_votes), 2) DESC)
       AS
       actor_rank
FROM   names n
       JOIN role_mapping rm
         ON n.id = rm.name_id
       JOIN ratings r using(movie_id)
       JOIN movie m
         ON m.id = r.movie_id
WHERE  rm.category = "actor"
       AND m.country = "india"
GROUP  BY actor_name
HAVING movie_count >= 5
ORDER  BY actor_rank; 

/* Output format:
+----------------------+-----------+--------------+---------------------+------------+
| actor_name	       |total_votes|movie_count	  |	actor_avg_rating   |actor_rank   |
+----------------------+-----------+---------------+---------------------+-----------+
| Vijay Sethupathi	   |    23114  |     5        |	      8.42         |	1        |
| Fahadh Faasil        |    13557  |     5        |	      7.99         |    2        |
| Yogi Babu	           |    8500   |     11       |	      7.83         |	3        |
| Joju George          |	3926   |     5        |       7.58         |    4        |
| Ammy Virk	           |    2504   |	 6	      |       7.55         |	5        |
| Dileesh Pothan	   |    6235   |     5	      |       7.52         |	6        |
| Kunchacko Boban	   |    5628   |     6	      |       7.48	       |    7        |
| Pankaj Tripathi	   |    40728  |	 5	      |       7.44	       |    8        |
| Rajkummar Rao	       |    42560  |     6     	  |       7.37         |	9        |
| Dulquer Salmaan	   |    17666  |     5	      |       7.30	       |    10       |
| Amit Sadh        	   |    13355  |     5     	  |       7.21	       |    11       |
| Tovino Thomas        |	11596  |	 8        |	      7.15         |	12       |
| Mammootty	           |    12613  |	 8	      |       7.04	       |    13       |
| Nassar	           |     4016  |	 5        |	      7.03         |	14       |
| Karamjit Anmol	   |     1970  |     6	      |       6.91	       |    15       |
| Hareesh Kanaran	   |     3196  |     5	      |       6.58	       |    16       |
| Anandraj	           |     2750  |     6	      |       6.54         |	17       |  
| Naseeruddin Shah	   |    12604  |     5        |	      6.54         |	17       |
| Mohanlal	           |    17244  |     6	      |       6.51	       |    18       |
| Aju Varghese	       |     2237  |     5	      |       6.43         |	19       |
| Siddique	           |     5953  |     7	      |       6.43     	   |    19       |
| Prakash Raj	       |     8548  |     6	      |       6.37         |	20       |
| Jimmy Sheirgill	   |     3826  |	 6	      |       6.29         |	21       |
| Biju Menon	       |     1916  |	 5	      |       6.21         |	22       |
| Mahesh Achanta	   |     2716  |	 6        |	      6.21         |	22       |
| Suraj Venjaramoodu   |     4284  |	 6	      |       6.19	       |    23       |
| Abir Chatterjee	   |     1413  |     5	      |       5.80         |	24       |
| Sunny Deol	       |     4594  |     5	      |       5.71	       |    25       |
| Radha Ravi	       |     1483  |	 5	      |       5.70         |	26       |
| Prabhu Deva	       |     2044  |	 5	      |       5.68	       |    27       |
+----------------------+-----------+--------------+--------------------+-------------+*/
/* CONCLUSION
	- Vijay Sethupathi is among top actor in India with actor average rating of 8.42 and total votes of 23115
    - Naseeruddin shah and Anandraj have same average rating of 6.54 but Naseeruddin shah is above him because total votes are more than anandraj.
    - Same goes for Siddique , Aju Varghese,Biju Menon,Mahesh Achanta,
*/
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
-- ANSWER 
-- WE ARE LOOKING FOR ACTRESS IN INDIA WITH LANGUAGE HINDI AND >= 3 FILMS 
-- Then Rank them from top 5 

WITH top_5_actress_summary
     AS (SELECT NAME
                AS
                   actress_name,
                Sum(total_votes)
                   AS total_votes,
                Count(DISTINCT movie_id)
                   AS movie_count,
                Round(Sum(avg_rating * total_votes) / Sum(total_votes), 2)
                   AS actress_avg_rating,
                Dense_rank()
                  OVER (
                    ORDER BY Round(Sum(avg_rating*total_votes)/Sum(total_votes),
                  2)
                  DESC
                  ) AS
                actress_rank
         FROM   names n
                JOIN role_mapping rm
                  ON n.id = rm.name_id
                JOIN ratings r using(movie_id)
                JOIN movie m
                  ON m.id = r.movie_id
         WHERE  rm.category = "actress"
                AND m.country LIKE "%india%"
                AND m.languages = "hindi"
         GROUP  BY actress_name
         HAVING movie_count >= 3
         ORDER  BY actress_rank)
SELECT *
FROM   top_5_actress_summary
WHERE  actress_rank <= 5; 
/* Output format:
+-------------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	    |	total_votes		|	movie_count		  |	actress_avg_rating 	 |actress_rank	   |
+-------------------+-------------------+---------------------+----------------------+-----------------+
| Taapsee Pannu		|		18061   	|	       3		  |	      7.74    		 |		1	       |
| Divya Dutta		|		 8579		|	       3		  |	      6.88    		 |		2	       |
| Kriti Kharbanda	|		 2549		|	       3		  |	   	  4.80    		 |		3	       |
| Sonakshi Sinha	|		 4025		|	       4		  |	      4.18	   		 |		4	       |
+-------------------+-------------------+---------------------+----------------------+-----------------+*/
/* CONCLUSION 
	- TAPSEE PANNU IS AMONG TOP ACTRESS IN INDIA  WITH HINDI LANGUAGE AND ACTRESS AVERAGE RATING OF 7.74 AND TOTAL VOTES OF 18061
*/

/* Taapsee Pannu tops with average rating 7.74. 
Now let us divide all the thriller movies in the following categories and find out their numbers.*/


/* Q24. Select thriller movies as per avg rating and classify them in the following category: 

			Rating > 8: Superhit movies
			Rating between 7 and 8: Hit movies
			Rating between 5 and 7: One-time-watch movies
			Rating < 5: Flop movies
--------------------------------------------------------------------------------------------*/
-- Type your code below:
-- Using CASE statements to classify thriller movies as per avg rating 

SELECT title,
       avg_rating,
       CASE
         WHEN avg_rating > 8 THEN "superhit movies"
         WHEN avg_rating BETWEEN 7 AND 8 THEN "hit movies"
         WHEN avg_rating BETWEEN 5 AND 7 THEN "one-time-watch movies"
         WHEN avg_rating < 5 THEN "flop movies"
       END AS movie_category
FROM   movie m
       JOIN genre g
         ON m.id = g.movie_id
       JOIN ratings r
         ON m.id = r.movie_id
WHERE  genre = 'Thriller'; 

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

SELECT genre,
       Round(Avg(duration), 2)                      AS avg_duration,
       SUM(Round(Avg(duration), 2))
         over (
           ORDER BY genre ROWS unbounded preceding) AS running_total_duration,
       Avg(Round(Avg(duration), 2))
         over (
           ORDER BY genre ROWS unbounded preceding) AS moving_avg_duration
FROM   genre g
       join movie m
         ON g.movie_id = m.id
GROUP  BY genre
ORDER  BY genre;

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
WITH top_3_genre_count AS
(
         SELECT   genre,
                  Count(id) AS movie_count
         FROM     movie m
         JOIN     genre g
         ON       m.id = g.movie_id
         GROUP BY genre
         ORDER BY movie_count DESC limit 3 ), top_5_gross_movies AS
(
         SELECT   genre,
                  year,
                  title                                                                       AS movie_name,
                  worlwide_gross_income                                                       AS worldwide_gross_income,
                  Row_number () OVER (partition BY year ORDER BY worlwide_gross_income DESC ) AS movie_rank
         FROM     movie m
         JOIN     genre g
         ON       m.id = g.movie_id
         WHERE    genre IN
                  (
                         SELECT genre
                         FROM   top_3_genre_count ))
SELECT *
FROM   top_5_gross_movies
WHERE  movie_rank <=5;
/* Output format:
+---------------+-------------------+------------------------------+-------------------------+-----------------+
| genre			|	year			|	      movie_name	       |worldwide_gross_income   |movie_rank	   |
+---------------+-------------------+------------------------------+-------------------------+-----------------+
|	Drama		|		2017	    |  Shatamanam Bhavati          |	 INR 530500000	     |		1	       |
|	Drama		|		2017		|	  Winner		           |	 INR 250000000 		 |		2	       |
|	Drama		|		2017		|  Thank You for Your Service  |	  $ 9995692    		 |		3	       |
|	Comedy		|		2017		|	  The Healer	           |	  $ 9979800   		 |		4	       |
|	Drama		|		2017	    |     The Healer               |	  $ 9979800	         |		5	       |
|	Thriller	|		2018	    |     The Villain              |	 INR 1300000000	     |		1	       |
|	Drama		|		2018		|	Antony & Cleopatra         |	  $ 998079   		 |		2	       |
|	Comedy		|		2018		|  La fuitina sbagliata        |	  $ 992070    		 |		3	       |
|	Drama		|		2018		|	  Zaba   	               |	  $ 991      		 |		4	       |
|	Comedy		|		2018	    |     Gung-hab                 |	  $ 9899017	         |		5	       |
|	Thriller	|		2019	    |     Prescience               |	  $ 9956     	     |		1	       |
|	Thriller	|		2019		|     Joker                    |	  $ 995064593  		 |		2	       |
|	Drama		|		2019		|     Joker                    |	  $ 995064593  		 |		3	       |
|	Comedy		|		2019		|  Eaten by Lions              |	  $ 99276      		 |		4	       |
|	Comedy		|		2019	    |  Friend Zone                 |	  $ 9894885	         |		5	       |
+---------------+-------------------+------------------------------+-------------------------+-----------------+*/

/*
CONCLUSION   
WE HAVE USED ROW_NUMBER BECASUE AS PER THE QUESTION HIGHEST-GROSSING MOVIES OF "EACH YEAR"  THEREFORE ROW NUMBER WILL BE BETTER THAN RANK OR 
DENSE RANK
*/

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
with prod_comp_summary As (
select production_company, count(id) as movie_count, 
row_number () over (order by count(id) desc) as prod_comp_rank
from movie m join ratings r on m.id = r.movie_id 
where median_rating >=8 and position(',' in languages) > 0
and production_company is not null
group by production_company )
select * from prod_comp_summary where prod_comp_rank <=2;
/* Output format:
+-----------------------+-------------------+---------------------+
|production_company     |  movie_count		|		prod_comp_rank|
+-----------------------+-------------------+---------------------+
| Star Cinema		    |		7			|		1	  		  |
| Twentieth Century Fox	|		4			|		2			  |
+-----------------------+-------------------+---------------------+*/

-- Multilingual is the important piece in the above question. It was created using POSITION(',' IN languages)>0 logic
-- If there is a comma, that means the movie is of more than one language


-- Q28. Who are the top 3 actresses based on number of Super Hit movies (average rating >8) in drama genre?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |actress_avg_rating	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Laura Dern	|			1016	|	       1		  |	   9.60			     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:
with top_3_actress as (
select n.name as actress_name, sum(r.total_votes) as total_votes, count(distinct r.movie_id) as movie_count,
round(avg(avg_rating), 2) as actress_avg_rating, 
dense_rank () over (order by count(distinct case when avg_rating > 8 then rm.movie_id end) desc) as actress_rank
from names n join role_mapping rm on n.id = rm.name_id 
join ratings r on r.movie_id = rm.movie_id
join genre g on g.movie_id = r.movie_id
where avg_rating > 8
and category = 'actress'
and genre = 'drama' 
group by actress_name
order by actress_avg_rating desc )
select * from top_3_actress where actress_rank = 1
limit 3 ;
/* Output format:
+-------------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	    |	total_votes		|	movie_count		  |actress_avg_rating	 |actress_rank	   |
+-------------------+-------------------+---------------------+----------------------+-----------------+
|   Amanda Lawrence	|			656  	|	       2		  |	   8.95			     |		1	       |
|	Denise Gough    |			656		|	       2		  |	   8.95	    		 |		1	       |
|	Susan Brown	    |			656		|	       2		  |	   8.95	    		 |		1	       |
+-------------------+-------------------+---------------------+----------------------+-----------------+*/
/* -- CONCLUSION :-
			TOP 3 ACTRESSES BASED ON NUMBER OF SUPER HIT MOVIES AMANDA LAWRENCE,DENISE GOUGH,SUSAN BROWN */				
		
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
-- since there is average inter(interval) between 2  movie  for that we have to find the date difference 
WITH summary_moives_date AS
(
         SELECT   d.name_id,
                  n.NAME,
                  d.movie_id,
                  duration,
                  r.avg_rating,
                  r.total_votes,
                  m.date_published,
                  Lead(date_published, 1) OVER (partition BY d.name_id ORDER BY m.date_published, d.name_id DESC ) AS next_movie_date
         FROM     director_mapping d
         JOIN     names n
         ON       d.name_id = n.id
         JOIN     movie m
         ON       m.id = d.movie_id
         JOIN     ratings r
         ON       r.movie_id = m.id ), days_diff_table AS
(
       SELECT *,
              Datediff(next_movie_date, date_published ) AS days_diff -- adding the column for date difference
       FROM   summary_moives_date )
SELECT   name_id                  AS director_id,
         NAME                     AS director_name,
         Count(movie_id)          AS number_of_movies,
         Round(Avg(days_diff), 0) AS avg_inter_movie_days,
         Round(Avg(avg_rating),2) AS avg_rating,
         Sum(total_votes)         AS total_votes ,
         Min(avg_rating)          AS min_rating ,
         Max(avg_rating)          AS max_rating ,
         Sum(duration)            AS total_duration
FROM     days_diff_table
GROUP BY director_id
ORDER BY number_of_movies DESC ,
         total_duration DESC limit 9 ;
 /*        
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
| director_id	|	director_name	|	number_of_movies  |	avg_inter_movie_days |	avg_rating	| total_votes  | min_rating	| max_rating | total_duration |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
|nm1777967		|	A.L. Vijay		|			5		  |	       177			 |	   5.42	    |	1754	   |	3.7		|	6.9		 |		613		  |
|nm2096009		|	Andrew Jones	|			5		  |	       191			 |	   3.02	    |	1989	   |	2.7		|	3.2		 |		432		  |
|nm0814469   	|	Sion Sono		|			4		  |	       331			 |	   6.03	    |	2972	   |	5.4		|	6.4		 |		502		  |
|nm0001752		|Steven Soderbergh	|			4		  |	       254			 |	   6.48	    |	171684	   |	6.2		|	7.0		 |		401		  |
|nm0425364		|Jesse V. Johnson	|			4		  |	       299			 |	   5.45	    |	14778	   |	4.2		|	6.5		 |		383		  |
|nm6356309		|Özgür Bakar		|			4		  |	       112			 |	   3.75	    |	1092       |	3.1		|	4.9		 |		374		  |
|nm0831321		|Chris Stokes		|			4		  |	       198			 |	   4.33	    |	3664       |	4.0		|	4.6		 |		352		  |
|nm2691863		|Justin Price		|			4		  |	       315			 |	   4.50	    |	5343	   |	3.0		|	5.8		 |		346		  |
|nm0515005		|Sam Liu			|			4		  |	       260			 |	   6.23	    |	28557	   |	5.8		|	6.7		 |		312		  |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+*/

/* CONCLUSION 
	A.L VIJAY ABD ABDREW JONES ARE THE DIRECTORS WHICH  HAVE THE HIGHEST NUMBER FOR MOVIES.
								
								
							




