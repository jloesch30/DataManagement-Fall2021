-------------------------
----DROP STATEMENTS
---------------------------

--drops for tables
DROP TABLE PATRON_TITLE_HOLDS;
DROP TABLE CHECKOUTS;
DROP TABLE TITLE_LOC_LINKING;
DROP TABLE TITLE_AUTHOR_LINKING;
DROP TABLE PATRON_PHONE;
DROP TABLE PATRON; 
DROP TABLE AUTHOR;
DROP TABLE LOCATION;
DROP TABLE TITLE;

--drops for sequences
DROP SEQUENCE TITLE_COPY_ID_SEQ;
DROP SEQUENCE PATRON_ID_SEQ;
DROP SEQUENCE PHONE_ID_SEQ;
DROP SEQUENCE TITLE_ID_SEQ;
DROP SEQUENCE AUTHOR_ID_SEQ;
drop sequence Checkout_ID_seq;

-------------------------
----CREATE STATEMENTS
-------------------------

------creates for sequences
-- CREATE SEQUENCE FOR TITLE_COPY_ID
CREATE SEQUENCE TITLE_COPY_ID_SEQ
START WITH 1000001 INCREMENT BY 1;

-- CREATE SEQUENCE FOR PATRON_ID
CREATE SEQUENCE PATRON_ID_SEQ
START WITH 31;

-- CREATE SEQUENCE FOR PHONE_ID
CREATE SEQUENCE PHONE_ID_SEQ
START WITH 32;

-- CREATE SEQUENCE FOR TITLE_ID
CREATE SEQUENCE TITLE_ID_SEQ
START WITH 89;

-- CREATE SEQUENCE FOR AUTHOR_ID
CREATE SEQUENCE AUTHOR_ID_SEQ
start with 88;

CREATE SEQUENCE Checkout_ID_seq;


-------creates for tables
CREATE TABLE LOCATION (
  Branch_ID     NUMBER   PRIMARY KEY,
  Branch_Name   VARCHAR(30) NOT NULL UNIQUE,
  Address       VARCHAR(30) NOT NULL,
  City          VARCHAR(30) NOT NULL,
  State         CHAR(2) NOT NULL,
  Zip           CHAR(5) NOT NULL,
  Phone         CHAR(12) NOT NULL
);

CREATE TABLE PATRON (
  Patron_ID         NUMBER      DEFAULT Patron_ID_seq.NEXTVAL   PRIMARY KEY,
  First_Name        VARCHAR(50) NOT NULL,
  Last_Name         VARCHAR(50) NOT NULL,
  Email             VARCHAR(50) UNIQUE NOT NULL,
  Address_Line_1    VARCHAR(50) NOT NULL,
  Address_Line_2    VARCHAR(50) ,
  City              VARCHAR(30) NOT NULL,
  State             CHAR(2)     NOT NULL,
  Zip               CHAR(5)     NOT NULL,
  Accrued_Fees      NUMBER(5,2) DEFAULT 0,
  Primary_Branch	NUMBER(12) 	REFERENCES Location (Branch_ID),
  CONSTRAINT  email_length_check  CHECK (LENGTH(email) >= 7),
  CONSTRAINT  email_format_check   CHECK (Email LIKE '%@%.%')
 ); 
 

CREATE TABLE PATRON_PHONE (
  Phone_ID      NUMBER      DEFAULT Phone_ID_seq.NEXTVAL    PRIMARY KEY,
  PATRON_ID     NUMBER      NOT NULL,
  PHONE_TYPE    VARCHAR(20) NOT NULL,
  PHONE         CHAR(12)    NOT NULL,
  CONSTRAINT    phone_id_fk   FOREIGN KEY (PATRON_ID)  REFERENCES PATRON (PATRON_ID)
);


CREATE TABLE Author (
  Author_ID     NUMBER   DEFAULT Author_ID_seq.NEXTVAL  PRIMARY KEY,
  First_Name    VARCHAR(50) NOT NULL,
  Middle_Name   VARCHAR(50) NULL,
  Last_Name     VARCHAR(50) NOT NULL,
  Bio_Notes     VARCHAR(1000) NULL
);


CREATE TABLE Title (
  Title_ID          NUMBER          DEFAULT Title_ID_seq.NEXTVAL    PRIMARY KEY,
  Title             VARCHAR(100)    NOT NULL,
  Publisher         VARCHAR(50)     NOT NULL,
  Publish_Date      DATE            NOT NULL,
  Number_of_pages   NUMBER(5,0),
  Format            CHAR(1)         NOT NULL,
  Genre             VARCHAR(30)     NOT NULL,
  ISBN              VARCHAR(15)     NOT NULL  UNIQUE
 ); 

 

CREATE TABLE Title_Loc_Linking (
  Title_Copy_ID     NUMBER      DEFAULT Title_Copy_ID_seq.NEXTVAL PRIMARY KEY,
  Title_ID          NUMBER      NOT NULL, 
  Last_Location     NUMBER      NOT NULL ,
  Status            CHAR(1)     NOT NULL, 
  CONSTRAINT    title_id_fk1    FOREIGN KEY (Title_ID)  REFERENCES Title (Title_ID),
  CONSTRAINT    branch_id_fk1   FOREIGN KEY (Last_Location) REFERENCES Location (Branch_ID),
  CONSTRAINT    status_check  CHECK (STATUS IN ('T','P','A','O'))   
);


CREATE TABLE Title_Author_Linking (
  Author_ID     NUMBER NOT NULL,
  Title_ID      NUMBER NOT NULL,
  CONSTRAINT    author_title_pk   PRIMARY KEY (Title_ID, Author_ID),
  CONSTRAINT    AUTHOR_id_fk1     FOREIGN KEY (Author_ID)  REFERENCES AUTHOR (Author_ID),
  CONSTRAINT    TITLE_id_fk2      FOREIGN KEY (Title_ID)   REFERENCES TITLE (Title_ID)
);

 
CREATE TABLE Patron_Title_Holds (
  Hold_ID	NUMBER 	PRIMARY KEY,
  Patron_ID 	NUMBER	NOT NULL,
  Title_ID 	NUMBER 	NOT NULL,
  DATE_HELD	DATE	NOT NULL,
  CONSTRAINT    PATRON_id_fk2     FOREIGN KEY (Patron_ID)  REFERENCES PATRON (Patron_ID),
  CONSTRAINT    TITLE_id_fk3      FOREIGN KEY (Title_ID)   REFERENCES TITLE (Title_ID)
);
 
 
CREATE TABLE Checkouts (
  Checkout_id	NUMBER  DEFAULT Checkout_ID_seq.NEXTVAL  PRIMARY KEY,
  Patron_ID     NUMBER  NOT NULL,
  Title_COPY_ID NUMBER  NOT NULL,
  Date_Out      DATE    DEFAULT SYSDATE,
  Due_Back_Date DATE    DEFAULT (SYSDATE + 21),
  Date_In       DATE    NULL,
  Times_Renewed NUMBER  default 0 NOT NULL,
  Late_Flag     CHAR(1) default 'N' NOT NULL,
  CONSTRAINT    PATRON_id_fk3         FOREIGN KEY (Patron_ID)       REFERENCES PATRON (Patron_ID),
  CONSTRAINT    Title_COPY_ID_FK      FOREIGN KEY (Title_COPY_ID)   REFERENCES TITLE_LOC_LINKING (Title_COPY_ID),
  CONSTRAINT    times_renewed_check  CHECK (Times_Renewed <= 2)
);




----------------------------------------------------
--  SEED DATA
----------------------------------------------------
SET DEFINE OFF;

-- 6 LOCATIONS
Insert into Location values (1,'North Branch', '12 Mustang Trail', 'Guillory', 'TX', '73948', '555-263-3482');
Insert into Location values (2,'South Branch', '84 Almo Way', 'Guillory', 'TX', '73944', '555-263-2918');
Insert into Location values (3,'West Branch', '51447 Columbus Plaza' , 'West Guillory', 'TX', '73946', '555-263-9182');
Insert into Location values (4,'East Branch', '98507 Harper Avenue' , 'Guillory', 'TX', '73945', '555-263-3009');
Insert into Location values (5,'Northeast Central Branch', '10 Farmco Avenue' , 'Guillory', 'TX', '73947', '555-263-1526');
Insert into Location values (6,'Southwest Central Branch', '120 Arizona Plaza' , 'Guillory', 'TX', '73944', '555-263-9090');
commit;



--Patrons
INSERT INTO PATRON (PATRON_ID, FIRST_NAME, LAST_NAME, EMAIL, ADDRESS_LINE_1, ADDRESS_LINE_2, CITY, STATE, ZIP, ACCRUED_FEES, PRIMARY_BRANCH) VALUES (1,'Jamill','Kemm','JKemm@gmail.com','9 Burrows Avenue','Apt 1B','Guillory','TX','73948',0.1,1);
INSERT INTO PATRON (PATRON_ID, FIRST_NAME, LAST_NAME, EMAIL, ADDRESS_LINE_1, ADDRESS_LINE_2, CITY, STATE, ZIP, ACCRUED_FEES, PRIMARY_BRANCH) VALUES (2,'Jefferey','Kosiada','JKosiada@yahoo.com','3 Iowa Street',NULL,'Guillory','TX','73947',0.0,5);
INSERT INTO PATRON (PATRON_ID, FIRST_NAME, LAST_NAME, EMAIL, ADDRESS_LINE_1, ADDRESS_LINE_2, CITY, STATE, ZIP, ACCRUED_FEES, PRIMARY_BRANCH) VALUES (3,'Joline','Gloyens','JG966@gmail.com','6795 Graedel Street','B2','Guillory','TX','73945',0.0,4);
INSERT INTO PATRON (PATRON_ID, FIRST_NAME, LAST_NAME, EMAIL, ADDRESS_LINE_1, ADDRESS_LINE_2, CITY, STATE, ZIP, ACCRUED_FEES, PRIMARY_BRANCH) VALUES (4,'Kary','Klimkowski','hookemfan192@hyper.net','14 Bluejay Crossing',NULL,'Guillory','TX','73944',0.1,6);
INSERT INTO PATRON (PATRON_ID, FIRST_NAME, LAST_NAME, EMAIL, ADDRESS_LINE_1, ADDRESS_LINE_2, CITY, STATE, ZIP, ACCRUED_FEES, PRIMARY_BRANCH) VALUES (5,'Lana','Eddison','LEddison@gmail.com','64 Calypso Pass','Unit C','West Guillory','TX','73940',0.0,3);
INSERT INTO PATRON (PATRON_ID, FIRST_NAME, LAST_NAME, EMAIL, ADDRESS_LINE_1, ADDRESS_LINE_2, CITY, STATE, ZIP, ACCRUED_FEES, PRIMARY_BRANCH) VALUES (6,'Laure','Chatin','LC194@yahoo.com','90 Logan Hill',NULL,'Guillory','TX','73947',0.2,5);
INSERT INTO PATRON (PATRON_ID, FIRST_NAME, LAST_NAME, EMAIL, ADDRESS_LINE_1, ADDRESS_LINE_2, CITY, STATE, ZIP, ACCRUED_FEES, PRIMARY_BRANCH) VALUES (7,'Leighton','Breawood','LB752@gmail.com','7 Welch Junction',NULL,'Guillory','TX','73945',0.0,4);
INSERT INTO PATRON (PATRON_ID, FIRST_NAME, LAST_NAME, EMAIL, ADDRESS_LINE_1, ADDRESS_LINE_2, CITY, STATE, ZIP, ACCRUED_FEES, PRIMARY_BRANCH) VALUES (8,'Lila','Weightman','WeightmanL1@hotmail.com','1494 Mcguire Street',NULL,'Guillory','TX','73947',0.55,5);
INSERT INTO PATRON (PATRON_ID, FIRST_NAME, LAST_NAME, EMAIL, ADDRESS_LINE_1, ADDRESS_LINE_2, CITY, STATE, ZIP, ACCRUED_FEES, PRIMARY_BRANCH) VALUES (9,'Linnell','Cranmere','LC697@yahoo.com','30 Crescent Oaks Terrace','Apt 5A','Guillory','TX','73947',3.25,5);
INSERT INTO PATRON (PATRON_ID, FIRST_NAME, LAST_NAME, EMAIL, ADDRESS_LINE_1, ADDRESS_LINE_2, CITY, STATE, ZIP, ACCRUED_FEES, PRIMARY_BRANCH) VALUES (10,'Malory','Buttrum','malbuttrum@mail.net','34 Hudson Lane',NULL,'Guillory','TX','73944',0.1,6);
INSERT INTO PATRON (PATRON_ID, FIRST_NAME, LAST_NAME, EMAIL, ADDRESS_LINE_1, ADDRESS_LINE_2, CITY, STATE, ZIP, ACCRUED_FEES, PRIMARY_BRANCH) VALUES (11,'Megan','Rotlauf','MRotlauf@gmail.com','09756 Bashford Point',NULL,'Guillory','TX','73945',0.0,4);
INSERT INTO PATRON (PATRON_ID, FIRST_NAME, LAST_NAME, EMAIL, ADDRESS_LINE_1, ADDRESS_LINE_2, CITY, STATE, ZIP, ACCRUED_FEES, PRIMARY_BRANCH) VALUES (12,'Meggie','Christoffels','MC535@gmail.com','38 Longview Point',NULL,'Guillory','TX','73948',0.0,1);
INSERT INTO PATRON (PATRON_ID, FIRST_NAME, LAST_NAME, EMAIL, ADDRESS_LINE_1, ADDRESS_LINE_2, CITY, STATE, ZIP, ACCRUED_FEES, PRIMARY_BRANCH) VALUES (13,'Omero','Goomes','OGoomes@yahoo.com','11 Fairfield Terrace',NULL,'Guillory','TX','73944',0.0,6);
INSERT INTO PATRON (PATRON_ID, FIRST_NAME, LAST_NAME, EMAIL, ADDRESS_LINE_1, ADDRESS_LINE_2, CITY, STATE, ZIP, ACCRUED_FEES, PRIMARY_BRANCH) VALUES (14,'Oren','Darycott','orenlovescats@yahoo.com','8 North Parkway',NULL,'Guillory','TX','73946',6.5,3);
INSERT INTO PATRON (PATRON_ID, FIRST_NAME, LAST_NAME, EMAIL, ADDRESS_LINE_1, ADDRESS_LINE_2, CITY, STATE, ZIP, ACCRUED_FEES, PRIMARY_BRANCH) VALUES (15,'Roda','Devil','RD427@yahoo.com','47196 Golf Park',NULL,'Guillory','TX','73947',1.1,5);
INSERT INTO PATRON (PATRON_ID, FIRST_NAME, LAST_NAME, EMAIL, ADDRESS_LINE_1, ADDRESS_LINE_2, CITY, STATE, ZIP, ACCRUED_FEES, PRIMARY_BRANCH) VALUES (16,'Rosalind','Joncic','RJoncic@gmail.com','89 Lindbergh Point',NULL,'Guillory','TX','73946',0.0,3);
INSERT INTO PATRON (PATRON_ID, FIRST_NAME, LAST_NAME, EMAIL, ADDRESS_LINE_1, ADDRESS_LINE_2, CITY, STATE, ZIP, ACCRUED_FEES, PRIMARY_BRANCH) VALUES (17,'Shirline','Laverock','shirlielou@gmail.com','6 Cody Terrace','Unit A','Guillory','TX','73945',0.75,4);
INSERT INTO PATRON (PATRON_ID, FIRST_NAME, LAST_NAME, EMAIL, ADDRESS_LINE_1, ADDRESS_LINE_2, CITY, STATE, ZIP, ACCRUED_FEES, PRIMARY_BRANCH) VALUES (18,'Sidoney','Schellig','SS947@gmail.com','039 Delladonna Parkway',NULL,'Guillory','TX','73946',0.35,3);
INSERT INTO PATRON (PATRON_ID, FIRST_NAME, LAST_NAME, EMAIL, ADDRESS_LINE_1, ADDRESS_LINE_2, CITY, STATE, ZIP, ACCRUED_FEES, PRIMARY_BRANCH) VALUES (19,'Sue','Stonehouse','stonesthrow@hotmail.com','294 Dennis Parkway',NULL,'Guillory','TX','73948',0.1,1);
INSERT INTO PATRON (PATRON_ID, FIRST_NAME, LAST_NAME, EMAIL, ADDRESS_LINE_1, ADDRESS_LINE_2, CITY, STATE, ZIP, ACCRUED_FEES, PRIMARY_BRANCH) VALUES (20,'Tarra','Vaughton','tarrav99@mail.net','7 Calypso Parkway','Unit 2','Guillory','TX','73947',0.0,5);
INSERT INTO PATRON (PATRON_ID, FIRST_NAME, LAST_NAME, EMAIL, ADDRESS_LINE_1, ADDRESS_LINE_2, CITY, STATE, ZIP, ACCRUED_FEES, PRIMARY_BRANCH) VALUES (21,'Teresina','Nelle','TN870@yahoo.com','480 Pierstorff Way',NULL,'Guillory','TX','73948',1.25,1);
INSERT INTO PATRON (PATRON_ID, FIRST_NAME, LAST_NAME, EMAIL, ADDRESS_LINE_1, ADDRESS_LINE_2, CITY, STATE, ZIP, ACCRUED_FEES, PRIMARY_BRANCH) VALUES (22,'Thomas','Haslehurst','THaslehurst@gmail.com','1560 Lake View Avenue',NULL,'Guillory','TX','73946',0.0,3);
INSERT INTO PATRON (PATRON_ID, FIRST_NAME, LAST_NAME, EMAIL, ADDRESS_LINE_1, ADDRESS_LINE_2, CITY, STATE, ZIP, ACCRUED_FEES, PRIMARY_BRANCH) VALUES (23,'Zarah','Lockney','zlock99@hotmail.com','0 Johnson Pass',NULL,'Guillory','TX','73947',0.0,5);
INSERT INTO PATRON (PATRON_ID, FIRST_NAME, LAST_NAME, EMAIL, ADDRESS_LINE_1, ADDRESS_LINE_2, CITY, STATE, ZIP, ACCRUED_FEES, PRIMARY_BRANCH) VALUES (24,'Zelma','Reynalds','ZR675@gmail.com','9691 Longview Street',NULL,'West Guillory','TX','73940',7.25,3);
INSERT INTO PATRON (PATRON_ID, FIRST_NAME, LAST_NAME, EMAIL, ADDRESS_LINE_1, ADDRESS_LINE_2, CITY, STATE, ZIP, ACCRUED_FEES, PRIMARY_BRANCH) VALUES (25,'Zsa zsa','Chifney','ZChifney@yahoo.com','0396 Lindbergh Pass','Apt 301','Guillory','TX','73946',0.0,3);
INSERT INTO PATRON (PATRON_ID, FIRST_NAME, LAST_NAME, EMAIL, ADDRESS_LINE_1, ADDRESS_LINE_2, CITY, STATE, ZIP, ACCRUED_FEES, PRIMARY_BRANCH) VALUES (26,'Blanch','Betchley','gosox99187@yahoo.com','48 Cordelia Hill',NULL,'Guillory','TX','73945',1.1,4);
INSERT INTO PATRON (PATRON_ID, FIRST_NAME, LAST_NAME, EMAIL, ADDRESS_LINE_1, ADDRESS_LINE_2, CITY, STATE, ZIP, ACCRUED_FEES, PRIMARY_BRANCH) VALUES (27,'Nanine','Carlyon','NCarlyon@gmail.com','40 Cherokee Way',NULL,'Guillory','TX','73945',0.0,4);
INSERT INTO PATRON (PATRON_ID, FIRST_NAME, LAST_NAME, EMAIL, ADDRESS_LINE_1, ADDRESS_LINE_2, CITY, STATE, ZIP, ACCRUED_FEES, PRIMARY_BRANCH) VALUES (28,'Wright','Avard','wrighta1212@hotmail.com','00839 Kipling Street',NULL,'Guillory','TX','73947',0.1,5);
INSERT INTO PATRON (PATRON_ID, FIRST_NAME, LAST_NAME, EMAIL, ADDRESS_LINE_1, ADDRESS_LINE_2, CITY, STATE, ZIP, ACCRUED_FEES, PRIMARY_BRANCH) VALUES (29,'Appolonia','Kilmartin','AK878@gmail.com','4 Center Plaza',NULL,'West Guillory','TX','73940',0.0,3);
INSERT INTO PATRON (PATRON_ID, FIRST_NAME, LAST_NAME, EMAIL, ADDRESS_LINE_1, ADDRESS_LINE_2, CITY, STATE, ZIP, ACCRUED_FEES, PRIMARY_BRANCH) VALUES (30,'Ayn','Style','AS932@yahoo.com','63129 Ridgeway Trail','Suite 2','Guillory','TX','73946',0.1,3);
commit;

