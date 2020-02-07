-- COMP3311 19T3 Assignment 2
-- Written by <<insert your name here>>

-- Q1 Which movies are more than 6 hours long? 

create or replace view Q1(title)
as

SELECT main_title as title
FROM Titles
WHERE runtime > 360 and format = 'movie'
ORDER BY title
;


-- Q2 What different formats are there in Titles, and how many of each?

create or replace view Q2(format, ntitles)
as
SELECT format, count(*) as ntitles
FROM Titles 
GROUP BY format
;


-- Q3 What are the top 10 movies that received more than 1000 votes?

create or replace view Q3(title, rating, nvotes)
as

SELECT main_title as title, rating, nvotes 
FROM Titles 
WHERE nvotes > 1000 and format = 'movie' 
ORDER BY rating desc, title asc
Limit 10
;


-- Q4 What are the top-rating TV series and how many episodes did each have?

create or replace view Q4(title, nepisodes)
as
SELECT main_title as title, count(*) as nepisodes
FROM Titles JOIN Episodes on Titles.id = Episodes.parent_id
WHERE rating = 10 and (format = 'tvSeries' or format = 'tvMiniSeries')
GROUP BY Titles.id
ORDER BY title
;


-- Q5 Which movie was released in the most languages?

create or replace view Q5(title, nlanguages)
as

SELECT title, nlanguages
FROM (SELECT main_title as title, count(distinct(language)) as nlanguages, 
    rank() over (ORDER BY count(distinct(language)) desc)
    FROM Titles JOIN Aliases on Titles.id = Aliases.title_id
    WHERE format = 'movie'
    GROUP BY Titles.id
    ORDER BY nlanguages desc
    ) as wow
WHERE rank <= 1
;


-- Q6 Which actor has the highest average rating in movies that they're known for?

create or replace view Q6(name)
as

SELECT name
FROM (SELECT name, rank() over (ORDER BY avg(rating) desc)
    FROM Names 
        JOIN Known_for on Names.id = Known_for.name_id 
        JOIN Titles on Known_for.title_id = Titles.id
    WHERE format = 'movie' and rating is not NULL and 
    name in (
        SELECT distinct(name) 
        FROM Names JOIN Worked_as on Names.id = Worked_as.name_id
        WHERE work_role = 'actor'
        ORDER BY name)
    GROUP BY name
    HAVING Count(Known_for.name_id) > 1
    ORDER BY avg(rating) desc
    ) as wow
WHERE rank <= 1
;

-- Q7 For each movie with more than 3 genres, show the movie title and a comma-separated list of the genres


create or replace view Q7(title,genres)
as

SELECT main_title as title, string_agg(distinct(genre), ',') as genres
FROM Titles JOIN Title_genres on Titles.id = Title_genres.title_id
WHERE format = 'movie'
GROUP BY Titles.id
HAVING count(distinct(genre)) > 3
;

-- Q8 Get the names of all people who had both actor and crew roles on the same movie

create or replace view Q8(name)
as

SELECT name 
FROM Names 
    JOIN Actor_roles on Names.id = Actor_roles.name_id
    JOIN Titles on Actor_roles.title_id = Titles.id
    LEFT JOIN Crew_roles on Names.id = Crew_roles.name_id and Titles.id = Crew_roles.title_id
WHERE format = 'movie' and Names.id = Crew_roles.name_id and Titles.id = Crew_roles.title_id
GROUP BY Names.id
ORDER BY name
;

-- Q9 Who was the youngest person to have an acting role in a movie, and how old were they when the movie started?

create or replace view Q9(name,age)
as

SELECT name, age
FROM (SELECT name, (start_year - birth_year) as age, 
    rank() over (ORDER BY (start_year - birth_year) asc)
    FROM Names 
        JOIN Actor_roles on Names.id = Actor_roles.name_id
        JOIN Titles on Actor_roles.title_id = Titles.id
    WHERE format = 'movie' and birth_year is not NULL
    ORDER BY age asc
    ) as wow
WHERE rank <= 1
;

-- Q10 Write a PLpgSQL function that, given part of a title, shows the full title and the total size of the cast and crew

create or replace view moviesList as
    SELECT main_title as title, count(distinct(name)) as totalSize
    FROM Titles
        JOIN Principals on Titles.id = Principals.title_id
        JOIN Names on Principals.name_id = Names.id
        LEFT JOIN Crew_roles on Names.id = Crew_roles.name_id and Titles.id = Crew_roles.title_id
        LEFT JOIN Actor_roles on Names.id = Actor_roles.name_id and Titles.id = Actor_roles.title_id
    GROUP BY Titles.id
    ORDER BY main_title
;

create or replace function
	Q10(partial_title text) returns setof text
as $$

declare
    fullTitle text;
    castSize integer := 0;
    tuple record;
begin
    if exists (
        SELECT moviesList.title as fullTitle, moviesList.totalSize as castSize
        FROM moviesList
        WHERE moviesList.title ilike '%' || partial_title || '%'
    ) then
        for tuple in 
            SELECT moviesList.title as fullTitle, moviesList.totalSize as castSize
            FROM moviesList
            WHERE moviesList.title ilike '%' || partial_title || '%'
        loop
            return next tuple.fullTitle || ' has ' || tuple.castSize || ' cast and crew';    
        end loop;  
    else return next 'No matching titles';
    end if;    
end;

$$ language plpgsql;


