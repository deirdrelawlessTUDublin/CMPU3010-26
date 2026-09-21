/*
    CMPU3010 Databases
    Lecture 2: Window Functions in PostgreSQL

    SQL examples used in L2-Window Functions(1).pptx.
    Slide numbers refer to that version of the presentation.
*/
-- Set CommunityCare as the default schema for future connections made using the postgres role.
-- PostgreSQL will search CommunityCare first and public second when an object name is not schema-qualified.
ALTER ROLE postgres
SET search_path TO communitycare, public;


-- Add a second appointment for Patient 1 on 14 September 2026.
-- This creates a tie on appointment_date for the ranking examples.
INSERT INTO appointment (
    patient_id,
    staff_id,
    service_id,
    appointment_date,
    appointment_time,
    status,
    notes
)
VALUES (
    1, 1, 1, '2026-09-14', '10:00', 'Completed', NULL
);

-- Add a later appointment for Patient 1.
-- This provides a following row for the LEAD() example.
INSERT INTO appointment (
    patient_id,
    staff_id,
    service_id,
    appointment_date,
    appointment_time,
    status,
    notes
)
VALUES (
    1, 1, 1, '2026-10-01', '09:00', 'Scheduled', NULL
);



/* ================================================================
   Slide 4: Previous appointment using a correlated subquery
   For each appointment, find the latest earlier appointment for
   the same patient.
   ================================================================ */

SELECT
    a.patient_id,
    a.appointment_date,
    (
        SELECT MAX(previous.appointment_date)
        FROM appointment previous
        WHERE previous.patient_id = a.patient_id
          AND previous.appointment_date < a.appointment_date
    ) AS previous_appointment
FROM appointment a
ORDER BY
    a.patient_id,
    a.appointment_date;


/* ================================================================
   Slide 5: Previous appointment using LAG()
   PARTITION BY keeps each patient's appointments separate.
   ORDER BY defines which appointment is previous.
   ================================================================ */

SELECT
    patient_id,
    appointment_date,
    LAG(appointment_date) OVER (
        PARTITION BY patient_id
        ORDER BY appointment_date
    ) AS previous_appointment
FROM appointment
ORDER BY
    patient_id,
    appointment_date;


/* ================================================================
   Slide 8: Appointment count using GROUP BY
   This produces one summary row for each patient.
   ================================================================ */

SELECT
    patient_id,
    COUNT(*) AS appointment_count
FROM appointment
GROUP BY patient_id
ORDER BY patient_id;


/* ================================================================
   Slide 9: Appointment count using a window aggregate
   Each appointment remains visible, while the patient-level count
   appears beside it.
   ================================================================ */

SELECT
    appointment_id,
    patient_id,
    appointment_date,
    COUNT(*) OVER (
        PARTITION BY patient_id
    ) AS appointment_count
FROM appointment
ORDER BY
    patient_id,
    appointment_date,
    appointment_id;


/* ================================================================
   Slide 11: General window-function pattern

   function_name(column_name) OVER (
       PARTITION BY grouping_column
       ORDER BY ordering_column
   )

   The selected columns should include the grouping column when it
   is needed to identify and interpret each partition. For the
   patient examples, this means selecting patient_id.
   ================================================================ */


/* ================================================================
   Slides 13-14: Basic ROW_NUMBER() pattern
   Number each patient's appointments in appointment-date order.
   ================================================================ */

SELECT
    appointment_id,
    patient_id,
    appointment_date,
    ROW_NUMBER() OVER (
        PARTITION BY patient_id
        ORDER BY appointment_date
    ) AS appointment_number
FROM appointment
ORDER BY
    patient_id,
    appointment_date,
    appointment_id;


/* ================================================================
   Slide 15: Deterministic appointment numbering
   Date, time and appointment ID provide an unambiguous order.
   ================================================================ */

SELECT
    appointment_id,
    patient_id,
    appointment_date,
    appointment_time,
    ROW_NUMBER() OVER (
        PARTITION BY patient_id
        ORDER BY
            appointment_date,
            appointment_time,
            appointment_id
    ) AS appointment_number
FROM appointment
ORDER BY
    patient_id,
    appointment_date,
    appointment_time,
    appointment_id;


/* ================================================================
   Slide 16: Rank appointments by date within each patient
   Appointments on the same date receive the same rank.
   ================================================================ */

SELECT
    appointment_id,
    patient_id,
    appointment_date,
    appointment_time,
    RANK() OVER (
        PARTITION BY patient_id
        ORDER BY appointment_date
    ) AS appointment_rank
FROM appointment
ORDER BY
    patient_id,
    appointment_date,
    appointment_time,
    appointment_id;


/* ================================================================
   Slide 17: Rank appointments using a complete chronological order
   appointment_id is the final tie-breaker. This corrects the
   repeated appointment_date in the slide's window ORDER BY.
   ================================================================ */

SELECT
    appointment_id,
    patient_id,
    appointment_date,
    appointment_time,
    RANK() OVER (
        PARTITION BY patient_id
        ORDER BY
            appointment_date,
            appointment_time,
            appointment_id
    ) AS appointment_rank
FROM appointment
ORDER BY
    patient_id,
    appointment_date,
    appointment_time,
    appointment_id;


/* ================================================================
   Slide 20: Compare ROW_NUMBER(), RANK() and DENSE_RANK()
   ROW_NUMBER() gives every appointment a unique number.
   RANK() leaves a gap after tied dates.
   DENSE_RANK() does not leave a gap after tied dates.
   ================================================================ */

