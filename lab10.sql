USE sakila;
-- 1
show full tables;

-- 2 
select * from actor;
select * from film;
select * from customer;
-- 3.1 
select title from film;
-- 3.2
select name AS lengua from language;
-- 3.3
select first_name from staff;
-- 4
select distinct release_year from film;
-- 5.1
select count(store_id) AS  numero_de_tiendas from store;
-- 5.2 
select count(staff_id) AS numero_de_empleados from staff;
-- 5.3
select * from inventory;


-- 5.4
select count(distinct last_name) from actor;

-- 6 las 10 peliculas mas largas
select * from sakila.film
order by length DESC
limit 10;
 
 -- 7 todos los actores que se llaman Scarlett
 
 select * from sakila.actor
 where first_name = 'Scarlett';
 
 -- 7.2
SELECT * FROM sakila.FILM
WHERE TITLE LIKE '%ARMAGEDDON% AND LENGTH > 100' ;

SELECT * FROM sakila.film
WHERE SPECIAL_FEATURES LIKE '%Behind the Scenes content%';
 
