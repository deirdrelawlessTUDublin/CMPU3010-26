-- ============================================================
-- CMPU 3010 Databases 2
-- CommunityCare Database
-- Lab 1 - Database Schema
-- ============================================================

-- Create the schema used by the CommunityCare application.
CREATE SCHEMA IF NOT EXISTS communitycare;

-- Use the CommunityCare schema for all unqualified object names
-- in this script.
SET search_path TO communitycare;

-- Remove existing tables if the script is run again.
-- Tables are dropped in reverse dependency order.

DROP TABLE IF EXISTS payment;
DROP TABLE IF EXISTS appointment;
DROP TABLE IF EXISTS staff_service;
DROP TABLE IF EXISTS service;
DROP TABLE IF EXISTS staff;
DROP TABLE IF EXISTS patient;
DROP TABLE IF EXISTS centre;


-- ============================================================
-- CENTRE
-- CommunityCare operates a number of healthcare centres.
-- ============================================================

CREATE TABLE centre (
    centre_id       INTEGER GENERATED ALWAYS AS IDENTITY,
    centre_name     VARCHAR(100) NOT NULL,
    address         VARCHAR(200) NOT NULL,
    phone           VARCHAR(20),

    CONSTRAINT pk_centre
        PRIMARY KEY (centre_id),

    CONSTRAINT uq_centre_name
        UNIQUE (centre_name)
);


-- ============================================================
-- PATIENT
-- Stores patients registered with CommunityCare.
-- ============================================================

CREATE TABLE patient (
    patient_id      INTEGER GENERATED ALWAYS AS IDENTITY,
    first_name      VARCHAR(50) NOT NULL,
    last_name       VARCHAR(50) NOT NULL,
    email           VARCHAR(100),
    phone           VARCHAR(20),
    date_of_birth   DATE NOT NULL,
    registered_date DATE NOT NULL DEFAULT CURRENT_DATE,

    CONSTRAINT pk_patient
        PRIMARY KEY (patient_id),

    CONSTRAINT uq_patient_email
        UNIQUE (email)
);


-- ============================================================
-- STAFF
-- Each staff member is currently associated with one centre.
--
-- This is deliberately a relatively simple model.
-- CommunityCare's requirements will evolve during the module.
-- ============================================================

CREATE TABLE staff (
    staff_id        INTEGER GENERATED ALWAYS AS IDENTITY,
    centre_id       INTEGER NOT NULL,
    first_name      VARCHAR(50) NOT NULL,
    last_name       VARCHAR(50) NOT NULL,
    role            VARCHAR(50) NOT NULL,
    email           VARCHAR(100) NOT NULL,

    CONSTRAINT pk_staff
        PRIMARY KEY (staff_id),

    CONSTRAINT uq_staff_email
        UNIQUE (email),

    CONSTRAINT fk_staff_centre
        FOREIGN KEY (centre_id)
        REFERENCES centre(centre_id)
);


-- ============================================================
-- SERVICE
-- Services offered by CommunityCare.
-- ============================================================

CREATE TABLE service (
    service_id      INTEGER GENERATED ALWAYS AS IDENTITY,
    service_name    VARCHAR(100) NOT NULL,
    duration_minutes INTEGER NOT NULL,
    standard_fee    NUMERIC(8,2) NOT NULL,

    CONSTRAINT pk_service
        PRIMARY KEY (service_id),

    CONSTRAINT uq_service_name
        UNIQUE (service_name),

    CONSTRAINT chk_service_duration
        CHECK (duration_minutes > 0),

    CONSTRAINT chk_service_fee
        CHECK (standard_fee >= 0)
);


-- ============================================================
-- STAFF_SERVICE
-- A staff member may provide several services.
-- A service may be provided by several staff members.
-- ============================================================

CREATE TABLE staff_service (
    staff_id        INTEGER NOT NULL,
    service_id      INTEGER NOT NULL,

    CONSTRAINT pk_staff_service
        PRIMARY KEY (staff_id, service_id),

    CONSTRAINT fk_staff_service_staff
        FOREIGN KEY (staff_id)
        REFERENCES staff(staff_id),

    CONSTRAINT fk_staff_service_service
        FOREIGN KEY (service_id)
        REFERENCES service(service_id)
);


-- ============================================================
-- APPOINTMENT
-- Records appointments between patients and staff.
-- ============================================================

CREATE TABLE appointment (
    appointment_id   INTEGER GENERATED ALWAYS AS IDENTITY,
    patient_id       INTEGER NOT NULL,
    staff_id         INTEGER NOT NULL,
    service_id       INTEGER NOT NULL,
    appointment_date DATE NOT NULL,
    appointment_time TIME NOT NULL,
    status           VARCHAR(20) NOT NULL DEFAULT 'Scheduled',
    notes            VARCHAR(500),

    CONSTRAINT pk_appointment
        PRIMARY KEY (appointment_id),

    CONSTRAINT fk_appointment_patient
        FOREIGN KEY (patient_id)
        REFERENCES patient(patient_id),

    CONSTRAINT fk_appointment_staff
        FOREIGN KEY (staff_id)
        REFERENCES staff(staff_id),

    CONSTRAINT fk_appointment_service
        FOREIGN KEY (service_id)
        REFERENCES service(service_id),

    CONSTRAINT chk_appointment_status
        CHECK (
            status IN (
                'Scheduled',
                'Completed',
                'Cancelled',
                'No Show'
            )
        ),

    -- A member of staff cannot have two appointments
    -- beginning at exactly the same date and time.
    CONSTRAINT uq_staff_appointment
        UNIQUE (
            staff_id,
            appointment_date,
            appointment_time
        )
);


-- ============================================================
-- PAYMENT
-- An appointment may have a payment associated with it.
-- Some appointments may therefore have no payment record.
-- ============================================================

CREATE TABLE payment (
    payment_id       INTEGER GENERATED ALWAYS AS IDENTITY,
    appointment_id   INTEGER NOT NULL,
    amount            NUMERIC(8,2) NOT NULL,
    payment_date      DATE,
    payment_method    VARCHAR(20),
    payment_status    VARCHAR(20) NOT NULL,

    CONSTRAINT pk_payment
        PRIMARY KEY (payment_id),

    CONSTRAINT uq_payment_appointment
        UNIQUE (appointment_id),

    CONSTRAINT fk_payment_appointment
        FOREIGN KEY (appointment_id)
        REFERENCES appointment(appointment_id),

    CONSTRAINT chk_payment_amount
        CHECK (amount >= 0),

    CONSTRAINT chk_payment_status
        CHECK (
            payment_status IN (
                'Pending',
                'Paid',
                'Refunded'
            )
        ),

    CONSTRAINT chk_payment_method
        CHECK (
            payment_method IS NULL
            OR payment_method IN (
                'Card',
                'Cash',
                'Online'
            )
        )
);