--NOTE: Primary and Foreign keys are described with the table name followed by an abbreviation for the key (Primary Key = PK, Foreign Key = FK)
DROP TABLE IF EXISTS customer_t CASCADE;
DROP TABLE IF EXISTS automobile_t CASCADE;
DROP TABLE IF EXISTS employee_t CASCADE;
DROP TABLE IF EXISTS technician_t CASCADE;
DROP TABLE IF EXISTS manager_t CASCADE;
DROP TABLE IF EXISTS repairestimate_t CASCADE;
DROP TABLE IF EXISTS repair_t CASCADE;
DROP TABLE IF EXISTS laborestimate_t CASCADE;
DROP TABLE IF EXISTS equipment_t CASCADE;
DROP TABLE IF EXISTS equipmentestimate_t CASCADE;
DROP TABLE IF EXISTS skill_t CASCADE;
DROP TABLE IF EXISTS possess_t CASCADE;
DROP TABLE IF EXISTS supervise_t CASCADE;
DROP TABLE IF EXISTS equipmentutilized_t CASCADE;
DROP TABLE IF EXISTS part_t CASCADE;
DROP TABLE IF EXISTS partquantity_t CASCADE;
DROP TABLE IF EXISTS partconsumption_t CASCADE;
DROP TABLE IF EXISTS laborutilized_t CASCADE;


--create table customer
CREATE TABLE customer_t(
	customerid						BIGINT		NOT NULL,
	customername					varchar,
	customerphonenumber				BIGINT,
	customeraddress					varchar,
CONSTRAINT customer_PK PRIMARY KEY (customerid));

--create table automobile
CREATE TABLE automobile_t(
	automobilevin					varchar		NOT NULL,
	automobileyear					INT,
	automobilemake					varchar,
	automobilemodel					varchar,
	customerid						BIGINT,
CONSTRAINT automobile_PK PRIMARY KEY (automobilevin),
CONSTRAINT automobile_FK FOREIGN KEY (customerid) REFERENCES customer_t(customerid));

--create employee table
CREATE TABLE employee_t(
	employeeid						BIGINT		NOT NULL,
	employeename					varchar,
	employeephonenumber				BIGINT,
	employeedateofhire				date,
	employeetype					varchar,
CONSTRAINT employee_PK PRIMARY KEY (employeeid));

--create technician table subtype
CREATE TABLE technician_t(
	temployeeid						BIGINT		NOT NULL,
CONSTRAINT technician_PK PRIMARY KEY (temployeeid));

--create manager table subtype
CREATE TABLE manager_t(
	memployeeid						BIGINT		NOT NULL,
CONSTRAINT manager_PK PRIMARY KEY (memployeeid));

--create repair estimate table
CREATE TABLE repairestimate_t(
	repairestimateid				BIGINT		NOT NULL,
	repairestimatedescription		varchar,
	repairestimateamount			numeric,
	repairestimatecompletiondate	date,
	requestingcustomerid			BIGINT,
	automobilevin					varchar,
	memployeeid						BIGINT,
	approvingcustomerid				BIGINT,
CONSTRAINT repairestimate_PK PRIMARY KEY (repairestimateid),
CONSTRAINT repairestimate_FK1 FOREIGN KEY (requestingcustomerid) REFERENCES customer_t(customerid),
CONSTRAINT repairestimate_FK2 FOREIGN KEY (automobilevin) REFERENCES automobile_t(automobilevin),
CONSTRAINT repairestimate_FK3 FOREIGN KEY (memployeeid) REFERENCES manager_t(memployeeid),
CONSTRAINT repairestimate_FK4 FOREIGN KEY (approvingcustomerid) REFERENCES customer_t(customerid));

--create repair table
CREATE TABLE repair_t(
	repairid						BIGINT		NOT NULL,
	repairdescription				varchar,
	repairinitiationdate			date,
	repairdepositamount				numeric,
	repaircompletiondate			date,
	repairtotalamount				numeric,
	customerid						BIGINT,
	automobilevin					varchar,
	repairestimateid				BIGINT,
CONSTRAINT repair_PK PRIMARY KEY (repairid),
CONSTRAINT repair_FK1 FOREIGN KEY (customerid) REFERENCES customer_t(customerid),
CONSTRAINT repair_FK2 FOREIGN KEY (automobilevin) REFERENCES automobile_t(automobilevin),
CONSTRAINT repair_FK3 FOREIGN KEY (repairestimateid) REFERENCES repairestimate_t(repairestimateid));

