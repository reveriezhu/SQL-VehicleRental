/*PART A - 1 */

-- 1. Drop Tables

DROP TABLE EMPLOYEE CASCADE CONSTRAINTS;DROP TABLE FAULTREPORT CASCADE CONSTRAINTS;DROP TABLE OUTLET CASCADE CONSTRAINTS;DROP TABLE Vehicle CASCADE CONSTRAINTS;DROP TABLE Client CASCADE CONSTRAINTS;DROP TABLE Ragreement CASCADE CONSTRAINTS;


-- 2. Create All Tables

CREATE TABLE EMPLOYEE(EmpNo VARCHAR2(4),
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

CREATE TABLE OUTLET(OutNo VARCHAR2(4),
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
 CONSTRAINT vehicle_outNo_fk FOREIGN KEY (OutNo) REFERENCES Outlet(OutNo), CONSTRAINT year_max CHECK (2018 - Year < 10),
 CONSTRAINT NoDoors_range CHECK (NoDoors<11 and NoDoors>0),
 CONSTRAINT InspectionDate_range CHECK (InspectionDate>'01-Nov-2017' and InspectionDate<'01-Dec-2018'),
 CONSTRAINT vehicle_DailyRate_positive CHECK (DailyRate>0));
 
CREATE TABLE CLIENT (ClientNo VARCHAR2(6), 
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

CREATE TABLE RAGREEMENT (RentalNo VARCHAR2(10),
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
 
CREATE TABLE FAULTREPORT(ReportNum VARCHAR2(12),
 DateChecked DATE,
 Comments VARCHAR2(60),
 EmpNo VARCHAR2(4),
 LicenseNo VARCHAR2(10),
 RentalNo VARCHAR2(10),
 CONSTRAINT Report_Num_Pk PRIMARY KEY(ReportNum),
 CONSTRAINT Emp_No_Fk FOREIGN KEY (EmpNo) REFERENCES EMPLOYEE (EmpNo),
 CONSTRAINT Rental_No_Fk FOREIGN KEY (RentalNo) REFERENCES RAGREEMENT (RentalNo),
 CONSTRAINT License_No_Fk FOREIGN KEY (LicenseNo) REFERENCES VEHICLE (LicenseNo));

INSERT INTO EMPLOYEE VALUES ('007','Muhammad','Aziz','General Manager', '(917) 703-0076','maziz2@andrew.cmu.edu','07-JUL-1990','Male','250000','20-AUG-2010','100','');INSERT INTO EMPLOYEE VALUES ('009','Muhammad','Awais','Sales Manager', '(917) 307-0076','mawis@andrew.cmu.edu','07-JUL-1994','Male','200000','20-AUG-2010','200','007');INSERT INTO EMPLOYEE VALUES ('101','Alisa','Reed','HR Executive', '(165) 893-0065','areed@gmail.com','06-DEC-1990','FeMale','120000','20-DEC-2010','100','007');INSERT INTO EMPLOYEE VALUES ('100','Nate','Smith','Sales Rep', '(235) 776-0078','natesmith@hotmail.com','08-JUL-1997','Male','25000','20-AUG-2018','200','009');INSERT INTO EMPLOYEE VALUES ('987','Mickey','Steve','Mechanic','(414) 548-3152','msteve@hotmail.com','03-Nov-1998','Male','10000','21-July-1999','200','009');INSERT INTO EMPLOYEE VALUES ('886','Jessica','Smith','Sales Manager','(498) 209-0150','jsmith@yahoo.com','19-Jan-1965','Female','70000','10-Dec-2011','400','007');INSERT INTO EMPLOYEE VALUES ('997','Imary','Childs','Assistant Sales Manager','(579) 674-5557','ichilds@optonline.net','22-Feb-1975','Male','80000','15-Jan-2009','500','009');INSERT INTO EMPLOYEE VALUES ('654','Eden','Charles','Sales Rep','(713) 518-5020','echarles@yahoo.ca','12-April-1985','Male','90000','20-Feb-2016','500','997');INSERT INTO EMPLOYEE VALUES ('777','Hibah','Khan','Administrative Asistant','(811) 672-3134','hkhan@aol.com','03-Dec-1991','Female','60000','25-March-2015','400','886');INSERT INTO EMPLOYEE VALUES ('008','Saad','Shahid','Sales Manager','(811) 672-3879','sshahid@aol.com','03-Dec-1991','Male','150000','25-March-2015','300','007');INSERT INTO EMPLOYEE VALUES ('443','Tim','Hardy','Mechanic','(804) 142-7863','thardy@mac.com','03-Nov-1991','Male','90000','21-July-1998','500','997');INSERT INTO EMPLOYEE VALUES ('444','Steve','Hardy','Mechanic','(807) 142-7863','steve@mac.com','08-Nov-1991','Male','90000','21-July-1996','100','007');INSERT INTO EMPLOYEE VALUES ('632','Gina','Hardy','HR Executive','(808) 142-9863','gina@mac.com','08-Nov-1990','Female','70000','21-July-2012','400','886');INSERT INTO EMPLOYEE VALUES ('567','Tom','Hardy','Mechanic','(804) 142-7863','tharddy@mac.com','03-Nov-1991','Male','90000','21-July-1997','300','008');
INSERT INTO OUTLET VALUES ('100','1712 Forbes Ave','Pittsburgh','PA','15219','(393) 828-6559','007');INSERT INTO OUTLET VALUES ('200','474 Bolton Steet','New York','NY','53154','(200) 888-9039','009');INSERT INTO OUTLET VALUES ('300','7526 Mountainview Ave.','San Carlos','CA','94070','(707) 828-9883','008');INSERT INTO OUTLET VALUES ('400','737 Wall Street','New York','NY','19406','(698) 779-3614','886');INSERT INTO OUTLET VALUES ('500','737 Hill Ave','Chicago','IL','16407','(695) 745-3614','997');
INSERT INTO VEHICLE VALUES ('ADD-5674','Mercedes-Benz','GLA-Class','White','2009','4','8','180','21-Mar-2018','400');INSERT INTO VEHICLE VALUES ('DFE-1099','Ford','Ranger','Black','2010','2','2','125','10-Aug-2018','300');INSERT INTO VEHICLE VALUES ('SD-9983','BMW','M4','Yello','2011','4','4','145','31-Aug-2018','100');INSERT INTO VEHICLE VALUES ('HM-AS09','Toyota','Yaris','Red','2012','4','4','90','02-Jan-2018','500');INSERT INTO VEHICLE VALUES ('98A-B789','Mazda','MX-5','Red','2011','2','2','110','22-May-2018','200');INSERT INTO VEHICLE VALUES ('BV6-7223','Mercedes-Benz','E-Class','Silver','2014','2','2','165','24-May-2018','300');INSERT INTO VEHICLE VALUES ('POD-2009','Ford','Escape','Yellow','2015','4','4','95','05-Jan-2018','200');INSERT INTO VEHICLE VALUES ('DP-5112','Mazda','BT-50','Indigo','2014','2','2','105','03-Jun-2018','100');INSERT INTO VEHICLE VALUES ('SF4-34ER','Volkswagen','Polo','Black','2016','4','4','110','20-Nov-2017','200');INSERT INTO VEHICLE VALUES ('ER-S323','Honda','Odyssey','White','2017','4','4','85','21-May-2018','100');INSERT INTO VEHICLE VALUES ('KJM-QP48','Ford','Territory','Silver','2018','4','8','160','12-Sep-2018','100');
INSERT INTO CLIENT VALUES ('640','Mandy','82 97th Street','New York','NY','10078','www.arithmatics.com','Mandy','Baker', '(201) 703-0076','ycai@163.com');INSERT INTO CLIENT VALUES ('081','Victoria','24 Bolton Street','New York','NY','10005','www.chinese.com','Victoria','Cai', '(200) 703-0076','sdat@andrew.cmu.edu');INSERT INTO CLIENT VALUES ('305','Alex','782 42th Street','San Jose','CA','12043','www.zen.com','Alex','Caico', '(201) 703-0076','kjosh@yahoo.com');INSERT INTO CLIENT VALUES ('142','Sarah','77 Hill Ave','Chicago','IL','16407','www.shillyshally.com','Sarah','Cho', '(695) 703-0076','ted2018@gmail.com');INSERT INTO CLIENT VALUES ('086','Naphat','1712 Forbes Ave','Oakland','CA','15219','www.truthfaith.com','Naphat','Korwanich', '(412) 703-0076','cute.s@126.com');INSERT INTO CLIENT VALUES ('710','John','398 Forbes Ave','Pittsburgh','PA','15219','www.superheros.com','John','Ostlund', '(412) 703-0076','yhzhu.16@andrew.cmu.edu');INSERT INTO CLIENT VALUES ('708','Eliza','1209 21st Street','Chicago','IL','10041','www.nobody.com','Eliza','Pan', '(200) 703-0076','schu.18@qq.com');INSERT INTO CLIENT VALUES ('048','Sayo','102 Centre Ave','Pittsburgh','PA','15219','www.letitgo.com','Sayo','Sanu', '(412) 703-0076','zack18@qq.com');INSERT INTO CLIENT VALUES ('115','Raj','325 Mountainview Ave','Chicago','IL','94070','www.zipzap.com','Raj','Singh', '(393) 703-0076','reveriez@andrew.cmu.edu');INSERT INTO CLIENT VALUES ('154','Tim','1226 Mountainview Ave','New York','NY','94070','www.buddism.com','Tim','Weng', '(393) 703-0076','hank@yahoo.com');INSERT INTO CLIENT VALUES ('030','Peggy','1712 Forbes Ave','Pittsburgh','PA','15219','www.crazyone.com','Peggy','Ostlund', '(412) 703-0076','sophie@gmail.com');
INSERT INTO RAGREEMENT VALUES ('RA002',to_date('15-JUN-17  3:09pm', 'dd-mon-yy hh:miam'),to_date('28-JUN-17  5:09pm', 'dd-mon-yy hh:miam'),'100','189','C05','081','SF4-34ER');INSERT INTO RAGREEMENT VALUES ('RA018',to_date('1-AUG-17  3:09pm', 'dd-mon-yy hh:miam'),to_date('8-AUG-17  5:09pm', 'dd-mon-yy hh:miam'),'189','260','C05','048','SF4-34ER');INSERT INTO RAGREEMENT VALUES ('RA007',to_date('24-Aug-18  4:21pm', 'dd-mon-yy hh:miam'),to_date('07-SEP-18  4:21pm', 'dd-mon-yy hh:miam'),'454','483','A01','305','DFE-1099');INSERT INTO RAGREEMENT VALUES ('RA006',to_date('21-MAR-17  1:18pm', 'dd-mon-yy hh:miam'),to_date('02-APR-17  4:00pm', 'dd-mon-yy hh:miam'),'48','187','A23','086','ER-S323');INSERT INTO RAGREEMENT VALUES ('RA008',to_date('06-SEP-18  1:18pm', 'dd-mon-yy hh:miam'),to_date('19-SEP-18  5:18pm', 'dd-mon-yy hh:miam'),'328','365','A23','640','KJM-QP48');INSERT INTO RAGREEMENT VALUES ('RA005',to_date('18-JAN-18  10:18am', 'dd-mon-yy hh:miam'),to_date('29-MAY-18  1:18pm', 'dd-mon-yy hh:miam'),'58','87','B03','710','POD-2009');INSERT INTO RAGREEMENT VALUES ('RA009',to_date('02-DEC-17  2:09pm', 'dd-mon-yy hh:miam'),to_date('15-DEC-17  3:09pm', 'dd-mon-yy hh:miam'),'339','546','B05','048','DP-5112');INSERT INTO RAGREEMENT VALUES ('RA091',to_date('25-DEC-17  2:09pm', 'dd-mon-yy hh:miam'),to_date('29-DEC-17  3:09pm', 'dd-mon-yy hh:miam'),'546','600','B05','081','DP-5112');INSERT INTO RAGREEMENT VALUES ('RA112',to_date('20-OCT-18  1:18pm', 'dd-mon-yy hh:miam'),to_date('26-OCT-18  1:18pm', 'dd-mon-yy hh:miam'),'175','310','C03','115','HM-AS09');INSERT INTO RAGREEMENT VALUES ('RA100',to_date('3-JAN-17  12:09pm', 'dd-mon-yy hh:miam'),to_date('3-FEB-17  3:09pm', 'dd-mon-yy hh:miam'),'87','120','B03','030','SD-9983');INSERT INTO RAGREEMENT VALUES ('RA390',to_date('10-MAY-18  1:19pm', 'dd-mon-yy hh:miam'),to_date('16-MAY-18  1:18pm', 'dd-mon-yy hh:miam'),'197','230','B05','708','BV6-7223');INSERT INTO RAGREEMENT VALUES ('RA120',to_date('11-MAY-17  1:18pm', 'dd-mon-yy hh:miam'),to_date('23-MAY-17  1:28pm', 'dd-mon-yy hh:miam'),'238','467','B05','154','ADD-5674');INSERT INTO RAGREEMENT VALUES ('RA124',to_date('11-OCT-18  2:18pm', 'dd-mon-yy hh:miam'),to_date('22-OCT-18  4:15pm', 'dd-mon-yy hh:miam'),'483','550','B05','086','DFE-1099');INSERT INTO RAGREEMENT VALUES ('RA456',to_date('12-NOV-18  2:18pm', 'dd-mon-yy hh:miam'),to_date('16-NOV-18  4:15pm', 'dd-mon-yy hh:miam'),'87','150','B05','142','POD-2009');INSERT INTO RAGREEMENT VALUES ('RA399',to_date('10-AUG-18  1:19pm', 'dd-mon-yy hh:miam'),to_date('16-AUG-18  1:18pm', 'dd-mon-yy hh:miam'),'600','704','B05','048','DP-5112');INSERT INTO RAGREEMENT VALUES ('RA128',to_date('11-SEP-18  2:18pm', 'dd-mon-yy hh:miam'),to_date('23-SEP-18  1:28pm', 'dd-mon-yy hh:miam'),'467','530','B05','154','ADD-5674');INSERT INTO RAGREEMENT VALUES ('RA567',to_date('10-DEC-17  2:18pm', 'dd-mon-yy hh:miam'),to_date('23-DEC-17  1:28pm', 'dd-mon-yy hh:miam'),'153','230','B05','640','98A-B789');INSERT INTO RAGREEMENT VALUES ('RA555',to_date('12-JAN-18  3:14pm', 'dd-mon-yy hh:miam'),to_date('24-JAN-18  1:28pm', 'dd-mon-yy hh:miam'),'162','197','B05','305','BV6-7223');INSERT INTO RAGREEMENT VALUES ('RA111',to_date('02-JAN-17  1:18pm', 'dd-mon-yy hh:miam'),to_date('10-JAN-17  3:27pm', 'dd-mon-yy hh:miam'),'75','175','C03','708','HM-AS09');INSERT INTO RAGREEMENT VALUES ('RA559',to_date('4-APR-17   3:18pm', 'dd-mon-yy hh:miam'),to_date('20-APR-17  1:20pm', 'dd-mon-yy hh:miam'),'97','137','B05','305','BV6-7223');INSERT INTO RAGREEMENT VALUES ('RA019',to_date('1-NOV-17   3:09pm', 'dd-mon-yy hh:miam'),to_date('6-NOV-17  5:09pm', 'dd-mon-yy hh:miam'),'260','335','C05','048','SF4-34ER');INSERT INTO RAGREEMENT VALUES ('RA551',to_date('25-FEB-17  3:09pm', 'dd-mon-yy hh:miam'),to_date('04-MAR-17  5:09pm', 'dd-mon-yy hh:miam'),'120','142','C05','081','SD-9983');INSERT INTO RAGREEMENT VALUES ('RA554',to_date('25-FEB-17  3:09pm', 'dd-mon-yy hh:miam'),to_date('04-MAR-17  5:09pm', 'dd-mon-yy hh:miam'),'120','142','C05','081','SD-9983');INSERT INTO RAGREEMENT VALUES ('RA059',to_date('7-MAR-17   3:09pm', 'dd-mon-yy hh:miam'),to_date('16-MAR-17  5:09pm', 'dd-mon-yy hh:miam'),'142','169','C05','708','SD-9983');INSERT INTO RAGREEMENT VALUES ('RA069',to_date('4-MAY-17   3:59pm', 'dd-mon-yy hh:miam'),to_date('10-MAY-17  1:20pm', 'dd-mon-yy hh:miam'),'137','162','B05','305','BV6-7223');INSERT INTO RAGREEMENT VALUES ('RA639',to_date('28-MAY-17  3:59pm', 'dd-mon-yy hh:miam'),to_date('1-JUN-17  1:20pm', 'dd-mon-yy hh:miam'),'23','58','B05','030','POD-2009');INSERT INTO RAGREEMENT VALUES ('RA222',to_date('2-AUG-17   3:59pm', 'dd-mon-yy hh:miam'),to_date('16-AUG-17  1:20pm', 'dd-mon-yy hh:miam'),'187','230','B05','115','ER-S323');INSERT INTO RAGREEMENT VALUES ('RA223',to_date('15-NOV-17  3:59pm', 'dd-mon-yy hh:miam'),to_date('30-NOV-17  1:20pm', 'dd-mon-yy hh:miam'),'230','300','B05','115','ER-S323');INSERT INTO FAULTREPORT VALUES ('R100',to_date('7-JUL-17  3:09pm', 'dd-mon-yy hh:miam'),'Engine Jammed','987','SF4-34ER','RA002');INSERT INTO FAULTREPORT VALUES ('R200',to_date('10-SEP-18  3:15pm', 'dd-mon-yy hh:miam'),'Engine Jammed due to Water','567','DFE-1099','RA007');INSERT INTO FAULTREPORT VALUES ('R400',to_date('20-SEP-18  3:09pm', 'dd-mon-yy hh:miam'),'A/C not working','444','KJM-QP48','RA008');INSERT INTO FAULTREPORT VALUES ('R700',to_date('30-OCT-18  5:09pm', 'dd-mon-yy hh:miam'),'Enginer water level low','443','HM-AS09','RA112');INSERT INTO FAULTREPORT VALUES ('R800',to_date('05-FEB-17  3:09pm', 'dd-mon-yy hh:miam'),'Engine Jammed due to Water','444','SD-9983','RA100');INSERT INTO FAULTREPORT VALUES ('R900',to_date('01-NOV-18  3:12pm', 'dd-mon-yy hh:miam'),'Engine Jammed due to Water','567','DFE-1099','RA124');INSERT INTO FAULTREPORT VALUES ('R567',to_date('12-JAN-17  3:12pm', 'dd-mon-yy hh:miam'),'A/C not working','443','HM-AS09','RA111');INSERT INTO FAULTREPORT VALUES ('R776',to_date('25-APR-17  5:33pm', 'dd-mon-yy hh:miam'),'A/C not working','567','BV6-7223','RA559');INSERT INTO FAULTREPORT VALUES ('R665',to_date('8-NOV-17  3:09pm', 'dd-mon-yy hh:miam'),'Engine Jammed','987','SF4-34ER','RA019');


/*PART B */
COMMIT;ALTER TABLE EMPLOYEEADD CONSTRAINT Out_No_Fk FOREIGN KEY (OutNo) REFERENCES OUTLET (OutNo);


/*
References:
1. https://www.carsguide.com.au/
2. https://gist.github.com/HeroicEric/1102788
3. 
*/
