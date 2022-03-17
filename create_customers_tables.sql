create schema customers;

create table customers.newsletter_users_stg(
      email_address varchar(255),
      created_at timestamp with time zone default now()
);

create table customers.newsletter_users_stg(
      newsletter_user_id int generated always as identity primary key
	  email_address varchar(255),
      created_at timestamp with time zone default now()
);

create table customers.prospects_stg(
    name varchar(255),
    email_address varchar(255),
    phone_number varchar(15),
    source varchar(50),
    created_at timestamp with time zone default now()
);

create table customers.prospects(
    prospect_id int generated always as identity primary key,
	name varchar(255),
    email_address varchar(255),
    phone_number varchar(15),
    source varchar(50),
    created_at timestamp with time zone default now()
);

create table  customers.investors (
    investor_id int generated always as identity primary key,
    fname varchar(255),
	lname varchar(255),
    email varchar(255) unique,
    phone_number varchar(255),
	street_address varchar(100),
	zip_code varchar(10),
	state varchar(5),
	created_at timestamp with time zone default now()
	updated_at timestamp with time zone
);