

-- #1.
SELECT R.RENTALNO, STARTDATE, RETURNDATE, MILEAGEBEFORE, MILEAGEAFTER,
       R.LICENSENO, OUTNO, MAKE, MODEL, YEAR, DATECHECKED
FROM VEHICLE V LEFT JOIN RAGREEMENT R ON V.LICENSENO = R.LICENSENO
               LEFT JOIN FAULTREPORT F ON R.RENTALNO = F.RENTALNO
ORDER BY R.RENTALNO;


-- #2.
SELECT DECODE(OUTNO, NULL, 'Total', OUTNO) "Outlet",
       NVL(SUM(VEHICLE#),0) "Number of Vehicles",
       NVL(SUM(RENTAL#),0) "Number of Rentals",
       CAST(NVL(SUM(DISTANCESUM)/SUM(RENTAL#),0) AS DECIMAL(10,2)) "Average Distance Driven",
       NVL(SUM(EMP#),0) "Number of Employees",
       CAST(NVL(SUM(RENTAL#),0)/SUM(EMP#) AS DECIMAL(5,2)) "Number of Rentals/Employee"
FROM (SELECT OUTNO, COUNT(RENTALNO) RENTAL#, COUNT(LICENSENO) VEHICLE#,
             SUM((MILEAGEAFTER-MILEAGEBEFORE)) DISTANCESUM
      FROM RAGREEMENT JOIN VEHICLE USING (LICENSENO)
      WHERE STARTDATE<=TO_DATE('2017-12-31','YYYY-MM-DD') AND STARTDATE>=TO_DATE('2017-01-01','YYYY-MM-DD')
      GROUP BY OUTNO)
    RIGHT JOIN
     (SELECT OUTNO, COUNT(EMPNO) EMP#
      FROM EMPLOYEE JOIN OUTLET USING (OUTNO)
      GROUP BY OUTNO)
    USING (OUTNO)
GROUP BY ROLLUP(OUTNO)
ORDER BY OUTNO;


-- #3.
SELECT DECODE(Months, NULL, 'Total', Months, TO_CHAR(TO_DATE(Months,'YYYYMM'),'YYYY') || '-' ||TO_CHAR(TO_DATE(Months,'YYYYMM'),'Mon')) "Month",
       NVL(SUM(O100),0) "Outlet 100",
       NVL(SUM(O200),0) "Outlet 200",
       NVL(SUM(O300),0) "Outlet 300",
       NVL(SUM(O400),0) "Outlet 400",
       NVL(SUM(O500),0) "Outlet 500",
       NVL(SUM(REVENUE),0) "Revenue",
       NVL(SUM(RENTALNO#),0) "Number of Rentals",
       NVL(SUM(RevenuePerRental),0) "Revenue per Rental"
FROM (SELECT TO_CHAR(RETURNDATE, 'YYYY') || TO_CHAR(RETURNDATE, 'MM') RENTALMONTH,
             CAST(SUM(DECODE(OUTNO, 100, DAILYRATE*ROUND(RETURNDATE-STARTDATE))) AS DECIMAL(10,2)) O100,
             CAST(SUM(DECODE(OUTNO, 200, DAILYRATE*ROUND(RETURNDATE-STARTDATE))) AS DECIMAL(10,2)) O200,
             CAST(SUM(DECODE(OUTNO, 300, DAILYRATE*ROUND(RETURNDATE-STARTDATE))) AS DECIMAL(10,2)) O300,
             CAST(SUM(DECODE(OUTNO, 400, DAILYRATE*ROUND(RETURNDATE-STARTDATE))) AS DECIMAL(10,2)) O400,
             CAST(SUM(DECODE(OUTNO, 500, DAILYRATE*ROUND(RETURNDATE-STARTDATE))) AS DECIMAL(10,2)) O500,
             CAST(SUM(ROUND(DAILYRATE*(RETURNDATE-STARTDATE))) AS DECIMAL(10,2)) REVENUE,
             COUNT(RENTALNO) RENTALNO#,
             CAST(SUM(DAILYRATE*ROUND((RETURNDATE-STARTDATE)))/COUNT(RENTALNO) AS DECIMAL(10,2)) RevenuePerRental
      FROM RAGREEMENT JOIN VEHICLE USING (LICENSENO)
      WHERE RETURNDATE>ADD_MONTHS(SYSDATE,-12)
      GROUP BY (TO_CHAR(RETURNDATE, 'YYYY') || TO_CHAR(RETURNDATE, 'MM'))
      ORDER BY 1)
  RIGHT JOIN
     (SELECT TO_CHAR(ADD_MONTHS(SYSDATE,level-13),'YYYY') || TO_CHAR(ADD_MONTHS(SYSDATE,level-1),'MM') Months
      FROM dual
      CONNECT BY level <= 12)
  ON Months=RENTALMONTH
GROUP BY ROLLUP (Months)
ORDER BY Months


-- #4.
SELECT DECODE(OUTNO, NULL, 'Total', OUTNO) "Outlet",
       SUM(Rental1) "Monday - Rental",
       NVL(SUM(Fault1),0) "Monday - FaultChecked",
       SUM(Rental2) "Tuesday - Rental",
       NVL(SUM(Fault2),0) "Tuesday - FaultChecked",
       SUM(Rental3) "Wednesday - Rental",
       NVL(SUM(Fault3),0) "Wednesday - FaultChecked",
       SUM(Rental4) "Thursday - Rental",
       NVL(SUM(Fault4),0) "Thursday - FaultChecked",
       SUM(Rental5) "Friday - Rental",
       NVL(SUM(Fault5),0) "Friday - FaultChecked",
       SUM(Rental6) "Saturday - Rental",
       NVL(SUM(Fault6),0) "Saturday - FaultChecked",
       SUM(Rental7) "Sunday - Rental",
       NVL(SUM(Fault7),0) "Sunday - FaultChecked",
       SUM(RentalCount) "Outlet Total - Rental",
       NVL(SUM(FaultCount),0) "Outlet Total - FaultChecked"
FROM
       (SELECT OUTNO,
               COUNT(DECODE(TO_CHAR(STARTDATE,'D'), 1, 1)) Rental1,
               COUNT(DECODE(TO_CHAR(STARTDATE,'D'), 2, 1)) Rental2,
               COUNT(DECODE(TO_CHAR(STARTDATE,'D'), 3, 1)) Rental3,
               COUNT(DECODE(TO_CHAR(STARTDATE,'D'), 4, 1)) Rental4,
               COUNT(DECODE(TO_CHAR(STARTDATE,'D'), 5, 1)) Rental5,
               COUNT(DECODE(TO_CHAR(STARTDATE,'D'), 6, 1)) Rental6,
               COUNT(DECODE(TO_CHAR(STARTDATE,'D'), 7, 1)) Rental7,
               COUNT(TO_CHAR(STARTDATE,'D')) RentalCount
       FROM RAGREEMENT JOIN VEHICLE USING (LICENSENO)
       WHERE STARTDATE>ADD_MONTHS(SYSDATE,-6)
       GROUP BY OUTNO)
       LEFT JOIN
       (SELECT OUTNO,
               COUNT(DECODE(TO_CHAR(DATECHECKED,'D'), 1, 1)) Fault1,
               COUNT(DECODE(TO_CHAR(DATECHECKED,'D'), 2, 1)) Fault2,
               COUNT(DECODE(TO_CHAR(DATECHECKED,'D'), 3, 1)) Fault3,
               COUNT(DECODE(TO_CHAR(DATECHECKED,'D'), 4, 1)) Fault4,
               COUNT(DECODE(TO_CHAR(DATECHECKED,'D'), 5, 1)) Fault5,
               COUNT(DECODE(TO_CHAR(DATECHECKED,'D'), 6, 1)) Fault6,
               COUNT(DECODE(TO_CHAR(DATECHECKED,'D'), 7, 1)) Fault7,
               COUNT(TO_CHAR(DATECHECKED,'D')) FaultCount
       FROM VEHICLE JOIN RAGREEMENT R ON VEHICLE.LICENSENO = R.LICENSENO
                    JOIN FAULTREPORT F ON R.RENTALNO = F.RENTALNO
       WHERE DATECHECKED>ADD_MONTHS(SYSDATE,-6)
       GROUP BY OUTNO)
       USING (OUTNO)
GROUP BY ROLLUP (OUTNO)
ORDER BY 1;


-- #5.
SELECT DECODE(E.OUTNO,NULL,'Subtotal',E.OUTNO) "Outlet",
       MANAGERNO, FNAME || ' ' || LNAME "Name",
       CAST(NVL(COUNT(R.RENTALNO),0) AS DECIMAL(10,2)) "Number of Rentals",
       CAST(NVL(SUM(DAILYRATE*(RETURNDATE-STARTDATE))/COUNT(R.RENTALNO),0) AS DECIMAL(10,2)) "Revenue per Rental",
       CAST(NVL(COUNT(REPORTNUM)/COUNT(R.RENTALNO),0) AS DECIMAL(10,2))"Fault Reports per Rental"
FROM VEHICLE V LEFT JOIN RAGREEMENT R ON V.LICENSENO = R.LICENSENO
               LEFT JOIN FAULTREPORT F ON R.RENTALNO = F.RENTALNO
               JOIN OUTLET O USING (OUTNO)
               JOIN EMPLOYEE E ON O.MANAGERNO = E.EMPNO
GROUP BY GROUPING SETS ((E.OUTNO, MANAGERNO, FNAME, LNAME),(MANAGERNO, FNAME, LNAME))
ORDER BY 1,2;


-- #6.
SELECT *
FROM  (SELECT OUTNO, CAST(SUM(DAILYRATE*(RETURNDATE-STARTDATE)) AS DECIMAL (10,2)) REVENUE
       FROM RAGREEMENT JOIN VEHICLE USING(LICENSENO)
       WHERE STARTDATE>TO_DATE('2017-10-1','YYYY-MM-DD') AND RETURNDATE<TO_DATE('2017-12-31','YYYY-MM-DD')
       OR STARTDATE>TO_DATE('2018-1-1','YYYY-MM-DD') AND RETURNDATE<TO_DATE('2018-03-31','YYYY-MM-DD')
       GROUP BY OUTNO
       ORDER BY REVENUE DESC)
WHERE ROWNUM=1
UNION ALL
SELECT *
FROM (SELECT OUTNO, CAST(SUM(DAILYRATE*(RETURNDATE-STARTDATE)) AS DECIMAL (10,2)) REVENUE
      FROM RAGREEMENT JOIN VEHICLE USING(LICENSENO)
      WHERE STARTDATE>TO_DATE('2017-10-1','YYYY-MM-DD') AND RETURNDATE<TO_DATE('2017-12-31','YYYY-MM-DD')
      OR STARTDATE>TO_DATE('2018-1-1','YYYY-MM-DD') AND RETURNDATE<TO_DATE('2018-03-31','YYYY-MM-DD')
      GROUP BY OUTNO
      ORDER BY REVENUE)
WHERE ROWNUM=1;


-- #7.
SELECT DECODE(MAKE, NULL, 'Grand Total:', MAKE) "Make", MODEL,
       NVL(SUM(CAR#),0) "Number of Cars",
       CAST(NVL(SUM(AGESUM)/SUM(AGECOUNT),0) AS DECIMAL(4,2)) "Average Cars Age",
       NVL(SUM(RENTAL#),0) "Number of Rentals",
       NVL(SUM(RENTALDAYS),0) "Number of Rented Days",
       NVL(SUM(FAULTREPORT#),0) "Number of Fault Reports"
FROM (SELECT MAKE, MODEL, COUNT(R.RENTALNO) RENTAL#,
             SUM(ROUND(RETURNDATE-STARTDATE)) RENTALDAYS,
             COUNT(REPORTNUM) FAULTREPORT#
      FROM VEHICLE V LEFT JOIN RAGREEMENT R ON V.LICENSENO = R.LICENSENO
                     LEFT JOIN FAULTREPORT F ON R.RENTALNO = F.RENTALNO
      WHERE STARTDATE>=TO_DATE('2018-01-01','YYYY-MM-DD') AND STARTDATE<=TO_DATE('2018-12-31','YYYY-MM-DD')
      GROUP BY (MAKE,MODEL))
FULL JOIN (SELECT MAKE, MODEL, COUNT(LICENSENO) CAR#,
           SUM(2018-YEAR) AGESUM,
           COUNT(YEAR) AGECOUNT
           FROM VEHICLE
           GROUP BY (MAKE,MODEL))
USING (MAKE, MODEL)
GROUP BY GROUPING SETS((MAKE, MODEL),MAKE,())
ORDER BY MAKE;


-- #8.
SELECT DECODE(QUARTERS,NULL,NULL,'Quarter' || ' ' || QUARTERS) "Quarter", MAKE,
       NVL(LFAULTREPORT,0) "Fault Report Likelihood",
       NVL(RENTALNO#,0) "Number of Rentals"
FROM (SELECT TO_CHAR(STARTDATE, 'q') QUARTERS, MAKE,
             CAST(COUNT(REPORTNUM)/COUNT(R.RENTALNO) AS DECIMAL(4,2)) LFAULTREPORT,
             COUNT(R.RENTALNO) RENTALNO#
      FROM VEHICLE V FULL JOIN RAGREEMENT R ON V.LICENSENO = R.LICENSENO
                     LEFT JOIN FAULTREPORT F ON R.RENTALNO = F.RENTALNO
      WHERE STARTDATE>=TO_DATE('2017-01-01','YYYY-MM-DD') AND STARTDATE<=TO_DATE('2017-12-31','YYYY-MM-DD')
      GROUP BY (MAKE, TO_CHAR(STARTDATE, 'q')))
FULL JOIN (SELECT * FROM
          (SELECT DISTINCT TO_CHAR(STARTDATE, 'q') QUARTERS FROM RAGREEMENT),
          (SELECT DISTINCT MAKE FROM VEHICLE))
USING (QUARTERS, MAKE)
ORDER BY 1,3 DESC;


-- #9.
SELECT OUTNO, NVL(SUM(ClientInstate),0) "Same State Customers", NVL(SUM(RentalInstate),0) "Number of Rentals",
       CAST(NVL(SUM(ClientInstate)/SUM(ClientAll),0) AS DECIMAL(4,2)) "Proportion of Customers",
       CAST(NVL(SUM(RentalInstate)/SUM(RentalAll),0) AS DECIMAL(4,2)) "Proportion of Rentals"
FROM (SELECT OUTNO, COUNT(CLIENTNO) ClientInstate, COUNT(RENTALNO) RentalInstate
      FROM OUTLET JOIN VEHICLE USING (OUTNO)
      JOIN RAGREEMENT USING (LICENSENO)
      JOIN CLIENT USING (CLIENTNO)
      WHERE OUTLET.STATE = CLIENT.STATE
      GROUP BY OUTNO)
  RIGHT JOIN
     (SELECT OUTNO, COUNT(CLIENTNO) ClientAll, COUNT(RENTALNO) RentalAll
      FROM OUTLET JOIN VEHICLE USING (OUTNO)
      JOIN RAGREEMENT USING (LICENSENO)
      JOIN CLIENT USING (CLIENTNO)
      GROUP BY OUTNO)
  USING (OUTNO)
GROUP BY OUTNO
ORDER BY OUTNO;


-- #10.
SELECT LEVEL, LPAD(' ', 3*(LEVEL - 1)) || EMPNO || ' ' || FNAME || ' ' || LNAME "Name",
       POSITION, OUTNO, STREET,
        DECODE(FAULTREPORT#, NULL, 0, FAULTREPORT#) "Number of Fault Reports"
FROM (SELECT EMPNO, COUNT(REPORTNUM) FAULTREPORT#
      FROM EMPLOYEE JOIN FAULTREPORT USING (EMPNO)
      WHERE (SYSDATE - DATECHECKED) < 90
      GROUP BY EMPNO)
  RIGHT JOIN (SELECT EMPNO, FNAME, LNAME, POSITION, OUTNO, STREET, SUPERVISORNO
              FROM EMPLOYEE JOIN OUTLET USING (OUTNO))
  USING (EMPNO)
START WITH EMPNO = 007
CONNECT BY PRIOR EMPNO = SUPERVISORNO;
