ALTER ROLE postgres
SET search_path TO communitycare, public;

SELECT patient_id, appointment_date, 
     LAG(appointment_date) 
     OVER 
   ( PARTITION BY patient_id ORDER BY appointment_date ) AS previous_appointment 
     FROM appointment 
ORDER BY patient_id, appointment_date;

set search_path to communitycare;
EXPLAIN analyse (SELECT
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
    a.appointment_date);
