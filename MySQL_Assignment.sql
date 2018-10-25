-- MySQL Assignment 10/25/2018 

-- select * from sakila.actor;
select count(*)
from sakila.address;

-- Item #1a: pull all records from actor table in schema sakila
/*Actors list by name */
select 
first_name
,last_name
from sakila.actor;

-- Item #1b: single string name 
/* actors name combined */
select 
Upper(concat(first_name," " ,last_name)) as 'Actor Name'
from sakila.actor;

-- Item #2a: pull all records for actor with first name Joe
select 
actor_id
,first_name
,last_name
from sakila.actor 
where first_name ='Joe';

-- Item #2b: Find all actors whose last name contain the letters GEN
select 
actor_id
,first_name
,last_name
from sakila.actor 
where last_name like '%GEN%';

/*Item # 2c. Find all actors whose last names contain the letters LI. 
This time, order the rows by last name and first name, in that order: */
select 
actor_id
,first_name
,last_name
from sakila.actor 
where last_name like '%LI%'
order by 3,2;

-- Item # 2d. Using IN, display the country_id and country columns of the following countries: Afghanistan, Bangladesh, and China:
select 
country_id
,country
from sakila.country
where country In ('Afghanistan', 'Bangladesh', 'China')
order by 1;

/*Item # 3a. You want to keep a description of each actor. You don't think you will be performing queries on a description, so create a column
in the table actor named description and use the data type BLOB 
(Make sure to research the type BLOB, as the difference between it and VARCHAR are significant). */
use sakila;
alter table actor
add column description blob ;

-- Item # 3b. Very quickly you realize that entering descriptions for each actor is too much effort. Delete the description column.
use sakila;
alter table actor
drop column description;

-- Item # 4a. List the last names of actors, as well as how many actors have that last name.*
select 
last_name
, count(actor_id) as name_cnt
from sakila.actor;

/*Item #4b. List last names of actors and the number of actors who have that last name, 
but only for names that are shared by at least two actors */
select 
last_name,
count(actor_id)
from sakila.actor
group by last_name
having count(actor_id) > 1;


/*Item #4c. The actor HARPO WILLIAMS was accidentally entered in the actor table as GROUCHO WILLIAMS. 
Write a query to fix the record.*/
use sakila;
update actor
set first_name = 'GROUCHO'
where first_name= 'HARPO';

/*Item #4d. Perhaps we were too hasty in changing GROUCHO to HARPO. It turns out that GROUCHO was the correct name after all! 
In a single query, if the first name of the actor is currently HARPO, change it to GROUCHO.*/
use sakila;
update actor
set first_name = 'HARPO'
where first_name= 'GROUCHO';

-- Item #5a. You cannot locate the schema of the address table. Which query would you use to re-create it?
use sakila ;
-- drop table if exists address;
SHOW CREATE TABLE address (
address_id,
address,
address2,
district,
city_id,
postal_code,
phone,
location,
last_update,
);

/*Item #6a. Use JOIN to display the first and last names, as well as the address, 
-- of each staff member. Use the tables staff and address:*/
use sakila;
select
a.address_id
,b.first_name
,b.last_name
from sakila.address a 
left join staff b on a.address_id = b.address_id;

-- Item #6b. Use JOIN to display the total amount rung up by each staff member in August of 2005. Use tables staff and payment. 
use sakila;
select
a.staff_id
,a.first_name
,a.last_name
, sum(b.amount) as Amount
,b.payment_id
,b.payment_date
from sakila.staff a 
left join payment b on a.staff_id = b.staff_id
where payment_date between '2005-08-01' and '2005-08-31';

-- Item #6c. List each film and the number of actors who are listed for that film. Use tables film_actor and film. Use inner join
use sakila;
select
a.title
,a.release_year
, count(b.actor_id) as Actor_Cnt
from sakila.film a 
inner join film_actor b on a.film_id = b.film_id
group by a.film_id;

-- Item #6d. How many copies of the film Hunchback Impossible exist in the inventory system?
use sakila;
select
a.title
,a.release_year
, count(b.inventory_id) as "Number of Copies"
from sakila.film a 
inner join inventory b on a.film_id = b.film_id
where title = "Hunchback Impossible"
group by a.film_id;

