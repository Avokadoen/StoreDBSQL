
DROP SCHEMA

IF EXISTS storedb;
	CREATE SCHEMA storedb COLLATE = utf8_general_ci;

USE storedb;

create table manufacturer (
  name varchar(16) NOT NULL UNIQUE,
  country varchar(2) NOT NULL,
  serviceURL varchar(250),
  primary key (name)
);

# TODO: REGEX always 1
create table lenstype (
  lensid int NOT NULL AUTO_INCREMENT,
	focallength varchar(16) NOT NULL,
  maxAperture dec(3,1) NOT NULL,
	length int NOT NULL,
  filtersize int NOT NULL,
  primary key (lensid)
);

create table lensmount (
	mountid int NOT NULL,
	lensname varchar(16) NOT NULL,
	name varchar(16) references manufacturer,
	primary key (mountid)
);

create table equipmenttype (
	name varchar(16) NOT NULL REFERENCES manufacturer,
	typename varchar(60) NOT NULL,
	weight int UNSIGNED NOT NULL,
	perdayprice dec(7,2) NOT NULL,
	mountid int NOT NULL REFERENCES lensmount,
	megapixel dec(3,1) DEFAULT 1,
	lensid int DEFAULT NULL REFERENCES lenstype,
	PRIMARY KEY(name, typename)
);

create table memorycardtype (
	memname varchar(16) NOT NULL UNIQUE,
	name varchar(16) references manufacturer,
	typename varchar(60) references equipmenttype,
	primary key(memname)
);

# TODO
# L CHECK ( email LIKE '^[A-Z0-9._%-]+@[A-Z0-9.-]+\.[A-Z]{2,4}$')
# CONSTRAINT CHK_customer_email CHECK( email LIKE '^[A-Z0-9._%-]+@[A-Z0-9.-]+\.[A-Z]{2,4}$')
create table customer (
  email varchar(250) NOT NULL,
	name varchar(60) NOT NULL,
	address varchar(250) NOT NULL,
	mobileno varchar(32) NOT NULL,
  primary key (email)
);

# TODO REGEXP for email
create table store (
	id int NOT NULL AUTO_INCREMENT,
	name varchar(60) NOT NULL UNIQUE,
	email varchar(250) NOT NULL,
	address varchar(250) NOT NULL,
	primary key (id)
);

# TODO REGEXP for email
create table assesser(
	id int NOT NULL AUTO_INCREMENT,
	assrname varchar(60) NOT NULL UNIQUE,
	email varchar(250) NOT NULL,
	address varchar(250) NOT NULL,
	phonenum int NOT NULL,
	primary key(id)
);

create table assesses(
	maname varchar(16) NOT NULL,
	assid int NOT NULL,
	storeid int NOT NULL,
	asdate date,
	primary key(maname, assid, storeid),
	constraint fk_asseses_manu foreign key(maname) references manufacturer(name),
	constraint fk_asseses_asses foreign key(assid) references assesser(id),
	constraint fk_asseses_store foreign key(storeid) references store(id)
);


# TODO create constraint that make sure that no row has same
# leaseno if id is same
# totalprice check if null if null set to standard
# status check if either active or finished
create table lease (
	id int references store,
	leaseno int NOT NULL,
	startdate date NOT NULL,
	enddate date NOT NULL,
	totalprice int,
	status ENUM('active', 'finished'),
	email varchar(250) NOT NULL references customer,
	primary key(id, leaseno)
);

create table price (
 	id int references store,
	leaseno int references lease,
	extrafee int NOT NULL,
	explanation varchar(2000) NOT NULL,
	primary key(id, leaseno)
);

create table equipment (
	serialno int UNSIGNED NOT NULL,
	startdate date NOT NULL,
	status ENUM('working', 'defect') NOT NULL,
	state ENUM('1', '2', '3', '4', '5')  NOT NULL,
	leaseno int references lease,
	typename varchar(60) NOT NULL references equipmenttype,
	maname varchar(16) NOT NULL,
	storeid int NOT NULL,
	primary key(serialno),
	constraint fk_equipment_manu foreign key(maname) references manufacturer(name),
	constraint fk_equipment_store foreign key(storeid) references store(id)
);

create table telephone (
	id int references store,
	phonenum varchar(32) NOT NULL,
	primary key (id, phonenum)
);

# 		INSERTION

#					MANUFACTURER
INSERT INTO manufacturer VALUES
('Nikon', 'JP', 'https://nikoneurope-no.custhelp.com/app/answers/list/locale/no_NO');
INSERT INTO manufacturer VALUES
('Sony', 'JP', 'https://www.sony.no/support/no/hub/prd-dime-alpha');

