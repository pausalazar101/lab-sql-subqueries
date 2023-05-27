USE sakila;

## 1. How many copies of the film Hunchback Impossible exist in the inventory system?

SELECT count(inventory_id) as copies from inventory i
WHERE i.film_id= 
(
SELECT film_id FROM film f
WHERE f.title='Hunchback Impossible'
);

## 2. List all films whose length is longer than the average of all the films.
SELECT avg(f.length)  FROM film f;

SELECT title FROM film f
WHERE length> 115.28;

SELECT title FROM film
WHERE length>
( SELECT avg(length) FROM film
);

## 3. Use subqueries to display all actors who appear in the film Alone Trip.

SELECT first_name, last_name FROM actor a
WHERE actor_id= ANY 
(
SELECT actor_id FROM film_actor fa
WHERE 
fa.film_id=
( SELECT film_id FROM film
WHERE 
title='Alone Trip'
)
);

## 4. Sales have been lagging among young families, 
## and you wish to target all family movies for a promotion. 
## Identify all movies categorized as family films.

SELECT title FROM film
WHERE film_id IN
(SELECT film_id FROM film_category
WHERE category_id=(
SELECT category_id FROM category
WHERE name='Family'
)
)
;

##Get name and email from customers from Canada using subqueries. 
##Do the same with joins. Note that to create a join, you will have
## to identify the correct tables with their primary keys and 
##foreign keys, that will help you get the relevant information.

SELECT first_name, last_name, email FROM customer
WHERE address_id IN (
SELECT address_id FROM address
WHERE city_id IN(
SELECT city_id FROM city
WHERE country_id=(
SELECT country_id FROM country c
WHERE c.country="Canada"
)
)
)
;


SELECT c.first_name, c.last_name, c.email
FROM customer AS c
JOIN address AS a ON c.address_id = a.address_id
JOIN city AS ct ON a.city_id = ct.city_id
JOIN country AS co ON ct.country_id = co.country_id
WHERE co.country = 'Canada';

##Which are films starred by the most prolific actor? 
##Most prolific actor is defined as the actor that has acted in the 
##most number of films. First you will have to find the most 
##prolific actor and then use that actor_id to find the different 
##films that he/she starred.

SELECT title FROM film
WHERE film_id IN(
SELECT film_id FROM film_actor as fa
WHERE fa.actor_id =
(
SELECT actor_id FROM film_actor
GROUP BY actor_id
HAVING COUNT(film_id) = (
SELECT MAX(count) FROM
(
SELECT COUNT(film_id) AS count
FROM film_actor
GROUP BY actor_id
) AS c
)
)
)
;

## Films rented by most profitable customer.You can use the customer
## table and payment table to find the most profitable customer ie 
## the customer that has made the largest sum of payments
SELECT title FROM film
WHERE film_id IN(
SELECT film_id FROM inventory 
WHERE inventory_id IN(
SELECT inventory_id FROM rental 
WHERE rental_id IN(
SELECT p.rental_id FROM payment as p
WHERE p.customer_id IN(
SELECT subquery.customer_id
FROM (
SELECT customer_id, SUM(amount) as total
FROM payment
GROUP BY customer_id
) AS subquery
WHERE subquery.total =(
SELECT MAX(total) FROM
(SELECT SUM(amount) as total
FROM payment
GROUP BY customer_id
) as t
)
)
)
)
)
;

## Get the client_id and the total_amount_spent of those clients who spent 
## more than the average of the total_amount spent by each client.

SELECT customer_id as clinet_id, sum(amount) as total_amount_spent 
FROM payment
GROUP BY customer_id
HAVING total_amount_spent > (
SELECT avg(t.total) AS average
FROM(
SELECT SUM(amount) as total
FROM payment
GROUP BY customer_id
) as t
);



