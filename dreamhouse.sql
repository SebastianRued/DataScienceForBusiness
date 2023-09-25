/* We create the the Schema */
DROP SCHEMA IF EXISTS dreamhouse CASCADE;
CREATE SCHEMA dreamhouse;
SET SCHEMA 'dreamhouse';

/* We create all of the domains */
CREATE DOMAIN branchnumber AS CHAR(4)
    CHECK (value BETWEEN 'B001' AND 'B999');
CREATE DOMAIN streetname AS VARCHAR(15);
CREATE DOMAIN city AS VARCHAR(15);
CREATE DOMAIN postcode AS VARCHAR(8);

CREATE DOMAIN staffnumber AS VARCHAR(5);
CREATE DOMAIN staffname AS VARCHAR(25);
CREATE DOMAIN position_ AS VARCHAR(15);
CREATE DOMAIN gender AS CHAR(1)
    CHECK (value IN ('M', 'F'));
CREATE DOMAIN dateofbirth AS DATE
    CHECK (value > TO_DATE('01-Jan-1920', 'dd-Mon-yyyy'));
CREATE DOMAIN salary DECIMAL(9, 2)
    CHECK (value BETWEEN 6000.00 AND 140000.00);

/* We create our tables */
CREATE TABLE IF NOT EXISTS branch
(
    branchno branchnumber NOT NULL PRIMARY KEY,
    street   streetname   NOT NULL,
    city     city         NOT NULL,
    postcode postcode     NOT NULL
)
;

CREATE TABLE IF NOT EXISTS staff
(
    staffno   staffnumber  NOT NULL PRIMARY KEY,
    fname     staffname    NOT NULL,
    lname     staffname    NOT NULL,
    position_ position_,
    sex       gender       NOT NULL,
    dob       dateofbirth,
    salary    salary,
    branchno  branchnumber NOT NULL REFERENCES branch (branchno)
)
;

/* We now populate the tables */
INSERT INTO branch
VALUES ('B005', '22 Deer Rd', 'London', 'SW1 4EH')
     , ('B007', '16 Argyll St', 'Aberdeen', 'AB2 3SU')
     , ('B003', '163 Main St', 'Glasgow', 'G11 9QX')
     , ('B004', '32 Manse Rd', 'Bristol', 'BS99 1NZ')
     , ('B002', '56 Clover Dr', 'London', 'NW10 6EU')
;

INSERT INTO staff
VALUES ('SL21', 'John', 'White', 'Manager', 'M', '01-Oct-1945', 130000, 'B005')
     , ('SG37', 'Ann', 'Beech', 'Assistant', 'F', '10-Nov-1960', 21000, 'B003')
     , ('SG14', 'David', 'Ford', 'Supervisor', 'M', '24-Mar-1960', 120000, 'B003')
     , ('SA9', 'Mary', 'Howe', 'Assistant', 'F', '19-Feb-1970', 20000, 'B007')
     , ('SG5', 'Susan', 'Brand', 'Manager', 'F', '03-Jun-1940', 90000, 'B003')
     , ('SL41', 'Julie', 'Lee', 'Assistant', 'F', '13-Jun-1965', 18000, 'B005')
;

/* The following tables are created as they will be used in the examples below */
CREATE TABLE IF NOT EXISTS privateowner
(
    ownerno   VARCHAR(4) NOT NULL PRIMARY KEY,
    fname     VARCHAR(25),
    lname     VARCHAR(25),
    address   VARCHAR(50),
    telno     VARCHAR(15),
    email     VARCHAR(120) CHECK (email LIKE '%@%'),
    password_ VARCHAR(20)
)
;

INSERT INTO privateowner
VALUES ('CO46', 'Joe', 'Keogh', '2 Fergus Dr Banchory, Aberdeen AB2 7SX', '01224-861212', 'jkeogh@lhh.com', '********')
     , ('CO87', 'Carol', 'Farrel', '6 Achray St, Glasgow G32 9DX', '0141-357-7419', 'cfarrel@gmail', '********')
     , ('CO40', 'Tina', 'Murphy', '63 Well St, Glasgow G42', '0141-943-1728', 'tinam@hotmail.com', '********')
     , ('CO93', 'Tony', 'Shaw', '12 Park Pl, Glasgow G4 0QR', '0141-225-7025', 'tony.shaw@ark.com', '********')
;

CREATE TABLE viewing
(
    clientno   VARCHAR(7) NOT NULL,
    propertyno VARCHAR(8) NOT NULL,
    viewdate   DATE       NOT NULL CHECK (viewdate > TO_DATE('01-Jan-2001', 'dd-Mon-yyyy')),
    comments_  VARCHAR(50),
    CONSTRAINT viewing_pk
        PRIMARY KEY (propertyno, clientno)
)
;

