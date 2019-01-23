/*PART A - 1 */

-- 1. Drop Tables

DROP TABLE EMPLOYEE CASCADE CONSTRAINTS;


-- 2. Create All Tables

CREATE TABLE EMPLOYEE
 Fname VARCHAR2(30),
 Lname VARCHAR2(30),
 Position VARCHAR2(40),
 Phone VARCHAR2(40),
 Email VARCHAR2(50),
 DOB DATE,
 Gender VARCHAR2(10),
 Salary NUMBER(9,2),
 HireDate DATE DEFAULT SYSDATE,
 OutNo VARCHAR2(4),
 SupervisorNo VARCHAR2(4),
 CONSTRAINT Emp_No_Pk PRIMARY KEY(EmpNo),
 CONSTRAINT Supervisor_No_Fk FOREIGN KEY (SupervisorNo) REFERENCES EMPLOYEE (EmpNo));

CREATE TABLE OUTLET
 Street VARCHAR2(40),
 City VARCHAR2(20),
 State VARCHAR2(10),
 Zipcode NUMBER(10),
 Phone VARCHAR2(30),
 ManagerNo VARCHAR(4),
 CONSTRAINT Out_No_Pk PRIMARY KEY (OutNo),
 CONSTRAINT Manager_No_Fk FOREIGN KEY (ManagerNo) REFERENCES EMPLOYEE (EmpNo));

CREATE TABLE VEHICLE
(LicenseNo VARCHAR2(10),
 Make VARCHAR2(20),
 Model VARCHAR2(20),
 Color VARCHAR2(10),
 Year NUMBER(4),
 NoDoors NUMBER(2),
 Capacity NUMBER(2),
 DailyRate NUMBER(4),
 InspectionDate DATE,
 OutNo VARCHAR2(4),
 CONSTRAINT License_No_Pk PRIMARY KEY (LicenseNo),
 CONSTRAINT vehicle_outNo_fk FOREIGN KEY (OutNo) REFERENCES Outlet(OutNo),
 CONSTRAINT NoDoors_range CHECK (NoDoors<11 and NoDoors>0),
 CONSTRAINT InspectionDate_range CHECK (InspectionDate>'01-Nov-2017' and InspectionDate<'01-Dec-2018'),
 CONSTRAINT vehicle_DailyRate_positive CHECK (DailyRate>0));
 
CREATE TABLE CLIENT 
 ClientName VARCHAR2(10),
 Street VARCHAR2(30),
 City VARCHAR2(12),
 State VARCHAR2(2),
 ZipCode VARCHAR2(5),
 WebAddress VARCHAR2(50),
 Contact_FName VARCHAR2(10),
 Contact_LName VARCHAR2(10),
 Phone VARCHAR2(20),
 Email VARCHAR2(30),
 CONSTRAINT Client_No_Pk PRIMARY KEY (ClientNo));

CREATE TABLE RAGREEMENT 
 StartDate DATE, 
 ReturnDate DATE,
 MileageBefore NUMBER(4,0),
 MileageAfter NUMBER(4,0), 
 InsuraceType VARCHAR2(3),
 ClientNo VARCHAR2(6),
 LicenseNo VARCHAR2(10),
 CONSTRAINT Rental_No_Pk PRIMARY KEY (RentalNo),
 CONSTRAINT ragreement_ClientNo_fk FOREIGN KEY (ClientNo) REFERENCES Client (ClientNo),
 CONSTRAINT ragreement_LicenseNo_fk FOREIGN KEY (LicenseNo) REFERENCES Vehicle (LicenseNo),
 CONSTRAINT ragreement_date_range CHECK (StartDate<ReturnDate),
 CONSTRAINT ragreement_mileage_range CHECK (MileageBefore<MileageAfter and MileageBefore>0));
 
CREATE TABLE FAULTREPORT
 DateChecked DATE,
 Comments VARCHAR2(60),
 EmpNo VARCHAR2(4),
 LicenseNo VARCHAR2(10),
 RentalNo VARCHAR2(10),
 CONSTRAINT Report_Num_Pk PRIMARY KEY(ReportNum),
 CONSTRAINT Emp_No_Fk FOREIGN KEY (EmpNo) REFERENCES EMPLOYEE (EmpNo),
 CONSTRAINT Rental_No_Fk FOREIGN KEY (RentalNo) REFERENCES RAGREEMENT (RentalNo),
 CONSTRAINT License_No_Fk FOREIGN KEY (LicenseNo) REFERENCES VEHICLE (LicenseNo));

INSERT INTO EMPLOYEE VALUES ('007','Muhammad','Aziz','General Manager', '(917) 703-0076','maziz2@andrew.cmu.edu','07-JUL-1990','Male','250000','20-AUG-2010','100','');
INSERT INTO OUTLET VALUES ('100','1712 Forbes Ave','Pittsburgh','PA','15219','(393) 828-6559','007');
INSERT INTO VEHICLE VALUES ('ADD-5674','Mercedes-Benz','GLA-Class','White','2009','4','8','180','21-Mar-2018','400');
INSERT INTO CLIENT VALUES ('640','Mandy','82 97th Street','New York','NY','10078','www.arithmatics.com','Mandy','Baker', '(201) 703-0076','ycai@163.com');
INSERT INTO RAGREEMENT VALUES ('RA002',to_date('15-JUN-17  3:09pm', 'dd-mon-yy hh:miam'),to_date('28-JUN-17  5:09pm', 'dd-mon-yy hh:miam'),'100','189','C05','081','SF4-34ER');


/*PART B */



/*
References:
1. https://www.carsguide.com.au/
2. https://gist.github.com/HeroicEric/1102788
3. 
*/