--insert patron phones
INSERT INTO PATRON_PHONE VALUES (1,1,'mobile','555-263-4329');
INSERT INTO PATRON_PHONE VALUES (2,1,'home','555-263-5955');
INSERT INTO PATRON_PHONE VALUES (3,2,'home','555-263-5955');
INSERT INTO PATRON_PHONE VALUES (4,3,'mobile','144-402-5732');
INSERT INTO PATRON_PHONE VALUES (5,4,'mobile','555-263-9515');
INSERT INTO PATRON_PHONE VALUES (6,4,'home','555-263-8273');
INSERT INTO PATRON_PHONE VALUES (7,4,'work','555-263-2928');
INSERT INTO PATRON_PHONE VALUES (8,5,'mobile','603-623-3885');
INSERT INTO PATRON_PHONE VALUES (9,6,'mobile','555-263-4450');
INSERT INTO PATRON_PHONE VALUES (10,7,'work','555-263-1377');
INSERT INTO PATRON_PHONE VALUES (11,9,'mobile','830-131-1258');
INSERT INTO PATRON_PHONE VALUES (12,10,'home','555-263-3029');
INSERT INTO PATRON_PHONE VALUES (13,10,'work','555-263-8908');
INSERT INTO PATRON_PHONE VALUES (14,11,'mobile','143-498-8226');
INSERT INTO PATRON_PHONE VALUES (15,13,'mobile','652-718-7370');
INSERT INTO PATRON_PHONE VALUES (16,14,'home','555-263-2192');
INSERT INTO PATRON_PHONE VALUES (17,14,'mobile','783-625-7173');
INSERT INTO PATRON_PHONE VALUES (18,16,'mobile','555-263-4967');
INSERT INTO PATRON_PHONE VALUES (19,17,'mobile','497-772-5452');
INSERT INTO PATRON_PHONE VALUES (20,18,'mobile','244-307-8888');
INSERT INTO PATRON_PHONE VALUES (21,19,'mobile','555-263-5415');
INSERT INTO PATRON_PHONE VALUES (22,20,'mobile','555-263-3363');
INSERT INTO PATRON_PHONE VALUES (23,21,'mobile','108-321-3682');
INSERT INTO PATRON_PHONE VALUES (24,21,'home','555-263-8765');
INSERT INTO PATRON_PHONE VALUES (25,23,'home','555-263-2553');
INSERT INTO PATRON_PHONE VALUES (26,24,'mobile','394-710-5408');
INSERT INTO PATRON_PHONE VALUES (27,25,'mobile','421-840-7968');
INSERT INTO PATRON_PHONE VALUES (28,27,'home','555-263-4146');
INSERT INTO PATRON_PHONE VALUES (29,28,'mobile','300-206-2921');
INSERT INTO PATRON_PHONE VALUES (30,29,'mobile','689-816-4304');
INSERT INTO PATRON_PHONE VALUES (31,30,'home','555-263-7147');
INSERT INTO PATRON_PHONE VALUES (32,30,'mobile','448-773-4915');
commit;



-- Insert titles
INSERT INTO TITLE (TITLE_ID, TITLE, PUBLISHER, PUBLISH_DATE, NUMBER_OF_PAGES, GENRE, FORMAT, ISBN) VALUES (1,'Frida','Harper Perennial',to_date('01-Jan-2002', 'DD-MON-RR'),528,'BIO','B','978-0060085896');
INSERT INTO TITLE (TITLE_ID, TITLE, PUBLISHER, PUBLISH_DATE, NUMBER_OF_PAGES, GENRE, FORMAT, ISBN) VALUES (2,'The Beast','Verso',to_date('03-Jun-2014', 'DD-MON-RR'),224,'NON','B','978-1781682975');
INSERT INTO TITLE (TITLE_ID, TITLE, PUBLISHER, PUBLISH_DATE, NUMBER_OF_PAGES, GENRE, FORMAT, ISBN) VALUES (3,'Armada','Ballantine Books',to_date('12-Apr-2016', 'DD-MON-RR'),384,'SCI','B','978-0804137270');
INSERT INTO TITLE (TITLE_ID, TITLE, PUBLISHER, PUBLISH_DATE, NUMBER_OF_PAGES, GENRE, FORMAT, ISBN) VALUES (4,'The Shadow of the Wind','Penguin Books',to_date('01-Feb-2005', 'DD-MON-RR'),487,'MYS','B','978-0143034902');
INSERT INTO TITLE (TITLE_ID, TITLE, PUBLISHER, PUBLISH_DATE, NUMBER_OF_PAGES, GENRE, FORMAT, ISBN) VALUES (5,'Martian Chronicles','Simon and Schuster',to_date('17-Apr-2012', 'DD-MON-RR'),256,'FIC','B','978-1451678192');
INSERT INTO TITLE (TITLE_ID, TITLE, PUBLISHER, PUBLISH_DATE, NUMBER_OF_PAGES, GENRE, FORMAT, ISBN) VALUES (6,'Friday Night Lights','Da Capo Press',to_date('11-Aug-2015', 'DD-MON-RR'),432,'NON','B','978-0306824203');
INSERT INTO TITLE (TITLE_ID, TITLE, PUBLISHER, PUBLISH_DATE, NUMBER_OF_PAGES, GENRE, FORMAT, ISBN) VALUES (7,'1984','Signet Classic',to_date('01-Jan-1961', 'DD-MON-RR'),328,'SCI','B','978-0451524935');
INSERT INTO TITLE (TITLE_ID, TITLE, PUBLISHER, PUBLISH_DATE, NUMBER_OF_PAGES, GENRE, FORMAT, ISBN) VALUES (8,'The Time Traveler''s Wife','Scribner',to_date('06-May-2014', 'DD-MON-RR'),592,'ROM','B','978-1476764832');
INSERT INTO TITLE (TITLE_ID, TITLE, PUBLISHER, PUBLISH_DATE, NUMBER_OF_PAGES, GENRE, FORMAT, ISBN) VALUES (9,'Windup Bird Chronicles','Vintage',to_date('01-Sep-1998', 'DD-MON-RR'),607,'FIC','B','978-0679775430');
INSERT INTO TITLE (TITLE_ID, TITLE, PUBLISHER, PUBLISH_DATE, NUMBER_OF_PAGES, GENRE, FORMAT, ISBN) VALUES (10,'Dune','Chilton Company',to_date('01-Aug-1965', 'DD-MON-RR'),720,'SCI','B','978-0143111580');
INSERT INTO TITLE (TITLE_ID, TITLE, PUBLISHER, PUBLISH_DATE, NUMBER_OF_PAGES, GENRE, FORMAT, ISBN) VALUES (11,'Mindset','Ballantine Books',to_date('26-Dec-2007', 'DD-MON-RR'),320,'SEL','B','978-0345472328');
INSERT INTO TITLE (TITLE_ID, TITLE, PUBLISHER, PUBLISH_DATE, NUMBER_OF_PAGES, GENRE, FORMAT, ISBN) VALUES (12,'A Brief History of Time','Bantam',to_date('01-Sep-1998', 'DD-MON-RR'),212,'NON','B','978-0553380163');
INSERT INTO TITLE (TITLE_ID, TITLE, PUBLISHER, PUBLISH_DATE, NUMBER_OF_PAGES, GENRE, FORMAT, ISBN) VALUES (13,'Catching Fire','Scholastic Press',to_date('04-Jun-2013', 'DD-MON-RR'),400,'FIC','B','978-0545586177');
INSERT INTO TITLE (TITLE_ID, TITLE, PUBLISHER, PUBLISH_DATE, NUMBER_OF_PAGES, GENRE, FORMAT, ISBN) VALUES (14,'How to be an Anti-Racist','One World',to_date('13-Aug-2019', 'DD-MON-RR'),284,'AUT','E','B07D2364N5');
INSERT INTO TITLE (TITLE_ID, TITLE, PUBLISHER, PUBLISH_DATE, NUMBER_OF_PAGES, GENRE, FORMAT, ISBN) VALUES (15,'The Guest List','William Morrow',to_date('02-Jun-2020', 'DD-MON-RR'),320,'THR','B','978-0062868930');
INSERT INTO TITLE (TITLE_ID, TITLE, PUBLISHER, PUBLISH_DATE, NUMBER_OF_PAGES, GENRE, FORMAT, ISBN) VALUES (16,'Essentialism','Currency',to_date('15-Apr-2014', 'DD-MON-RR'),272,'SEL','B','978-0804137386');
INSERT INTO TITLE (TITLE_ID, TITLE, PUBLISHER, PUBLISH_DATE, NUMBER_OF_PAGES, GENRE, FORMAT, ISBN) VALUES (17,'Lonesome Dove','Simon and Schuster',to_date('24-May-2010', 'DD-MON-RR'),964,'FIC','E','B003NE6HD4');
INSERT INTO TITLE (TITLE_ID, TITLE, PUBLISHER, PUBLISH_DATE, NUMBER_OF_PAGES, GENRE, FORMAT, ISBN) VALUES (18,'1776','Simon and Schuster',to_date('27-Jun-2006', 'DD-MON-RR'),386,'HIS','B','978-0743226721');
INSERT INTO TITLE (TITLE_ID, TITLE, PUBLISHER, PUBLISH_DATE, NUMBER_OF_PAGES, GENRE, FORMAT, ISBN) VALUES (19,'A Game of Thrones','Bantam',to_date('28-May-2002', 'DD-MON-RR'),704,'FAN','B','978-0553381689');
INSERT INTO TITLE (TITLE_ID, TITLE, PUBLISHER, PUBLISH_DATE, NUMBER_OF_PAGES, GENRE, FORMAT, ISBN) VALUES (20,'Whole','BenBella Books',to_date('06-May-2014', 'DD-MON-RR'),352,'NON','B','978-1939529848');
INSERT INTO TITLE (TITLE_ID, TITLE, PUBLISHER, PUBLISH_DATE, NUMBER_OF_PAGES, GENRE, FORMAT, ISBN) VALUES (21,'Becoming','Crown Publishing Group',to_date('13-Nov-2018', 'DD-MON-RR'),448,'NON','B','978-1524763138');
INSERT INTO TITLE (TITLE_ID, TITLE, PUBLISHER, PUBLISH_DATE, NUMBER_OF_PAGES, GENRE, FORMAT, ISBN) VALUES (22,'The Woman in the Window','William Morrow',to_date('05-Mar-2019', 'DD-MON-RR'),463,'THR','B','978-0062678423');
INSERT INTO TITLE (TITLE_ID, TITLE, PUBLISHER, PUBLISH_DATE, NUMBER_OF_PAGES, GENRE, FORMAT, ISBN) VALUES (23,'The Years of Lyndon Johnson: The Path to Power','Vintage',to_date('17-Feb-1990', 'DD-MON-RR'),960,'NON','B','978-0679729457');
INSERT INTO TITLE (TITLE_ID, TITLE, PUBLISHER, PUBLISH_DATE, NUMBER_OF_PAGES, GENRE, FORMAT, ISBN) VALUES (24,'A Beautiful Mind','Faber and Faber',to_date('15-Nov-2012', 'DD-MON-RR'),480,'BIO','E','B00A9MOAR8');
INSERT INTO TITLE (TITLE_ID, TITLE, PUBLISHER, PUBLISH_DATE, NUMBER_OF_PAGES, GENRE, FORMAT, ISBN) VALUES (25,'The Lion the Witch and the Wardrobe','HarperCollins',to_date('02-Jan-2008', 'DD-MON-RR'),208,'FAN','E','978-0064404990');
INSERT INTO TITLE (TITLE_ID, TITLE, PUBLISHER, PUBLISH_DATE, NUMBER_OF_PAGES, GENRE, FORMAT, ISBN) VALUES (26,'The Godfather','Berkley',to_date('01-Mar-2002', 'DD-MON-RR'),448,'FIC','B','978-0451205766');
INSERT INTO TITLE (TITLE_ID, TITLE, PUBLISHER, PUBLISH_DATE, NUMBER_OF_PAGES, GENRE, FORMAT, ISBN) VALUES (27,'One Hundred Years of Solitude','Harper Perennial Modern Classics',to_date('21-Feb-2006', 'DD-MON-RR'),417,'FIC','B','60883286');
INSERT INTO TITLE (TITLE_ID, TITLE, PUBLISHER, PUBLISH_DATE, NUMBER_OF_PAGES, GENRE, FORMAT, ISBN) VALUES (28,'Red, White, and Royal Blue','St. Martin''s Griffin',to_date('14-May-2019', 'DD-MON-RR'),432,'ROM','B','978-1250316776');
INSERT INTO TITLE (TITLE_ID, TITLE, PUBLISHER, PUBLISH_DATE, NUMBER_OF_PAGES, GENRE, FORMAT, ISBN) VALUES (29,'Wool','Houghton Mifflin Harcourt',to_date('19-May-2020', 'DD-MON-RR'),592,'SCI','E','B088SY4GSD');
INSERT INTO TITLE (TITLE_ID, TITLE, PUBLISHER, PUBLISH_DATE, NUMBER_OF_PAGES, GENRE, FORMAT, ISBN) VALUES (30,'The Girl with the Dragon Tattoo','Vintage',to_date('22-Nov-2011', 'DD-MON-RR'),672,'MYS','B','978-0307949486');
INSERT INTO TITLE (TITLE_ID, TITLE, PUBLISHER, PUBLISH_DATE, NUMBER_OF_PAGES, GENRE, FORMAT, ISBN) VALUES (31,'Between The World and Me','One World',to_date('14-Jul-2015', 'DD-MON-RR'),176,'NON','B','978-0812993547');
INSERT INTO TITLE (TITLE_ID, TITLE, PUBLISHER, PUBLISH_DATE, NUMBER_OF_PAGES, GENRE, FORMAT, ISBN) VALUES (32,'Empire Falls','Vintage',to_date('12-Apr-2002', 'DD-MON-RR'),483,'FIC','B','978-0375726408');
INSERT INTO TITLE (TITLE_ID, TITLE, PUBLISHER, PUBLISH_DATE, NUMBER_OF_PAGES, GENRE, FORMAT, ISBN) VALUES (33,'All Our Wrong Todays','Dutton',to_date('20-Feb-2018', 'DD-MON-RR'),400,'SCI','B','978-1101985151');
INSERT INTO TITLE (TITLE_ID, TITLE, PUBLISHER, PUBLISH_DATE, NUMBER_OF_PAGES, GENRE, FORMAT, ISBN) VALUES (34,'7 Habits of Highly Effective People','Simon and Schuster',to_date('19-Nov-2013', 'DD-MON-RR'),432,'SEL','B','978-1451639612');
INSERT INTO TITLE (TITLE_ID, TITLE, PUBLISHER, PUBLISH_DATE, NUMBER_OF_PAGES, GENRE, FORMAT, ISBN) VALUES (35,'Freakonomics','William Morrow Paperbacks',to_date('25-Aug-2009', 'DD-MON-RR'),315,'NON','B','978-0060731335');
INSERT INTO TITLE (TITLE_ID, TITLE, PUBLISHER, PUBLISH_DATE, NUMBER_OF_PAGES, GENRE, FORMAT, ISBN) VALUES (36,'Make Time: How to Focus on What Matters Every Day','Currency',to_date('25-Sep-2018', 'DD-MON-RR'),304,'SEL','B','978-0525572428');
INSERT INTO TITLE (TITLE_ID, TITLE, PUBLISHER, PUBLISH_DATE, NUMBER_OF_PAGES, GENRE, FORMAT, ISBN) VALUES (37,'Endurance','Basic Books',to_date('28-Apr-2015', 'DD-MON-RR'),357,'NON','B','978-0465062881');
INSERT INTO TITLE (TITLE_ID, TITLE, PUBLISHER, PUBLISH_DATE, NUMBER_OF_PAGES, GENRE, FORMAT, ISBN) VALUES (38,'Alexander Hamilton','Penguin Books',to_date('29-Mar-2005', 'DD-MON-RR'),818,'BIO','B','978-0143034759');
INSERT INTO TITLE (TITLE_ID, TITLE, PUBLISHER, PUBLISH_DATE, NUMBER_OF_PAGES, GENRE, FORMAT, ISBN) VALUES (39,'Gone Girl','Broadway Books',to_date('22-Apr-2014', 'DD-MON-RR'),422,'THR','B','978-0307588371');
INSERT INTO TITLE (TITLE_ID, TITLE, PUBLISHER, PUBLISH_DATE, NUMBER_OF_PAGES, GENRE, FORMAT, ISBN) VALUES (40,'The New Jim Crow','The New Press',to_date('07-Jan-2020', 'DD-MON-RR'),352,'NON','B','978-1620971932');
INSERT INTO TITLE (TITLE_ID, TITLE, PUBLISHER, PUBLISH_DATE, NUMBER_OF_PAGES, GENRE, FORMAT, ISBN) VALUES (41,'Grant','Penguin Books',to_date('25-Sep-2018', 'DD-MON-RR'),1104,'HIS','B','978-0143110637');
INSERT INTO TITLE (TITLE_ID, TITLE, PUBLISHER, PUBLISH_DATE, NUMBER_OF_PAGES, GENRE, FORMAT, ISBN) VALUES (42,'Prince: A Private View','St. Martin''s Press',to_date('24-Oct-2017', 'DD-MON-RR'),256,'BIO','B','978-1250134431');
INSERT INTO TITLE (TITLE_ID, TITLE, PUBLISHER, PUBLISH_DATE, NUMBER_OF_PAGES, GENRE, FORMAT, ISBN) VALUES (43,'The Da Vinci Code','Anchor',to_date('31-Mar-2009', 'DD-MON-RR'),597,'MYS','B','978-0307474278');
INSERT INTO TITLE (TITLE_ID, TITLE, PUBLISHER, PUBLISH_DATE, NUMBER_OF_PAGES, GENRE, FORMAT, ISBN) VALUES (44,'Man Called Ove','Washington Square Press',to_date('05-May-2015', 'DD-MON-RR'),337,'FIC','B','978-1476738024');
INSERT INTO TITLE (TITLE_ID, TITLE, PUBLISHER, PUBLISH_DATE, NUMBER_OF_PAGES, GENRE, FORMAT, ISBN) VALUES (45,'The Silent Patient','Celadon Books',to_date('05-Feb-2019', 'DD-MON-RR'),336,'THR','B','978-1250301697');
INSERT INTO TITLE (TITLE_ID, TITLE, PUBLISHER, PUBLISH_DATE, NUMBER_OF_PAGES, GENRE, FORMAT, ISBN) VALUES (46,'In Cold Blood','Vintage ',to_date('01-Feb-1994', 'DD-MON-RR'),343,'MYS','B','978-0679745587');
INSERT INTO TITLE (TITLE_ID, TITLE, PUBLISHER, PUBLISH_DATE, NUMBER_OF_PAGES, GENRE, FORMAT, ISBN) VALUES (47,'The Alchemist','HarperOne',to_date('15-Apr-2014', 'DD-MON-RR'),208,'FIC','B','978-0062315007');
INSERT INTO TITLE (TITLE_ID, TITLE, PUBLISHER, PUBLISH_DATE, NUMBER_OF_PAGES, GENRE, FORMAT, ISBN) VALUES (48,'The Handmaid''s Tail','Anchor',to_date('16-Mar-1998', 'DD-MON-RR'),311,'FIC','B','978-0385490818');
INSERT INTO TITLE (TITLE_ID, TITLE, PUBLISHER, PUBLISH_DATE, NUMBER_OF_PAGES, GENRE, FORMAT, ISBN) VALUES (49,'The President Is Missing','Grand Central Publishing',to_date('11-Jun-2019', 'DD-MON-RR'),528,'MYS','B','978-1538713839');
INSERT INTO TITLE (TITLE_ID, TITLE, PUBLISHER, PUBLISH_DATE, NUMBER_OF_PAGES, GENRE, FORMAT, ISBN) VALUES (50,'Alan Turing: The Enigma','Princeton University Press',to_date('10-Nov-2014', 'DD-MON-RR'),768,'BIO','B','978-0691164724');
INSERT INTO TITLE (TITLE_ID, TITLE, PUBLISHER, PUBLISH_DATE, NUMBER_OF_PAGES, GENRE, FORMAT, ISBN) VALUES (51,'Steve Jobs','Simon and Schuster',to_date('24-Oct-2011', 'DD-MON-RR'),656,'BIO','B','978-1451648539');
INSERT INTO TITLE (TITLE_ID, TITLE, PUBLISHER, PUBLISH_DATE, NUMBER_OF_PAGES, GENRE, FORMAT, ISBN) VALUES (52,'Modern Romance','Penguin Books',to_date('14-Jun-2016', 'DD-MON-RR'),288,'NON','B','978-0143109259');
INSERT INTO TITLE (TITLE_ID, TITLE, PUBLISHER, PUBLISH_DATE, NUMBER_OF_PAGES, GENRE, FORMAT, ISBN) VALUES (53,'The Hunger Games','Scholastic Press',to_date('03-Jul-2010', 'DD-MON-RR'),384,'FIC','B','978-0439023528');
INSERT INTO TITLE (TITLE_ID, TITLE, PUBLISHER, PUBLISH_DATE, NUMBER_OF_PAGES, GENRE, FORMAT, ISBN) VALUES (54,'Of Mice and Men','Penguin Books',to_date('01-Sep-1993', 'DD-MON-RR'),107,'FIC','B','978-0140177398');
INSERT INTO TITLE (TITLE_ID, TITLE, PUBLISHER, PUBLISH_DATE, NUMBER_OF_PAGES, GENRE, FORMAT, ISBN) VALUES (55,'White Fragility','Beacon Press',to_date('26-Jun-2018', 'DD-MON-RR'),192,'SEL','B','978-0807047415');
INSERT INTO TITLE (TITLE_ID, TITLE, PUBLISHER, PUBLISH_DATE, NUMBER_OF_PAGES, GENRE, FORMAT, ISBN) VALUES (56,'The Sixth Extiction','Picador',to_date('06-Jan-2015', 'DD-MON-RR'),336,'NON','B','978-1250062185');
INSERT INTO TITLE (TITLE_ID, TITLE, PUBLISHER, PUBLISH_DATE, NUMBER_OF_PAGES, GENRE, FORMAT, ISBN) VALUES (57,'Will in the World','W. W. Norton and Company',to_date('04-Apr-2016', 'DD-MON-RR'),464,'BIO','B','978-0393352603');
INSERT INTO TITLE (TITLE_ID, TITLE, PUBLISHER, PUBLISH_DATE, NUMBER_OF_PAGES, GENRE, FORMAT, ISBN) VALUES (58,'E=mc²','Berkley Publishing Group',to_date('01-Oct-2001', 'DD-MON-RR'),337,'BIO','B','978-0425181645');
INSERT INTO TITLE (TITLE_ID, TITLE, PUBLISHER, PUBLISH_DATE, NUMBER_OF_PAGES, GENRE, FORMAT, ISBN) VALUES (59,'Ender''s Game','Tor Science Fiction',to_date('15-Jul-1994', 'DD-MON-RR'),352,'SCI','B','978-0812550702');
INSERT INTO TITLE (TITLE_ID, TITLE, PUBLISHER, PUBLISH_DATE, NUMBER_OF_PAGES, GENRE, FORMAT, ISBN) VALUES (60,'The Martian','Broadway Books',to_date('28-Oct-2014', 'DD-MON-RR'),387,'SCI','B','978-0553418026');
INSERT INTO TITLE (TITLE_ID, TITLE, PUBLISHER, PUBLISH_DATE, NUMBER_OF_PAGES, GENRE, FORMAT, ISBN) VALUES (61,'I Know Why The Caged Bird Sings','Ballantine Books',to_date('21-Apr-2009', 'DD-MON-RR'),304,'AUT','B','978-0345514400');
INSERT INTO TITLE (TITLE_ID, TITLE, PUBLISHER, PUBLISH_DATE, NUMBER_OF_PAGES, GENRE, FORMAT, ISBN) VALUES (62,'Martian Chronicles','Simon and Schuster',to_date('17-Apr-2012', 'DD-MON-RR'),702,'FIC','A','1451678193');
INSERT INTO TITLE (TITLE_ID, TITLE, PUBLISHER, PUBLISH_DATE, NUMBER_OF_PAGES, GENRE, FORMAT, ISBN) VALUES (63,'Diary of a Young Girl','Everyman''s Library',to_date('19-Oct-2010', 'DD-MON-RR'),320,'AUT','B','978-0307594006');
INSERT INTO TITLE (TITLE_ID, TITLE, PUBLISHER, PUBLISH_DATE, NUMBER_OF_PAGES, GENRE, FORMAT, ISBN) VALUES (64,'Mockingjay','Scholastic Press',to_date('25-Feb-2014', 'DD-MON-RR'),400,'FIC','B','978-0545663267');
INSERT INTO TITLE (TITLE_ID, TITLE, PUBLISHER, PUBLISH_DATE, NUMBER_OF_PAGES, GENRE, FORMAT, ISBN) VALUES (65,'Churchill: Walking with Destiny','Viking',to_date('06-Nov-2018', 'DD-MON-RR'),1152,'HIS','B','978-1101980996');
INSERT INTO TITLE (TITLE_ID, TITLE, PUBLISHER, PUBLISH_DATE, NUMBER_OF_PAGES, GENRE, FORMAT, ISBN) VALUES (66,'Invisible','Vision',to_date('24-Nov-2015', 'DD-MON-RR'),416,'MYS','B','978-1455585021');
INSERT INTO TITLE (TITLE_ID, TITLE, PUBLISHER, PUBLISH_DATE, NUMBER_OF_PAGES, GENRE, FORMAT, ISBN) VALUES (67,'The Autobiography of Benjamin Franklin','Blackstone Audio, Inc.',to_date('02-Feb-2006', 'DD-MON-RR'),389,'AUT','A','B000EGFIN4');
INSERT INTO TITLE (TITLE_ID, TITLE, PUBLISHER, PUBLISH_DATE, NUMBER_OF_PAGES, GENRE, FORMAT, ISBN) VALUES (68,'The Woman''s Hour: The Great Fight to Win the Vote','Penguin Books',to_date('05-Mar-2019', 'DD-MON-RR'),432,'HIS','B','978-0143128991');
INSERT INTO TITLE (TITLE_ID, TITLE, PUBLISHER, PUBLISH_DATE, NUMBER_OF_PAGES, GENRE, FORMAT, ISBN) VALUES (69,'The Race Beat: The Press, the Civil Rights Struggle, and the Awakening of a Nation','Vintage',to_date('04-Sep-2007', 'DD-MON-RR'),544,'HIS','B','978-0679735656');
INSERT INTO TITLE (TITLE_ID, TITLE, PUBLISHER, PUBLISH_DATE, NUMBER_OF_PAGES, GENRE, FORMAT, ISBN) VALUES (70,'The Fellowship of the Ring','Del Rey',to_date('12-Aug-1986', 'DD-MON-RR'),480,'FAN','B','978-0345339706');
INSERT INTO TITLE (TITLE_ID, TITLE, PUBLISHER, PUBLISH_DATE, NUMBER_OF_PAGES, GENRE, FORMAT, ISBN) VALUES (71,'The Witches','Back Bay Books',to_date('20-Sep-2016', 'DD-MON-RR'),512,'NON','B','978-0316200592');
INSERT INTO TITLE (TITLE_ID, TITLE, PUBLISHER, PUBLISH_DATE, NUMBER_OF_PAGES, GENRE, FORMAT, ISBN) VALUES (72,'The Notebook','Grand Central Publishing',to_date('24-Jun-2014', 'DD-MON-RR'),272,'ROM','B','978-1455582877');
INSERT INTO TITLE (TITLE_ID, TITLE, PUBLISHER, PUBLISH_DATE, NUMBER_OF_PAGES, GENRE, FORMAT, ISBN) VALUES (73,'Dark Matter','Ballantine Books',to_date('26-Jul-2016', 'DD-MON-RR'),343,'THR','E','B0180T0IUY');
INSERT INTO TITLE (TITLE_ID, TITLE, PUBLISHER, PUBLISH_DATE, NUMBER_OF_PAGES, GENRE, FORMAT, ISBN) VALUES (74,'Sapiens: A Brief History of Humankind','Harper Perennial',to_date('15-May-2018', 'DD-MON-RR'),464,'NON','B','978-0062316110');
INSERT INTO TITLE (TITLE_ID, TITLE, PUBLISHER, PUBLISH_DATE, NUMBER_OF_PAGES, GENRE, FORMAT, ISBN) VALUES (75,'Recursion','Crown Publishing Group',to_date('11-Jun-2019', 'DD-MON-RR'),324,'THR','E','B07HDSHP7N');
INSERT INTO TITLE (TITLE_ID, TITLE, PUBLISHER, PUBLISH_DATE, NUMBER_OF_PAGES, GENRE, FORMAT, ISBN) VALUES (76,'The Immortal Life of Henrietta Lacks ','Broadway Books',to_date('08-Mar-2011', 'DD-MON-RR'),381,'BIO','B','978-1400052189');
INSERT INTO TITLE (TITLE_ID, TITLE, PUBLISHER, PUBLISH_DATE, NUMBER_OF_PAGES, GENRE, FORMAT, ISBN) VALUES (77,'Fried Green Tomatoes at the Whistle Stop Café','Ballantine Books',to_date('27-Sep-2016', 'DD-MON-RR'),416,'FIC','B','978-0425286555');
INSERT INTO TITLE (TITLE_ID, TITLE, PUBLISHER, PUBLISH_DATE, NUMBER_OF_PAGES, GENRE, FORMAT, ISBN) VALUES (78,'A Game of Thrones','Random Houes Audio',to_date('09-Dec-2003', 'DD-MON-RR'),1971,'FAN','A','B0001DBI1Q');
INSERT INTO TITLE (TITLE_ID, TITLE, PUBLISHER, PUBLISH_DATE, NUMBER_OF_PAGES, GENRE, FORMAT, ISBN) VALUES (79,'Outliers','Back Bay Books',to_date('07-Jun-2011', 'DD-MON-RR'),336,'NON','B','978-0316017930');
INSERT INTO TITLE (TITLE_ID, TITLE, PUBLISHER, PUBLISH_DATE, NUMBER_OF_PAGES, GENRE, FORMAT, ISBN) VALUES (80,'The Fellowship of the Ring','Houghton Mifflin Harcourt',to_date('15-Feb-2012', 'DD-MON-RR'),432,'FAN','E','B007978NPG');
INSERT INTO TITLE (TITLE_ID, TITLE, PUBLISHER, PUBLISH_DATE, NUMBER_OF_PAGES, GENRE, FORMAT, ISBN) VALUES (81,'The Great Gatsby','Scribner ',to_date('30-Jun-2020', 'DD-MON-RR'),208,'FIC','B','978-1982144548');
INSERT INTO TITLE (TITLE_ID, TITLE, PUBLISHER, PUBLISH_DATE, NUMBER_OF_PAGES, GENRE, FORMAT, ISBN) VALUES (82,'Helter Skelter: The True Story of the Mason Murders','W. W. Norton and Company',to_date('17-Dec-2001', 'DD-MON-RR'),689,'MYS','B','978-0393322231');
INSERT INTO TITLE (TITLE_ID, TITLE, PUBLISHER, PUBLISH_DATE, NUMBER_OF_PAGES, GENRE, FORMAT, ISBN) VALUES (83,'Into the Wild','Anchor Books',to_date('01-Feb-1997', 'DD-MON-RR'),240,'BIO','B','978-0385486804');
INSERT INTO TITLE (TITLE_ID, TITLE, PUBLISHER, PUBLISH_DATE, NUMBER_OF_PAGES, GENRE, FORMAT, ISBN) VALUES (84,'Ready Player One','Ballantine Books',to_date('05-Jun-2012', 'DD-MON-RR'),400,'SCI','B','978-0307887443');
INSERT INTO TITLE (TITLE_ID, TITLE, PUBLISHER, PUBLISH_DATE, NUMBER_OF_PAGES, GENRE, FORMAT, ISBN) VALUES (85,'Grit: The Power of Passion and Perseverance','Scribner',to_date('21-Aug-2018', 'DD-MON-RR'),368,'SEL','B','978-1501111112');
INSERT INTO TITLE (TITLE_ID, TITLE, PUBLISHER, PUBLISH_DATE, NUMBER_OF_PAGES, GENRE, FORMAT, ISBN) VALUES (86,'1491: New Revelations of the Americas Before Columbus','Vintage',to_date('10-Oct-2006', 'DD-MON-RR'),541,'HIS','B','978-1400032051');
INSERT INTO TITLE (TITLE_ID, TITLE, PUBLISHER, PUBLISH_DATE, NUMBER_OF_PAGES, GENRE, FORMAT, ISBN) VALUES (87,'My Grandmother Asked Me To Tell You She''s Sorry','Washington Square Press',to_date('05-Apr-2016', 'DD-MON-RR'),400,'FIC','B','978-1501115073');
INSERT INTO TITLE (TITLE_ID, TITLE, PUBLISHER, PUBLISH_DATE, NUMBER_OF_PAGES, GENRE, FORMAT, ISBN) VALUES (88,'Pride and Prejudice','Independent Publishing',to_date('05-Nov-2018', 'DD-MON-RR'),309,'ROM','B','978-1731546425');
Commit;


