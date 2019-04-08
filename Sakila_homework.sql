USE sakila;
-- 1a. Display the first and last names of all actors from the table actor.
SELECT first_name,
       last_name
FROM actor;

-- 1b. Display the first and last name of each actor in a single column 
-- in upper case letters. Name the column Actor Name.
SELECT UPPER(CONCAT(first_name, ' ', last_name)) AS `Actor Name`
FROM actor;

-- 2a. You need to find the ID number, first name, and last name of an actor,
-- of whom you know only the first name, "Joe." 
-- What is one query would you use to obtain this information?
SELECT actor_id, 
       first_name, 
       last_name
FROM actor
Where first_name = 'Joe';

-- 2b. Find all actors whose last name contain the letters GEN:
SELECT actor_id, 
       first_name, 
       last_name
FROM actor
Where last_name like '%GEN%';

-- 2c.Find all actors whose last names contain the letters LI.
--  This time, order the rows by last name and first name, in that order:
SELECT actor_id, 
       last_name, 
       first_name
FROM actor
Where last_name like '%LI%';

-- 2d. Using IN, display the country_id and country columns of the following countries: 
-- Afghanistan, Bangladesh, and China:
SELECT country_id, 
       country
FROM country
Where country IN
('Afghanistan', 'Bangladesh','China');

-- 3a. You want to keep a description of each actor.
--  You don't think you will be performing queries on a description, 
-- so create a column in the table actor named description 
-- and use the data type BLOB (Make sure to research the type BLOB,
--  as the difference between it and VARCHAR are significant).
ALTER TABLE actor
ADD COLUMN description BLOB;

-- 3b. Very quickly you realize that entering descriptions for each actor is too much effort. 
-- Delete the description column.
ALTER TABLE actor
DROP COLUMN description;

-- 4a. List the last names of actors, as well as how many actors have that last name.
SELECT last_name, COUNT(*) AS 'Number of Actors' 
FROM actor GROUP BY last_name;

-- 4b. List last names of actors and the number of actors who have that last name, 
-- but only for names that are shared by at least two actors
SELECT last_name, COUNT(*) AS 'Number of Actors' 
FROM actor GROUP BY last_name HAVING count(*) >=2;

-- 4c. The actor HARPO WILLIAMS was accidentally entered in the actor table as GROUCHO WILLIAMS. 
-- Write a query to fix the record.
UPDATE actor 
SET first_name = 'HARPO'
WHERE First_name = "Groucho" AND last_name = "Williams";

-- 4d. Perhaps we were too hasty in changing GROUCHO to HARPO.
-- It turns out that GROUCHO was the correct name after all! 
-- In a single query, if the first name of the actor is currently HARPO, change it to GROUCHO.
UPDATE actor 
SET first_name = 'Groucho'
WHERE First_name = "HARPO" AND last_name = "Williams";

-- 5a. You cannot locate the schema of the address table. Which query would you use to re-create it?
USE Schema;
DROP Table address IF exists;
CREATE Table address;

-- 6a. Use JOIN to display the first and last names, as well as the address,
--  of each staff member. Use the tables staff and address:
select s.first_name,s.last_name,
        a.address
from staff s
LEFT join address a on (s.address_id = a.address_id);

-- 6b. Use JOIN to display the total amount rung up by each staff member in August of 2005.
--  Use tables staff and payment.
SELECT s.first_name,
		s.last_name,
		sum(p.amount) as 'total amount'
from staff s
INNER JOIN payment p on (s.staff_id = p.staff_id)
AND p.payment_date LIKE '2005-08%'
GROUP BY s.first_name, s.last_name;

-- 6c. List each film and the number of actors who are listed for that film. 
-- Use tables film_actor and film. Use inner join.
SELECT f.title AS "Film Title",
       count(a.actor_id) AS "Number of Actors"
FROM film_actor a
INNER JOIN film f on (a.film_id = f.film_id)
GROUP BY f.title;

-- 6d. How many copies of the film Hunchback Impossible exist in the inventory system?
select count(store_id) as Copies
From inventory
where film_id =
(select film_id
 From film
 where title = 'Hunchback Impossible')
 ;

