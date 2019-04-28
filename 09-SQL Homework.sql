USE sakila;
-- 1a
select * from actor;

-- 1b
SELECT CONCAT(first_name, " ", last_name) AS "Actor_Name"
FROM actor;

-- 2a
SELECT * from actor WHERE first_name = "JOE";

-- 2b
SELECT * from actor WHERE last_name LIKE "%GEN%";

-- 2c
SELECT * from actor WHERE last_name LIKE "%LI%"
	ORDER BY last_name, first_name;

-- 2d
SELECT country, country_id
FROM country
WHERE country IN ('Afghanistan', 'Bangladesh', 'China');

-- 3a
ALTER TABLE actor ADD COLUMN description BLOB(300);

-- 3b
ALTER TABLE actor DROP COLUMN description;

-- 4a
SELECT last_name, COUNT(last_name)
FROM actor
GROUP BY last_name;

-- 4b
SELECT last_name, COUNT(last_name)
FROM actor
GROUP BY last_name
HAVING COUNT(last_name) > 1;

-- 4c
UPDATE actor SET first_name = "HARPO"
WHERE first_name = "GROUCHO" AND last_name = "WILLIAMS";

SELECT * FROM actor WHERE last_name = "WILLIAMS";

-- 4d
UPDATE actor SET first_name = "GROUCHO"
WHERE first_name = "HARPO" AND last_name = "WILLIAMS";

SELECT * FROM actor WHERE last_name = "WILLIAMS";

-- 5a
SHOW CREATE TABLE address;

-- 6a
SELECT * FROM staff INNER JOIN address ON staff.address_id=address.address_id;

-- 6b
SELECT * FROM staff INNER JOIN payment ON staff.staff_id=payment.staff_id;

-- 6c
SELECT title, COUNT(actor_id) 
FROM (film_actor INNER JOIN film ON film_actor.film_id=film.film_id)
GROUP BY title;

-- 6d
SELECT title, COUNT(inventory_id) 
FROM (film INNER JOIN inventory ON film.film_id=inventory.film_id)
WHERE title = "HUNCHBACK IMPOSSIBLE";

-- 6e
SELECT first_name, last_name, SUM(amount) AS "Total Amount Paid" 
FROM (customer INNER JOIN payment ON customer.customer_id=payment.customer_id)
GROUP BY customer.customer_id
ORDER BY last_name, first_name;

-- 7a  *A language_id of 1 indicates English, 
-- all films in the table film have a language_id of 1*

SELECT language_id, COUNT(language_id)
FROM film
GROUP BY language_id;

SELECT * FROM film
WHERE title LIKE "K%" OR title LIKE "Q%";

-- 7b
SELECT first_name, last_name
FROM actor
WHERE actor_id IN
(
	SELECT actor_id
    FROM film_actor
    WHERE film_id IN
	(
		SELECT film_id
		FROM film
		WHERE title = "ALONE TRIP"
	)
);
-- 7c
SELECT first_name, last_name, email
FROM 
customer INNER JOIN address ON customer.address_id=address.address_id
INNER JOIN city ON address.city_id=city.city_id
INNER JOIN country on city.country_id=country.country_id
WHERE country.country = "Canada";
        
-- 7d
SELECT title
FROM film
WHERE film_id in
(
	SELECT film_id
    FROM film_category
    WHERE category_id IN
    (
		SELECT category_id
        FROM category
        WHERE name = "Family"
	)
);

-- 7e
SELECT title, COUNT(title) AS "Rentals"
FROM film INNER JOIN inventory ON film.film_id=inventory.film_id
INNER JOIN rental ON inventory.inventory_id=rental.inventory_id
GROUP BY title ORDER BY COUNT(title) DESC;

-- 7f
SELECT store.store_id, SUM(amount) AS "Income"
FROM store INNER JOIN inventory ON store.store_id=inventory.store_id
INNER JOIN rental ON inventory.inventory_id=rental.inventory_id
INNER JOIN payment ON rental.rental_id=payment.rental_id
GROUP BY store.store_id;

-- 7g 
SELECT store.store_id, city, country
FROM store INNER JOIN address ON store.address_id=address.address_id
INNER JOIN city ON address.city_id=city.city_id
INNER JOIN country ON city.country_id=country.country_id;

-- 7h
SELECT category.name, SUM(payment.amount) AS "Revenue"
FROM payment INNER JOIN rental ON payment.rental_id=rental.rental_id
INNER JOIN inventory ON rental.inventory_id=inventory.inventory_id
INNER JOIN film_category ON inventory.film_id=film_category.film_id
INNER JOIN category ON film_category.category_id=category.category_id
GROUP BY category.name
ORDER BY SUM(amount) DESC
LIMIT 5;

-- 8a
CREATE VIEW Top_Five AS
SELECT category.name, SUM(payment.amount) AS "Revenue"
FROM payment INNER JOIN rental ON payment.rental_id=rental.rental_id
INNER JOIN inventory ON rental.inventory_id=inventory.inventory_id
INNER JOIN film_category ON inventory.film_id=film_category.film_id
INNER JOIN category ON film_category.category_id=category.category_id
GROUP BY category.name
ORDER BY SUM(amount) DESC
LIMIT 5;

-- 8b
SELECT * FROM Top_Five;

-- 8c
DROP VIEW Top_Five;