-- Insert Authors
INSERT INTO AUTHOR VALUES (1,'A','J','Finn','Daniel Mallory (born 1979) is an American editor and author who writes under the name A. J. Finn. His 2018 novel The Woman in the Window debuted at number one on the New York Times Best Seller list and has been adapted into a feature film.');
INSERT INTO AUTHOR VALUES (2,'Afshin','','Shahidi','Afshin Shahidi, an Iranian-born, American photographer and filmmaker, has worked worldwide on a depth and variety of projects, ranging from films and documentaries, to music videos and commercials.');
INSERT INTO AUTHOR VALUES (3,'Alex','','Michaelides','Alex Michaelides (born 1977)[1][2] is a bestselling British-Cypriot author and screenwriter. His debut novel, the psychological thriller The Silent Patient, is a New York Times and Sunday Times besteller.');
INSERT INTO AUTHOR VALUES (4,'Alfred','','Lansing','Alfred Lansing (July 21, 1921 – August 27, 1975) was an American journalist and writer, best known for his book Endurance (1959), an account of Ernest Shackleton''s Antarctic explorations.');
INSERT INTO AUTHOR VALUES (5,'Andrew','','Hodge','Andrew Hodge is the author of A Mother Gone Bad.');
INSERT INTO AUTHOR VALUES (6,'Andrew','','Roberts','Andrew Roberts FRHistS FRSL[2] (born 13 January 1963)[3] is a British historian and journalist. He is a Visiting Professor at the Department of War Studies, King''s College London, a Roger and Martha Mertz Visiting Research Fellow at the Hoover Institution at Stanford University and a Lehrman Institute Distinguished Lecturer at the New-York Historical Society. ');
INSERT INTO AUTHOR VALUES (7,'Andy','','Weir','Andrew Taylor Weir (born June 16, 1972) is an American novelist whose debut novel in 2011, The Martian, was later adapted into a film of the same name directed by Ridley Scott in 2015.[3] He received the John W. Campbell Award for Best New Writer in 2016.');
INSERT INTO AUTHOR VALUES (8,'Angela','','Duckworth','Angela Lee Duckworth (born 1970) is an American academic, psychologist and popular science author. She is the Rosa Lee and Egbert Chang Professor of Psychology at the University of Pennsylvania, where she studies grit and self-control. ');
INSERT INTO AUTHOR VALUES (9,'Anne','','Frank','Annelies Marie "Anne" Frank (12 June 1929 – February or March 1945) was a German-Dutch diarist of Jewish heritage. One of the most discussed Jewish victims of the Holocaust, she gained fame with the publication of The Diary of a Young Girl , in which she documents her life in hiding from 1942 to 1944, during the German occupation of the Netherlands in World War II. It is one of the world''s best known books and has been the basis for several plays and films.');
INSERT INTO AUTHOR VALUES (10,'Audrey','','Niffenegger','Audrey Niffenegger (born June 13, 1963) is an American writer, artist and academic. She is a published author and her debut novel, The Time Traveler''s Wife, published in 2003, was a bestseller.');
INSERT INTO AUTHOR VALUES (11,'Aziz','','Ansari','Aziz Ismail Ansari (born February 23, 1983) is an American actor, writer, producer, director, and comedian. He is known for his role as Tom Haverford on the NBC series Parks and Recreation (2009–2015)');
INSERT INTO AUTHOR VALUES (12,'Benjamin','','Franklin','Benjamin Franklin (January 17, 1706 – April 17, 1790) was one of the Founding Fathers of the United States. A polymath, he was a leading writer, printer, political philosopher, politician, Freemason, postmaster, scientist, inventor, humorist, civic activist, statesman, and diplomat.');
INSERT INTO AUTHOR VALUES (13,'Blake','','Crouch','William Blake Crouch (born October 15, 1978) is an American author best known for his Wayward Pines Trilogy, which was adapted into the 2015 television series Wayward Pines.');
INSERT INTO AUTHOR VALUES (14,'C','S','Lewis','Clive Staples Lewis (29 November 1898 – 22 November 1963) was a British writer and lay theologian. He held academic positions in English literature at both Oxford University (Magdalen College, 1925–1954) and Cambridge University (Magdalene College, 1954–1963). He is best known for his works of fiction, especially The Screwtape Letters, The Chronicles of Narnia, and The Space Trilogy, and for his non-fiction Christian apologetics, such as Mere Christianity, Miracles, and The Problem of Pain.');
INSERT INTO AUTHOR VALUES (15,'Carlos','','Zafon','Carlos Ruiz Zafón (25 September 1964 – 19 June 2020) was a Spanish novelist best known for his 2001 novel La sombra del viento (The Shadow of the Wind).');
INSERT INTO AUTHOR VALUES (16,'Carol','','Dweck','Carol Susan Dweck (born October 17, 1946) is an American psychologist. She is the Lewis and Virginia Eaton Professor of Psychology at Stanford University.[2] Dweck is known for her work on mindset. ');
INSERT INTO AUTHOR VALUES (17,'Casey','','Miquisten','Casey McQuiston is an American author of romance novels, best known for their New York Times best-selling debut novel Red, White & Royal Blue, in which the son of America''s first female president falls in love with the prince of England.');
INSERT INTO AUTHOR VALUES (18,'Charles','','Mann','Charles C. Mann (born 1955) is an American journalist and author, specializing in scientific topics. His book 1491: New Revelations of the Americas Before Columbus won the National Academies Communication Award for best book of the year. He is the coauthor of four books, and contributing editor for Science, The Atlantic Monthly, and Wired.');
INSERT INTO AUTHOR VALUES (19,'Colin','','Campbell PhD','Thomas Colin Campbell (born March 14, 1934) is an American biochemist who specializes in the effect of nutrition on long-term health. He is the Jacob Gould Schurman Professor Emeritus of Nutritional Biochemistry at Cornell University.');
INSERT INTO AUTHOR VALUES (20,'Dan','','Brown','Daniel Gerhard Brown (born June 22, 1964) is an American author best known for his thriller novels, including the Robert Langdon novels Angels & Demons (2000), The Da Vinci Code (2003), The Lost Symbol (2009), Inferno (2013) and Origin (2017). His novels are treasure hunts that usually take place over a period of 24 hours.');
INSERT INTO AUTHOR VALUES (21,'David','','Bodanis','David Bodanis is a speaker, business advisor and writer of bestselling nonfiction books, notably E=mc2: A Biography of the World''s Most Famous Equation, which was translated into 26 languages.');
INSERT INTO AUTHOR VALUES (22,'David','','McCullough','David Gaub McCullough (born July 7, 1933) is an American author, narrator, popular historian, and lecturer. He is a two-time winner of the Pulitzer Prize and the National Book Award and a recipient of the Presidential Medal of Freedom, the United States'' highest civilian award.');
INSERT INTO AUTHOR VALUES (23,'Elaine','','Weiss','Elaine Weiss is an award-winning journalist and writer. Her magazine feature writing has been recognized with prizes from the Society of Professional Journalists, and her by-line has appeared in The Atlantic, Harper’s, New York Times, Boston Globe, Philadelphia Inquirer, as well as reports and documentaries for National Public Radio and Voice of America. She has been a frequent correspondent for the Christian Science Monitor.');
INSERT INTO AUTHOR VALUES (24,'Elan','','Mastai','Elan Mastai is a Canadian screenwriter and novelist. He is best known for The F Word, for which he won the Canadian Screen Award for Best Adapted Screenplay at the 2nd Canadian Screen Awards in 2014.');
INSERT INTO AUTHOR VALUES (25,'Elizabeth','','Kolbert','Elizabeth Kolbert (born 1961) is an American journalist and author and visiting fellow at Williams College. She is best known for her Pulitzer Prize-winning book The Sixth Extinction: An Unnatural History, and as an observer and commentator on environmentalism for The New Yorker magazine. As of March 2017, Kolbert serves as a member of the Bulletin of the Atomic Scientists'' Science and Security Board.');
INSERT INTO AUTHOR VALUES (26,'Ernest','','Cline','Ernest Christy Cline (born March 29, 1972) is an American science fiction novelist, slam poet, and screenwriter. He wrote the novels Ready Player One, Armada, and Ready Player Two and co-wrote the screenplay for the film adaptation of Ready Player One, directed by Steven Spielberg.');
INSERT INTO AUTHOR VALUES (27,'F','Scott','Fitzgerald','Francis Scott Key Fitzgerald (September 24, 1896 – December 21, 1940) was an American novelist, essayist, screenwriter, and short-story writer. He was best known for his novels depicting the flamboyance and excess of the Jazz Age—a term which he popularized. During his lifetime, he published four novels, four collections of short stories, and 164 short stories.');
INSERT INTO AUTHOR VALUES (28,'Fannie','','Flag','Fannie Flagg (born Patricia Neal; September 21, 1944) is an American actress, comedian and author. She is best known as a semi-regular panelist on the 1973–82 versions of the game show Match Game and for the 1987 novel Fried Green Tomatoes at the Whistle Stop Cafe, which was adapted into the 1991 motion picture Fried Green Tomatoes. She was nominated for an Academy Award for the screenplay adaptation. Flagg lives in California and Alabama.');
INSERT INTO AUTHOR VALUES (29,'Frank','','Herbert','Franklin Patrick Herbert Jr. (October 8, 1920 – February 11, 1986) was an American science-fiction author best known for the 1965 novel Dune and its five sequels. Though he became famous for his novels, he also wrote short stories and worked as a newspaper journalist, photographer, book reviewer, ecological consultant, and lecturer.');
INSERT INTO AUTHOR VALUES (30,'Fredrick','','Backman','Fredrik Backman (born 2 June 1981) is a Swedish columnist, blogger and writer. He is the author of A Man Called Ove (2012), My Grandmother Asked Me to Tell You She''s Sorry (2013), Britt-Marie Was Here (2014), Beartown (2017), Us Against You (2018), and Anxious People (2020). The books were number one bestsellers in his home country of Sweden. Backman''s books have been published around the world in more than twenty-five languages.');
INSERT INTO AUTHOR VALUES (31,'Gabriel','Garcia','Marquez','Gabriel García Márquez (6 March 1927 – 17 April 2014) was a Colombian novelist, short-story writer, screenwriter, and journalist, known affectionately as Gabo throughout Latin America. Considered one of the most significant authors of the 20th century, particularly in the Spanish language, he was awarded the 1972 Neustadt International Prize for Literature and the 1982 Nobel Prize in Literature.');
INSERT INTO AUTHOR VALUES (32,'Gene','','Roberts','Eugene Leslie Roberts Jr. (born June 15, 1932) is an American journalist and professor of journalism. He has been a national editor of The New York Times, executive editor of The Philadelphia Inquirer from 1972 to 1990, and managing editor of The New York Times from 1994 to 1997. Roberts is most known for presiding over The Inquirer''s "Golden Age", a time in which the newspaper was given increased freedom and resources, won 17 Pulitzer Prizes in 18 years, displaced The Philadelphia Bulletin as the city''s "paper of record", and was considered to be Knight Ridder''s crown jewel as a profitable enterprise and an influential regional paper.');
INSERT INTO AUTHOR VALUES (33,'George','','Orwell','Eric Arthur Blair (25 June 1903 – 21 January 1950), known by his pen name George Orwell, was an English novelist, essayist, journalist and critic. His work is characterised by lucid prose, biting social criticism, opposition to totalitarianism, and outspoken support of democratic socialism.');
INSERT INTO AUTHOR VALUES (34,'George','R. R. ','Martin','George Raymond Richard Martin (born September 20, 1948), also known as GRRM, is an American novelist and short story writer, screenwriter, and television producer. He is the author of the series of epic fantasy novels A Song of Ice and Fire, which was adapted into the Emmy Award-winning HBO series Game of Thrones (2011–2019).');
INSERT INTO AUTHOR VALUES (35,'Gillian','','Flynn','Gillian Schieber Flynn (born February 24, 1971) is an American writer. Flynn has published three novels, Sharp Objects, Dark Places, and Gone Girl, all three of which have been adapted for film or television. Flynn wrote the adaptations for the 2014 Gone Girl film and the HBO limited series Sharp Objects. She was formerly a television critic for Entertainment Weekly.');
INSERT INTO AUTHOR VALUES (36,'Greg','','McKeown','Greg McKeown (born 1977 in London, England) is an author, public speaker, leadership and business strategist, and New York Times Bestselling Author. In 2012, The World Economic Forum inducted McKeown into the Forum of Young Global Leaders. His most recent bestseller, Essentialism: The Disciplined Pursuit of Less, (Crown Business, April 2014), is a business and self-leadership book that discusses how to figure out what is essential, how to eliminate what''s nonessential and how to make it as effortless as possible to do what really matters.');
INSERT INTO AUTHOR VALUES (37,'H','G','Bissinger','Harry Gerard Bissinger III, also known as Buzz Bissinger and H. G. Bissinger (born November 1, 1954) is an American journalist and author, best known for his 1990 non-fiction book Friday Night Lights. He is a longtime contributing editor at Vanity Fair magazine. In 2019, HBO released a documentary on Bissinger titled “Buzz”.');
INSERT INTO AUTHOR VALUES (38,'Haruki','','Murakami','Haruki Murakami (born January 12, 1949) is a Japanese writer. His books and stories have been bestsellers in Japan as well as internationally, with his work being translated into 50 languages and selling millions of copies outside his native country.');
INSERT INTO AUTHOR VALUES (39,'Hayden','','Herrera','Hayden Herrera (born November 20, 1940) is an American author and historian. Her book Frida: A Biography of Frida Kahlo was turned into a movie in 2002 and Herrera''s biography Arshile Gorky: His Life and Work was named a finalist for the 2004 Pulitzer Prize for Biography or Autobiography.');
INSERT INTO AUTHOR VALUES (40,'Hugh','','Howey','Hugh C. Howey (born 1975) is an American writer, known best for the science fiction series Silo, part of which he published independently through Amazon.com''s Kindle Direct Publishing system. Howey was raised in Monroe, North Carolina and before publishing his books, he worked as a book store clerk, yacht captain, roofer, and audio technician.');
INSERT INTO AUTHOR VALUES (41,'Ibram','','Kendi','Ibram Xolani Kendi (born August 13, 1982) is an American author, professor, anti-racist activist, and historian of race and discriminatory policy in America. In July 2020, he assumed the position of director of the Center for Antiracist Research at Boston University.');
INSERT INTO AUTHOR VALUES (42,'J. R. R. ','','Tolkien','John Ronald Reuel Tolkien (3 January 1892 – 2 September 1973) was an English writer, poet, philologist, and academic, best known as the author of the high fantasy works The Hobbit and The Lord of the Rings.');
INSERT INTO AUTHOR VALUES (43,'Jake','','Knapp','Jake Knapp (born 1977) is an American writer and designer. Jake spent 10 years working at Google, where he created the Design Sprint and has since coached teams at Slack, LEGO, Savioke, Blue Bottle Coffee, and The New York Times on the method.');
INSERT INTO AUTHOR VALUES (44,'James','','Patterson','James Brendan Patterson (born March 22, 1947) is an American author and philanthropist. Among his works are the Alex Cross, Michael Bennett, Women''s Murder Club, Maximum Ride, Daniel X, NYPD Red, Witch and Wizard, and Private series, as well as many stand-alone thrillers, non-fiction, and romance novels. His books have sold more than 300 million copies, and he was the first person to sell 1 million e-books.');
INSERT INTO AUTHOR VALUES (45,'Jane','','Austen','Jane Austen, (born December 16, 1775, Steventon, Hampshire, England—died July 18, 1817, Winchester, Hampshire), English writer who first gave the novel its distinctly modern character through her treatment of ordinary people in everyday life.');
INSERT INTO AUTHOR VALUES (46,'John','','Steinbeck','John Steinbeck, in full John Ernst Steinbeck, (born February 27, 1902, Salinas, California, U.S.—died December 20, 1968, New York, New York), American novelist, best known for The Grapes of Wrath (1939), which summed up the bitterness of the Great Depression decade and aroused widespread sympathy for the plight of migratory farmworkers. He received the Nobel Prize for Literature for 1962.');
INSERT INTO AUTHOR VALUES (47,'Jon','','Krakauer','Jon Krakauer (born April 12, 1954) is an American writer and mountaineer. He is the author of best-selling non-fiction books—Into the Wild; Into Thin Air; Under the Banner of Heaven; and Where Men Win Glory: The Odyssey of Pat Tillman—as well as numerous magazine articles. He was a member of an ill-fated expedition to summit Mount Everest in 1996');
INSERT INTO AUTHOR VALUES (48,'Larry','','McMurtry','Larry McMurtry, in full Larry Jeff McMurtry, (born June 3, 1936, Wichita Falls, Texas, U.S.), prolific American writer noted for his novels set on the frontier, in contemporary small towns, and in increasingly urbanized and industrial areas of Texas.');
INSERT INTO AUTHOR VALUES (49,'Lucy','','Foley','Lucy Foley studied English Literature at Durham and UCL universities. She then worked for several years as a fiction editor in the publishing industry – during which time she also wrote her debut, The Book of Lost and Found. Lucy now writes full-time, and is busy travelling (for research, naturally!) and working on her next novel.');
INSERT INTO AUTHOR VALUES (50,'Malcom','','Gladwell','Malcolm Gladwell, (born September 3, 1963, London, England), Canadian journalist and writer best known for his unique perspective on popular culture. He adeptly treaded the boundary between popularizer and intellectual.');
INSERT INTO AUTHOR VALUES (51,'Margaret','','Atwood','She is Canada''s most eminent novelist and poet, and also writes short stories, critical studies, screenplays, radio scripts and books for children; her works have been translated into over 30 languages');
INSERT INTO AUTHOR VALUES (52,'Mario','','Puzo','Mario Gianluigi Puzo (/?pu?zo?/; October 15, 1920 – July 2, 1999) was an American author, screenwriter, and journalist. He is known for his crime novels about the Italian-American Mafia and Sicilian Mafia, most notably The Godfather (1969), which he later co-adapted into a film trilogy directed by Francis Ford Coppola.');
INSERT INTO AUTHOR VALUES (53,'Maya','','Angelou','Maya Angelou was an American poet, memoirist, and civil rights activist. She published seven autobiographies, three books of essays, several books of poetry, and is credited with a list of plays, movies, and television shows spanning over 50 years. She received dozens of awards and more than 50 honorary degrees.');
INSERT INTO AUTHOR VALUES (54,'Michelle','','Alexander','Michelle Alexander is a writer, civil rights advocate, and visiting professor at Union Theological Seminary. She is best known for her 2010 book The New Jim Crow: Mass Incarceration in the Age of Colorblindness, and is an opinion columnist for The New York Times.');
INSERT INTO AUTHOR VALUES (55,'Michelle','','Obama','Michelle LaVaughn Obama is an American attorney and author who was the first lady of the United States from 2009 to 2017. She is married to the 44th president of the United States, Barack Obama, and was the first African-American first lady.');
INSERT INTO AUTHOR VALUES (56,'Nicholas','','Sparks','Nicholas Charles Sparks is an American novelist, screenwriter, and philanthropist. He has published twenty-one novels and two non-fiction books, all of which have been New York Times bestsellers, with over 115 million copies sold worldwide in more than 50 languages.');
INSERT INTO AUTHOR VALUES (57,'Orson','Scott','Card','Orson Scott Card is an American writer known best for his science fiction works. His novel Ender''s Game and its sequel Speaker for the Dead won both the Hugo Award and the Nebula Award. A feature film adaptation of Ender''s Game, which Card co-produced, was released in 2013.');
INSERT INTO AUTHOR VALUES (58,'Oscar','','Martinez','Oscar Martínez is an Argentine actor, author and theatre director. He received the Premio Konex de Platino in 1991 for his film work, and again in 2001 for his work as a theatre actor.');
INSERT INTO AUTHOR VALUES (59,'Paulo','','Coelho','Paulo Coelho is a Brazilian author. When Coelho was 38 years old, he had a spiritual awakening in Spain and wrote about it in his first book, The Pilgrimage. It was his second book, The Alchemist, which made him famous. He''s sold 35 million copies and now writes about one book every two years.');
INSERT INTO AUTHOR VALUES (60,'Ray','','Bradbury','Ray Bradbury was an American fantasy and horror author who rejected being categorized as a science fiction author, claiming that his work was based on the fantastical and unreal. His best known novel is Fahrenheit 451, a dystopian study of future American society in which critical thought is outlawed.');
INSERT INTO AUTHOR VALUES (61,'Rebecca','','Skloot','Rebecca L. Skloot is an American science writer who specializes in science and medicine. Her first book, The Immortal Life of Henrietta Lacks, was one of the best-selling new books of 2010, staying on The New York Times Bestseller list for over 6 years and eventually reaching #1.');
INSERT INTO AUTHOR VALUES (62,'Richard','','Russo','Richard Russo (born July 15, 1949) is an American novelist, short story writer, screenwriter, and teacher. Russo is considered by many to be the best contemporary writer of small-town American life. ');
INSERT INTO AUTHOR VALUES (63,'Robert','','Caro','Robert Allan Caro is an American journalist and author known for his biographies of United States political figures Robert Moses and Lyndon B. Johnson.');
INSERT INTO AUTHOR VALUES (64,'Robin','','DiAngelo','Robin Jeanne DiAngelo is an American author, consultant, and facilitator working in the fields of critical discourse analysis and whiteness studies.');
INSERT INTO AUTHOR VALUES (65,'Ron','','Chernow','Ronald Chernow is an American writer, journalist, historian, and biographer. He has written bestselling and award-winning biographies of historical figures from the world of business, finance, and American politics.');
INSERT INTO AUTHOR VALUES (66,'Stacy','','Schiff','Stacy Madeleine Schiff is an American former editor, essayist, and author of five biographies; her biography of Vera Nabokov, the wife and muse of the Russian-American novelist Vladimir Nabokov, won the 2000 Pulitzer Prize in biography. ');
INSERT INTO AUTHOR VALUES (67,'Stephen','','Covey','Stephen Richards Covey was an American educator, author, businessman, and keynote speaker. His most popular book is The 7 Habits of Highly Effective People. ');
INSERT INTO AUTHOR VALUES (68,'Stephen','','Greenblatt','Stephen Jay Greenblatt (born November 7, 1943) is an American Shakespearean, literary historian, and author. Greenblatt is one of the founders of new historicism, a set of critical practices that he often refers to as "cultural poetics"; his works have been influential since the early 1980s when he introduced the term.');
INSERT INTO AUTHOR VALUES (69,'Stephen','','Hawking','Stephen Hawking, in full Stephen William Hawking, (born January 8, 1942, Oxford, Oxfordshire, England—died March 14, 2018, Cambridge, Cambridgeshire), English theoretical physicist whose theory of exploding black holes drew upon both relativity theory and quantum mechanics. He also worked with space-time singularities.');
INSERT INTO AUTHOR VALUES (70,'Steven','','Levitt','Steven David Levitt (born May 29, 1967) is an American economist and co-author of the best-selling book Freakonomics and its sequels (along with Stephen J. Dubner). Levitt was the winner of the 2003 John Bates Clark Medal for his work in the field of crime, and is currently the William B.');
INSERT INTO AUTHOR VALUES (71,'Stieg','','Larsson','Stieg Larsson, original name Karl Stig-Erland Larsson, (born August 15, 1954, Skelleftehamn, Sweden—died November 9, 2004, Stockholm), Swedish writer and activist whose posthumously published Millennium series of crime novels brought him international acclaim');
INSERT INTO AUTHOR VALUES (72,'Suzanne','','Colins','Suzanne Collins is an American television writer and author. She is known as the author of The New York Times best-selling series The Underland Chronicles and The Hunger Games');
INSERT INTO AUTHOR VALUES (73,'Sylvia','','Nasar','Sylvia Nasar (born 17 August 1947) is an Uzbek German-born American journalist, best known for her biography of John Forbes Nash Jr., A Beautiful Mind. She received the National Book Critics Circle Award for biography. Nasar currently serves as Knight Professor Emirita at Columbia University''s School of Journalism.');
INSERT INTO AUTHOR VALUES (74,'Ta-Nehisi','X','Coates','Ta-Nehisi Coates, in full Ta-Nehisi Paul Coates, (born September 30, 1975, Baltimore, Maryland, U.S.), American essayist, journalist, and writer who often explored contemporary race relations, perhaps most notably in his book Between the World and Me (2015), which won the National Book Award for nonfiction.');
INSERT INTO AUTHOR VALUES (75,'Truman','','Capote','Truman Garcia Capote was an American novelist, short story writer, screenwriter, playwright, and actor. Several of his short stories, novels, and plays have been praised as literary classics, including the novella Breakfast at Tiffany''s and the true crime novel In Cold Blood, which he labeled a "nonfiction novel".');
INSERT INTO AUTHOR VALUES (76,'Vincent','','Bugliosi','Vincent T. Bugliosi Jr. was an American attorney and New York Times bestselling author. During his eight years in the Los Angeles County District Attorney''s Office, he successfully prosecuted 105 out of 106 felony jury trials, which included 21 murder convictions');
INSERT INTO AUTHOR VALUES (77,'Walter','','Isaacson','Walter Isaacson is an American author, journalist, and professor. He has been the President and CEO of the Aspen Institute, a nonpartisan policy studies organization based in Washington, D.C., the chair and CEO of CNN, and the editor of Time.');
INSERT INTO AUTHOR VALUES (78,'Yuval','','Harari','Yuval Noah Harari is an Israeli public intellectual, historian and a professor in the Department of History at the Hebrew University of Jerusalem. He is the author of the popular science bestsellers Sapiens: A Brief History of Humankind, Homo Deus: A Brief History of Tomorrow, and 21 Lessons for the 21st Century.');
INSERT INTO AUTHOR VALUES (79,'Douglas','','Hofstadter','Douglas Richard Hofstadter is an American scholar of cognitive science, physics, and comparative literature whose research includes concepts such as the sense of self in relation to the external world, consciousness, analogy-making, artistic creation, literary translation, and discovery in mathematics and physics.');
INSERT INTO AUTHOR VALUES (80,'Lucia','','Graves','Lucia is a translator working in English and Spanish/Catalan. Her translations include the worldwide bestsellers The Shadow of the Wind, The Angel''s Game, The Prisoner of Heaven, and "The Labyrinth of the Spirits", by Carlos Ruiz Zafón, and The Columbus Papers. She has translated over 30 volumes.');
INSERT INTO AUTHOR VALUES (81,'Howard','','Jacobson PhD','Howard Jacobson, PhD is the host of the Plant Yourself Podcast, and contributing author to Whole, by T. Colin Campbell, and Proteinaholic, by Garth Davis, MD. Howard runs the Big Change Program, with Josh LaJaunie, and helps people adopt lifestyle and dietary habits in alignment with their goals and values. ');
INSERT INTO AUTHOR VALUES (82,'Hank','','Klibanoff','Hank Klibanoff, a veteran journalist, a Pulitzer Prize-winning author and a Peabody Award-winning podcast host, is a Professor of Practice in Emory''s Creative Writing Program. He co-authored The Race Beat: The Press, the Civil Rights Struggle, and the Awakening of a Nation that won the 2007 Pulitzer Prize for history.');
INSERT INTO AUTHOR VALUES (83,'John','','Zeratsky','John Zeratsky is a technology designer, startup investor, and the bestselling author of Sprint and Make Time. He has worked with more than 200 of the world''s most important and innovative organizations, including Google, Harvard University, Slack, IDEO, and Netflix.');
INSERT INTO AUTHOR VALUES (84,'Bill','','Clinton','William Jefferson Clinton (né Blythe III; born August 19, 1946) is an American lawyer and politician who served as the 42nd president of the United States from 1993 to 2001. Prior to his presidency, he served as governor of Arkansas (1979–1981 and 1983–1992) and as attorney general of Arkansas (1977–1979).');
INSERT INTO AUTHOR VALUES (85,'Karen','','Chilton','Karen Chilton is a multi-talented author, actor, and audiobook narrator, as well as a freelance writer, script writer, and librettist. She wrote the biography Hazel Scott about the trailblazing jazz pianist and coauthored I Wish You Love with legendary jazz vocalist Gloria Lynne.');
INSERT INTO AUTHOR VALUES (86,'Stephen','','Dubner','Stephen Joseph Dubner is an American author, journalist, and podcast and radio host. He is co-author of the popular Freakonomics book series and host of Freakonomics Radio.');
INSERT INTO AUTHOR VALUES (87,'Curt','','Gentry','Curtis Marsena "Curt" Gentry (June 13, 1931 – July 10, 2014) was an American writer, born in Lamar, Colorado. He is best known for co-authoring, with Vincent Bugliosi, the 1974 book Helter Skelter, which detailed the Charles Manson murders. ... Gentry died, aged 83, on July 10, 2014, in San Francisco.');
commit;

 
---Author/Title Linking Table
Insert into TITLE_AUTHOR_LINKING (AUTHOR_ID,TITLE_ID) values (39,1);
Insert into TITLE_AUTHOR_LINKING (AUTHOR_ID,TITLE_ID) values (58,2);
Insert into TITLE_AUTHOR_LINKING (AUTHOR_ID,TITLE_ID) values (26,3);
Insert into TITLE_AUTHOR_LINKING (AUTHOR_ID,TITLE_ID) values (15,4);
Insert into TITLE_AUTHOR_LINKING (AUTHOR_ID,TITLE_ID) values (80,4);
Insert into TITLE_AUTHOR_LINKING (AUTHOR_ID,TITLE_ID) values (60,5);
Insert into TITLE_AUTHOR_LINKING (AUTHOR_ID,TITLE_ID) values (37,6);
Insert into TITLE_AUTHOR_LINKING (AUTHOR_ID,TITLE_ID) values (33,7);
Insert into TITLE_AUTHOR_LINKING (AUTHOR_ID,TITLE_ID) values (10,8);
Insert into TITLE_AUTHOR_LINKING (AUTHOR_ID,TITLE_ID) values (38,9);
Insert into TITLE_AUTHOR_LINKING (AUTHOR_ID,TITLE_ID) values (29,10);
Insert into TITLE_AUTHOR_LINKING (AUTHOR_ID,TITLE_ID) values (16,11);
Insert into TITLE_AUTHOR_LINKING (AUTHOR_ID,TITLE_ID) values (69,12);
Insert into TITLE_AUTHOR_LINKING (AUTHOR_ID,TITLE_ID) values (72,13);
Insert into TITLE_AUTHOR_LINKING (AUTHOR_ID,TITLE_ID) values (41,14);
Insert into TITLE_AUTHOR_LINKING (AUTHOR_ID,TITLE_ID) values (49,15);
Insert into TITLE_AUTHOR_LINKING (AUTHOR_ID,TITLE_ID) values (36,16);
Insert into TITLE_AUTHOR_LINKING (AUTHOR_ID,TITLE_ID) values (48,17);
Insert into TITLE_AUTHOR_LINKING (AUTHOR_ID,TITLE_ID) values (22,18);
Insert into TITLE_AUTHOR_LINKING (AUTHOR_ID,TITLE_ID) values (34,19);
Insert into TITLE_AUTHOR_LINKING (AUTHOR_ID,TITLE_ID) values (19,20);
Insert into TITLE_AUTHOR_LINKING (AUTHOR_ID,TITLE_ID) values (81,20);
Insert into TITLE_AUTHOR_LINKING (AUTHOR_ID,TITLE_ID) values (55,21);
Insert into TITLE_AUTHOR_LINKING (AUTHOR_ID,TITLE_ID) values (1,22);
Insert into TITLE_AUTHOR_LINKING (AUTHOR_ID,TITLE_ID) values (63,23);
Insert into TITLE_AUTHOR_LINKING (AUTHOR_ID,TITLE_ID) values (73,24);
Insert into TITLE_AUTHOR_LINKING (AUTHOR_ID,TITLE_ID) values (14,25);
Insert into TITLE_AUTHOR_LINKING (AUTHOR_ID,TITLE_ID) values (52,26);
Insert into TITLE_AUTHOR_LINKING (AUTHOR_ID,TITLE_ID) values (31,27);
Insert into TITLE_AUTHOR_LINKING (AUTHOR_ID,TITLE_ID) values (17,28);
Insert into TITLE_AUTHOR_LINKING (AUTHOR_ID,TITLE_ID) values (40,29);
Insert into TITLE_AUTHOR_LINKING (AUTHOR_ID,TITLE_ID) values (71,30);
Insert into TITLE_AUTHOR_LINKING (AUTHOR_ID,TITLE_ID) values (74,31);
Insert into TITLE_AUTHOR_LINKING (AUTHOR_ID,TITLE_ID) values (62,32);
Insert into TITLE_AUTHOR_LINKING (AUTHOR_ID,TITLE_ID) values (24,33);
Insert into TITLE_AUTHOR_LINKING (AUTHOR_ID,TITLE_ID) values (67,34);
Insert into TITLE_AUTHOR_LINKING (AUTHOR_ID,TITLE_ID) values (70,35);
Insert into TITLE_AUTHOR_LINKING (AUTHOR_ID,TITLE_ID) values (86,35);
Insert into TITLE_AUTHOR_LINKING (AUTHOR_ID,TITLE_ID) values (43,36);
Insert into TITLE_AUTHOR_LINKING (AUTHOR_ID,TITLE_ID) values (83,36);
Insert into TITLE_AUTHOR_LINKING (AUTHOR_ID,TITLE_ID) values (4,37);
Insert into TITLE_AUTHOR_LINKING (AUTHOR_ID,TITLE_ID) values (65,38);
Insert into TITLE_AUTHOR_LINKING (AUTHOR_ID,TITLE_ID) values (35,39);
Insert into TITLE_AUTHOR_LINKING (AUTHOR_ID,TITLE_ID) values (54,40);
Insert into TITLE_AUTHOR_LINKING (AUTHOR_ID,TITLE_ID) values (85,40);
Insert into TITLE_AUTHOR_LINKING (AUTHOR_ID,TITLE_ID) values (65,41);
Insert into TITLE_AUTHOR_LINKING (AUTHOR_ID,TITLE_ID) values (2,42);
Insert into TITLE_AUTHOR_LINKING (AUTHOR_ID,TITLE_ID) values (20,43);
Insert into TITLE_AUTHOR_LINKING (AUTHOR_ID,TITLE_ID) values (30,44);
Insert into TITLE_AUTHOR_LINKING (AUTHOR_ID,TITLE_ID) values (3,45);
Insert into TITLE_AUTHOR_LINKING (AUTHOR_ID,TITLE_ID) values (75,46);
Insert into TITLE_AUTHOR_LINKING (AUTHOR_ID,TITLE_ID) values (59,47);
Insert into TITLE_AUTHOR_LINKING (AUTHOR_ID,TITLE_ID) values (51,48);
Insert into TITLE_AUTHOR_LINKING (AUTHOR_ID,TITLE_ID) values (44,49);
Insert into TITLE_AUTHOR_LINKING (AUTHOR_ID,TITLE_ID) values (84,49);
Insert into TITLE_AUTHOR_LINKING (AUTHOR_ID,TITLE_ID) values (5,50);
Insert into TITLE_AUTHOR_LINKING (AUTHOR_ID,TITLE_ID) values (79,50);
Insert into TITLE_AUTHOR_LINKING (AUTHOR_ID,TITLE_ID) values (77,51);
Insert into TITLE_AUTHOR_LINKING (AUTHOR_ID,TITLE_ID) values (11,52);
Insert into TITLE_AUTHOR_LINKING (AUTHOR_ID,TITLE_ID) values (72,53);
Insert into TITLE_AUTHOR_LINKING (AUTHOR_ID,TITLE_ID) values (46,54);
Insert into TITLE_AUTHOR_LINKING (AUTHOR_ID,TITLE_ID) values (64,55);
Insert into TITLE_AUTHOR_LINKING (AUTHOR_ID,TITLE_ID) values (25,56);
Insert into TITLE_AUTHOR_LINKING (AUTHOR_ID,TITLE_ID) values (68,57);
Insert into TITLE_AUTHOR_LINKING (AUTHOR_ID,TITLE_ID) values (21,58);
Insert into TITLE_AUTHOR_LINKING (AUTHOR_ID,TITLE_ID) values (57,59);
Insert into TITLE_AUTHOR_LINKING (AUTHOR_ID,TITLE_ID) values (7,60);
Insert into TITLE_AUTHOR_LINKING (AUTHOR_ID,TITLE_ID) values (53,61);
Insert into TITLE_AUTHOR_LINKING (AUTHOR_ID,TITLE_ID) values (60,62);
Insert into TITLE_AUTHOR_LINKING (AUTHOR_ID,TITLE_ID) values (9,63);
Insert into TITLE_AUTHOR_LINKING (AUTHOR_ID,TITLE_ID) values (72,64);
Insert into TITLE_AUTHOR_LINKING (AUTHOR_ID,TITLE_ID) values (6,65);
Insert into TITLE_AUTHOR_LINKING (AUTHOR_ID,TITLE_ID) values (44,66);
Insert into TITLE_AUTHOR_LINKING (AUTHOR_ID,TITLE_ID) values (12,67);
Insert into TITLE_AUTHOR_LINKING (AUTHOR_ID,TITLE_ID) values (23,68);
Insert into TITLE_AUTHOR_LINKING (AUTHOR_ID,TITLE_ID) values (32,69);
Insert into TITLE_AUTHOR_LINKING (AUTHOR_ID,TITLE_ID) values (82,69);
Insert into TITLE_AUTHOR_LINKING (AUTHOR_ID,TITLE_ID) values (42,70);
Insert into TITLE_AUTHOR_LINKING (AUTHOR_ID,TITLE_ID) values (66,71);
Insert into TITLE_AUTHOR_LINKING (AUTHOR_ID,TITLE_ID) values (56,72);
Insert into TITLE_AUTHOR_LINKING (AUTHOR_ID,TITLE_ID) values (13,73);
Insert into TITLE_AUTHOR_LINKING (AUTHOR_ID,TITLE_ID) values (78,74);
Insert into TITLE_AUTHOR_LINKING (AUTHOR_ID,TITLE_ID) values (13,75);
Insert into TITLE_AUTHOR_LINKING (AUTHOR_ID,TITLE_ID) values (61,76);
Insert into TITLE_AUTHOR_LINKING (AUTHOR_ID,TITLE_ID) values (28,77);
Insert into TITLE_AUTHOR_LINKING (AUTHOR_ID,TITLE_ID) values (34,78);
Insert into TITLE_AUTHOR_LINKING (AUTHOR_ID,TITLE_ID) values (50,79);
Insert into TITLE_AUTHOR_LINKING (AUTHOR_ID,TITLE_ID) values (42,80);
Insert into TITLE_AUTHOR_LINKING (AUTHOR_ID,TITLE_ID) values (27,81);
Insert into TITLE_AUTHOR_LINKING (AUTHOR_ID,TITLE_ID) values (76,82);
Insert into TITLE_AUTHOR_LINKING (AUTHOR_ID,TITLE_ID) values (87,82);
Insert into TITLE_AUTHOR_LINKING (AUTHOR_ID,TITLE_ID) values (47,83);
Insert into TITLE_AUTHOR_LINKING (AUTHOR_ID,TITLE_ID) values (26,84);
Insert into TITLE_AUTHOR_LINKING (AUTHOR_ID,TITLE_ID) values (8,85);
Insert into TITLE_AUTHOR_LINKING (AUTHOR_ID,TITLE_ID) values (18,86);
Insert into TITLE_AUTHOR_LINKING (AUTHOR_ID,TITLE_ID) values (30,87);
Insert into TITLE_AUTHOR_LINKING (AUTHOR_ID,TITLE_ID) values (45,88);
commit;



