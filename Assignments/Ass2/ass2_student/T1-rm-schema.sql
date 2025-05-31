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
CREATE TABLE COMPETITOR (
    comp_no NUMBER(5) PRIMARY KEY,
    comp_fname VARCHAR2(30),
    comp_lname VARCHAR2(30),
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
CREATE TABLE ENTRY (
    entry_no NUMBER(5),
    event_id NUMBER(6) NOT NULL,
    entry_starttime DATE,
    entry_finishtime DATE,
    entry_elapsedtime DATE,
    comp_no NUMBER(5) NOT NULL,
    team_id NUMBER(3),
    char_id NUMBER(3),
    PRIMARY KEY (entry_no, event_id)
    
);

COMMENT ON COLUMN ENTRY.entry_no IS 'Entry number (unique only within an event)';
COMMENT ON COLUMN ENTRY.event_id IS 'ID of the event the entry is for';
COMMENT ON COLUMN ENTRY.comp_no IS 'Competitor''s ID entering the event';
COMMENT ON COLUMN ENTRY.entry_starttime IS 'Entrant''s start time (hh24:mi:ss)';
COMMENT ON COLUMN ENTRY.entry_finishtime IS 'Entrant''s finish time (hh24:mi:ss)';
COMMENT ON COLUMN ENTRY.entry_elapsedtime IS 'Elapsed time to complete the event (hh24:mi:ss)';


--TEAM
CREATE TABLE TEAM (
    team_id NUMBER(3) PRIMARY KEY,
    team_name VARCHAR2(30) NOT NULL,
    carn_date DATE UNIQUE NOT NULL,
    event_id NUMBER(6) NOT NULL,
    entry_no NUMBER(5) NOT NULL
);

COMMENT ON COLUMN TEAM.team_id IS 'Team identifier (unique)';
COMMENT ON COLUMN TEAM.team_name IS 'Team name';
COMMENT ON COLUMN TEAM.carnival_id IS 'ID of the carnival the team is in';
COMMENT ON COLUMN TEAM.team_leader_comp_no IS 'Competitor number of the team leader';



-- Add all missing FK Constraints below here

-- ENTRY Table Foreign Keys
ALTER TABLE ENTRY 
    ADD CONSTRAINT fk_entry_comp
        FOREIGN KEY (comp_no) REFERENCES COMPETITOR(comp_no);

ALTER TABLE ENTRY
    ADD CONSTRAINT fk_entry_event
        FOREIGN KEY (event_id) REFERENCES EVENT(event_id);

ALTER TABLE ENTRY
    ADD CONSTRAINT fk_entry_team
        FOREIGN KEY (team_id) REFERENCES TEAM(team_id);

ALTER TABLE ENTRY
    ADD CONSTRAINT fk_entry_charity
        FOREIGN KEY (char_id) REFERENCES CHARITY(char_id);

-- TEAM Table Foreign Keys
ALTER TABLE TEAM 
    ADD CONSTRAINT fk_team_carnival
        FOREIGN KEY (carn_date) REFERENCES CARNIVAL(carn_date);
ALTER TABLE TEAM
    ADD CONSTRAINT fk_team_event
        FOREIGN KEY (event_id) REFERENCES EVENT(event_id);
ALTER TABLE TEAM
    ADD CONSTRAINT fk_team_entry
        FOREIGN KEY (entry_no) REFERENCES ENTRY(entry_no);
