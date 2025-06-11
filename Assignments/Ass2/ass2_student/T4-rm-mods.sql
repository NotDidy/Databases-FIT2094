-- T4-rm-mods.sql
-- Task 4: Database modifications for Run Monash
-- Student ID: 33523061
-- Student Name: MUHAMMAD JOHAN ARIEF BIN MULIADEE

-- a)

-- Added new column to COMPETITOR
ALTER TABLE COMPETITOR
  ADD comp_completed_events NUMBER(3);

-- Commented on new column
COMMENT ON COLUMN COMPETITOR.comp_completed_events IS
  'Number of completed events by competitor';

-- Populated new column based on existing data
UPDATE COMPETITOR c
   SET comp_completed_events = (
     SELECT COUNT(*)
       FROM ENTRY e
      WHERE e.comp_no = c.comp_no
        AND e.entry_finishtime IS NOT NULL
   );
COMMIT;

-- Structural change and sample data update
DESC COMPETITOR;
SELECT comp_no, comp_fname, comp_lname, comp_completed_events
  FROM COMPETITOR
 ORDER BY comp_no;

-- b)

-- Drop table statement
DROP TABLE ENTRY_CHARITY CASCADE CONSTRAINTS PURGE;

-- Created new table for entry-charity allocations
CREATE TABLE ENTRY_CHARITY (
    event_id   NUMBER(6) NOT NULL,
    entry_no   NUMBER(5) NOT NULL,
    char_id    NUMBER(3) NOT NULL,
    percentage NUMBER(3) NOT NULL CHECK (percentage BETWEEN 0 AND 100),

    -- Constraint declaration
    CONSTRAINT pk_entry_charity PRIMARY KEY (event_id, entry_no, char_id),
    CONSTRAINT fk_ec_entry FOREIGN KEY (event_id, entry_no)
      REFERENCES ENTRY (event_id, entry_no),
    CONSTRAINT fk_ec_charity FOREIGN KEY (char_id)
      REFERENCES CHARITY (char_id)
);

-- Commented on new table columns
COMMENT ON COLUMN ENTRY_CHARITY.event_id IS
  'Event ID for the entry allocation';
COMMENT ON COLUMN ENTRY_CHARITY.entry_no IS
  'Entry number for the event allocation';
COMMENT ON COLUMN ENTRY_CHARITY.char_id IS
  'Charity supported by the entry';
COMMENT ON COLUMN ENTRY_CHARITY.percentage IS
  'Percentage of funds allocated to the charity';

-- Migrated existing single-charity data into new table 
INSERT INTO ENTRY_CHARITY (event_id, entry_no, char_id, percentage)
  SELECT event_id, entry_no, char_id, 100
    FROM ENTRY
   WHERE char_id IS NOT NULL;
COMMIT;

-- Remove old single-charity column
ALTER TABLE ENTRY
  DROP COLUMN char_id;
COMMIT;

-- Show structure of new table and migrated data
DESC ENTRY_CHARITY;
SELECT *
  FROM ENTRY_CHARITY
 ORDER BY event_id, entry_no, char_id;

DESC ENTRY;
SELECT *
  FROM ENTRY
 ORDER BY entry_no, event_id;