SELECT
    p.first_name,
    p.last_name,
    a.appointment_id,
    a.appointment_date,
    a.appointment_time,
    ROW_NUMBER() OVER (
        PARTITION BY a.patient_id
        ORDER BY
            a.appointment_date,
            a.appointment_time,
            a.appointment_id
    ) AS row_number,
    RANK() OVER (
        PARTITION BY a.patient_id
        ORDER BY a.appointment_date
    ) AS appointment_rank,
    DENSE_RANK() OVER (
        PARTITION BY a.patient_id
        ORDER BY a.appointment_date
    ) AS dense_appointment_rank
FROM patient p
JOIN appointment a
    ON p.patient_id = a.patient_id
ORDER BY
    a.patient_id,
    a.appointment_date,
    a.appointment_time,
    a.appointment_id;


/* ================================================================
   Slide 21: Access the previous row using LAG()
   The first appointment in each patient partition returns NULL.
   ================================================================ */

SELECT
    patient_id,
    appointment_date,
    LAG(appointment_date) OVER (
        PARTITION BY patient_id
        ORDER BY
            appointment_date,
            appointment_time,
            appointment_id
    ) AS previous_appointment
FROM appointment
ORDER BY
    patient_id,
    appointment_date,
    appointment_time,
    appointment_id;


/* ================================================================
   Slide 23: Access the following row using LEAD()
   The final appointment in each patient partition returns NULL.
   ================================================================ */

SELECT
    patient_id,
    appointment_date,
    LEAD(appointment_date) OVER (
        PARTITION BY patient_id
        ORDER BY
            appointment_date,
            appointment_time,
            appointment_id
    ) AS next_appointment
FROM appointment
ORDER BY
    patient_id,
    appointment_date,
    appointment_time,
    appointment_id;


/* ================================================================
   Slide 25: General LAG() and LEAD() patterns

   LAG(column_name) OVER (
       PARTITION BY group_column
       ORDER BY sequence_column
   )

   LEAD(column_name) OVER (
       PARTITION BY group_column
       ORDER BY sequence_column
   )
   ================================================================ */


/* ================================================================
   Slide 27: Count appointments within each service
   The service count appears beside every individual appointment.
   ================================================================ */

SELECT
    appointment_id,
    service_id,
    appointment_date,
    COUNT(*) OVER (
        PARTITION BY service_id
    ) AS service_appointment_count
FROM appointment
ORDER BY
    service_id,
    appointment_date,
    appointment_id;


/* ================================================================
   Slide 28: Sum standard fees for each patient
   Only completed appointments participate in the calculation.
   ================================================================ */

SELECT
    a.appointment_id,
    a.patient_id,
    s.service_name,
    s.standard_fee,
    SUM(s.standard_fee) OVER (
        PARTITION BY a.patient_id
    ) AS total_standard_fees
FROM appointment a
JOIN service s
    ON a.service_id = s.service_id
WHERE a.status = 'Completed'
ORDER BY
    a.patient_id,
    a.appointment_date,
    a.appointment_id;


/* ================================================================
   Slide 29: Average standard fee for each patient
   The unrounded PostgreSQL average may contain several decimals.
   ================================================================ */

SELECT
    a.appointment_id,
    a.patient_id,
    s.service_name,
    s.standard_fee,
    AVG(s.standard_fee) OVER (
        PARTITION BY a.patient_id
    ) AS average_standard_fee
FROM appointment a
JOIN service s
    ON a.service_id = s.service_id
WHERE a.status = 'Completed'
ORDER BY
    a.patient_id,
    a.appointment_date,
    a.appointment_id;


/* ================================================================
   Slide 30: Round the window average to two decimal places
   ================================================================ */

SELECT
    a.appointment_id,
    a.patient_id,
    s.service_name,
    s.standard_fee,
    ROUND(
        AVG(s.standard_fee) OVER (
            PARTITION BY a.patient_id
        ),
        2
    ) AS average_standard_fee
FROM appointment a
JOIN service s
    ON a.service_id = s.service_id
WHERE a.status = 'Completed'
ORDER BY
    a.patient_id,
    a.appointment_date,
    a.appointment_id;


/* ================================================================
   Slide 31: Use several window aggregates in one query
   All three functions use the same patient partition while each
   completed appointment remains visible.
   ================================================================ */

SELECT
    a.appointment_id,
    a.patient_id,
    a.appointment_date,
    s.standard_fee,
    COUNT(*) OVER (
        PARTITION BY a.patient_id
    ) AS completed_appointment_count,
    SUM(s.standard_fee) OVER (
        PARTITION BY a.patient_id
    ) AS total_standard_fees,
    ROUND(
        AVG(s.standard_fee) OVER (
            PARTITION BY a.patient_id
        ),
        2
    ) AS average_standard_fee
FROM appointment a
JOIN service s
    ON a.service_id = s.service_id
WHERE a.status = 'Completed'
ORDER BY
    a.patient_id,
    a.appointment_date,
    a.appointment_id;


/* ================================================================
   Slide 32: Window ORDER BY reminder

   COUNT(*) OVER (PARTITION BY patient_id)
   SUM(standard_fee) OVER (PARTITION BY patient_id)
   AVG(standard_fee) OVER (PARTITION BY patient_id)

   These calculate a total or average for the complete partition.
   Adding ORDER BY changes the window behaviour and can produce a
   cumulative calculation.
   ================================================================ */