-- 2 copies per title distributed to one of 6 locations.  note 1 book as 6 copies (one per location)
Insert into TITLE_LOC_LINKING (TITLE_COPY_ID,TITLE_ID,LAST_LOCATION,STATUS) values (1,1,6,'A');
Insert into TITLE_LOC_LINKING (TITLE_COPY_ID,TITLE_ID,LAST_LOCATION,STATUS) values (2,1,4,'A');
Insert into TITLE_LOC_LINKING (TITLE_COPY_ID,TITLE_ID,LAST_LOCATION,STATUS) values (3,1,5,'A');
Insert into TITLE_LOC_LINKING (TITLE_COPY_ID,TITLE_ID,LAST_LOCATION,STATUS) values (4,2,4,'A');
Insert into TITLE_LOC_LINKING (TITLE_COPY_ID,TITLE_ID,LAST_LOCATION,STATUS) values (5,2,1,'A');
Insert into TITLE_LOC_LINKING (TITLE_COPY_ID,TITLE_ID,LAST_LOCATION,STATUS) values (6,2,4,'A');
Insert into TITLE_LOC_LINKING (TITLE_COPY_ID,TITLE_ID,LAST_LOCATION,STATUS) values (7,3,3,'A');
Insert into TITLE_LOC_LINKING (TITLE_COPY_ID,TITLE_ID,LAST_LOCATION,STATUS) values (8,3,2,'A');
Insert into TITLE_LOC_LINKING (TITLE_COPY_ID,TITLE_ID,LAST_LOCATION,STATUS) values (9,3,5,'A');
Insert into TITLE_LOC_LINKING (TITLE_COPY_ID,TITLE_ID,LAST_LOCATION,STATUS) values (10,4,6,'A');
Insert into TITLE_LOC_LINKING (TITLE_COPY_ID,TITLE_ID,LAST_LOCATION,STATUS) values (11,4,5,'A');
Insert into TITLE_LOC_LINKING (TITLE_COPY_ID,TITLE_ID,LAST_LOCATION,STATUS) values (12,4,4,'A');
Insert into TITLE_LOC_LINKING (TITLE_COPY_ID,TITLE_ID,LAST_LOCATION,STATUS) values (13,5,5,'A');
Insert into TITLE_LOC_LINKING (TITLE_COPY_ID,TITLE_ID,LAST_LOCATION,STATUS) values (14,5,4,'A');
Insert into TITLE_LOC_LINKING (TITLE_COPY_ID,TITLE_ID,LAST_LOCATION,STATUS) values (15,5,5,'A');
Insert into TITLE_LOC_LINKING (TITLE_COPY_ID,TITLE_ID,LAST_LOCATION,STATUS) values (16,6,1,'A');
Insert into TITLE_LOC_LINKING (TITLE_COPY_ID,TITLE_ID,LAST_LOCATION,STATUS) values (17,6,4,'A');
Insert into TITLE_LOC_LINKING (TITLE_COPY_ID,TITLE_ID,LAST_LOCATION,STATUS) values (18,6,5,'A');
Insert into TITLE_LOC_LINKING (TITLE_COPY_ID,TITLE_ID,LAST_LOCATION,STATUS) values (19,7,3,'A');
Insert into TITLE_LOC_LINKING (TITLE_COPY_ID,TITLE_ID,LAST_LOCATION,STATUS) values (20,7,1,'A');
Insert into TITLE_LOC_LINKING (TITLE_COPY_ID,TITLE_ID,LAST_LOCATION,STATUS) values (21,7,5,'A');
Insert into TITLE_LOC_LINKING (TITLE_COPY_ID,TITLE_ID,LAST_LOCATION,STATUS) values (22,8,2,'A');
Insert into TITLE_LOC_LINKING (TITLE_COPY_ID,TITLE_ID,LAST_LOCATION,STATUS) values (23,8,4,'A');
Insert into TITLE_LOC_LINKING (TITLE_COPY_ID,TITLE_ID,LAST_LOCATION,STATUS) values (24,8,4,'A');
Insert into TITLE_LOC_LINKING (TITLE_COPY_ID,TITLE_ID,LAST_LOCATION,STATUS) values (25,9,1,'A');
Insert into TITLE_LOC_LINKING (TITLE_COPY_ID,TITLE_ID,LAST_LOCATION,STATUS) values (26,9,3,'A');
Insert into TITLE_LOC_LINKING (TITLE_COPY_ID,TITLE_ID,LAST_LOCATION,STATUS) values (27,9,5,'A');
Insert into TITLE_LOC_LINKING (TITLE_COPY_ID,TITLE_ID,LAST_LOCATION,STATUS) values (28,10,5,'A');
Insert into TITLE_LOC_LINKING (TITLE_COPY_ID,TITLE_ID,LAST_LOCATION,STATUS) values (29,10,3,'A');
Insert into TITLE_LOC_LINKING (TITLE_COPY_ID,TITLE_ID,LAST_LOCATION,STATUS) values (30,10,1,'A');
Insert into TITLE_LOC_LINKING (TITLE_COPY_ID,TITLE_ID,LAST_LOCATION,STATUS) values (31,11,6,'A');
Insert into TITLE_LOC_LINKING (TITLE_COPY_ID,TITLE_ID,LAST_LOCATION,STATUS) values (32,11,6,'A');
Insert into TITLE_LOC_LINKING (TITLE_COPY_ID,TITLE_ID,LAST_LOCATION,STATUS) values (33,11,3,'A');
Insert into TITLE_LOC_LINKING (TITLE_COPY_ID,TITLE_ID,LAST_LOCATION,STATUS) values (34,12,1,'A');
Insert into TITLE_LOC_LINKING (TITLE_COPY_ID,TITLE_ID,LAST_LOCATION,STATUS) values (35,12,5,'A');
Insert into TITLE_LOC_LINKING (TITLE_COPY_ID,TITLE_ID,LAST_LOCATION,STATUS) values (36,12,5,'A');
Insert into TITLE_LOC_LINKING (TITLE_COPY_ID,TITLE_ID,LAST_LOCATION,STATUS) values (37,13,3,'A');
Insert into TITLE_LOC_LINKING (TITLE_COPY_ID,TITLE_ID,LAST_LOCATION,STATUS) values (38,13,5,'A');
Insert into TITLE_LOC_LINKING (TITLE_COPY_ID,TITLE_ID,LAST_LOCATION,STATUS) values (39,13,1,'A');
Insert into TITLE_LOC_LINKING (TITLE_COPY_ID,TITLE_ID,LAST_LOCATION,STATUS) values (40,14,4,'A');
Insert into TITLE_LOC_LINKING (TITLE_COPY_ID,TITLE_ID,LAST_LOCATION,STATUS) values (41,14,2,'A');
Insert into TITLE_LOC_LINKING (TITLE_COPY_ID,TITLE_ID,LAST_LOCATION,STATUS) values (42,14,6,'A');
Insert into TITLE_LOC_LINKING (TITLE_COPY_ID,TITLE_ID,LAST_LOCATION,STATUS) values (43,15,1,'A');
Insert into TITLE_LOC_LINKING (TITLE_COPY_ID,TITLE_ID,LAST_LOCATION,STATUS) values (44,15,5,'A');
Insert into TITLE_LOC_LINKING (TITLE_COPY_ID,TITLE_ID,LAST_LOCATION,STATUS) values (45,15,5,'A');
Insert into TITLE_LOC_LINKING (TITLE_COPY_ID,TITLE_ID,LAST_LOCATION,STATUS) values (46,16,1,'A');
Insert into TITLE_LOC_LINKING (TITLE_COPY_ID,TITLE_ID,LAST_LOCATION,STATUS) values (47,16,2,'A');
Insert into TITLE_LOC_LINKING (TITLE_COPY_ID,TITLE_ID,LAST_LOCATION,STATUS) values (48,16,2,'A');
Insert into TITLE_LOC_LINKING (TITLE_COPY_ID,TITLE_ID,LAST_LOCATION,STATUS) values (49,17,3,'A');
Insert into TITLE_LOC_LINKING (TITLE_COPY_ID,TITLE_ID,LAST_LOCATION,STATUS) values (50,17,4,'A');
Insert into TITLE_LOC_LINKING (TITLE_COPY_ID,TITLE_ID,LAST_LOCATION,STATUS) values (51,17,5,'A');
Insert into TITLE_LOC_LINKING (TITLE_COPY_ID,TITLE_ID,LAST_LOCATION,STATUS) values (52,18,3,'A');
Insert into TITLE_LOC_LINKING (TITLE_COPY_ID,TITLE_ID,LAST_LOCATION,STATUS) values (53,18,4,'A');
Insert into TITLE_LOC_LINKING (TITLE_COPY_ID,TITLE_ID,LAST_LOCATION,STATUS) values (54,18,5,'A');
Insert into TITLE_LOC_LINKING (TITLE_COPY_ID,TITLE_ID,LAST_LOCATION,STATUS) values (55,19,3,'A');
Insert into TITLE_LOC_LINKING (TITLE_COPY_ID,TITLE_ID,LAST_LOCATION,STATUS) values (56,19,4,'A');
Insert into TITLE_LOC_LINKING (TITLE_COPY_ID,TITLE_ID,LAST_LOCATION,STATUS) values (57,19,4,'A');
Insert into TITLE_LOC_LINKING (TITLE_COPY_ID,TITLE_ID,LAST_LOCATION,STATUS) values (58,20,5,'A');
Insert into TITLE_LOC_LINKING (TITLE_COPY_ID,TITLE_ID,LAST_LOCATION,STATUS) values (59,20,6,'A');
Insert into TITLE_LOC_LINKING (TITLE_COPY_ID,TITLE_ID,LAST_LOCATION,STATUS) values (60,20,1,'A');
Insert into TITLE_LOC_LINKING (TITLE_COPY_ID,TITLE_ID,LAST_LOCATION,STATUS) values (61,21,2,'A');
Insert into TITLE_LOC_LINKING (TITLE_COPY_ID,TITLE_ID,LAST_LOCATION,STATUS) values (62,21,2,'A');
Insert into TITLE_LOC_LINKING (TITLE_COPY_ID,TITLE_ID,LAST_LOCATION,STATUS) values (63,21,3,'A');
Insert into TITLE_LOC_LINKING (TITLE_COPY_ID,TITLE_ID,LAST_LOCATION,STATUS) values (64,22,5,'A');
Insert into TITLE_LOC_LINKING (TITLE_COPY_ID,TITLE_ID,LAST_LOCATION,STATUS) values (65,22,4,'A');
Insert into TITLE_LOC_LINKING (TITLE_COPY_ID,TITLE_ID,LAST_LOCATION,STATUS) values (66,22,4,'A');
Insert into TITLE_LOC_LINKING (TITLE_COPY_ID,TITLE_ID,LAST_LOCATION,STATUS) values (67,23,4,'A');
Insert into TITLE_LOC_LINKING (TITLE_COPY_ID,TITLE_ID,LAST_LOCATION,STATUS) values (68,23,3,'A');
Insert into TITLE_LOC_LINKING (TITLE_COPY_ID,TITLE_ID,LAST_LOCATION,STATUS) values (69,23,3,'A');
Insert into TITLE_LOC_LINKING (TITLE_COPY_ID,TITLE_ID,LAST_LOCATION,STATUS) values (70,24,1,'A');
Insert into TITLE_LOC_LINKING (TITLE_COPY_ID,TITLE_ID,LAST_LOCATION,STATUS) values (71,24,1,'A');
Insert into TITLE_LOC_LINKING (TITLE_COPY_ID,TITLE_ID,LAST_LOCATION,STATUS) values (72,24,4,'A');
Insert into TITLE_LOC_LINKING (TITLE_COPY_ID,TITLE_ID,LAST_LOCATION,STATUS) values (73,25,4,'A');
Insert into TITLE_LOC_LINKING (TITLE_COPY_ID,TITLE_ID,LAST_LOCATION,STATUS) values (74,25,1,'A');
Insert into TITLE_LOC_LINKING (TITLE_COPY_ID,TITLE_ID,LAST_LOCATION,STATUS) values (75,25,5,'A');
Insert into TITLE_LOC_LINKING (TITLE_COPY_ID,TITLE_ID,LAST_LOCATION,STATUS) values (76,26,2,'A');
Insert into TITLE_LOC_LINKING (TITLE_COPY_ID,TITLE_ID,LAST_LOCATION,STATUS) values (77,26,2,'A');
Insert into TITLE_LOC_LINKING (TITLE_COPY_ID,TITLE_ID,LAST_LOCATION,STATUS) values (78,26,5,'A');
Insert into TITLE_LOC_LINKING (TITLE_COPY_ID,TITLE_ID,LAST_LOCATION,STATUS) values (79,27,2,'A');
Insert into TITLE_LOC_LINKING (TITLE_COPY_ID,TITLE_ID,LAST_LOCATION,STATUS) values (80,27,1,'A');
Insert into TITLE_LOC_LINKING (TITLE_COPY_ID,TITLE_ID,LAST_LOCATION,STATUS) values (81,27,4,'A');
Insert into TITLE_LOC_LINKING (TITLE_COPY_ID,TITLE_ID,LAST_LOCATION,STATUS) values (82,28,3,'A');
Insert into TITLE_LOC_LINKING (TITLE_COPY_ID,TITLE_ID,LAST_LOCATION,STATUS) values (83,28,5,'A');
Insert into TITLE_LOC_LINKING (TITLE_COPY_ID,TITLE_ID,LAST_LOCATION,STATUS) values (84,28,2,'A');
Insert into TITLE_LOC_LINKING (TITLE_COPY_ID,TITLE_ID,LAST_LOCATION,STATUS) values (85,29,1,'A');
Insert into TITLE_LOC_LINKING (TITLE_COPY_ID,TITLE_ID,LAST_LOCATION,STATUS) values (86,29,2,'A');
Insert into TITLE_LOC_LINKING (TITLE_COPY_ID,TITLE_ID,LAST_LOCATION,STATUS) values (87,29,1,'A');
Insert into TITLE_LOC_LINKING (TITLE_COPY_ID,TITLE_ID,LAST_LOCATION,STATUS) values (88,30,3,'A');
Insert into TITLE_LOC_LINKING (TITLE_COPY_ID,TITLE_ID,LAST_LOCATION,STATUS) values (89,30,3,'A');
Insert into TITLE_LOC_LINKING (TITLE_COPY_ID,TITLE_ID,LAST_LOCATION,STATUS) values (90,30,3,'A');
Insert into TITLE_LOC_LINKING (TITLE_COPY_ID,TITLE_ID,LAST_LOCATION,STATUS) values (91,31,6,'A');
Insert into TITLE_LOC_LINKING (TITLE_COPY_ID,TITLE_ID,LAST_LOCATION,STATUS) values (92,31,6,'A');
Insert into TITLE_LOC_LINKING (TITLE_COPY_ID,TITLE_ID,LAST_LOCATION,STATUS) values (93,31,1,'A');
Insert into TITLE_LOC_LINKING (TITLE_COPY_ID,TITLE_ID,LAST_LOCATION,STATUS) values (94,32,4,'A');
Insert into TITLE_LOC_LINKING (TITLE_COPY_ID,TITLE_ID,LAST_LOCATION,STATUS) values (95,32,6,'A');
Insert into TITLE_LOC_LINKING (TITLE_COPY_ID,TITLE_ID,LAST_LOCATION,STATUS) values (96,32,4,'A');
Insert into TITLE_LOC_LINKING (TITLE_COPY_ID,TITLE_ID,LAST_LOCATION,STATUS) values (97,33,3,'A');
Insert into TITLE_LOC_LINKING (TITLE_COPY_ID,TITLE_ID,LAST_LOCATION,STATUS) values (98,33,1,'A');
Insert into TITLE_LOC_LINKING (TITLE_COPY_ID,TITLE_ID,LAST_LOCATION,STATUS) values (99,33,6,'A');
Insert into TITLE_LOC_LINKING (TITLE_COPY_ID,TITLE_ID,LAST_LOCATION,STATUS) values (100,34,4,'A');
Insert into TITLE_LOC_LINKING (TITLE_COPY_ID,TITLE_ID,LAST_LOCATION,STATUS) values (101,34,2,'A');
Insert into TITLE_LOC_LINKING (TITLE_COPY_ID,TITLE_ID,LAST_LOCATION,STATUS) values (102,34,2,'A');
Insert into TITLE_LOC_LINKING (TITLE_COPY_ID,TITLE_ID,LAST_LOCATION,STATUS) values (103,35,4,'A');
Insert into TITLE_LOC_LINKING (TITLE_COPY_ID,TITLE_ID,LAST_LOCATION,STATUS) values (104,35,6,'A');
Insert into TITLE_LOC_LINKING (TITLE_COPY_ID,TITLE_ID,LAST_LOCATION,STATUS) values (105,35,5,'A');
Insert into TITLE_LOC_LINKING (TITLE_COPY_ID,TITLE_ID,LAST_LOCATION,STATUS) values (106,36,6,'A');
Insert into TITLE_LOC_LINKING (TITLE_COPY_ID,TITLE_ID,LAST_LOCATION,STATUS) values (107,36,3,'A');
Insert into TITLE_LOC_LINKING (TITLE_COPY_ID,TITLE_ID,LAST_LOCATION,STATUS) values (108,36,5,'A');
Insert into TITLE_LOC_LINKING (TITLE_COPY_ID,TITLE_ID,LAST_LOCATION,STATUS) values (109,37,2,'A');
Insert into TITLE_LOC_LINKING (TITLE_COPY_ID,TITLE_ID,LAST_LOCATION,STATUS) values (110,37,3,'A');
Insert into TITLE_LOC_LINKING (TITLE_COPY_ID,TITLE_ID,LAST_LOCATION,STATUS) values (111,37,2,'A');
Insert into TITLE_LOC_LINKING (TITLE_COPY_ID,TITLE_ID,LAST_LOCATION,STATUS) values (112,38,3,'A');
Insert into TITLE_LOC_LINKING (TITLE_COPY_ID,TITLE_ID,LAST_LOCATION,STATUS) values (113,38,1,'A');
Insert into TITLE_LOC_LINKING (TITLE_COPY_ID,TITLE_ID,LAST_LOCATION,STATUS) values (114,38,5,'A');
Insert into TITLE_LOC_LINKING (TITLE_COPY_ID,TITLE_ID,LAST_LOCATION,STATUS) values (115,39,3,'A');
Insert into TITLE_LOC_LINKING (TITLE_COPY_ID,TITLE_ID,LAST_LOCATION,STATUS) values (116,39,1,'A');
Insert into TITLE_LOC_LINKING (TITLE_COPY_ID,TITLE_ID,LAST_LOCATION,STATUS) values (117,39,6,'A');
Insert into TITLE_LOC_LINKING (TITLE_COPY_ID,TITLE_ID,LAST_LOCATION,STATUS) values (118,40,5,'A');
Insert into TITLE_LOC_LINKING (TITLE_COPY_ID,TITLE_ID,LAST_LOCATION,STATUS) values (119,40,2,'A');
Insert into TITLE_LOC_LINKING (TITLE_COPY_ID,TITLE_ID,LAST_LOCATION,STATUS) values (120,40,1,'A');
Insert into TITLE_LOC_LINKING (TITLE_COPY_ID,TITLE_ID,LAST_LOCATION,STATUS) values (121,41,1,'A');
Insert into TITLE_LOC_LINKING (TITLE_COPY_ID,TITLE_ID,LAST_LOCATION,STATUS) values (122,41,2,'A');
Insert into TITLE_LOC_LINKING (TITLE_COPY_ID,TITLE_ID,LAST_LOCATION,STATUS) values (123,41,3,'A');
Insert into TITLE_LOC_LINKING (TITLE_COPY_ID,TITLE_ID,LAST_LOCATION,STATUS) values (124,42,3,'A');
Insert into TITLE_LOC_LINKING (TITLE_COPY_ID,TITLE_ID,LAST_LOCATION,STATUS) values (125,42,6,'A');
Insert into TITLE_LOC_LINKING (TITLE_COPY_ID,TITLE_ID,LAST_LOCATION,STATUS) values (126,42,6,'A');
Insert into TITLE_LOC_LINKING (TITLE_COPY_ID,TITLE_ID,LAST_LOCATION,STATUS) values (127,43,3,'A');
Insert into TITLE_LOC_LINKING (TITLE_COPY_ID,TITLE_ID,LAST_LOCATION,STATUS) values (128,43,6,'A');
Insert into TITLE_LOC_LINKING (TITLE_COPY_ID,TITLE_ID,LAST_LOCATION,STATUS) values (129,43,6,'A');
Insert into TITLE_LOC_LINKING (TITLE_COPY_ID,TITLE_ID,LAST_LOCATION,STATUS) values (130,44,3,'A');
Insert into TITLE_LOC_LINKING (TITLE_COPY_ID,TITLE_ID,LAST_LOCATION,STATUS) values (131,44,2,'A');
Insert into TITLE_LOC_LINKING (TITLE_COPY_ID,TITLE_ID,LAST_LOCATION,STATUS) values (132,44,2,'A');
Insert into TITLE_LOC_LINKING (TITLE_COPY_ID,TITLE_ID,LAST_LOCATION,STATUS) values (133,45,3,'A');
Insert into TITLE_LOC_LINKING (TITLE_COPY_ID,TITLE_ID,LAST_LOCATION,STATUS) values (134,45,1,'A');
Insert into TITLE_LOC_LINKING (TITLE_COPY_ID,TITLE_ID,LAST_LOCATION,STATUS) values (135,45,3,'A');
Insert into TITLE_LOC_LINKING (TITLE_COPY_ID,TITLE_ID,LAST_LOCATION,STATUS) values (136,46,4,'A');
Insert into TITLE_LOC_LINKING (TITLE_COPY_ID,TITLE_ID,LAST_LOCATION,STATUS) values (137,46,2,'A');
Insert into TITLE_LOC_LINKING (TITLE_COPY_ID,TITLE_ID,LAST_LOCATION,STATUS) values (138,46,4,'A');
Insert into TITLE_LOC_LINKING (TITLE_COPY_ID,TITLE_ID,LAST_LOCATION,STATUS) values (139,47,1,'A');
Insert into TITLE_LOC_LINKING (TITLE_COPY_ID,TITLE_ID,LAST_LOCATION,STATUS) values (140,47,5,'A');
Insert into TITLE_LOC_LINKING (TITLE_COPY_ID,TITLE_ID,LAST_LOCATION,STATUS) values (141,47,3,'A');
Insert into TITLE_LOC_LINKING (TITLE_COPY_ID,TITLE_ID,LAST_LOCATION,STATUS) values (142,48,5,'A');
Insert into TITLE_LOC_LINKING (TITLE_COPY_ID,TITLE_ID,LAST_LOCATION,STATUS) values (143,48,6,'A');
Insert into TITLE_LOC_LINKING (TITLE_COPY_ID,TITLE_ID,LAST_LOCATION,STATUS) values (144,48,1,'A');
Insert into TITLE_LOC_LINKING (TITLE_COPY_ID,TITLE_ID,LAST_LOCATION,STATUS) values (145,49,4,'A');
Insert into TITLE_LOC_LINKING (TITLE_COPY_ID,TITLE_ID,LAST_LOCATION,STATUS) values (146,49,4,'A');
Insert into TITLE_LOC_LINKING (TITLE_COPY_ID,TITLE_ID,LAST_LOCATION,STATUS) values (147,49,3,'A');
Insert into TITLE_LOC_LINKING (TITLE_COPY_ID,TITLE_ID,LAST_LOCATION,STATUS) values (148,50,3,'A');
Insert into TITLE_LOC_LINKING (TITLE_COPY_ID,TITLE_ID,LAST_LOCATION,STATUS) values (149,50,3,'A');
Insert into TITLE_LOC_LINKING (TITLE_COPY_ID,TITLE_ID,LAST_LOCATION,STATUS) values (150,50,4,'A');
Insert into TITLE_LOC_LINKING (TITLE_COPY_ID,TITLE_ID,LAST_LOCATION,STATUS) values (151,51,1,'A');
Insert into TITLE_LOC_LINKING (TITLE_COPY_ID,TITLE_ID,LAST_LOCATION,STATUS) values (152,51,5,'A');
Insert into TITLE_LOC_LINKING (TITLE_COPY_ID,TITLE_ID,LAST_LOCATION,STATUS) values (153,51,6,'A');
Insert into TITLE_LOC_LINKING (TITLE_COPY_ID,TITLE_ID,LAST_LOCATION,STATUS) values (154,52,4,'A');
Insert into TITLE_LOC_LINKING (TITLE_COPY_ID,TITLE_ID,LAST_LOCATION,STATUS) values (155,52,6,'A');
Insert into TITLE_LOC_LINKING (TITLE_COPY_ID,TITLE_ID,LAST_LOCATION,STATUS) values (156,52,3,'A');
Insert into TITLE_LOC_LINKING (TITLE_COPY_ID,TITLE_ID,LAST_LOCATION,STATUS) values (157,53,2,'A');
Insert into TITLE_LOC_LINKING (TITLE_COPY_ID,TITLE_ID,LAST_LOCATION,STATUS) values (158,53,6,'A');
Insert into TITLE_LOC_LINKING (TITLE_COPY_ID,TITLE_ID,LAST_LOCATION,STATUS) values (159,53,1,'A');
Insert into TITLE_LOC_LINKING (TITLE_COPY_ID,TITLE_ID,LAST_LOCATION,STATUS) values (160,54,1,'A');
Insert into TITLE_LOC_LINKING (TITLE_COPY_ID,TITLE_ID,LAST_LOCATION,STATUS) values (161,54,4,'A');
Insert into TITLE_LOC_LINKING (TITLE_COPY_ID,TITLE_ID,LAST_LOCATION,STATUS) values (162,54,6,'A');
Insert into TITLE_LOC_LINKING (TITLE_COPY_ID,TITLE_ID,LAST_LOCATION,STATUS) values (163,55,3,'A');
Insert into TITLE_LOC_LINKING (TITLE_COPY_ID,TITLE_ID,LAST_LOCATION,STATUS) values (164,55,2,'A');
Insert into TITLE_LOC_LINKING (TITLE_COPY_ID,TITLE_ID,LAST_LOCATION,STATUS) values (165,55,4,'A');
Insert into TITLE_LOC_LINKING (TITLE_COPY_ID,TITLE_ID,LAST_LOCATION,STATUS) values (166,56,1,'A');
Insert into TITLE_LOC_LINKING (TITLE_COPY_ID,TITLE_ID,LAST_LOCATION,STATUS) values (167,56,3,'A');
Insert into TITLE_LOC_LINKING (TITLE_COPY_ID,TITLE_ID,LAST_LOCATION,STATUS) values (168,56,6,'A');
Insert into TITLE_LOC_LINKING (TITLE_COPY_ID,TITLE_ID,LAST_LOCATION,STATUS) values (169,57,1,'A');
Insert into TITLE_LOC_LINKING (TITLE_COPY_ID,TITLE_ID,LAST_LOCATION,STATUS) values (170,57,6,'A');
Insert into TITLE_LOC_LINKING (TITLE_COPY_ID,TITLE_ID,LAST_LOCATION,STATUS) values (171,57,1,'A');
Insert into TITLE_LOC_LINKING (TITLE_COPY_ID,TITLE_ID,LAST_LOCATION,STATUS) values (172,58,3,'A');
Insert into TITLE_LOC_LINKING (TITLE_COPY_ID,TITLE_ID,LAST_LOCATION,STATUS) values (173,58,5,'A');
Insert into TITLE_LOC_LINKING (TITLE_COPY_ID,TITLE_ID,LAST_LOCATION,STATUS) values (174,58,2,'A');
Insert into TITLE_LOC_LINKING (TITLE_COPY_ID,TITLE_ID,LAST_LOCATION,STATUS) values (175,59,2,'A');
Insert into TITLE_LOC_LINKING (TITLE_COPY_ID,TITLE_ID,LAST_LOCATION,STATUS) values (176,59,1,'A');
Insert into TITLE_LOC_LINKING (TITLE_COPY_ID,TITLE_ID,LAST_LOCATION,STATUS) values (177,59,5,'A');
Insert into TITLE_LOC_LINKING (TITLE_COPY_ID,TITLE_ID,LAST_LOCATION,STATUS) values (178,60,1,'A');
Insert into TITLE_LOC_LINKING (TITLE_COPY_ID,TITLE_ID,LAST_LOCATION,STATUS) values (179,60,2,'A');
Insert into TITLE_LOC_LINKING (TITLE_COPY_ID,TITLE_ID,LAST_LOCATION,STATUS) values (180,60,6,'A');
Insert into TITLE_LOC_LINKING (TITLE_COPY_ID,TITLE_ID,LAST_LOCATION,STATUS) values (181,61,2,'A');
Insert into TITLE_LOC_LINKING (TITLE_COPY_ID,TITLE_ID,LAST_LOCATION,STATUS) values (182,61,6,'A');
Insert into TITLE_LOC_LINKING (TITLE_COPY_ID,TITLE_ID,LAST_LOCATION,STATUS) values (183,61,6,'A');
Insert into TITLE_LOC_LINKING (TITLE_COPY_ID,TITLE_ID,LAST_LOCATION,STATUS) values (184,62,5,'A');
Insert into TITLE_LOC_LINKING (TITLE_COPY_ID,TITLE_ID,LAST_LOCATION,STATUS) values (185,62,1,'A');
Insert into TITLE_LOC_LINKING (TITLE_COPY_ID,TITLE_ID,LAST_LOCATION,STATUS) values (186,62,6,'A');
Insert into TITLE_LOC_LINKING (TITLE_COPY_ID,TITLE_ID,LAST_LOCATION,STATUS) values (187,63,4,'A');
Insert into TITLE_LOC_LINKING (TITLE_COPY_ID,TITLE_ID,LAST_LOCATION,STATUS) values (188,63,4,'A');
Insert into TITLE_LOC_LINKING (TITLE_COPY_ID,TITLE_ID,LAST_LOCATION,STATUS) values (189,63,6,'A');
Insert into TITLE_LOC_LINKING (TITLE_COPY_ID,TITLE_ID,LAST_LOCATION,STATUS) values (190,64,5,'A');
Insert into TITLE_LOC_LINKING (TITLE_COPY_ID,TITLE_ID,LAST_LOCATION,STATUS) values (191,64,3,'A');
Insert into TITLE_LOC_LINKING (TITLE_COPY_ID,TITLE_ID,LAST_LOCATION,STATUS) values (192,64,5,'A');
Insert into TITLE_LOC_LINKING (TITLE_COPY_ID,TITLE_ID,LAST_LOCATION,STATUS) values (193,65,4,'A');
Insert into TITLE_LOC_LINKING (TITLE_COPY_ID,TITLE_ID,LAST_LOCATION,STATUS) values (194,65,5,'A');
Insert into TITLE_LOC_LINKING (TITLE_COPY_ID,TITLE_ID,LAST_LOCATION,STATUS) values (195,65,2,'A');
Insert into TITLE_LOC_LINKING (TITLE_COPY_ID,TITLE_ID,LAST_LOCATION,STATUS) values (196,66,3,'A');
Insert into TITLE_LOC_LINKING (TITLE_COPY_ID,TITLE_ID,LAST_LOCATION,STATUS) values (197,66,5,'A');
Insert into TITLE_LOC_LINKING (TITLE_COPY_ID,TITLE_ID,LAST_LOCATION,STATUS) values (198,66,2,'A');
Insert into TITLE_LOC_LINKING (TITLE_COPY_ID,TITLE_ID,LAST_LOCATION,STATUS) values (199,67,3,'A');
Insert into TITLE_LOC_LINKING (TITLE_COPY_ID,TITLE_ID,LAST_LOCATION,STATUS) values (200,67,3,'A');
Insert into TITLE_LOC_LINKING (TITLE_COPY_ID,TITLE_ID,LAST_LOCATION,STATUS) values (201,67,4,'A');
Insert into TITLE_LOC_LINKING (TITLE_COPY_ID,TITLE_ID,LAST_LOCATION,STATUS) values (202,68,6,'A');
Insert into TITLE_LOC_LINKING (TITLE_COPY_ID,TITLE_ID,LAST_LOCATION,STATUS) values (203,68,6,'A');
Insert into TITLE_LOC_LINKING (TITLE_COPY_ID,TITLE_ID,LAST_LOCATION,STATUS) values (204,68,3,'A');
Insert into TITLE_LOC_LINKING (TITLE_COPY_ID,TITLE_ID,LAST_LOCATION,STATUS) values (205,69,6,'A');
Insert into TITLE_LOC_LINKING (TITLE_COPY_ID,TITLE_ID,LAST_LOCATION,STATUS) values (206,69,4,'A');
Insert into TITLE_LOC_LINKING (TITLE_COPY_ID,TITLE_ID,LAST_LOCATION,STATUS) values (207,69,2,'A');
Insert into TITLE_LOC_LINKING (TITLE_COPY_ID,TITLE_ID,LAST_LOCATION,STATUS) values (208,70,2,'A');
Insert into TITLE_LOC_LINKING (TITLE_COPY_ID,TITLE_ID,LAST_LOCATION,STATUS) values (209,70,2,'A');
Insert into TITLE_LOC_LINKING (TITLE_COPY_ID,TITLE_ID,LAST_LOCATION,STATUS) values (210,70,3,'A');
Insert into TITLE_LOC_LINKING (TITLE_COPY_ID,TITLE_ID,LAST_LOCATION,STATUS) values (211,71,5,'A');
Insert into TITLE_LOC_LINKING (TITLE_COPY_ID,TITLE_ID,LAST_LOCATION,STATUS) values (212,71,3,'A');
Insert into TITLE_LOC_LINKING (TITLE_COPY_ID,TITLE_ID,LAST_LOCATION,STATUS) values (213,71,4,'A');
Insert into TITLE_LOC_LINKING (TITLE_COPY_ID,TITLE_ID,LAST_LOCATION,STATUS) values (214,72,5,'A');
Insert into TITLE_LOC_LINKING (TITLE_COPY_ID,TITLE_ID,LAST_LOCATION,STATUS) values (215,72,6,'A');
Insert into TITLE_LOC_LINKING (TITLE_COPY_ID,TITLE_ID,LAST_LOCATION,STATUS) values (216,72,3,'A');
Insert into TITLE_LOC_LINKING (TITLE_COPY_ID,TITLE_ID,LAST_LOCATION,STATUS) values (217,73,5,'A');
Insert into TITLE_LOC_LINKING (TITLE_COPY_ID,TITLE_ID,LAST_LOCATION,STATUS) values (218,73,3,'A');
Insert into TITLE_LOC_LINKING (TITLE_COPY_ID,TITLE_ID,LAST_LOCATION,STATUS) values (219,73,5,'A');
Insert into TITLE_LOC_LINKING (TITLE_COPY_ID,TITLE_ID,LAST_LOCATION,STATUS) values (220,74,3,'A');
Insert into TITLE_LOC_LINKING (TITLE_COPY_ID,TITLE_ID,LAST_LOCATION,STATUS) values (221,74,6,'A');
Insert into TITLE_LOC_LINKING (TITLE_COPY_ID,TITLE_ID,LAST_LOCATION,STATUS) values (222,74,2,'A');
Insert into TITLE_LOC_LINKING (TITLE_COPY_ID,TITLE_ID,LAST_LOCATION,STATUS) values (223,75,1,'A');
Insert into TITLE_LOC_LINKING (TITLE_COPY_ID,TITLE_ID,LAST_LOCATION,STATUS) values (224,75,4,'A');
Insert into TITLE_LOC_LINKING (TITLE_COPY_ID,TITLE_ID,LAST_LOCATION,STATUS) values (225,75,3,'A');
Insert into TITLE_LOC_LINKING (TITLE_COPY_ID,TITLE_ID,LAST_LOCATION,STATUS) values (226,76,3,'A');
Insert into TITLE_LOC_LINKING (TITLE_COPY_ID,TITLE_ID,LAST_LOCATION,STATUS) values (227,76,6,'A');
Insert into TITLE_LOC_LINKING (TITLE_COPY_ID,TITLE_ID,LAST_LOCATION,STATUS) values (228,76,1,'A');
Insert into TITLE_LOC_LINKING (TITLE_COPY_ID,TITLE_ID,LAST_LOCATION,STATUS) values (229,77,3,'A');
Insert into TITLE_LOC_LINKING (TITLE_COPY_ID,TITLE_ID,LAST_LOCATION,STATUS) values (230,77,1,'A');
Insert into TITLE_LOC_LINKING (TITLE_COPY_ID,TITLE_ID,LAST_LOCATION,STATUS) values (231,77,5,'A');
Insert into TITLE_LOC_LINKING (TITLE_COPY_ID,TITLE_ID,LAST_LOCATION,STATUS) values (232,78,6,'A');
Insert into TITLE_LOC_LINKING (TITLE_COPY_ID,TITLE_ID,LAST_LOCATION,STATUS) values (233,78,1,'A');
Insert into TITLE_LOC_LINKING (TITLE_COPY_ID,TITLE_ID,LAST_LOCATION,STATUS) values (234,78,1,'A');
Insert into TITLE_LOC_LINKING (TITLE_COPY_ID,TITLE_ID,LAST_LOCATION,STATUS) values (235,79,2,'A');
Insert into TITLE_LOC_LINKING (TITLE_COPY_ID,TITLE_ID,LAST_LOCATION,STATUS) values (236,79,6,'A');
Insert into TITLE_LOC_LINKING (TITLE_COPY_ID,TITLE_ID,LAST_LOCATION,STATUS) values (237,79,3,'A');
Insert into TITLE_LOC_LINKING (TITLE_COPY_ID,TITLE_ID,LAST_LOCATION,STATUS) values (238,80,1,'A');
Insert into TITLE_LOC_LINKING (TITLE_COPY_ID,TITLE_ID,LAST_LOCATION,STATUS) values (239,80,5,'A');
Insert into TITLE_LOC_LINKING (TITLE_COPY_ID,TITLE_ID,LAST_LOCATION,STATUS) values (240,80,5,'A');
Insert into TITLE_LOC_LINKING (TITLE_COPY_ID,TITLE_ID,LAST_LOCATION,STATUS) values (241,81,6,'A');
Insert into TITLE_LOC_LINKING (TITLE_COPY_ID,TITLE_ID,LAST_LOCATION,STATUS) values (242,81,3,'A');
Insert into TITLE_LOC_LINKING (TITLE_COPY_ID,TITLE_ID,LAST_LOCATION,STATUS) values (243,81,4,'A');
Insert into TITLE_LOC_LINKING (TITLE_COPY_ID,TITLE_ID,LAST_LOCATION,STATUS) values (244,82,4,'A');
Insert into TITLE_LOC_LINKING (TITLE_COPY_ID,TITLE_ID,LAST_LOCATION,STATUS) values (245,82,4,'A');
Insert into TITLE_LOC_LINKING (TITLE_COPY_ID,TITLE_ID,LAST_LOCATION,STATUS) values (246,82,5,'A');
Insert into TITLE_LOC_LINKING (TITLE_COPY_ID,TITLE_ID,LAST_LOCATION,STATUS) values (247,83,4,'A');
Insert into TITLE_LOC_LINKING (TITLE_COPY_ID,TITLE_ID,LAST_LOCATION,STATUS) values (248,83,5,'A');
Insert into TITLE_LOC_LINKING (TITLE_COPY_ID,TITLE_ID,LAST_LOCATION,STATUS) values (249,83,3,'A');
Insert into TITLE_LOC_LINKING (TITLE_COPY_ID,TITLE_ID,LAST_LOCATION,STATUS) values (250,84,3,'A');
Insert into TITLE_LOC_LINKING (TITLE_COPY_ID,TITLE_ID,LAST_LOCATION,STATUS) values (251,84,5,'A');
Insert into TITLE_LOC_LINKING (TITLE_COPY_ID,TITLE_ID,LAST_LOCATION,STATUS) values (252,84,6,'A');
Insert into TITLE_LOC_LINKING (TITLE_COPY_ID,TITLE_ID,LAST_LOCATION,STATUS) values (253,85,6,'A');
Insert into TITLE_LOC_LINKING (TITLE_COPY_ID,TITLE_ID,LAST_LOCATION,STATUS) values (254,85,6,'A');
Insert into TITLE_LOC_LINKING (TITLE_COPY_ID,TITLE_ID,LAST_LOCATION,STATUS) values (255,85,2,'A');
Insert into TITLE_LOC_LINKING (TITLE_COPY_ID,TITLE_ID,LAST_LOCATION,STATUS) values (256,86,1,'A');
Insert into TITLE_LOC_LINKING (TITLE_COPY_ID,TITLE_ID,LAST_LOCATION,STATUS) values (257,86,5,'A');
Insert into TITLE_LOC_LINKING (TITLE_COPY_ID,TITLE_ID,LAST_LOCATION,STATUS) values (258,86,5,'A');
Insert into TITLE_LOC_LINKING (TITLE_COPY_ID,TITLE_ID,LAST_LOCATION,STATUS) values (259,87,3,'A');
Insert into TITLE_LOC_LINKING (TITLE_COPY_ID,TITLE_ID,LAST_LOCATION,STATUS) values (260,87,5,'A');
Insert into TITLE_LOC_LINKING (TITLE_COPY_ID,TITLE_ID,LAST_LOCATION,STATUS) values (261,87,4,'A');
Insert into TITLE_LOC_LINKING (TITLE_COPY_ID,TITLE_ID,LAST_LOCATION,STATUS) values (262,88,5,'A');
Insert into TITLE_LOC_LINKING (TITLE_COPY_ID,TITLE_ID,LAST_LOCATION,STATUS) values (263,88,1,'A');
Insert into TITLE_LOC_LINKING (TITLE_COPY_ID,TITLE_ID,LAST_LOCATION,STATUS) values (264,88,2,'A');
commit;