-- 6e. Using the tables payment and customer and the JOIN command, 
-- list the total paid by each customer. List the customers alphabetically by last name:
SELECT c.first_name, c.last_name,
       sum(p.amount) as 'Total'
From customer c
join payment p on (c.customer_id = p.customer_id)
GROUP BY c.first_name, c.last_name
ORDER BY c.last_name;


-- 7a. The music of Queen and Kris Kristofferson have seen an unlikely resurgence. 
-- As an unintended consequence, films starting with the letters K and Q have also soared in popularity.
-- Use subqueries to display the titles of movies starting with the letters K and Q whose language is English.
Select title
From film
Where (title lIKE 'k%' OR title LIKE 'Q%')
And language_id =
(Select language_id
From language
where name = 'English');

-- 7b. Use subqueries to display all actors who appear in the film Alone Trip.
Select first_name,
       last_name
From actor
where actor_id in
(Select actor_id
 From film_actor
 where film_id in
               (Select film_id
                From film
                where title = "Alone Trip"
                )
);

-- 7c. You want to run an email marketing campaign in Canada, 
-- for which you will need the names and email addresses of all Canadian customers.
--  Use joins to retrieve this information.
Select c.first_name, 
		c.last_name,
		c.email
From customer c
JOIN address a on (c.address_id = a.address_id)
JOIN city on (a.city_id = city.city_id)
JOIN country on (city.country_id =country.country_id)
where country.country = 'Canada';

-- 7d. Sales have been lagging among young families, 
-- and you wish to target all family movies for a promotion.
--  Identify all movies categorized as family films.
Select title 
From film
where film_id in
(Select film_id
From film_category
where category_id =
(select category_id
From category
Where name = "Family")
);


-- 7e. Display the most frequently rented movies in descending order.
SELECT title, COUNT(f.film_id) AS 'Count_of_Rented_Movies'
FROM  film f
JOIN inventory i ON (f.film_id= i.film_id)
JOIN rental r ON (i.inventory_id=r.inventory_id)
GROUP BY title ORDER BY Count_of_Rented_Movies DESC;

-- 7f. Write a query to display how much business, in dollars, each store brought in.
Select c.store_id, 
       sum(p.amount) as 'Total Business ($)'
From customer c
Join payment p on (c.customer_id = p.customer_id)
Group By c.store_id;


-- 7g. Write a query to display for each store its store ID, city, and country.
Select s.store_id,
city.city,
country.country
From store s
JOIN address a on (s.address_id = a.address_id)
JOIN city on (a.city_id = city.city_id)
JOIN country on (city.country_id =country.country_id);


-- 7h. List the top five genres in gross revenue in descending order. 
-- (Hint: you may need to use the following tables: category, film_category, inventory, payment, and rental.)
SELECT c.name AS 'Genre', SUM(p.amount) AS 'Gross' 
FROM category c
JOIN film_category fc 
ON (c.category_id=fc.category_id)
JOIN inventory i 
ON (fc.film_id=i.film_id)
JOIN rental r 
ON (i.inventory_id=r.inventory_id)
JOIN payment p 
ON (r.rental_id=p.rental_id)
GROUP BY c.name ORDER BY Gross  LIMIT 5;
-- 8a. In your new role as an executive, you would like to have an easy way of viewing the Top five genres by gross revenue. 
-- Use the solution from the problem above to create a view. If you haven't solved 7h, you can substitute another query to create a view.
CREATE VIEW vw_genre_revenue AS
SELECT c.name AS 'Genre', SUM(p.amount) AS 'Gross' 
FROM category c
JOIN film_category fc 
ON (c.category_id=fc.category_id)
JOIN inventory i 
ON (fc.film_id=i.film_id)
JOIN rental r 
ON (i.inventory_id=r.inventory_id)
JOIN payment p 
ON (r.rental_id=p.rental_id)
GROUP BY c.name ORDER BY Gross  LIMIT 5;
-- 8b. How would you display the view that you created in 8a?
SELECT * FROM vw_genre_revenue;

-- 8c. You find that you no longer need the view top_five_genres. Write a query to delete it.
DROP VIEW vw_genre_revenue;





      