--create labor estimate table
CREATE TABLE laborestimate_t(
	repairestimateid 				BIGINT		NOT NULL,
	skillid 						BIGINT		NOT NULL,
	skillhoursrequired				INT,			
CONSTRAINT laborestimate_PK PRIMARY KEY (repairestimateid, skillid));

--create equipment table
CREATE TABLE equipment_t(
	equipmentid						BIGINT		NOT NULL,
	equipmentdescription			varchar,
	equipmentmanufacturer			varchar,
	equipmentmodel					varchar,
CONSTRAINT equipment_PK PRIMARY KEY (equipmentid));

--create equipment estimate table
CREATE TABLE equipmentestimate_t(
	repairestimateid				BIGINT		NOT NULL,
	equipmentid						BIGINT		NOT NULL,
	equipmenthoursrequired			INT,
CONSTRAINT equipmentestimate_PK PRIMARY KEY (repairestimateid, equipmentid));

--create skill table
CREATE TABLE skill_t(
	skillid							BIGINT		NOT NULL,
	skillname						varchar,
	skilldescription				varchar,
CONSTRAINT skill_PK PRIMARY KEY (skillid));

--create possess table
CREATE TABLE possess_t(
	skillid							bigint		NOT NULL,
	temployeeid						bigint		NOT NULL,
CONSTRAINT possess_PK PRIMARY KEY (skillid, temployeeid));

--create supervise table
CREATE TABLE supervise_t(
	repairid						BIGINT		NOT NULL,
	memployeeid						BIGINT		NOT NULL,
CONSTRAINT supervise_PK PRIMARY KEY (repairid, memployeeid));

--create equipment utilized table
CREATE TABLE equipmentutilized_t(
	equipmentid						BIGINT 		NOT NULL,
	repairid						BIGINT		NOT NULL,
	equipmentcheckindateandtime		date,
	equipmentcheckoutdateandtime	date,
	temployeeid						BIGINT,
CONSTRAINT equipmentutilized_PK PRIMARY KEY (equipmentid, repairid),
CONSTRAINT equipmentutilized_FK FOREIGN KEY (temployeeid) REFERENCES technician_t(temployeeid));

--create parts table
CREATE TABLE part_t(
	partid							BIGINT		NOT NULL,
	partdescription					varchar,
	partunitcost					numeric,
	partquantityonhand				INT,
CONSTRAINT part_PK PRIMARY KEY (partid));

--create part quantity required table
CREATE TABLE partquantity_t(
	repairestimateid				BIGINT		NOT NULL,
	partid							BIGINT		NOT NULL,
	partquantityrequired			INT,		
CONSTRAINT partquantity_PK PRIMARY KEY (repairestimateid, partid));

-- creats parts consumption table
CREATE TABLE partconsumption_t(
	partid							BIGINT		NOT NULL,
	repairid						BIGINT		NOT NULL,
	partconsumptiondate				date,
	partquantityconsumed			varchar,
CONSTRAINT partconsumption_PK PRIMARY KEY (partid, repairid));

-- creats labor utilized table
CREATE TABLE laborutilized_t(
	repairid						BIGINT		NOT NULL,
	temployeeid						BIGINT		NOT NULL,
	shiftstartdateandtime			date,
	shiftenddateandtime				date,
CONSTRAINT laborutilized_PK PRIMARY KEY (repairid, temployeeid));