-- Item #6e. Using the tables payment and customer and the JOIN command, 
-- list the total paid by each customer. List the customers alphabetically by last name:
use sakila;
select
a.customer_id
,a.last_name
,a.first_name
, sum(b.amount) as "Total Amount Paid"
from sakila.customer a 
inner join payment b on a.customer_id = b.customer_id
group by a.last_name asc;

-- Item #7a. The music of Queen and Kris Kristofferson have seen an unlikely resurgence. 
-- As an unintended consequence, films starting with the letters K and Q have also soared in popularity. 
-- Use subqueries to display the titles of movies starting with the letters K and Q whose language is English
use sakila;
select title,
language_id
from film
where title like 'K%' OR title like 'Q%' and language_id in
(select language_id
from film
);

-- Item #7b. Use subqueries to display all actors who appear in the film Alone Trip.
use sakila;
select *
from actor 
where actor_id in
( 
select actor_id
from film_actor
where film_id in
(
select film_id
from film
where title = 'Alone Trip'
)
);

-- Item #7c. You want to run an email marketing campaign in Canada, for which you will need the names and email addresses 
-- of all Canadian customers. city, customer, county, address
-- Use joins to retrieve this information.
use sakila;
select
a.first_name,
a.last_name,
a.email,
a.customer_id,
b.district,
b.address,
b.postal_code,
c.city,
c.country_id,
d.country
from customer a
inner join address b on a.address_id = b.address_id
inner join city c on b.city_id = c.city_id
inner join country d on c.country_id =d.country_id
where d.country = 'Canada';

-- Item #7d. Sales have been lagging among young families, and you wish to target all family movies for a promotion. 
-- Identify all movies categorized as family films.
use sakila;
select * 
from category
where name ='family';
-- create a list of movies that are rated family
select
film_id,
title,
description,
rating
from film
where film_id in
(
select
film_id
from film_category
where category_id = 8
);

-- Item #7e. Display the most frequently rented movies in descending order.
select 
title,
description,
release_year,
rental_duration,
rental_rate
from film
where rental_rate >2.99
order by 1 desc;

-- Item #7f. Write a query to display how much business, in dollars, each store brought in.
use sakila;
-- used group by to aggregate sum by store_id
select
sum(amount) as 'Total Dollars',
a.staff_id,
b.store_id
from payment a
inner join store b 
on a.staff_id = b.manager_staff_id
group by store_id;

-- Item #7g. Write a query to display for each store its store ID, city, and country.
use sakila;
select
s.store_id,
b.city_id,
c.city,
c.country_id,
d.country
from store s
inner join address b on s.address_id = b.address_id
inner join city c on b.city_id = c.city_id
inner join country d on c.country_id =d.country_id;

-- Item #7h. List the top five genres in gross revenue in descending order. 
-- (Hint: you may need to use the following tables: category, film_category, inventory, payment, and rental.)
use sakila;
select 
r.rental_id,
i.inventory_id,
p.amount,
fc.category_id,
c.name
from rental r
inner join inventory i on r.inventory_id = i.inventory_id
inner join payment p on r.rental_id =p.rental_id
inner join film_category fc on fc.film_id = i.film_id
inner join category c on c.category_id = fc.category_id
group by c.name
order by p.amount desc
limit 5;

-- Item #8a. In your new role as an executive, you would like to have an easy way of viewing the Top five genres by gross revenue. 
-- Use the solution from the problem above to create a view. If you haven't solved 7h, you can substitute another query to create a view.
use sakila;
create view top_5 as 
select 
r.rental_id,
i.inventory_id,
p.amount,
fc.category_id,
c.name
from rental r
inner join inventory i on r.inventory_id = i.inventory_id
inner join payment p on r.rental_id =p.rental_id
inner join film_category fc on fc.film_id = i.film_id
inner join category c on c.category_id = fc.category_id
group by c.name
order by p.amount desc
limit 5;

-- Item #8b. How would you display the view that you created in 8a?
select * from top_5;

-- Item #8c. You find that you no longer need the view top_five_genres. Write a query to delete it.
use sakila;
drop view top_5;