USE SAKILA;

SELECT FIRST_NAME, LAST_NAME FROM ACTOR;

SELECT Concat(FIRST_NAME, ' ',LAST_NAME) AS 'Actor Name' FROM ACTOR;

SELECT actor_id, first_name, last_name FROM actor WHERE first_name = "Joe";

SELECT first_name, last_name FROM actor WHERE last_name LIKE "%GEN%";

SELECT last_name, first_name FROM actor WHERE last_name LIKE "%LI%";

SELECT country_id, country FROM Country WHERE Country IN ('Afghanistan', 'Bangladesh', 'China');

ALTER TABLE actor
ADD COLUMN description BLOB;

ALTER TABLE actor
DROP COLUMN description;

SELECT last_name, COUNT(last_name) FROM Actor
GROUP BY last_name;

SELECT last_name, COUNT(last_name) FROM Actor
GROUP BY last_name
HAVING COUNT(last_name) >1;

UPDATE actor Set first_name = "HARPO" 
WHERE last_name = "WILLIAMS" AND first_name = "GROUCHO";

UPDATE actor Set first_name = "GROUCHO" 
WHERE last_name = "WILLIAMS" AND first_name = "HARPO";

DESCRIBE address;

SHOW CREATE TABLE address;

-- *****I didn't want to accidently replace the address table, so I commented out this section so it wouldn't run**** --

-- CREATE TABLE `address`(
-- `address_id` smallint(5) unsigned NOT NULL AUTO_INCREMENT,  
-- `address` varchar(50) NOT NULL,  
-- `address2` varchar(50) DEFAULT NULL,  
-- `district` varchar(20) NOT NULL,  
-- `city_id` smallint(5) unsigned NOT NULL,  
-- `postal_code` varchar(10) DEFAULT NULL,  
-- `phone` varchar(20) NOT NULL,  
-- `location` geometry NOT NULL,  
-- `last_update` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,  
-- PRIMARY KEY (`address_id`),  
-- KEY idx_fk_city_id (`city_id`),  
-- SPATIAL KEY idx_location (`location`),  
-- CONSTRAINT fk_address_city 
-- FOREIGN KEY (`city_id`) 
-- REFERENCES city (`city_id`) ON UPDATE CASCADE) ENGINE=InnoDB AUTO_INCREMENT=606 DEFAULT CHARSET=utf8;
 

SELECT staff.first_name, staff.last_name, address.address
FROM address
INNER JOIN staff ON
address.address_id = staff.address_id;

SELECT staff.first_name, staff.last_name, SUM(payment.amount) AS "TOTAL FOR AUGUST 2005"
FROM staff
INNER JOIN payment ON
staff.staff_id = payment.staff_id
WHERE payment.payment_date BETWEEN '2005-08-01' AND '2005-08-31'
GROUP BY last_name;

SELECT film.title, COUNT(actor_id) AS 'Number of Actors'
FROM film
INNER JOIN film_actor ON
film.film_id = film_actor.film_id
GROUP BY film.title;

SELECT film.title, COUNT(inventory.film_id) AS 'Copies Available'
FROM film
INNER JOIN inventory ON
film.film_id = inventory.film_id
WHERE film.title = "Hunchback Impossible";

SELECT customer.first_name, customer.last_name, SUM(payment.amount) AS 'Total Amount Paid'
FROM customer
INNER JOIN payment ON
customer.customer_id = payment.customer_id
GROUP BY customer.last_name
ORDER BY customer.last_name ASC;

SELECT title
FROM film
WHERE title LIKE 'Q%' 
OR title LIKE'K%'
AND language_id IN(

SELECT language_id
FROM language
WHERE name = "English"
);


SELECT first_name, last_name, actor_id
FROM actor
WHERE actor_id IN
	(	
	SELECT actor_id
    FROM film_actor
    WHERE film_id IN
	 (		
	 SELECT film_id 
	 FROM film 
	 WHERE title = "Alone Trip"
        ));


SELECT customer.first_name, customer.last_name, customer.email
FROM customer
JOIN address ON
customer.address_id = address.address_id
JOIN city ON
city.city_id = address.city_id
JOIN country ON
country.country_id = city.country_id
WHERE country = "Canada";

SELECT Title 
FROM Film
WHERE film_id IN
	(
	SELECT film_id
    FROM film_category
    WHERE category_id IN
    (
     SELECT category_id
     FROM category
     WHERE name = "Family"
     ));


SELECT film.title, COUNT(rental.rental_date) AS 'Number of Times Rented' 
FROM film
JOIN inventory ON
film.film_id = inventory.film_id
JOIN rental ON
inventory.inventory_id = rental.inventory_id
GROUP BY film.title
ORDER BY COUNT(rental_date) DESC;

SELECT store.store_id AS 'Store #', SUM(payment.amount) AS 'Total Sales Per Store'
FROM store
JOIN inventory ON
store.store_id = inventory.store_id
JOIN rental ON
inventory.inventory_id = rental.inventory_id
JOIN payment ON
rental.rental_id = payment.rental_id
GROUP BY store.store_id;

SELECT store.store_id AS 'Store #', city.city AS 'City', country.country AS 'Country'
FROM store
JOIN address ON
address.address_id = store.address_id
JOIN city ON
address.city_id = city.city_id
JOIN country ON
city.country_id = country.country_id
GROUP BY store_id ASC;

SELECT category.name AS 'Genre', SUM(payment.amount) AS 'Gross Revenue'
FROM category
JOIN film_category ON
category.category_id = film_category.category_id
JOIN inventory ON
film_category.film_id = inventory.film_id
JOIN rental ON
inventory.inventory_id = rental.inventory_id
JOIN payment ON
rental.rental_id = payment.rental_id
GROUP BY category.name
ORDER BY SUM(payment.amount) DESC LIMIT 5; 

CREATE VIEW Top_Five_Grossing_Genre AS
	SELECT 
		category.name AS 'Genre', SUM(payment.amount) AS 'Gross Revenue'
	FROM
		category
		JOIN film_category ON
		category.category_id = film_category.category_id
		JOIN inventory ON
		film_category.film_id = inventory.film_id
		JOIN rental ON
		inventory.inventory_id = rental.inventory_id
		JOIN payment ON
		rental.rental_id = payment.rental_id
	GROUP BY category.name
    ORDER BY SUM(payment.amount) DESC LIMIT 5; 
    
SELECT * FROM sakila.top_five_grossing_genre;

DROP VIEW sakila.top_five_grossing_genre;