--insert into customer table
INSERT INTO customer_t("customerid", "customername", "customerphonenumber", "customeraddress")
VALUES(1, 'Robert Geno', 4851816177,'814 Ahwanee Ave');
INSERT INTO customer_t("customerid", "customername", "customerphonenumber", "customeraddress")
VALUES(2, 'Fred Damico', 2386059943,'4500 Stevens Creek Blvd');
INSERT INTO customer_t("customerid", "customername", "customerphonenumber", "customeraddress")
VALUES(3, 'Greg Bradberry', 1134968909,'2549 S King Rd');
INSERT INTO customer_t("customerid", "customername", "customerphonenumber", "customeraddress")
VALUES(4, 'Paul Smith', 1077881380,'43962 Fremont Blvd');
INSERT INTO customer_t("customerid", "customername", "customerphonenumber", "customeraddress")
VALUES(5, 'John Doe', 5103457631, '2201 Fillmore St');

--insert into automobile table
INSERT INTO automobile_t("automobilevin", "automobileyear", "automobilemake","automobilemodel","customerid")
VALUES('JH4DB7640SS802939', 1995, 'Acura', 'Integra', 1);
INSERT INTO automobile_t("automobilevin", "automobileyear", "automobilemake","automobilemodel","customerid")
VALUES('SCFFBEBN0C0015016', 2012, 'Aston Martin', 'Mustang', 2);
INSERT INTO automobile_t("automobilevin", "automobileyear", "automobilemake","automobilemodel","customerid")
VALUES('SCBZF19C0VCX59555', 1997, 'Bentley', 'Brooklands', 3);
INSERT INTO automobile_t("automobilevin", "automobileyear", "automobilemake","automobilemodel","customerid")
VALUES('1G6DM5EY0B0100347', 2011, 'Cadillac', 'CTS', 4);
INSERT INTO automobile_t("automobilevin", "automobileyear", "automobilemake","automobilemodel","customerid")
VALUES('ZFF73SKAXE0199252', 2014, 'Ferrari', 'FF', 5);

--insert into employee table
INSERT INTO employee_t("employeeid", "employeename", "employeephonenumber", "employeedateofhire", "employeetype")
VALUES (1, 'Sam Smith', 9876543210, '2002-01-15', 'technician');
INSERT INTO employee_t("employeeid", "employeename", "employeephonenumber", "employeedateofhire", "employeetype")
VALUES (2, 'Harrison Ford', 5551234567, '1999-10-31', 'technician');
INSERT INTO employee_t("employeeid", "employeename", "employeephonenumber", "employeedateofhire", "employeetype")
VALUES (3, 'Peter Carlson', 8885551212, '2003-02-23', 'technician');
INSERT INTO employee_t("employeeid", "employeename", "employeephonenumber", "employeedateofhire", "employeetype")
VALUES (4, 'James Trout', 3334445555, '2013-06-19', 'technician');
INSERT INTO employee_t("employeeid", "employeename", "employeephonenumber", "employeedateofhire", "employeetype")
VALUES (5, 'Chaggai Yaffe', 7778889999, '2014-05-28', 'technician');
INSERT INTO employee_t("employeeid", "employeename", "employeephonenumber", "employeedateofhire", "employeetype")
VALUES (6, 'Lucyna Willifrid', 9995451234, '2007-12-10', 'manager');
INSERT INTO employee_t("employeeid", "employeename", "employeephonenumber", "employeedateofhire", "employeetype")
VALUES (7, 'Raghnall Terrie', 1512223633, '2005-04-27', 'manager');
INSERT INTO employee_t("employeeid", "employeename", "employeephonenumber", "employeedateofhire", "employeetype")
VALUES (8, 'Graciela Ana', 9916664555, '2015-02-01', 'manager');
INSERT INTO employee_t("employeeid", "employeename", "employeephonenumber", "employeedateofhire", "employeetype")
VALUES (9, 'Vaiva Aki', 4445356666, '2019-05-05', 'manager');
INSERT INTO employee_t("employeeid", "employeename", "employeephonenumber", "employeedateofhire", "employeetype")
VALUES (10, 'Ester Luliana', 3214124812, '2011-03-27', 'manager');

--insert into technician table
INSERT INTO technician_t("temployeeid")
VALUES (1);
INSERT INTO technician_t("temployeeid")
VALUES (2);
INSERT INTO technician_t("temployeeid")
VALUES (3);
INSERT INTO technician_t("temployeeid")
VALUES (4);
INSERT INTO technician_t("temployeeid")
VALUES (5);

