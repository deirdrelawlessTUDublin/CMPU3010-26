-- ============================================================
-- CMPU 3010 Databases 2
-- CommunityCare Database
-- Lab 1 - Sample Data
-- ============================================================

-- Use the CommunityCare schema for all unqualified object names
-- in this script.
SET search_path TO communitycare;

-- ============================================================
-- CENTRES
-- ============================================================

INSERT INTO centre (centre_name, address, phone)
VALUES
('Riverside Health Centre', '14 River Road, Dublin', '01-555-1001'),
('Oakwood Health Centre', '27 Oakwood Avenue, Dublin', '01-555-1002'),
('City Community Clinic', '8 Market Street, Dublin', '01-555-1003');


-- ============================================================
-- SERVICES
-- ============================================================

INSERT INTO service
    (service_name, duration_minutes, standard_fee)
VALUES
('Physiotherapy',       45, 65.00),
('Dietitian',           60, 70.00),
('General Consultation',30, 50.00),
('Counselling',         60, 75.00),
('Occupational Therapy',60, 70.00),
('Health Screening',    30, 45.00);


-- ============================================================
-- STAFF
-- ============================================================

INSERT INTO staff
    (centre_id, first_name, last_name, role, email)
VALUES
(1, 'Aoife',   'Murphy',   'Physiotherapist',
    'aoife.murphy@communitycare.ie'),

(1, 'Conor',   'Byrne',    'General Practitioner',
    'conor.byrne@communitycare.ie'),

(1, 'Niamh',   'Kelly',    'Dietitian',
    'niamh.kelly@communitycare.ie'),

(2, 'Sarah',   'Doyle',    'Physiotherapist',
    'sarah.doyle@communitycare.ie'),

(2, 'David',   'Ryan',     'Counsellor',
    'david.ryan@communitycare.ie'),

(2, 'Laura',   'Walsh',    'Occupational Therapist',
    'laura.walsh@communitycare.ie'),

(3, 'Michael', 'O''Brien', 'General Practitioner',
    'michael.obrien@communitycare.ie'),

(3, 'Emma',    'Nolan',    'Physiotherapist',
    'emma.nolan@communitycare.ie'),

(3, 'Patrick', 'Flynn',    'Counsellor',
    'patrick.flynn@communitycare.ie'),

(3, 'Rachel',  'Quinn',    'Nurse',
    'rachel.quinn@communitycare.ie');


-- ============================================================
-- STAFF / SERVICE RELATIONSHIPS
-- ============================================================

INSERT INTO staff_service (staff_id, service_id)
VALUES
(1,1),
(1,6),

(2,3),
(2,6),

(3,2),

(4,1),

(5,4),

(6,5),

(7,3),
(7,6),

(8,1),

(9,4),

(10,6);


-- ============================================================
-- PATIENTS
-- All data is fictional/synthetic.
-- ============================================================

INSERT INTO patient
    (first_name, last_name, email, phone,
     date_of_birth, registered_date)
VALUES
('Jack',    'Brennan',  'jack.brennan@example.com',
 '087-555-0101', '1985-03-12', '2025-01-10'),

('Emily',   'Dunne',    'emily.dunne@example.com',
 '087-555-0102', '1992-07-21', '2025-01-15'),

('Daniel',  'Murray',   'daniel.murray@example.com',
 '087-555-0103', '1978-11-04', '2025-02-01'),

('Sophie',  'Kavanagh', 'sophie.kavanagh@example.com',
 '087-555-0104', '2000-05-17', '2025-02-10'),

('Adam',    'Reilly',   'adam.reilly@example.com',
 '087-555-0105', '1969-09-30', '2025-03-04'),

('Grace',   'Fitzgerald','grace.fitzgerald@example.com',
 '087-555-0106', '1988-01-14', '2025-03-12'),

('Luke',    'Casey',    'luke.casey@example.com',
 '087-555-0107', '1995-06-08', '2025-04-01'),

('Ella',    'McCarthy', 'ella.mccarthy@example.com',
 '087-555-0108', '1983-12-19', '2025-04-16'),

