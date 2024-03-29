SET SQLPROMPT "W21050558 > "

SET VERIFY ON

SET ECHO ON

CREATE TYPE AGENT_TYPE
/

CREATE TYPE BRANCH_TYPE AS OBJECT(
  BRANCH_ID         NUMBER(3),
  AGENT_REF           REF AGENT_TYPE,
  ADDRESS             VARCHAR(100),
  CONTACT_DETAILS     CHAR(13),
  MANAGER_ID          NUMBER(3)
)
/

CREATE TYPE BR_NT_TYPE AS TABLE OF REF BRANCH_TYPE
/

CREATE OR REPLACE TYPE AGENT_TYPE AS OBJECT(
  AGENT_ID            NUMBER(3),
  HEADQUARTER         VARCHAR(25),
  FULL_NAME           VARCHAR(50),
  ADDRESS             VARCHAR(100),
  WEBSITE             VARCHAR(50),
  CONTACT_DETAILS     CHAR(13),
  BRANCHES            BR_NT_TYPE
)
/

CREATE TABLE BRANCH_TAB OF BRANCH_TYPE(
  PRIMARY KEY (BRANCH_ID)
  /*FOREIGN KEY (AGENT_REF) REFERENCES AGENT_TAB */
)
/

CREATE TABLE AGENT_TAB OF AGENT_TYPE(
  PRIMARY KEY (AGENT_ID)
)
NESTED TABLE BRANCHES STORE AS AGENT_BR_NT
/

ALTER TABLE BRANCH_TAB
ADD CONSTRAINT AGENT_REF_FK FOREIGN KEY (AGENT_REF) REFERENCES AGENT_TAB;



INSERT INTO BRANCH_TAB VALUES (1,NULL,'QUEENSWAY 5, FENHAM, NEWCASTLE','+441234567898',100);
INSERT INTO BRANCH_TAB VALUES (2,NULL,'HEATON RD 12, HEATON, NEWCASTLE','+441234567899',150);
INSERT INTO BRANCH_TAB VALUES (3,NULL,'MOUNT RD 34, SUNDERLAND','+441234567810',145);
INSERT INTO BRANCH_TAB VALUES (4,NULL,'RODSLEY AVE 77, GATESHEAD','+441234567811',103);
INSERT INTO BRANCH_TAB VALUES (5,NULL,'NORA ST 5, SUNDERLAND','+441234567812',200);
INSERT INTO BRANCH_TAB VALUES (6,NULL,'NORTHUMBRIAN RD 85, CRAMLINGTON','+441234567813',333);
INSERT INTO BRANCH_TAB VALUES (8,NULL,'WINGROVE RD 45, FENHAM, NEWCASTLE','+441234567815',107);


INSERT INTO AGENT_TAB VALUES (10,'NEWCASTLE','NEWCASTLE REAL ESTATE','GIBSON ST, 1','WWW.NCRE.CO.UK','+441234567890',BR_NT_TYPE());
INSERT INTO AGENT_TAB VALUES (12,'LONDON','LONDON REAL ESTATE','GOSSET ST, 3','WWW.LRE.CO.UK','+441234567892',BR_NT_TYPE());
INSERT INTO AGENT_TAB VALUES (13,'EDINBURGH','EDINBURGH REAL ESTATE','PRINCESS ST, 4','WWW.EDRE.CO.UK','+441234567893',BR_NT_TYPE());
INSERT INTO AGENT_TAB VALUES (14,'WOKING','WOKING REAL ESTATE','GUILDFORD ST, 5','WWW.WRE.CO.UK','+441234567894',BR_NT_TYPE());
INSERT INTO AGENT_TAB VALUES (16,'NEWCASTLE','BEST NEWCASTLE REAL ESTATE','NEWTON ST, 13','WWW.BNCRE.CO.UK','+441234567896',BR_NT_TYPE());