--insert into manager table
INSERT INTO manager_t("memployeeid")
VALUES (6);
INSERT INTO manager_t("memployeeid")
VALUES (7);
INSERT INTO manager_t("memployeeid")
VALUES (8);
INSERT INTO manager_t("memployeeid")
VALUES (9);
INSERT INTO manager_t("memployeeid")
VALUES (10);

--insert into repair estimate table
INSERT INTO repairestimate_t("repairestimateid", "repairestimatedescription", "repairestimateamount", "repairestimatecompletiondate", "requestingcustomerid", "automobilevin", "memployeeid", "approvingcustomerid")
VALUES(1,'change tires', 222.3, '2012-04-13', 1, 'JH4DB7640SS802939', 6, 1);
INSERT INTO repairestimate_t("repairestimateid", "repairestimatedescription", "repairestimateamount", "repairestimatecompletiondate", "requestingcustomerid", "automobilevin", "memployeeid", "approvingcustomerid")
VALUES(2,'change oil', 50.9, '2013-05-11', 2, 'SCFFBEBN0C0015016', 7, 2);
INSERT INTO repairestimate_t("repairestimateid", "repairestimatedescription", "repairestimateamount", "repairestimatecompletiondate", "requestingcustomerid", "automobilevin", "memployeeid", "approvingcustomerid")
VALUES(3,'change windshield wipers', 200.0, '2014-02-13', 3, 'SCBZF19C0VCX59555', 8, 3);
INSERT INTO repairestimate_t("repairestimateid", "repairestimatedescription", "repairestimateamount", "repairestimatecompletiondate", "requestingcustomerid", "automobilevin", "memployeeid", "approvingcustomerid")
VALUES(4,'change windscreen', 500.9, '2015-05-06', 4, '1G6DM5EY0B0100347', 9, 4);
INSERT INTO repairestimate_t("repairestimateid", "repairestimatedescription", "repairestimateamount", "repairestimatecompletiondate", "requestingcustomerid", "automobilevin", "memployeeid", "approvingcustomerid")
VALUES(5,'repair clutch', 900.9, '2018-02-18', 5, 'ZFF73SKAXE0199252', 10, 5);

--insert into repair table
INSERT INTO repair_t("repairid", "repairdescription", "repairinitiationdate", "repairdepositamount", "repaircompletiondate", "repairtotalamount", "customerid", "automobilevin", "repairestimateid")
VALUES (1, 'tire change', '2015-10-28', 475, '2015-11-02', 850.25, 1,'JH4DB7640SS802939', 1);
INSERT INTO repair_t("repairid", "repairdescription", "repairinitiationdate", "repairdepositamount", "repaircompletiondate", "repairtotalamount", "customerid", "automobilevin", "repairestimateid")
VALUES (2, 'refill oil', '2015-11-12', 500, '2015-11-19', 795, 2, 'SCFFBEBN0C0015016', 2);
INSERT INTO repair_t("repairid", "repairdescription", "repairinitiationdate", "repairdepositamount", "repaircompletiondate", "repairtotalamount", "customerid", "automobilevin", "repairestimateid")
VALUES (3, 'replace engine', '2016-01-26', 150, '2016-01-29', 300, 3, 'SCBZF19C0VCX59555', 3);
INSERT INTO repair_t("repairid", "repairdescription", "repairinitiationdate", "repairdepositamount", "repaircompletiondate", "repairtotalamount", "customerid", "automobilevin", "repairestimateid")
VALUES (4, 'replace car door', '2018-03-27', 375, '2018-03-29', 485, 4, '1G6DM5EY0B0100347', 4);
INSERT INTO repair_t("repairid", "repairdescription", "repairinitiationdate", "repairdepositamount", "repaircompletiondate", "repairtotalamount", "customerid", "automobilevin", "repairestimateid")
VALUES (5, 'tint windows', '2019-01-26', 550, '2016-01-31', 900.63, 5, 'ZFF73SKAXE0199252', 5);

