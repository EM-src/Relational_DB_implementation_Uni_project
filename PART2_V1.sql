SET VERIFY ON

Rem	Setup File for DML, DMA FINAL ASSIGNMENT PART2

SET ECHO ON

SET SQLBLANKLINES ON

Rem PART2, QUESTION B, SUBQUESTION Q1

SELECT p.*
FROM PROPERTY p, CUSTOMER_INTENTION ci
WHERE p.CUSTOMER_ID = ci.CUSTOMER_ID
AND   ci.PURPOSE = 'SELL'
AND   p.ROOMS >= 4
AND   p.LOCATION = 'NEWCASTLE'
AND   p.ADDRESS IN ('%, HEATON', '%, FENHAM')
AND   p.REGISTRATION_DATE > SYSDATE-42

Rem PART2, QUESTION B, SUBQUESTION Q2
