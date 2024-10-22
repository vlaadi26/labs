USE sakila;

-- 1.1 Determine the shortest and longest movie durations and name the values as max_duration and min_duration.
SELECT MAX(length) AS max_duration, min(length) as min_duration FROM sakila.film ;

-- 1.2 1.2. Express the average movie duration in hours and minutes. Don't use decimals
SELECT FLOOR(AVG(length)) FROM sakila.film;

-- 2.1 Calculate the number of days that the company has been operating

select distinct last_update, convert(last_update, date) as fecha
 from sakila.rental
 order by last_update desc;



-- 2.2 Retrieve rental information and add two additional columns to show the month and weekday of the rental. Return 20 rows of results.

select * from sakila.rental;
SELECT *, DATE_FORMAT(CONVERT(rental_date, DATE), '%D') as dia, DATE_FORMAT(CONVERT(rental_date, DATE), '%M') as mes ,
CASE
when (DATE_FORMAT(CONVERT(rental_date, DATE), '%D')) = '24th' then 'martes'
when (DATE_FORMAT(CONVERT(rental_date, DATE), '%D')) = 25 then 'miercoles'
else 'otro dia'
end as DIA_DE_LA_SEMANA
from sakila.rental
limit 20;


-- 2.3 Bonus: Retrieve rental information and add an additional column called DAY_TYPE with values 'weekend' or 'workday', depending on the day of the week.
select *,
case
when DATE_FORMAT(CONVERT(rental_date, DATE), '%D') = 24 then 'workday'
when DAte_format(convert(rental_date,DATE), '%D') = 25 then 'workday'
else 'weekday'
end as DAY_TYPE
from sakila.rental;

-- 3 You need to ensure that customers can easily access information about the movie collection. To achieve this, retrieve the film titles and their rental duration. 
-- If any rental duration value is NULL, replace it with the string 'Not Available'. Sort the results of the film title in ascending order.

select ifnull(return_Date-rental_date, 'not available') AS tiempo_ESPERADO, c.title from sakila.rental as a
join inventory as b
on a.inventory_id = b.inventory_id
join film as c
on b.film_id = c.film_id
order by tiempo_ESPERADO desc;


-- Challenge 2
-- 2.1.1 The total number of films that have been released.
select  count(release_year) , release_year from sakila.film
group by release_year;

-- 2.1.2 The number of films for each rating.
select count(rating) as cantidad , rating from sakila.film
group by rating;
-- 2.1.3 The number of films for each rating, sorting the results in descending order of the number of films. 
-- This will help you to better understand the popularity of different film ratings and adjust purchasing decisions accordingly.alter
select count(rating) as cantidad , rating from sakila.film
group by rating
order by cantidad desc;

-- 2.2.1 The mean film duration for each rating,
select count(rating) as cantidad , rating, round(avg(length),2)  from sakila.film
group by rating
order by cantidad desc;
-- 2.2.2 Identify which ratings have a mean duration of over two hours
-- in order to help select films for customers who prefer longer movies.
select count(rating) as cantidad , rating, avg(length)  from sakila.film
where rating in(
select length
from sakila.film
where length > 120
)
group by rating
order by cantidad desc;
