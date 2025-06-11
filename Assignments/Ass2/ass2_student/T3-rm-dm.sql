-- T3-rm-dm.sql
-- Task 3: Data manipulation script for Run Monash
-- Student ID: 33523061
-- Student Name: MUHAMMAD JOHAN ARIEF BIN MULIADEE

/* =============================
   Task 3(a): Create sequences
   ============================= */
-- Remove existing sequences (if any)
DROP SEQUENCE competitor_seq;
DROP SEQUENCE team_seq;

-- Create COMPETITOR sequence
CREATE SEQUENCE competitor_seq
  START WITH 100
  INCREMENT BY 5;

-- Create TEAM sequence
CREATE SEQUENCE team_seq
  START WITH 100
  INCREMENT BY 5;

/* ==========================================================
   Task 3(b): Add Keith Rose & Jackson Bull, register and team
   ========================================================== */
SET TRANSACTION READ WRITE;

-- Insert two new competitors
INSERT INTO COMPETITOR
  (comp_no, comp_fname, comp_lname, comp_gender, comp_dob, comp_email, comp_unistatus, comp_phone)
VALUES
  (competitor_seq.NEXTVAL, 'Keith',  'Rose',  'M', TO_DATE('01/JAN/1990','DD/MON/YYYY'), 'keith.rose@monash.edu',  'Y', '0422141112');

INSERT INTO COMPETITOR
  (comp_no, comp_fname, comp_lname, comp_gender, comp_dob, comp_email, comp_unistatus, comp_phone)
VALUES
  (competitor_seq.NEXTVAL, 'Jackson','Bull', 'M', TO_DATE('15/MAR/1992','DD/MON/YYYY'), 'jackson.bull@monash.edu','Y', '0422412524');

-- Register both in the 10 Km Run of RM Winter Series Caulfield 2025
INSERT INTO ENTRY
  (event_id, entry_no, entry_starttime, entry_finishtime, entry_elapsedtime, comp_no, team_id, char_id)
VALUES
  (
    -- event_id for 10 Km Run at RM Winter Series Caulfield 2025
    (SELECT e.event_id
       FROM EVENT e
       JOIN CARNIVAL c ON e.carn_date = c.carn_date
       JOIN EVENTTYPE et ON e.eventtype_code = et.eventtype_code
      WHERE c.carn_name = 'RM Winter Series Caulfield 2025'
        AND et.eventtype_desc = '10 Km Run'),
    -- next entry_no
    NVL(
      (SELECT MAX(entry_no) FROM ENTRY
         WHERE event_id = (
           SELECT e.event_id
             FROM EVENT e
             JOIN CARNIVAL c ON e.carn_date = c.carn_date
             JOIN EVENTTYPE et ON e.eventtype_code = et.eventtype_code
            WHERE c.carn_name = 'RM Winter Series Caulfield 2025'
              AND et.eventtype_desc = '10 Km Run'
         )
      ), 0
    ) + 1,
    NULL, NULL, NULL,
    -- comp_no for Keith
    (SELECT comp_no FROM COMPETITOR WHERE comp_phone = '0422141112'),
    NULL,
    -- charity = Salvation Army
    (SELECT char_id FROM CHARITY WHERE char_name = 'Salvation Army')
  );

INSERT INTO ENTRY
  (event_id, entry_no, entry_starttime, entry_finishtime, entry_elapsedtime, comp_no, team_id, char_id)
VALUES
  (
    (SELECT e.event_id
       FROM EVENT e
       JOIN CARNIVAL c ON e.carn_date = c.carn_date
       JOIN EVENTTYPE et ON e.eventtype_code = et.eventtype_code
      WHERE c.carn_name = 'RM Winter Series Caulfield 2025'
        AND et.eventtype_desc = '10 Km Run'),
    NVL(
      (SELECT MAX(entry_no) FROM ENTRY
         WHERE event_id = (
           SELECT e.event_id
             FROM EVENT e
             JOIN CARNIVAL c ON e.carn_date = c.carn_date
             JOIN EVENTTYPE et ON e.eventtype_code = et.eventtype_code
            WHERE c.carn_name = 'RM Winter Series Caulfield 2025'
              AND et.eventtype_desc = '10 Km Run'
         )
      ), 0
    ) + 2,
    NULL, NULL, NULL,
    -- comp_no for Jackson
    (SELECT comp_no FROM COMPETITOR WHERE comp_phone = '0422412524'),
    NULL,
    -- charity = RSPCA
    (SELECT char_id FROM CHARITY WHERE char_name = 'RSPCA')
  );

-- Create the new team "Super Runners" 
INSERT INTO TEAM
  (team_id, team_name, carn_date, event_id, entry_no)