UPDATE BRANCH_TAB
SET AGENT_REF = (SELECT REF(A) FROM AGENT_TAB A WHERE A.AGENT_ID = 10)
WHERE BRANCH_ID = 1;
UPDATE BRANCH_TAB
SET AGENT_REF = (SELECT REF(A) FROM AGENT_TAB A WHERE A.AGENT_ID = 10)
WHERE BRANCH_ID = 2;
UPDATE BRANCH_TAB
SET AGENT_REF = (SELECT REF(A) FROM AGENT_TAB A WHERE A.AGENT_ID = 13)
WHERE BRANCH_ID = 3;
UPDATE BRANCH_TAB
SET AGENT_REF = (SELECT REF(A) FROM AGENT_TAB A WHERE A.AGENT_ID = 10)
WHERE BRANCH_ID = 4;
UPDATE BRANCH_TAB
SET AGENT_REF = (SELECT REF(A) FROM AGENT_TAB A WHERE A.AGENT_ID = 12)
WHERE BRANCH_ID = 5;
UPDATE BRANCH_TAB
SET AGENT_REF = (SELECT REF(A) FROM AGENT_TAB A WHERE A.AGENT_ID = 14)
WHERE BRANCH_ID = 6;
UPDATE BRANCH_TAB
SET AGENT_REF = (SELECT REF(A) FROM AGENT_TAB A WHERE A.AGENT_ID = 16)
WHERE BRANCH_ID = 8;



INSERT INTO TABLE (SELECT A.BRANCHES FROM AGENT_TAB A WHERE A.AGENT_ID = 10)
SELECT REF(C) FROM BRANCH_TAB C WHERE C.AGENT_REF.AGENT_ID = 10;
INSERT INTO TABLE (SELECT A.BRANCHES FROM AGENT_TAB A WHERE A.AGENT_ID = 12)
SELECT REF(C) FROM BRANCH_TAB C WHERE C.AGENT_REF.AGENT_ID = 12;
INSERT INTO TABLE (SELECT A.BRANCHES FROM AGENT_TAB A WHERE A.AGENT_ID = 13)
SELECT REF(C) FROM BRANCH_TAB C WHERE C.AGENT_REF.AGENT_ID = 13;
INSERT INTO TABLE (SELECT A.BRANCHES FROM AGENT_TAB A WHERE A.AGENT_ID = 14)
SELECT REF(C) FROM BRANCH_TAB C WHERE C.AGENT_REF.AGENT_ID = 14;
INSERT INTO TABLE (SELECT A.BRANCHES FROM AGENT_TAB A WHERE A.AGENT_ID = 16)
SELECT REF(C) FROM BRANCH_TAB C WHERE C.AGENT_REF.AGENT_ID = 16;



/*
  DISPLAY DETAILS OF ALL BRANCHES REGISTERED IN AGENTS WITH FULL NAME 'NEWCASTLE REAL ESTATE'
  AND 'EDINBURGH REAL ESTATE' OR WITH BRANCH MANAGER_ID 107.
*/

SELECT AT.AGENT_ID, AT.FULL_NAME AS "AGENT_FN", DEREF(VALUE(B)).BRANCH_ID AS "BRANCH_ID", DEREF(VALUE(B)).CONTACT_DETAILS AS "BRANCH_CD", DEREF(VALUE(B)).MANAGER_ID AS "BRANCH_MID"
FROM AGENT_TAB AT, TABLE(AT.BRANCHES) B
WHERE AT.FULL_NAME IN ('NEWCASTLE REAL ESTATE', 'EDINBURGH REAL ESTATE')
UNION
SELECT AT.AGENT_ID, AT.FULL_NAME AS "AGENT_FN", DEREF(VALUE(B)).BRANCH_ID AS "BRANCH_ID", DEREF(VALUE(B)).CONTACT_DETAILS AS "BRANCH_CD", DEREF(VALUE(B)).MANAGER_ID AS "BRANCH_MID"
FROM AGENT_TAB AT, TABLE(AT.BRANCHES) B
WHERE DEREF(VALUE(B)).MANAGER_ID = 107
/