-- Patron holds
Insert into PATRON_TITLE_HOLDS (HOLD_ID,PATRON_ID,TITLE_ID,DATE_HELD) values (1,1,42,to_date('01-MAR-21','DD-MON-RR'));
Insert into PATRON_TITLE_HOLDS (HOLD_ID,PATRON_ID,TITLE_ID,DATE_HELD) values (2,2,45,to_date('01-MAR-21','DD-MON-RR'));
Insert into PATRON_TITLE_HOLDS (HOLD_ID,PATRON_ID,TITLE_ID,DATE_HELD) values (3,2,14,to_date('01-MAR-21','DD-MON-RR'));
Insert into PATRON_TITLE_HOLDS (HOLD_ID,PATRON_ID,TITLE_ID,DATE_HELD) values (4,2,71,to_date('02-MAR-21','DD-MON-RR'));
Insert into PATRON_TITLE_HOLDS (HOLD_ID,PATRON_ID,TITLE_ID,DATE_HELD) values (5,2,17,to_date('27-FEB-21','DD-MON-RR'));
Insert into PATRON_TITLE_HOLDS (HOLD_ID,PATRON_ID,TITLE_ID,DATE_HELD) values (6,3,49,to_date('01-MAR-21','DD-MON-RR'));
Insert into PATRON_TITLE_HOLDS (HOLD_ID,PATRON_ID,TITLE_ID,DATE_HELD) values (7,3,54,to_date('25-FEB-21','DD-MON-RR'));
Insert into PATRON_TITLE_HOLDS (HOLD_ID,PATRON_ID,TITLE_ID,DATE_HELD) values (8,3,17,to_date('03-MAR-21','DD-MON-RR'));
Insert into PATRON_TITLE_HOLDS (HOLD_ID,PATRON_ID,TITLE_ID,DATE_HELD) values (9,4,33,to_date('24-FEB-21','DD-MON-RR'));
Insert into PATRON_TITLE_HOLDS (HOLD_ID,PATRON_ID,TITLE_ID,DATE_HELD) values (10,5,25,to_date('28-FEB-21','DD-MON-RR'));
Insert into PATRON_TITLE_HOLDS (HOLD_ID,PATRON_ID,TITLE_ID,DATE_HELD) values (11,5,42,to_date('24-FEB-21','DD-MON-RR'));
Insert into PATRON_TITLE_HOLDS (HOLD_ID,PATRON_ID,TITLE_ID,DATE_HELD) values (12,5,65,to_date('25-FEB-21','DD-MON-RR'));
Insert into PATRON_TITLE_HOLDS (HOLD_ID,PATRON_ID,TITLE_ID,DATE_HELD) values (13,5,84,to_date('01-MAR-21','DD-MON-RR'));
Insert into PATRON_TITLE_HOLDS (HOLD_ID,PATRON_ID,TITLE_ID,DATE_HELD) values (14,6,84,to_date('24-FEB-21','DD-MON-RR'));
Insert into PATRON_TITLE_HOLDS (HOLD_ID,PATRON_ID,TITLE_ID,DATE_HELD) values (15,7,3,to_date('01-MAR-21','DD-MON-RR'));
Insert into PATRON_TITLE_HOLDS (HOLD_ID,PATRON_ID,TITLE_ID,DATE_HELD) values (16,8,24,to_date('26-FEB-21','DD-MON-RR'));
Insert into PATRON_TITLE_HOLDS (HOLD_ID,PATRON_ID,TITLE_ID,DATE_HELD) values (17,8,55,to_date('04-MAR-21','DD-MON-RR'));
Insert into PATRON_TITLE_HOLDS (HOLD_ID,PATRON_ID,TITLE_ID,DATE_HELD) values (18,8,21,to_date('26-FEB-21','DD-MON-RR'));
Insert into PATRON_TITLE_HOLDS (HOLD_ID,PATRON_ID,TITLE_ID,DATE_HELD) values (19,8,63,to_date('25-FEB-21','DD-MON-RR'));
Insert into PATRON_TITLE_HOLDS (HOLD_ID,PATRON_ID,TITLE_ID,DATE_HELD) values (20,8,62,to_date('28-FEB-21','DD-MON-RR'));
Insert into PATRON_TITLE_HOLDS (HOLD_ID,PATRON_ID,TITLE_ID,DATE_HELD) values (21,9,6,to_date('24-FEB-21','DD-MON-RR'));
Insert into PATRON_TITLE_HOLDS (HOLD_ID,PATRON_ID,TITLE_ID,DATE_HELD) values (22,9,77,to_date('01-MAR-21','DD-MON-RR'));
Insert into PATRON_TITLE_HOLDS (HOLD_ID,PATRON_ID,TITLE_ID,DATE_HELD) values (23,9,82,to_date('04-MAR-21','DD-MON-RR'));
Insert into PATRON_TITLE_HOLDS (HOLD_ID,PATRON_ID,TITLE_ID,DATE_HELD) values (24,9,58,to_date('01-MAR-21','DD-MON-RR'));
Insert into PATRON_TITLE_HOLDS (HOLD_ID,PATRON_ID,TITLE_ID,DATE_HELD) values (25,9,3,to_date('24-FEB-21','DD-MON-RR'));
Insert into PATRON_TITLE_HOLDS (HOLD_ID,PATRON_ID,TITLE_ID,DATE_HELD) values (26,10,1,to_date('26-FEB-21','DD-MON-RR'));
Insert into PATRON_TITLE_HOLDS (HOLD_ID,PATRON_ID,TITLE_ID,DATE_HELD) values (27,10,46,to_date('01-MAR-21','DD-MON-RR'));
Insert into PATRON_TITLE_HOLDS (HOLD_ID,PATRON_ID,TITLE_ID,DATE_HELD) values (28,10,79,to_date('27-FEB-21','DD-MON-RR'));
Insert into PATRON_TITLE_HOLDS (HOLD_ID,PATRON_ID,TITLE_ID,DATE_HELD) values (29,10,70,to_date('26-FEB-21','DD-MON-RR'));
Insert into PATRON_TITLE_HOLDS (HOLD_ID,PATRON_ID,TITLE_ID,DATE_HELD) values (30,13,19,to_date('01-MAR-21','DD-MON-RR'));
Insert into PATRON_TITLE_HOLDS (HOLD_ID,PATRON_ID,TITLE_ID,DATE_HELD) values (31,13,68,to_date('28-FEB-21','DD-MON-RR'));
Insert into PATRON_TITLE_HOLDS (HOLD_ID,PATRON_ID,TITLE_ID,DATE_HELD) values (32,13,57,to_date('01-MAR-21','DD-MON-RR'));
Insert into PATRON_TITLE_HOLDS (HOLD_ID,PATRON_ID,TITLE_ID,DATE_HELD) values (33,13,15,to_date('03-MAR-21','DD-MON-RR'));
Insert into PATRON_TITLE_HOLDS (HOLD_ID,PATRON_ID,TITLE_ID,DATE_HELD) values (34,14,56,to_date('03-MAR-21','DD-MON-RR'));
Insert into PATRON_TITLE_HOLDS (HOLD_ID,PATRON_ID,TITLE_ID,DATE_HELD) values (35,15,25,to_date('02-MAR-21','DD-MON-RR'));
Insert into PATRON_TITLE_HOLDS (HOLD_ID,PATRON_ID,TITLE_ID,DATE_HELD) values (36,15,81,to_date('01-MAR-21','DD-MON-RR'));
Insert into PATRON_TITLE_HOLDS (HOLD_ID,PATRON_ID,TITLE_ID,DATE_HELD) values (37,15,66,to_date('28-FEB-21','DD-MON-RR'));
Insert into PATRON_TITLE_HOLDS (HOLD_ID,PATRON_ID,TITLE_ID,DATE_HELD) values (38,16,22,to_date('24-FEB-21','DD-MON-RR'));
Insert into PATRON_TITLE_HOLDS (HOLD_ID,PATRON_ID,TITLE_ID,DATE_HELD) values (39,16,59,to_date('02-MAR-21','DD-MON-RR'));
Insert into PATRON_TITLE_HOLDS (HOLD_ID,PATRON_ID,TITLE_ID,DATE_HELD) values (40,16,7,to_date('02-MAR-21','DD-MON-RR'));
Insert into PATRON_TITLE_HOLDS (HOLD_ID,PATRON_ID,TITLE_ID,DATE_HELD) values (41,17,5,to_date('25-FEB-21','DD-MON-RR'));
Insert into PATRON_TITLE_HOLDS (HOLD_ID,PATRON_ID,TITLE_ID,DATE_HELD) values (42,17,74,to_date('25-FEB-21','DD-MON-RR'));
Insert into PATRON_TITLE_HOLDS (HOLD_ID,PATRON_ID,TITLE_ID,DATE_HELD) values (43,18,28,to_date('24-FEB-21','DD-MON-RR'));
Insert into PATRON_TITLE_HOLDS (HOLD_ID,PATRON_ID,TITLE_ID,DATE_HELD) values (44,19,40,to_date('01-MAR-21','DD-MON-RR'));
Insert into PATRON_TITLE_HOLDS (HOLD_ID,PATRON_ID,TITLE_ID,DATE_HELD) values (45,19,47,to_date('02-MAR-21','DD-MON-RR'));
Insert into PATRON_TITLE_HOLDS (HOLD_ID,PATRON_ID,TITLE_ID,DATE_HELD) values (46,19,60,to_date('04-MAR-21','DD-MON-RR'));
Insert into PATRON_TITLE_HOLDS (HOLD_ID,PATRON_ID,TITLE_ID,DATE_HELD) values (47,19,6,to_date('24-FEB-21','DD-MON-RR'));
Insert into PATRON_TITLE_HOLDS (HOLD_ID,PATRON_ID,TITLE_ID,DATE_HELD) values (48,19,33,to_date('04-MAR-21','DD-MON-RR'));
Insert into PATRON_TITLE_HOLDS (HOLD_ID,PATRON_ID,TITLE_ID,DATE_HELD) values (49,20,49,to_date('27-FEB-21','DD-MON-RR'));
Insert into PATRON_TITLE_HOLDS (HOLD_ID,PATRON_ID,TITLE_ID,DATE_HELD) values (50,20,80,to_date('01-MAR-21','DD-MON-RR'));
Insert into PATRON_TITLE_HOLDS (HOLD_ID,PATRON_ID,TITLE_ID,DATE_HELD) values (51,20,70,to_date('03-MAR-21','DD-MON-RR'));
Insert into PATRON_TITLE_HOLDS (HOLD_ID,PATRON_ID,TITLE_ID,DATE_HELD) values (52,21,51,to_date('01-MAR-21','DD-MON-RR'));
Insert into PATRON_TITLE_HOLDS (HOLD_ID,PATRON_ID,TITLE_ID,DATE_HELD) values (53,21,67,to_date('26-FEB-21','DD-MON-RR'));
Insert into PATRON_TITLE_HOLDS (HOLD_ID,PATRON_ID,TITLE_ID,DATE_HELD) values (54,24,40,to_date('01-MAR-21','DD-MON-RR'));
Insert into PATRON_TITLE_HOLDS (HOLD_ID,PATRON_ID,TITLE_ID,DATE_HELD) values (55,24,59,to_date('04-MAR-21','DD-MON-RR'));
Insert into PATRON_TITLE_HOLDS (HOLD_ID,PATRON_ID,TITLE_ID,DATE_HELD) values (56,25,39,to_date('26-FEB-21','DD-MON-RR'));
Insert into PATRON_TITLE_HOLDS (HOLD_ID,PATRON_ID,TITLE_ID,DATE_HELD) values (57,25,29,to_date('01-MAR-21','DD-MON-RR'));
Insert into PATRON_TITLE_HOLDS (HOLD_ID,PATRON_ID,TITLE_ID,DATE_HELD) values (58,25,41,to_date('24-FEB-21','DD-MON-RR'));
Insert into PATRON_TITLE_HOLDS (HOLD_ID,PATRON_ID,TITLE_ID,DATE_HELD) values (59,26,27,to_date('03-MAR-21','DD-MON-RR'));
Insert into PATRON_TITLE_HOLDS (HOLD_ID,PATRON_ID,TITLE_ID,DATE_HELD) values (60,26,75,to_date('27-FEB-21','DD-MON-RR'));
Insert into PATRON_TITLE_HOLDS (HOLD_ID,PATRON_ID,TITLE_ID,DATE_HELD) values (61,28,85,to_date('04-MAR-21','DD-MON-RR'));
Insert into PATRON_TITLE_HOLDS (HOLD_ID,PATRON_ID,TITLE_ID,DATE_HELD) values (62,28,54,to_date('04-MAR-21','DD-MON-RR'));
Insert into PATRON_TITLE_HOLDS (HOLD_ID,PATRON_ID,TITLE_ID,DATE_HELD) values (63,28,61,to_date('01-MAR-21','DD-MON-RR'));
Insert into PATRON_TITLE_HOLDS (HOLD_ID,PATRON_ID,TITLE_ID,DATE_HELD) values (64,28,43,to_date('02-MAR-21','DD-MON-RR'));
Insert into PATRON_TITLE_HOLDS (HOLD_ID,PATRON_ID,TITLE_ID,DATE_HELD) values (65,29,54,to_date('24-FEB-21','DD-MON-RR'));
Insert into PATRON_TITLE_HOLDS (HOLD_ID,PATRON_ID,TITLE_ID,DATE_HELD) values (66,29,11,to_date('03-MAR-21','DD-MON-RR'));
Insert into PATRON_TITLE_HOLDS (HOLD_ID,PATRON_ID,TITLE_ID,DATE_HELD) values (67,29,66,to_date('25-FEB-21','DD-MON-RR'));
Insert into PATRON_TITLE_HOLDS (HOLD_ID,PATRON_ID,TITLE_ID,DATE_HELD) values (68,29,73,to_date('03-MAR-21','DD-MON-RR'));
Insert into PATRON_TITLE_HOLDS (HOLD_ID,PATRON_ID,TITLE_ID,DATE_HELD) values (69,29,88,to_date('04-MAR-21','DD-MON-RR'));
Insert into PATRON_TITLE_HOLDS (HOLD_ID,PATRON_ID,TITLE_ID,DATE_HELD) values (70,30,44,to_date('04-MAR-21','DD-MON-RR'));
Insert into PATRON_TITLE_HOLDS (HOLD_ID,PATRON_ID,TITLE_ID,DATE_HELD) values (71,30,75,to_date('28-FEB-21','DD-MON-RR'));
Insert into PATRON_TITLE_HOLDS (HOLD_ID,PATRON_ID,TITLE_ID,DATE_HELD) values (72,30,28,to_date('27-FEB-21','DD-MON-RR'));
commit;


