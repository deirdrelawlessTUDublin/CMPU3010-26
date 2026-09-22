/*
    CMPU3010 Databases
    Lecture 2: SQL Subqueries

    Companion SQL for: L2-Subqueries.pptx
    Case study: CommunityCare

    The examples are arranged in slide order. Each section identifies the
    relevant slide and explains the purpose of the query.
*/

-- Work with the CommunityCare schema throughout this script.
SET search_path TO communitycare, public;


/* -------------------------------------------------------------------------
   Slide 3: What is a subquery?

   The scalar subquery calculates the average service fee. The outer query
   returns services whose standard fee is greater than that average.
   ------------------------------------------------------------------------- */

SELECT service_name,
       standard_fee
FROM service
WHERE standard_fee > (
    SELECT AVG(standard_fee)
    FROM service
);


/* -------------------------------------------------------------------------
   Slide 5: Simple subquery

   The subquery runs independently and returns the IDs of patients who have
   completed appointments. IN allows the outer query to use multiple IDs.
   ------------------------------------------------------------------------- */

SELECT patient_id,
       first_name,
       last_name
FROM patient
WHERE patient_id IN (
    SELECT patient_id
    FROM appointment
    WHERE status = 'Completed'
);

-- Run the inner query separately to inspect the list used by the outer query.
SELECT patient_id
FROM appointment
WHERE status = 'Completed';


/* -------------------------------------------------------------------------
   Slide 6: IN with a subquery

   The inner scalar subquery finds the ID for Physiotherapy. The enclosing
   subquery finds staff linked to that service, and the outer query returns
   the details of those staff members.
   ------------------------------------------------------------------------- */

SELECT staff_id,
       first_name,
       last_name
FROM staff
WHERE staff_id IN (
    SELECT ss.staff_id
    FROM staff_service AS ss
    WHERE ss.service_id = (
        SELECT service_id
        FROM service
        WHERE service_name = 'Physiotherapy'
    )
);


/* -------------------------------------------------------------------------
   Slide 7: Scalar subquery in a WHERE clause

   A scalar subquery returns no more than one row and one column. Here it
   returns the overall average service fee.
   ------------------------------------------------------------------------- */

SELECT service_name,
       standard_fee
FROM service
WHERE standard_fee > (
    SELECT AVG(standard_fee)
    FROM service
);


/* -------------------------------------------------------------------------
   Slide 7: Scalar subquery in a SELECT list

   The same overall average appears beside every service. The scalar subquery
   produces one value that the outer query can display for each row.
   ------------------------------------------------------------------------- */

SELECT service_name,
       standard_fee,
       (
           SELECT ROUND(AVG(standard_fee), 2)
           FROM service
       ) AS average_fee
FROM service;


/* -------------------------------------------------------------------------
   Slide 8: Scalar subquery error

   The query shown below is intentionally commented out. The appointment
   subquery normally returns several service IDs, but = expects one value.
   PostgreSQL therefore reports that the scalar subquery returned more than
   one row.
   ------------------------------------------------------------------------- */

/*
SELECT service_name
FROM service
WHERE service_id = (
    SELECT service_id
    FROM appointment
);
*/

-- Corrected version: IN accepts the multiple service IDs from the subquery.
SELECT service_name
FROM service
WHERE service_id IN (
    SELECT service_id
    FROM appointment
);


/* -------------------------------------------------------------------------
   Slide 9: Correlated scalar subquery

   The subquery refers to p.patient_id from the current row of the outer
   query. It therefore calculates a separate appointment count per patient.
   COUNT(*) returns 0 when a patient has no matching appointments.
   ------------------------------------------------------------------------- */

SELECT p.patient_id,
       p.first_name,
       p.last_name,
       (
           SELECT COUNT(*)
           FROM appointment AS a
           WHERE a.patient_id = p.patient_id
       ) AS appointment_count
FROM patient AS p
ORDER BY p.last_name,
         p.first_name;


/* -------------------------------------------------------------------------
   Slide 10: Correlated subquery with EXISTS

   This query finds patients who HAVE at least one cancelled appointment.
   The wording on Slide 10 says "never cancelled", but EXISTS gives the
   opposite result. SELECT 1 is conventional because EXISTS only checks
   whether a matching row is present.
   ------------------------------------------------------------------------- */

SELECT p.patient_id,
       p.first_name,
       p.last_name
FROM patient AS p
WHERE EXISTS (
    SELECT 1
    FROM appointment AS a
    WHERE a.patient_id = p.patient_id
      AND a.status = 'Cancelled'
);

-- Use NOT EXISTS if the intended question is:
-- "Which patients have never cancelled an appointment?"
SELECT p.patient_id,
       p.first_name,
       p.last_name
FROM patient AS p
WHERE NOT EXISTS (
    SELECT 1
    FROM appointment AS a
    WHERE a.patient_id = p.patient_id
      AND a.status = 'Cancelled'
);


/* -------------------------------------------------------------------------
   Slide 11: Correlated subquery with NOT EXISTS

   Find patients who have never had an appointment. The status condition
   displayed on Slide 11 has been removed because it would only identify
   patients with no cancelled appointments.
   ------------------------------------------------------------------------- */

SELECT p.patient_id,
       p.first_name,
       p.last_name
FROM patient AS p
WHERE NOT EXISTS (
    SELECT 1
    FROM appointment AS a
    WHERE a.patient_id = p.patient_id
);


/* -------------------------------------------------------------------------
   Slide 12: Correlated comparison

   The first subquery counts appointments for the current service. The second
   calculates the average appointment count among services that have at least
   one appointment. The outer query returns services above that average.
   ------------------------------------------------------------------------- */

SELECT s.service_id,
       s.service_name
FROM service AS s
WHERE (
    SELECT COUNT(*)
    FROM appointment AS a
    WHERE a.service_id = s.service_id
) > (
    SELECT AVG(service_total)
    FROM (
        SELECT COUNT(*) AS service_total
        FROM appointment
        GROUP BY service_id
    ) AS service_counts
);

