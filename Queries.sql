-- QUESTION 1
-- Who are the top 10 most active customers based on film rentals?
-- searching for the most active customers using the total amount of movies rented

WITH customerrentalcounts AS (
    SELECT
        c.customer_id,
        concat(c.first_name, ' ', c.last_name) AS customer_name,
        count(r.rental_id) AS rental_per_customer,
        rank() OVER (ORDER BY count(r.rental_id) DESC) AS customer_rank
    FROM
        customer c
        JOIN rental r ON c.customer_id = r.customer_id
    GROUP BY
        c.customer_id,
        customer_name
)
SELECT
    customer_id,
    customer_name,
    rental_per_customer
FROM
    customerrentalcounts
WHERE
    customer_rank <= 10
ORDER BY
    customer_rank;
	
-- QUESTION 2
-- How does the trend of revenue and customer count change over time?
-- next i will be searching for the revenue and customer count over time
	
    WITH monthlyrevenue AS (
        SELECT
            date_trunc('month', p.payment_date) AS payment_month,
            sum(p.amount) AS monthly_revenue,
            count(p.customer_id) AS monthly_customer_count
        FROM
            payment p
        GROUP BY
            payment_month
)
    SELECT
        coalesce(mr.payment_month) AS time_period,
    coalesce(mr.monthly_revenue, 0) AS monthly_revenue,
    coalesce(mr.monthly_customer_count, 0) AS monthly_customer_count
FROM
    monthlyrevenue mr
ORDER BY
    time_period;
	
-- QUESTION 3
-- What is the average rental rate based on language and rating of the film?
-- now i'd like to see the the average rental rate by language and rating

SELECT
    language_name,
    rating,
    avg(rental_rate) AS avg_rental_rate
FROM (
    SELECT
        l.name AS language_name,
        f.rating,
        f.rental_rate
    FROM
        film f
        JOIN rental r ON f.film_id = r.inventory_id
        JOIN
        LANGUAGE l
        ON f.language_id = l.language_id) AS filmrentalstats
GROUP BY
    language_name,
    rating
ORDER BY
    language_name,
    rating;

-- QUESTION 4
-- How does the different countries perform based revenue, rental counts and customer counts?
-- checking for country performance

WITH countrystat AS (
    SELECT
        c.country,
        sum(p.amount) AS total_revenue,
        count(DISTINCT r.rental_id) AS rentals,
        count(DISTINCT cu.customer_id) AS customers
    FROM
        country c
        JOIN city ci ON c.country_id = ci.country_id
        JOIN address a ON ci.city_id = a.city_id
        JOIN customer cu ON a.address_id = cu.address_id
        JOIN rental r ON cu.customer_id = r.customer_id
        JOIN payment p ON r.rental_id = p.rental_id
    GROUP BY
        c.country
)
SELECT
    country,
    total_revenue,
    rentals,
    customers,
    rank() OVER (ORDER BY total_revenue DESC) AS revenue_rank,
        rank() OVER (ORDER BY rentals DESC) AS rental_rank,
            rank() OVER (ORDER BY customers DESC) customer_rank
            FROM
                countrystat
            ORDER BY
                country,
                total_revenue,
                customers DESC;
