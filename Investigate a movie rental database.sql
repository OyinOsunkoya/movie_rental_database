/*12- Question Set 1*/
/*Question 1*/
/*What were the total rental orders for family movies?*/
SELECT sub.title film_title, sub.category category_name,
        COUNT(*) AS rental_count
FROM (
        SELECT f.title title, c.name category, i.inventory_id
        FROM film f
        JOIN film_category fc
        ON f.film_id = fc.film_id
        JOIN category c
        ON c.category_id = fc.category_id
        JOIN inventory i
        ON i.film_id = f.film_id
        WHERE c.name IN ('Animation', 'Children', 'Classics', 'Comedy', 'Family', 'Music')
        ORDER BY title
      ) sub
JOIN rental r
ON sub.inventory_id=r.inventory_id
GROUP BY 1,2
ORDER BY sub.category, sub.title;


/*Question 2*/
/*Dividing movies into quartiles by rental duration, what is the average rental duration? */
SELECT quartile, AVG(rental_duration) AS avg_rental_duration,
      COUNT(*) AS rental_count
FROM (
      SELECT f.title title, c.name category, f.rental_duration rental_duration,
             NTILE(4) OVER (ORDER BY f.rental_duration) AS quartile
      FROM film f
      JOIN film_category fc
      ON f.film_id = fc.film_id
      JOIN category c
      ON c.category_id = fc.category_id
      WHERE c.name IN ('Animation', 'Children', 'Classics', 'Comedy', 'Family', 'Music')
      ORDER BY title
    ) sub
GROUP BY 1
ORDER BY 1;


/*Question 3*/
/*Dividing movies into quartiles by rental duration, are less movies rented in the
 lower rental duration category? If yes, for which categories of family movies?*/
SELECT sub.category category, sub.quartile standard_quartile,
       COUNT(*)
FROM (
      SELECT f.title title, c.name category, f.rental_duration rental_duration,
             NTILE(4) OVER (ORDER BY f.rental_duration) AS quartile
      FROM film f
      JOIN film_category fc
      ON f.film_id = fc.film_id
      JOIN category c
      ON c.category_id = fc.category_id
      WHERE c.name IN ('Animation', 'Children', 'Classics', 'Comedy', 'Family', 'Music')
    ) sub
GROUP BY 1,2
ORDER BY 1,2;

/*Question 4*/
/*In which store and in what month and year was the highest number of rentals recorded?*/
SELECT DATE_PART('month', r.rental_date) AS rental_month,
       DATE_PART('year', r.rental_date) AS rental_year,
       s.store_id, COUNT(*) AS count_rentals
FROM rental r
JOIN payment p
ON r.rental_id = p.rental_id
AND r.customer_id = p.customer_id
JOIN staff st
ON p.staff_id = st.staff_id
JOIN store s
ON st.store_id = s.store_id
GROUP BY 1,2,3
ORDER BY count_rentals DESC;
