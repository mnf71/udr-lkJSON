RECREATE TABLE SAMPLE (
    REC  SMALLINT,
    I32  INTEGER,
    DBL  DOUBLE PRECISION,
    STR  VARCHAR(32),
    DMY  DATE
);

COMMIT WORK;

UPDATE OR
INSERT INTO SAMPLE
       (REC, I32, DBL, STR, DMY)
VALUES (1, -1, 1.5, 'Record 1', '2021-05-12 11:07:10')
MATCHING (REC);

UPDATE OR
INSERT INTO SAMPLE
       (REC, I32, DBL, STR, DMY)
VALUES (2, 1, 10.95, 'Record 2', '2021-05-12 11:07:12')
MATCHING (REC);

COMMIT WORK;