VALUES
  (
    team_seq.NEXTVAL,
    'Super Runners',
    (SELECT c.carn_date FROM CARNIVAL c WHERE c.carn_name = 'RM Winter Series Caulfield 2025'),
    (SELECT e.event_id
       FROM EVENT e
       JOIN CARNIVAL c ON e.carn_date = c.carn_date
       JOIN EVENTTYPE et ON e.eventtype_code = et.eventtype_code
      WHERE c.carn_name = 'RM Winter Series Caulfield 2025'
        AND et.eventtype_desc = '10 Km Run'),
    (SELECT entry_no FROM ENTRY
       WHERE comp_no = (SELECT comp_no FROM COMPETITOR WHERE comp_phone = '0422141112')
         AND event_id = (
           SELECT e.event_id
             FROM EVENT e
             JOIN CARNIVAL c ON e.carn_date = c.carn_date
             JOIN EVENTTYPE et ON e.eventtype_code = et.eventtype_code
            WHERE c.carn_name = 'RM Winter Series Caulfield 2025'
              AND et.eventtype_desc = '10 Km Run'
         )
    )
  );

-- Assign Jackson’s entry to that team
UPDATE ENTRY
   SET team_id = (
     SELECT team_id
       FROM TEAM
      WHERE team_name = 'Super Runners'
        AND carn_date = (
          SELECT c.carn_date FROM CARNIVAL c WHERE c.carn_name = 'RM Winter Series Caulfield 2025'
        )
   )
 WHERE comp_no = (SELECT comp_no FROM COMPETITOR WHERE comp_phone = '0422412524')
   AND event_id = (
     SELECT e.event_id
       FROM EVENT e
       JOIN CARNIVAL c ON e.carn_date = c.carn_date
       JOIN EVENTTYPE et ON e.eventtype_code = et.eventtype_code
      WHERE c.carn_name = 'RM Winter Series Caulfield 2025'
        AND et.eventtype_desc = '10 Km Run'
   );

-- Update Keith Entry
UPDATE ENTRY
   SET team_id = (
     SELECT team_id
       FROM TEAM
      WHERE team_name = 'Super Runners'
        AND carn_date = (
          SELECT c.carn_date FROM CARNIVAL c WHERE c.carn_name = 'RM Winter Series Caulfield 2025'
        )
   )
 WHERE comp_no = (SELECT comp_no FROM COMPETITOR WHERE comp_phone = '0422141112')
   AND event_id = (
     SELECT e.event_id
       FROM EVENT e
       JOIN CARNIVAL c ON e.carn_date = c.carn_date
       JOIN EVENTTYPE et ON e.eventtype_code = et.eventtype_code
      WHERE c.carn_name = 'RM Winter Series Caulfield 2025'
        AND et.eventtype_desc = '10 Km Run'
   );

COMMIT;

/* ==========================================================
   Task 3(c): Jackson downgrades to 5 Km Run & new charity
   ========================================================== */
UPDATE ENTRY
   SET event_id = (
     SELECT e.event_id
       FROM EVENT e
       JOIN CARNIVAL c ON e.carn_date = c.carn_date
       JOIN EVENTTYPE et ON e.eventtype_code = et.eventtype_code
      WHERE c.carn_name = 'RM Winter Series Caulfield 2025'
        AND et.eventtype_desc = '5 Km Run'
   ),
       char_id  = (
     SELECT char_id FROM CHARITY WHERE char_name = 'Beyond Blue'
   )
 WHERE comp_no = (SELECT comp_no FROM COMPETITOR WHERE comp_phone = '0422412524')
   AND event_id = (
     SELECT e.event_id
       FROM EVENT e
       JOIN CARNIVAL c ON e.carn_date = c.carn_date
       JOIN EVENTTYPE et ON e.eventtype_code = et.eventtype_code
      WHERE c.carn_name = 'RM Winter Series Caulfield 2025'
        AND et.eventtype_desc = '10 Km Run'
   );

COMMIT;

/* ===============================================================================
   Task 3(d): Keith withdraws --> delete entry, disband team, Jackson continues solo
   =============================================================================== */

-- Delete the Super Runners team
DELETE FROM TEAM
 WHERE team_name = 'Super Runners'
   AND carn_date = (
     SELECT c.carn_date FROM CARNIVAL c WHERE c.carn_name = 'RM Winter Series Caulfield 2025'
   );


-- Remove Keith’s entry
DELETE FROM ENTRY
 WHERE comp_no = (SELECT comp_no FROM COMPETITOR WHERE comp_phone = '0422141112')
   AND event_id IN (
     SELECT e.event_id
       FROM EVENT e
       JOIN CARNIVAL c ON e.carn_date = c.carn_date
      WHERE c.carn_name = 'RM Winter Series Caulfield 2025'
   );



-- Unassign Jackson from team 
UPDATE ENTRY
   SET team_id = NULL
 WHERE comp_no = (SELECT comp_no FROM COMPETITOR WHERE comp_phone = '0422412524')
   AND event_id = (
     SELECT e.event_id
       FROM EVENT e
       JOIN CARNIVAL c ON e.carn_date = c.carn_date
       JOIN EVENTTYPE et ON e.eventtype_code = et.eventtype_code
      WHERE c.carn_name = 'RM Winter Series Caulfield 2025'
        AND et.eventtype_desc = '5 Km Run'
   );

COMMIT;