INSERT INTO viewing
VALUES ('CR56', 'PA14', '24-May-2008', 'too small')
     , ('CR76', 'PG4', '20-Apr-2008', 'too --ote')
     , ('CR56', 'PG4', '26-May-2008', NULL)
     , ('CR62', 'PA14', '14-May-2008', 'no dining room')
     , ('CR56', 'PG36', '28-May-2008', NULL)
;

CREATE TABLE propertyforrent
(
    propertyno   VARCHAR(8)    NOT NULL,
    street       VARCHAR(25)   NOT NULL,
    city         VARCHAR(15)   NOT NULL,
    postcode     VARCHAR(8)    NOT NULL,
    propertytype VARCHAR(10)   NOT NULL,
    rooms        SMALLINT      NOT NULL,
    rent         DECIMAL(5, 1) NOT NULL,
    ownerno      VARCHAR(7)    NOT NULL,
    staffno      staffnumber,
    branchno     branchnumber  NOT NULL,
    CONSTRAINT propertyforrent_pk
        PRIMARY KEY (propertyno),
    CONSTRAINT property_owner_fk
        FOREIGN KEY (ownerno)
            REFERENCES privateowner (ownerno),
    CONSTRAINT property_staff_fk
        FOREIGN KEY (staffno)
            REFERENCES staff (staffno),
    CONSTRAINT property_branch_fk
        FOREIGN KEY (branchno)
            REFERENCES branch (branchno)
);

INSERT INTO propertyforrent
VALUES ('PA14', '16 Holhead', 'Aberdeen', 'AB7 5SU', 'House', 6, 650, 'CO46', 'SA9', 'B007');
INSERT INTO propertyforrent
VALUES ('PL94', '6 Argyll St', 'London', 'NW2', 'Flat', 4, 400, 'CO87', 'SL41', 'B005');
INSERT INTO propertyforrent
VALUES ('PG4', '6 Lawrence St', 'Glasgow', 'G11 9QX', 'Flat', 3, 350, 'CO40', NULL, 'B003');
INSERT INTO propertyforrent
VALUES ('PG36', '2 Manor Rd', 'Glasgow', 'G32 4QX', 'Flat', 3, 375, 'CO93', 'SG37', 'B003');
INSERT INTO propertyforrent
VALUES ('PG21', '18 Dale Rd', 'Glasgow', 'G12', 'House', 5, 600, 'CO87', 'SG37', 'B003');
INSERT INTO propertyforrent
VALUES ('PG16', '5 Novar Dr', 'Glasgow', 'G12 9AX', 'Flat', 4, 450, 'CO93', 'SG14', 'B003');

CREATE TABLE client
(
    clientno VARCHAR(7)    NOT NULL,
    fname    VARCHAR(15)   NOT NULL,
    lname    VARCHAR(15)   NOT NULL,
    telno    VARCHAR(13)   NOT NULL,
    preftype VARCHAR(10)   NOT NULL,
    maxrent  DECIMAL(5, 1) NOT NULL,
    CONSTRAINT client_pk
        PRIMARY KEY (clientno)
);

INSERT INTO client
VALUES ('CR76', 'John', 'Kay', '0207-774-5632', 'Flat', 425);
INSERT INTO client
VALUES ('CR56', 'Aline', 'Stewart', '0141-848-1825', 'Flat', 350);
INSERT INTO client
VALUES ('CR74', 'Mike', 'Ritchie', '01475-392178', 'House', 750);
INSERT INTO client
VALUES ('CR62', 'Mary', 'Tregar', '01224-196720', 'Flat', 600);

/*				Writing SQL Commands
Use extended form of BNF notation:
	UPPER-CASE letters represent reserved words.
	lower-case letters represent user-defined words.
	| indicates a choice among alternatives.
	{Curly braces} indicate a required element.
	[Square brackets] indicate an optional element.
	… indicates optional repetition (0 or more).

				Literals
Literals are constants used in SQL statements.
All non-numeric literals must be enclosed in single quotes (e.g. ‘London’).
All numeric literals must not be enclosed in quotes (e.g. 650.00).

				SELECT Statement
SELECT [DISTINCT | ALL]
	{* | [columnExpression [AS newName]] [,...] }	-- Specifies which columns are to appear in output.
FROM		TableName [alias] [, ...]				-- Specifies table(s) to be used.
[WHERE	condition]									-- Filter rows
[GROUP BY	columnList]  [HAVING	condition]		-- Forms groups of rows with same column value.
													-- HAVING: Filters groups subject to some condition.
[ORDER BY	columnList]								-- Specifies the order of the output.
*/