--insert into labor estimate
INSERT INTO laborestimate_t("repairestimateid", "skillid", "skillhoursrequired")
VALUES(1, 1, 1);
INSERT INTO laborestimate_t("repairestimateid", "skillid", "skillhoursrequired")
VALUES(2, 2, 4);
INSERT INTO laborestimate_t("repairestimateid", "skillid", "skillhoursrequired")
VALUES(3, 3, 9);
INSERT INTO laborestimate_t("repairestimateid", "skillid", "skillhoursrequired")
VALUES(4, 4, 16);
INSERT INTO laborestimate_t("repairestimateid", "skillid", "skillhoursrequired")
VALUES(5, 5, 25);

--insert into equipment
INSERT INTO equipment_t("equipmentid","equipmentdescription","equipmentmanufacturer","equipmentmodel")
values(1, 'torque driver', 'dewalt' ,'t-dw-20v');
INSERT INTO equipment_t("equipmentid","equipmentdescription","equipmentmanufacturer","equipmentmodel")
values(2, 'car lift','triumph', 'E-nss-8');
INSERT INTO equipment_t("equipmentid","equipmentdescription","equipmentmanufacturer","equipmentmodel")
values(3, 'car scanner', 'thinkcar', 'd-tk-s7');
INSERT INTO equipment_t("equipmentid","equipmentdescription","equipmentmanufacturer","equipmentmodel")
values(4, 'Oil pump', 'Groz', 'e-GZ-4550');
INSERT INTO equipment_t("equipmentid","equipmentdescription","equipmentmanufacturer","equipmentmodel")
values(5, 'tpms', 'duralast', 'p-DL-4');

--insert into equipment estimate
INSERT INTO equipmentestimate_t("repairestimateid", "equipmentid", "equipmenthoursrequired")
VALUES(1, 1, 1);
INSERT INTO equipmentestimate_t("repairestimateid", "equipmentid", "equipmenthoursrequired")
VALUES(2, 2, 4);
INSERT INTO equipmentestimate_t("repairestimateid", "equipmentid", "equipmenthoursrequired")
VALUES(3, 3, 9);
INSERT INTO equipmentestimate_t("repairestimateid", "equipmentid", "equipmenthoursrequired")
VALUES(4, 4, 16); 
INSERT INTO equipmentestimate_t("repairestimateid", "equipmentid", "equipmenthoursrequired")
VALUES(5, 5, 25);

--insert into skills
INSERT INTO skill_t("skillid", "skillname", "skilldescription")
values (1,'Oil Change', 'Can change oil');
INSERT INTO skill_t("skillid", "skillname", "skilldescription")
values (2, 'Welding', 'Is certified to weld body parts');
INSERT INTO skill_t("skillid", "skillname", "skilldescription")
values (3,'Manager', 'Can manage employees');
INSERT INTO skill_t("skillid", "skillname", "skilldescription")
values (4,'Exhaust', 'Can install exhausts');
INSERT INTO skill_t("skillid", "skillname", "skilldescription")
values (5,'Programmer', 'can write code for digital aspects of business');

--insert into possess table
INSERT INTO possess_t("skillid", "temployeeid")
VALUES (1, 1);
INSERT INTO possess_t("skillid", "temployeeid")
VALUES (2, 2);
INSERT INTO possess_t("skillid", "temployeeid")
VALUES (3, 3);
INSERT INTO possess_t("skillid", "temployeeid")
VALUES (4, 4);
INSERT INTO possess_t("skillid", "temployeeid")
VALUES (5, 5);

--insert into supervise table
INSERT INTO supervise_t("repairid", "memployeeid")
VALUES (1, 6);
INSERT INTO supervise_t("repairid", "memployeeid")
VALUES (2, 7);
INSERT INTO supervise_t("repairid", "memployeeid")
VALUES (3, 8);
INSERT INTO supervise_t("repairid", "memployeeid")
VALUES (4, 9);
INSERT INTO supervise_t("repairid", "memployeeid")
VALUES (5, 10);