-- checkouts  
Insert into CHECKOUTS (PATRON_ID,TITLE_COPY_ID,DATE_OUT,DUE_BACK_DATE,DATE_IN,TIMES_RENEWED,LATE_FLAG) values (1,3,to_date('30-JAN-21','DD-MON-RR'),to_date('13-MAR-21','DD-MON-RR'),to_date('26-FEB-21','DD-MON-RR'),1,'N');
Insert into CHECKOUTS (PATRON_ID,TITLE_COPY_ID,DATE_OUT,DUE_BACK_DATE,DATE_IN,TIMES_RENEWED,LATE_FLAG) values (2,6,to_date('09-FEB-21','DD-MON-RR'),to_date('02-MAR-21','DD-MON-RR'),null,0,'N');
Insert into CHECKOUTS (PATRON_ID,TITLE_COPY_ID,DATE_OUT,DUE_BACK_DATE,DATE_IN,TIMES_RENEWED,LATE_FLAG) values (3,12,to_date('03-DEC-20','DD-MON-RR'),to_date('04-FEB-21','DD-MON-RR'),to_date('05-FEB-21','DD-MON-RR'),2,'Y');
Insert into CHECKOUTS (PATRON_ID,TITLE_COPY_ID,DATE_OUT,DUE_BACK_DATE,DATE_IN,TIMES_RENEWED,LATE_FLAG) values (4,237,to_date('01-FEB-21','DD-MON-RR'),to_date('15-MAR-21','DD-MON-RR'),null,1,'N');
Insert into CHECKOUTS (PATRON_ID,TITLE_COPY_ID,DATE_OUT,DUE_BACK_DATE,DATE_IN,TIMES_RENEWED,LATE_FLAG) values (5,207,to_date('04-JAN-21','DD-MON-RR'),to_date('08-MAR-21','DD-MON-RR'),to_date('26-FEB-21','DD-MON-RR'),2,'N');
Insert into CHECKOUTS (PATRON_ID,TITLE_COPY_ID,DATE_OUT,DUE_BACK_DATE,DATE_IN,TIMES_RENEWED,LATE_FLAG) values (6,115,to_date('10-DEC-20','DD-MON-RR'),to_date('11-FEB-21','DD-MON-RR'),null,2,'Y');
Insert into CHECKOUTS (PATRON_ID,TITLE_COPY_ID,DATE_OUT,DUE_BACK_DATE,DATE_IN,TIMES_RENEWED,LATE_FLAG) values (6,142,to_date('21-FEB-21','DD-MON-RR'),to_date('14-MAR-21','DD-MON-RR'),null,0,'N');
Insert into CHECKOUTS (PATRON_ID,TITLE_COPY_ID,DATE_OUT,DUE_BACK_DATE,DATE_IN,TIMES_RENEWED,LATE_FLAG) values (6,8,to_date('18-FEB-21','DD-MON-RR'),to_date('11-MAR-21','DD-MON-RR'),null,0,'N');
Insert into CHECKOUTS (PATRON_ID,TITLE_COPY_ID,DATE_OUT,DUE_BACK_DATE,DATE_IN,TIMES_RENEWED,LATE_FLAG) values (8,216,to_date('24-FEB-21','DD-MON-RR'),to_date('17-MAR-21','DD-MON-RR'),null,0,'N');
Insert into CHECKOUTS (PATRON_ID,TITLE_COPY_ID,DATE_OUT,DUE_BACK_DATE,DATE_IN,TIMES_RENEWED,LATE_FLAG) values (9,56,to_date('06-FEB-21','DD-MON-RR'),to_date('27-FEB-21','DD-MON-RR'),null,0,'N');
Insert into CHECKOUTS (PATRON_ID,TITLE_COPY_ID,DATE_OUT,DUE_BACK_DATE,DATE_IN,TIMES_RENEWED,LATE_FLAG) values (10,246,to_date('22-FEB-21','DD-MON-RR'),to_date('15-MAR-21','DD-MON-RR'),null,0,'N');
Insert into CHECKOUTS (PATRON_ID,TITLE_COPY_ID,DATE_OUT,DUE_BACK_DATE,DATE_IN,TIMES_RENEWED,LATE_FLAG) values (10,243,to_date('20-JAN-21','DD-MON-RR'),to_date('03-MAR-21','DD-MON-RR'),null,1,'N');
Insert into CHECKOUTS (PATRON_ID,TITLE_COPY_ID,DATE_OUT,DUE_BACK_DATE,DATE_IN,TIMES_RENEWED,LATE_FLAG) values (12,178,to_date('14-JAN-21','DD-MON-RR'),to_date('18-MAR-21','DD-MON-RR'),null,2,'N');
Insert into CHECKOUTS (PATRON_ID,TITLE_COPY_ID,DATE_OUT,DUE_BACK_DATE,DATE_IN,TIMES_RENEWED,LATE_FLAG) values (13,165,to_date('02-JAN-21','DD-MON-RR'),to_date('06-MAR-21','DD-MON-RR'),null,2,'N');
Insert into CHECKOUTS (PATRON_ID,TITLE_COPY_ID,DATE_OUT,DUE_BACK_DATE,DATE_IN,TIMES_RENEWED,LATE_FLAG) values (14,155,to_date('10-DEC-20','DD-MON-RR'),to_date('11-FEB-21','DD-MON-RR'),to_date('12-FEB-21','DD-MON-RR'),2,'Y');
Insert into CHECKOUTS (PATRON_ID,TITLE_COPY_ID,DATE_OUT,DUE_BACK_DATE,DATE_IN,TIMES_RENEWED,LATE_FLAG) values (15,153,to_date('31-DEC-20','DD-MON-RR'),to_date('11-FEB-21','DD-MON-RR'),null,1,'Y');
Insert into CHECKOUTS (PATRON_ID,TITLE_COPY_ID,DATE_OUT,DUE_BACK_DATE,DATE_IN,TIMES_RENEWED,LATE_FLAG) values (15,7,to_date('16-JAN-21','DD-MON-RR'),to_date('27-FEB-21','DD-MON-RR'),to_date('24-FEB-21','DD-MON-RR'),1,'N');
Insert into CHECKOUTS (PATRON_ID,TITLE_COPY_ID,DATE_OUT,DUE_BACK_DATE,DATE_IN,TIMES_RENEWED,LATE_FLAG) values (15,76,to_date('14-FEB-21','DD-MON-RR'),to_date('07-MAR-21','DD-MON-RR'),null,0,'N');
Insert into CHECKOUTS (PATRON_ID,TITLE_COPY_ID,DATE_OUT,DUE_BACK_DATE,DATE_IN,TIMES_RENEWED,LATE_FLAG) values (17,249,to_date('30-DEC-20','DD-MON-RR'),to_date('03-MAR-21','DD-MON-RR'),null,2,'N');
Insert into CHECKOUTS (PATRON_ID,TITLE_COPY_ID,DATE_OUT,DUE_BACK_DATE,DATE_IN,TIMES_RENEWED,LATE_FLAG) values (18,161,to_date('07-JAN-21','DD-MON-RR'),to_date('11-MAR-21','DD-MON-RR'),null,2,'N');
Insert into CHECKOUTS (PATRON_ID,TITLE_COPY_ID,DATE_OUT,DUE_BACK_DATE,DATE_IN,TIMES_RENEWED,LATE_FLAG) values (19,26,to_date('31-JAN-21','DD-MON-RR'),to_date('14-MAR-21','DD-MON-RR'),null,1,'N');
Insert into CHECKOUTS (PATRON_ID,TITLE_COPY_ID,DATE_OUT,DUE_BACK_DATE,DATE_IN,TIMES_RENEWED,LATE_FLAG) values (20,34,to_date('01-JAN-21','DD-MON-RR'),to_date('05-MAR-21','DD-MON-RR'),null,2,'N');
Insert into CHECKOUTS (PATRON_ID,TITLE_COPY_ID,DATE_OUT,DUE_BACK_DATE,DATE_IN,TIMES_RENEWED,LATE_FLAG) values (21,74,to_date('04-JAN-21','DD-MON-RR'),to_date('15-FEB-21','DD-MON-RR'),to_date('16-FEB-21','DD-MON-RR'),1,'Y');
Insert into CHECKOUTS (PATRON_ID,TITLE_COPY_ID,DATE_OUT,DUE_BACK_DATE,DATE_IN,TIMES_RENEWED,LATE_FLAG) values (21,101,to_date('14-JAN-21','DD-MON-RR'),to_date('18-MAR-21','DD-MON-RR'),null,2,'N');
Insert into CHECKOUTS (PATRON_ID,TITLE_COPY_ID,DATE_OUT,DUE_BACK_DATE,DATE_IN,TIMES_RENEWED,LATE_FLAG) values (23,122,to_date('07-FEB-21','DD-MON-RR'),to_date('28-FEB-21','DD-MON-RR'),to_date('23-FEB-21','DD-MON-RR'),0,'N');
Insert into CHECKOUTS (PATRON_ID,TITLE_COPY_ID,DATE_OUT,DUE_BACK_DATE,DATE_IN,TIMES_RENEWED,LATE_FLAG) values (24,212,to_date('01-FEB-21','DD-MON-RR'),to_date('15-MAR-21','DD-MON-RR'),null,1,'N');
Insert into CHECKOUTS (PATRON_ID,TITLE_COPY_ID,DATE_OUT,DUE_BACK_DATE,DATE_IN,TIMES_RENEWED,LATE_FLAG) values (25,224,to_date('09-JAN-21','DD-MON-RR'),to_date('13-MAR-21','DD-MON-RR'),null,2,'N');
Insert into CHECKOUTS (PATRON_ID,TITLE_COPY_ID,DATE_OUT,DUE_BACK_DATE,DATE_IN,TIMES_RENEWED,LATE_FLAG) values (26,172,to_date('27-DEC-20','DD-MON-RR'),to_date('28-FEB-21','DD-MON-RR'),null,2,'N');
Insert into CHECKOUTS (PATRON_ID,TITLE_COPY_ID,DATE_OUT,DUE_BACK_DATE,DATE_IN,TIMES_RENEWED,LATE_FLAG) values (27,150,to_date('24-JAN-21','DD-MON-RR'),to_date('07-MAR-21','DD-MON-RR'),null,1,'N');
Insert into CHECKOUTS (PATRON_ID,TITLE_COPY_ID,DATE_OUT,DUE_BACK_DATE,DATE_IN,TIMES_RENEWED,LATE_FLAG) values (28,87,to_date('03-JAN-21','DD-MON-RR'),to_date('07-MAR-21','DD-MON-RR'),null,2,'N');
Insert into CHECKOUTS (PATRON_ID,TITLE_COPY_ID,DATE_OUT,DUE_BACK_DATE,DATE_IN,TIMES_RENEWED,LATE_FLAG) values (28,207,to_date('08-JAN-21','DD-MON-RR'),to_date('19-FEB-21','DD-MON-RR'),null,1,'Y');
Insert into CHECKOUTS (PATRON_ID,TITLE_COPY_ID,DATE_OUT,DUE_BACK_DATE,DATE_IN,TIMES_RENEWED,LATE_FLAG) values (30,190,to_date('20-DEC-20','DD-MON-RR'),to_date('21-FEB-21','DD-MON-RR'),to_date('22-FEB-21','DD-MON-RR'),2,'Y');
commit;

