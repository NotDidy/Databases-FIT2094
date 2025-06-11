-- T4-rm-mods.sql
-- Task 4: Database modifications for Run Monash
-- Student ID: 33523061
-- Student Name: MUHAMMAD JOHAN ARIEF BIN MULIADEE

-- a)

-- Add new column to COMPETITOR
ALTER TABLE COMPETITOR
  ADD comp_completed_events NUMBER(3);

-- Comment on new column
COMMENT ON COLUMN COMPETITOR.comp_completed_events IS
  'Number of completed events by competitor';

-- Populate new column based on existing data
UPDATE COMPETITOR c
   SET comp_completed_events = (
     SELECT COUNT(*)
       FROM ENTRY e
      WHERE e.comp_no = c.comp_no
        AND e.entry_finishtime IS NOT NULL
   );
COMMIT;

-- Show structural change and sample data update
DESC COMPETITOR;
SELECT comp_no, comp_fname, comp_lname, comp_completed_events
  FROM COMPETITOR
 ORDER BY comp_no;