--insert into equipment utilized
INSERT INTO equipmentutilized_t("equipmentid", "repairid", "equipmentcheckoutdateandtime", "equipmentcheckindateandtime", "temployeeid")
VALUES(1, 1, '2023-03-11', '2023-03-12', 1);
INSERT INTO equipmentutilized_t("equipmentid", "repairid", "equipmentcheckindateandtime", "equipmentcheckoutdateandtime", "temployeeid")
VALUES(2, 2, '2023-03-12', '2023-03-13', 2);
INSERT INTO equipmentutilized_t("equipmentid", "repairid", "equipmentcheckindateandtime", "equipmentcheckoutdateandtime", "temployeeid")
VALUES(3, 3, '2023-03-13', '2023-03-14', 3);
INSERT INTO equipmentutilized_t("equipmentid", "repairid", "equipmentcheckindateandtime", "equipmentcheckoutdateandtime", "temployeeid")
VALUES(4, 4, '2023-03-14', '2023-03-15', 4);
INSERT INTO equipmentutilized_t("equipmentid", "repairid", "equipmentcheckindateandtime", "equipmentcheckoutdateandtime", "temployeeid")
VALUES(5, 5, '2023-03-15', '2023-03-16', 5);

--insert into parts
INSERT INTO part_t("partid", "partdescription", "partunitcost", "partquantityonhand")
values (1, 'Wiper Fluid', 20, 5);
INSERT INTO part_t("partid", "partdescription", "partunitcost", "partquantityonhand")
values(2, 'Motor Oil', 40, 10);
INSERT INTO part_t("partid", "partdescription", "partunitcost", "partquantityonhand")
values(3,'Lug Nut', 2.5, 100);
INSERT INTO part_t("partid", "partdescription", "partunitcost", "partquantityonhand")
values(4, 'LocTite', 10, 20);
INSERT INTO part_t("partid", "partdescription", "partunitcost", "partquantityonhand")
values(5,'Exhaust', 500, 5);

--insert into part quantity required
INSERT INTO partquantity_t("repairestimateid", "partid", "partquantityrequired")
VALUES (1, 1, 1);
INSERT INTO partquantity_t("repairestimateid", "partid", "partquantityrequired")
VALUES (2, 2, 4);
INSERT INTO partquantity_t("repairestimateid", "partid", "partquantityrequired")
VALUES (3, 3, 9);
INSERT INTO partquantity_t("repairestimateid", "partid", "partquantityrequired")
VALUES (4, 4, 16);
INSERT INTO partquantity_t("repairestimateid", "partid", "partquantityrequired")
VALUES (5, 5, 25);

--insert into part consumption
INSERT INTO partconsumption_t("partid", "repairid", "partconsumptiondate","partquantityconsumed")
VALUES(1, 1,'2023-03-12', 1);
INSERT INTO partconsumption_t("repairid", "partid","partconsumptiondate","partquantityconsumed")
VALUES(2, 2, '2023-03-13', 4);
INSERT INTO partconsumption_t("repairid", "partid","partconsumptiondate","partquantityconsumed")
VALUES(3, 3, '2023-03-14', 9);
INSERT INTO partconsumption_t("repairid", "partid","partconsumptiondate","partquantityconsumed")
VALUES(4, 4, '2023-03-15', 16);
INSERT INTO partconsumption_t("repairid", "partid","partconsumptiondate","partquantityconsumed")
VALUES(5, 5, '2023-03-16', 25);

--insert into labor utilized
INSERT INTO laborutilized_t("repairid", "temployeeid", "shiftstartdateandtime", "shiftenddateandtime")
VALUES(1, 1, '2023-03-11', '2023-03-12');
INSERT INTO laborutilized_t("repairid", "temployeeid", "shiftstartdateandtime", "shiftenddateandtime")
VALUES(2, 2, '2023-03-12', '2023-03-13');
INSERT INTO laborutilized_t("repairid", "temployeeid", "shiftstartdateandtime", "shiftenddateandtime")
VALUES(3, 3, '2023-03-13', '2023-03-14');
INSERT INTO laborutilized_t("repairid", "temployeeid", "shiftstartdateandtime", "shiftenddateandtime")
VALUES(4, 4, '2023-03-14', '2023-03-15');
INSERT INTO laborutilized_t("repairid", "temployeeid", "shiftstartdateandtime", "shiftenddateandtime")
VALUES(5, 5, '2023-03-15', '2023-03-16');