----------------------------------------------------
-- CREATE INDEXES
----------------------------------------------------

-- Foreign Keys
CREATE INDEX patron_phone_patron_id_ix 
    ON patron_phone (patron_id);
    
CREATE INDEX Patron_Title_Holds_P_FKs_ix 
    on Patron_Title_Holds (Patron_ID);

CREATE INDEX Patron_Title_Holds_T_FKs_ix 
    on Patron_Title_Holds (Title_ID);

CREATE INDEX Checkouts_P_FKs_ix 
    on Checkouts (Patron_ID);

CREATE INDEX Checkouts_T_FKs_ix 
    on Checkouts (Title_Copy_ID);
    
CREATE INDEX title_loc_linking_title_id_ix 
    ON title_loc_linking (title_id);

CREATE INDEX title_loc_linking_last_location_ix 
    ON title_loc_linking (last_location);

CREATE INDEX Title_Author_Linking_A_FKs_ix 
    on Title_Author_Linking (Author_ID);

CREATE INDEX Title_Author_Linking_T_FKs_ix 
    on Title_Author_Linking (Title_ID);

CREATE INDEX Patron_FK_ix 
    on Patron (Primary_Branch);


--other indexes
CREATE INDEX patron_last_name_ix 
    ON patron (last_name);

CREATE INDEX author_last_name_ix 
    ON author (last_name);