('James',   'Kennedy',  'james.kennedy@example.com',
 '087-555-0109', '1975-04-27', '2025-05-03'),

('Chloe',   'Lynch',    'chloe.lynch@example.com',
 '087-555-0110', '1998-08-11', '2025-05-22'),

('Sean',    'Gallagher','sean.gallagher@example.com',
 '087-555-0111', '1990-02-05', '2025-06-07'),

('Lucy',    'Power',    'lucy.power@example.com',
 '087-555-0112', '1986-10-23', '2025-06-20'),

('Tom',     'Hayes',    'tom.hayes@example.com',
 '087-555-0113', '1958-07-07', '2025-07-05'),

('Anna',    'Clarke',   'anna.clarke@example.com',
 '087-555-0114', '2001-03-16', '2025-07-14'),

('Mark',    'Duffy',    'mark.duffy@example.com',
 '087-555-0115', '1981-09-09', '2025-08-01'),

('Kate',    'Moore',    'kate.moore@example.com',
 '087-555-0116', '1993-11-28', '2025-08-18'),

('Brian',   'Connolly', 'brian.connolly@example.com',
 '087-555-0117', '1972-05-13', '2025-09-02'),

('Amy',     'Ward',     'amy.ward@example.com',
 NULL, '1997-01-25', '2025-09-12'),

('Kevin',   'Burke',    'kevin.burke@example.com',
 '087-555-0119', '1989-06-15', '2025-10-01'),

('Orla',    'Martin',   'orla.martin@example.com',
 '087-555-0120', '1994-04-03', '2025-10-11');


-- ============================================================
-- APPOINTMENTS
--
-- Includes:
--   completed appointments
--   cancellations
--   no-shows
--   future/scheduled appointments
--   repeat patients
--
-- This gives students useful data for SQL investigation.
-- ============================================================

INSERT INTO appointment
(patient_id, staff_id, service_id,
 appointment_date, appointment_time, status)
VALUES

-- January
(1,  1, 1, '2026-01-08', '09:00', 'Completed'),
(2,  2, 3, '2026-01-08', '10:00', 'Completed'),
(3,  3, 2, '2026-01-09', '09:30', 'Completed'),
(4,  1, 1, '2026-01-10', '11:00', 'Cancelled'),
(5,  2, 3, '2026-01-12', '14:00', 'Completed'),
(6,  4, 1, '2026-01-13', '09:00', 'Completed'),
(7,  5, 4, '2026-01-13', '10:30', 'Completed'),
(8,  6, 5, '2026-01-14', '11:00', 'No Show'),

-- February
(1,  1, 1, '2026-02-03', '09:00', 'Completed'),
(2,  3, 2, '2026-02-03', '10:00', 'Completed'),
(3,  7, 3, '2026-02-04', '09:30', 'Completed'),
(9,  8, 1, '2026-02-05', '11:00', 'Completed'),
(10, 9, 4, '2026-02-06', '14:00', 'Cancelled'),
(11, 7, 3, '2026-02-09', '10:00', 'Completed'),
(12,10, 6, '2026-02-10', '11:30', 'Completed'),
(13, 4, 1, '2026-02-11', '09:00', 'Completed'),

-- March
(4,  1, 1, '2026-03-02', '09:00', 'Completed'),
(5,  2, 3, '2026-03-02', '10:30', 'Completed'),
(6,  3, 2, '2026-03-03', '11:00', 'Completed'),
(7,  5, 4, '2026-03-04', '13:00', 'Completed'),
(8,  6, 5, '2026-03-05', '09:30', 'Completed'),
(9,  8, 1, '2026-03-06', '10:00', 'Cancelled'),
(10, 9, 4, '2026-03-09', '14:00', 'Completed'),
(11, 7, 3, '2026-03-10', '09:00', 'No Show'),