#					STORE
INSERT INTO store VALUES
(1, 'FotoRental Bergen', 'bergen@fotorental.no', 'Storgata 10, 5835 Bergen');
INSERT INTO store VALUES
(2, 'FotoRental Kristiansand', 'kristiansand@fotorental.no', 'Storgata 10, 4604 Kristiansand');

#					CUSTOMER
INSERT INTO customer VALUES
('ola@nordmann.com', 'Ola Nordmann', '+4799999999', 'Langrand 51, 3055 Krokstadelva');
INSERT INTO customer VALUES
('kari@nordmann.com', 'Kari Nordmann', '+4744444444', 'Vestpå 1, 5003 Bergen');
INSERT INTO customer VALUES
('per@nordmann.com', 'Per Nordmann', '+4791919191', 'Sørpå 1, 4513 Mandal');

#					TELEPHONE
INSERT INTO telephone VALUES
(1, '+4755555555');
INSERT INTO telephone VALUES
(1, '+4743211234');
INSERT INTO telephone VALUES
(2, '+4738383838');

#					ASSESSER
INSERT INTO assesser VALUES
(1, 'Kameratakst', 'post@kameratakst.no', '+4799119911', 'Strandveien 22, 4630 Kristiansand');
INSERT INTO assesser VALUES
(2, 'C&V Teknikk AS', 'service@camera.no', '+4755393880', 'Liaveien 1, 5132 Nyborg');

#					ASSESSES
INSERT INTO assesses VALUES
('Nikon', 1, 1, '2014-1-1');
INSERT INTO assesses VALUES
('Nikon', 1, 2, '2014-1-1');
INSERT INTO assesses VALUES
('Sony', 1, 1, '2014-1-1');
INSERT INTO assesses VALUES
('Sony', 1, 2, '2014-1-1');
INSERT INTO assesses VALUES
('Nikon', 2, 1, '2016-1-1');

#					LENSTYPE
INSERT INTO lenstype VALUES
(1, '58', 1.4, 70, 72);
INSERT INTO lenstype VALUES
(2, '50', 1.4, 43, 55);
INSERT INTO lenstype VALUES
(3, '50', 1.4, 71, 72);

#					LENSMOUNT
INSERT INTO lensmount VALUES
(1, 'Nikon F-mount', 'Nikon');
INSERT INTO lensmount VALUES
(2, 'Sony A-mount', 'Sony');

#					EQUIPMENTTYPE
INSERT INTO equipmenttype VALUES
('Nikon', 'D4', 1180, 300.0, 1, 16.4, NULL);
INSERT INTO equipmenttype VALUES
('Nikon', 'AF-S Nikkor 58mm f/1.4G', 385, 150, 1, NULL, 1);
INSERT INTO equipmenttype VALUES
('Sony', 'Alfa 900', 850, 200, 2, 24.6, NULL);
INSERT INTO equipmenttype VALUES
('Sony', '50mm f/1.4', 220, 100, 2, NULL, 2);
INSERT INTO equipmenttype VALUES
('Sony', 'Planar T* FE 50mm F1.4 ZA', 778, 150, 2, NULL, 3);

#					MEMORYCARDTYPE
INSERT INTO memorycardtype VALUES
('Compact Flash', 'Nikon', 'D4');
INSERT INTO memorycardtype VALUES
('XQD', 'Nikon', 'D4');

#					LEASE
INSERT INTO lease VALUES
(1, 1, '2013-01-10', '2013-01-16', NULL, 'finished', 'per@nordmann.com');
INSERT INTO lease VALUES
(2, 1, '2014-11-10', '2014-11-12', 750, 'finished', 'kari@nordmann.com');
INSERT INTO lease VALUES
(2, 2, '2016-10-10', '2016-10-30', NULL, 'active', 'per@nordmann.com');

#					PRICE
INSERT INTO price VALUES
(2, 1, 250, 'UV-filter ødelagt');

#					EQUIPMENT
INSERT INTO equipment VALUES
(11112222, '2012-12-12', 'working', '3', 1, 'D4', 'Nikon', 1);
INSERT INTO equipment VALUES
(11113333, '2015-08-10', 'working', '1', NULL,'AF-S Nikkor 58mm f / 1.4G', 'Nikon', 1);
INSERT INTO equipment VALUES
(22224444, '2012-12-12', 'working', '2', 2, 'Alfa 900', 'Sony', 2);
INSERT INTO equipment VALUES
(22225555, '2013-11-11', 'defect', '3', NULL, '50mm f / 1.4G', 'Sony', 2);
INSERT INTO equipment VALUES
(22227777, '2014-09-22', 'working', '2', 1,'50mm f / 1.4G', 'Sony', 2);
INSERT INTO equipment VALUES
(22229999, '2015-11-30', 'working', '1', 1,'Planar T * FE 50mm F1.4 ZA', 'Sony', 2);
