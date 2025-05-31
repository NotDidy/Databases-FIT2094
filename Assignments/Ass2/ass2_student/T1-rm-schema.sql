/*****PLEASE ENTER YOUR DETAILS BELOW*****/
--T1-rm-schema.sql

--Student ID: 33523061
--Student Name: MUHAMMAD JOHAN ARIEF BIN MULIADEE

/* Comments for your marker:




*/

/* drop table statements - do not remove*/

DROP TABLE competitor CASCADE CONSTRAINTS PURGE;

DROP TABLE entry CASCADE CONSTRAINTS PURGE;

DROP TABLE team CASCADE CONSTRAINTS PURGE;

/* end of drop table statements*/

-- Task 1 Add Create table statements for the Missing TABLES below.
-- Ensure all column comments, and constraints (other than FK's)are included.
-- FK constraints are to be added at the end of this script

-- COMPETITOR
CREATE TABLE competitor (
    comp_no NUMBER(5) PRIMARY KEY,
    comp_fname VARCHAR2(30) ,
    comp_lname VARCHAR2(30) ,
    comp_gender CHAR(1) CHECK (comp_gender IN ('M', 'F', 'U')),
    comp_dob DATE NOT NULL,
    comp_email VARCHAR2(50) UNIQUE NOT NULL,
    comp_unistatus CHAR(1) CHECK (comp_unistatus IN ('Y', 'N')),
    comp_phone CHAR(10) UNIQUE NOT NULL

    )

COMMENT ON COLUMN COMPETITOR.comp_no IS 'Unique identifier for a competitor';
COMMENT ON COLUMN COMPETITOR.comp_fname IS 'Competitor''s first name';
COMMENT ON COLUMN COMPETITOR.comp_lname IS 'Competitor''s last name';
COMMENT ON COLUMN COMPETITOR.comp_gender IS 'Competitor''s gender (M, F, or U)';
COMMENT ON COLUMN COMPETITOR.comp_dob IS 'Competitor''s date of birth';
COMMENT ON COLUMN COMPETITOR.comp_email IS 'Competitor''s email - unique for each competitor';
COMMENT ON COLUMN COMPETITOR.comp_unistatus IS 'Competitor is a university student/staff (Y or N)';
COMMENT ON COLUMN COMPETITOR.comp_phone IS 'Competitor''s phone number - unique for each competitor';


--ENTRY



--TEAM



-- Add all missing FK Constraints below here