-- April
(1,  1, 1, '2026-04-01', '09:00', 'Completed'),
(2,  3, 2, '2026-04-01', '10:00', 'Completed'),
(12,10, 6, '2026-04-02', '11:00', 'Completed'),
(13, 4, 1, '2026-04-03', '09:30', 'Completed'),
(14, 5, 4, '2026-04-07', '14:00', 'Cancelled'),
(15, 6, 5, '2026-04-08', '10:00', 'Completed'),
(3,  7, 3, '2026-04-09', '11:30', 'Completed'),
(4,  8, 1, '2026-04-10', '09:00', 'Completed'),

-- May
(5,  2, 3, '2026-05-04', '09:00', 'Completed'),
(6,  3, 2, '2026-05-05', '10:00', 'Completed'),
(7,  5, 4, '2026-05-06', '11:00', 'Completed'),
(8,  6, 5, '2026-05-07', '13:00', 'Completed'),
(9,  8, 1, '2026-05-08', '09:30', 'Completed'),
(10, 9, 4, '2026-05-11', '14:00', 'No Show'),

-- September - useful for current semester examples
(1,  1, 1, '2026-09-14', '09:00', 'Scheduled'),
(2,  2, 3, '2026-09-14', '10:00', 'Scheduled'),
(3,  3, 2, '2026-09-14', '11:00', 'Scheduled'),
(4,  4, 1, '2026-09-15', '09:00', 'Scheduled'),
(5,  5, 4, '2026-09-15', '10:00', 'Scheduled'),
(6,  6, 5, '2026-09-15', '11:00', 'Scheduled'),
(7,  7, 3, '2026-09-16', '09:30', 'Scheduled'),
(8,  8, 1, '2026-09-16', '10:30', 'Scheduled'),
(9,  9, 4, '2026-09-17', '11:00', 'Scheduled'),
(10,10, 6, '2026-09-18', '09:00', 'Scheduled');


-- ============================================================
-- PAYMENTS
--
-- Deliberately not every appointment has a payment.
-- This makes OUTER JOIN questions useful.
-- ============================================================

INSERT INTO payment
(appointment_id, amount, payment_date,
 payment_method, payment_status)
VALUES
(1,  65.00, '2026-01-08', 'Card',   'Paid'),
(2,  50.00, '2026-01-08', 'Card',   'Paid'),
(3,  70.00, '2026-01-09', 'Online', 'Paid'),
(5,  50.00, '2026-01-12', 'Cash',   'Paid'),
(6,  65.00, '2026-01-13', 'Card',   'Paid'),
(7,  75.00, '2026-01-13', 'Online', 'Paid'),

(9,  65.00, '2026-02-03', 'Card',   'Paid'),
(10, 70.00, '2026-02-03', 'Card',   'Paid'),
(11, 50.00, '2026-02-04', 'Online', 'Paid'),
(12, 65.00, '2026-02-05', 'Card',   'Paid'),
(14, 50.00, '2026-02-09', 'Cash',   'Paid'),
(15, 45.00, '2026-02-10', 'Card',   'Paid'),

(17, 65.00, '2026-03-02', 'Card',   'Paid'),
(18, 50.00, '2026-03-02', 'Online', 'Paid'),
(19, 70.00, '2026-03-03', 'Card',   'Paid'),
(20, 75.00, '2026-03-04', 'Card',   'Paid'),
(21, 70.00, '2026-03-05', 'Online', 'Paid'),
(23, 75.00, '2026-03-09', 'Cash',   'Paid'),

(25, 65.00, '2026-04-01', 'Card',   'Paid'),
(26, 70.00, '2026-04-01', 'Online', 'Paid'),
(27, 45.00, '2026-04-02', 'Card',   'Paid'),
(28, 65.00, '2026-04-03', 'Card',   'Paid'),
(30, 70.00, '2026-04-08', 'Online', 'Paid'),
(31, 50.00, '2026-04-09', 'Cash',   'Paid'),

-- Future appointments awaiting payment
(41, 65.00, NULL, NULL, 'Pending'),
(42, 50.00, NULL, NULL, 'Pending'),
(43, 70.00, NULL, NULL, 'Pending');