/* List full details of all staff.*/



/* Can use * as an abbreviation for ‘all columns’:*/


/* Produce a list of salaries for all staff, showing only  staff number, first and last names, and salary.*/


/* List the property numbers of all properties that have been viewed.*/



/* Use DISTINCT to eliminate duplicates.*/


/* Produce list of monthly salaries for all staff, showing staff number, first/last name, and  salary.*/



/* 					Comparison Search Condition
List all staff with a salary greater than 100,000. */



/*					Compound Comparison Search Condition
List addresses of all branch offices in London or Glasgow. */



/*					Range Search Condition
List all staff with a salary between 20,000 and 30,000. */



/* NOTE: BETWEEN test includes the endpoints of range.
Also a negated version NOT BETWEEN. Both d0 not add anything new, since could be implemented with where + >=/<=

					Set Membership
List all managers and supervisors. */



/* There is a negated version (NOT IN).
IN does not add much to SQL’s expressive power. Could have expressed this as:*/


/* IN is more efficient when set contains many values.

					Pattern Matching
Find all owners with the string ‘Glasgow’ in their address. */


/*
SQL has two special pattern matching symbols:
	%: sequence of zero or more characters;
	_ (underscore): any single character.
LIKE '%Glasgow%' means a sequence of characters of any length containing 'Glasgow'.

					NULL Search Condition
List details of all viewings on property PG4 where a comment has not been supplied.*/


/*				Single Column Ordering
List salaries for all staff, arranged in descending order of salary.*/



/*					Multiple Column Ordering
Produce abbreviated list of properties in order of property type.*/


/* To arrange in order of rent, specify minor order:*/


--------------------------------------------------------------------

/* 					SELECT Statement - Aggregates
Aggregate functions can be used only in SELECT list and in HAVING clause (see below).

How many properties cost more than £350 per month to rent?*/



/* How many different properties viewed in May 2008?*/



/* Find number of Managers and sum of their salaries.*/


/* Find minimum, maximum, and average staff salary. */


----------------------------------------------------------

/*					SELECT Statement - Grouping

Use GROUP BY clause to get sub-totals.
SELECT and GROUP BY closely integrated:
each item in SELECT list must be single-valued per group,
and SELECT clause may only contain:
	- column names
	- aggregate functions
	- constants
	- expression involving combinations of the above.
All column names in SELECT list must appear in GROUP BY clause
unless name is used only in an aggregate function.
If WHERE is used with GROUP BY, WHERE is applied first,
then groups are formed from remaining rows satisfying predicate.

Find number of staff in each branch and their total salaries sorted by descending total salaries.*/



/*				Restricted Groupings – HAVING clause
HAVING clause is designed for use with GROUP BY to restrict groups that appear in final result table.
Similar to WHERE, but WHERE filters individual rows whereas HAVING filters groups.
Column names in HAVING clause must also appear in the GROUP BY list or be contained within an aggregate function.

For each branch with more than 1 member of staff, find number of staff in each branch and sum of their salaries.*/



/*
Some SQL statements can have a SELECT embedded within them.
A subselect can be used in WHERE and HAVING clauses of an outer SELECT,
where it is called a subquery or nested query.
Subselects may also appear in INSERT, UPDATE, and DELETE statements.

List staff who work in branch at ‘163 Main St’.*/


/* List all staff whose salary is greater than the average salary, and show by how much.*/


/* Find staff whose salary is larger than salary of at least one member of staff at branch B003.*/


/* Find staff whose salary is larger than salary of every member of staff at branch B003.*/


/*					Query using EXISTS (Only subqueries)
Find all staff who work in a London branch.*/


/*					Update
Give all staff a 3% pay increase.*/

/*
Give all Managers a 5% pay increase.*/


/*
Promote David Ford (staffNo='SG14') to Manager and change his salary to £18,000.*/


--DELETE FROM Staff;

/*
INSERT INTO Staff VALUES
('SL21', 'John', 'White','Manager',   'F', '1945-10-01', 30000, 'B005'),
('SG37', 'Ann',  'Beech','Assistant', 'F', '1960-11-10', 12000, 'B003'),
('SG14', 'David','Ford', 'Supervisor','M', '1960-03-24', 18000, 'B003'),
('SA9',  'Mary', 'Howe', 'Assistant', 'F', '1970-02-19', 9000, 'B007'),
('SG5',  'Susan','Brand','Manager',   'F', '1940-06-03', 24000, 'B003'),
('SL41', 'Julie','Lee',  'Assistant', 'F', '1965-06-13', 9000, 'B005');
*/