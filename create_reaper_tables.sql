create schema reaper;

create table reaper.potential_winners_stg(
    street_addr varchar(255),
    state varchar(5),
    zip_code varchar(10),
    price float,
    foreclosure bool,
    baths float,
    beds int,
    units int,
    median_rent float,
    avg_rent float,
    hud_rent float,
    avg_school_rtg float,
    median_school_rtg float,
    population_by_zip int,
    median_income_by_zip float,
    pct_profit_hud float,
    pct_profit_med float,
    pct_profit_avg float,
    rent_profit_6pct float,
    rent_profit_15pct float,
    rent_profit_20pct float,
    created_at timestamp with time zone default now()
);
create table reaper.potential_winners(
    id int generated always as identity primary key,
    street_addr varchar(255),
    state varchar(5),
    zip_code varchar(10),
    price float,
    foreclosure bool,
    baths float,
    beds int,
    units int,
    median_rent float,
    avg_rent float,
    hud_rent float,
    avg_school_rtg float,
    median_school_rtg float,
    population_by_zip int,
    median_income_by_zip float,
    pct_profit_hud float,
    pct_profit_med float,
    pct_profit_avg float,
    rent_profit_6pct float,
    rent_profit_15pct float,
    rent_profit_20pct float,
    created_at timestamp with time zone default now()
);

create table reaper.school_ratings_stg(
    school_name varchar(255),
    street_addr varchar(255),
    city varchar(255),
    state varchar(5),
    zip_code varchar(10),
    school_type varchar(100),
    student_count varchar(20),
    rating varchar(3),
    scale varchar(20),
    url varchar(100)
);

create table reaper.school_ratings(
    school_id int generated always as identity,
    school_name varchar(255),
    street_addr varchar(255),
    city varchar(255),
    state varchar(5),
    zip_code varchar(10),
    school_type varchar(100),
    student_count varchar(20),
    rating varchar(3),
    scale varchar(20),
    url varchar(100),
    dt_insert timestamp with time zone default  now()
);

create table reaper.zip_code_master(
    id int generated always as identity primary key,
    zip_code varchar(10) not null,
    zip_type varchar(25) not null,
    city varchar(255),
    state varchar(5),
    county_a varchar(100),
    timezone varchar(50),
    area_codes varchar(100),
    county_b varchar(100),
    lat float,
    lng float
);

create table reaper.zip_code_master_stg(
    zip_code varchar(10) not null,
    zip_type varchar(25) not null,
    city varchar(255),
    state varchar(5),
    county_a varchar(100),
    timezone varchar(50),
    area_codes varchar(100),
    county_b varchar(100),
    lat varchar(25),
    lng varchar(25)
);

create table reaper.hud_rents(
    year varchar(10),
    zip_code varchar(10),
    hud_area_code varchar(255),
    hud_metro_fair_market_rent_area_name varchar(255),
    br_studio int,
    br_one int,
    br_two int,
    br_three int,
    br_four int
);

create table reaper.locations_queue(
    id int references reaper.locations(id),
    realtor_city_format varchar(255),
    zillow_city_format varchar(255),
    zip_code varchar(255)
);

create table reaper.locations(
    id  integer generated always as identity primary key,
    city                varchar(255) not null,
    state               varchar(5)   not null,
    zip_code            varchar(10),
    realtor_city_format varchar(255),
    zillow_city_format  varchar(255),
    dt_created          timestamp with time zone default now(),
    active              integer                  default 1
);

create table reaper.realtor_purchase_property_stg(
    street_addr varchar(255),
    city varchar(255),
    state varchar(5),
    zip_code varchar(10),
    url varchar(255),
    price varchar(25),
    sqft varchar(25),
    baths varchar(10),
    beds varchar(10),
    price_reduction varchar(25),
    dt_insert timestamp with time zone default now()

);

create table reaper.realtor_purchase_property(
    property_id int generated always as identity primary key,
    street_addr varchar(255) Not Null,
    city varchar(255),
    state varchar(5),
    zip_code varchar(10),
    url varchar(255),
    price int,
    sqft int,
    baths int,
    beds int,
    price_reduction int,
    dt_insert timestamp with time zone default now()

);

create table reaper.realtor_rental_property_stg(
    street_addr varchar(255),
    city varchar(255),
    state varchar(5),
    zip_code varchar(10),
    url varchar(255),
    price varchar(25),
    sqft varchar(25),
    baths varchar(10),
    beds varchar(10),
    dt_insert timestamp with time zone default now()

);

create table reaper.realtor_rental_property(
    rental_id int generated always as identity primary key,
    street_addr varchar(255),
    city varchar(255),
    state varchar(5),
    zip_code varchar(10),
    url varchar(255),
    price int,
    sqft int,
    baths int,
    beds int,
    dt_insert timestamp with time zone default now()
);

create table reaper.schools_queue(
    id int generated always as identity primary key,
    zip_code varchar(10),
    city varchar(255),
    state varchar(255)
);

create table reaper.state_property_tax(
    id int generated always as identity,
    state varchar(50),
    state_abbr varchar(2),
    tax_rate float,
	dt_year varchar(4)
);

create view reaper.rental_prices as
select
       rp.zip_code,
       city,
       state,
       beds,
       round(avg(price),2) as avg_price,
       percentile_cont(.5) within group ( order by price::float ) median_price,
       count(1) as available_rentals_by_unit,
       avg(ttl.count) as total_units_available

from reaper.realtor_rental_property rp
left join (select zip_code, count(1) as count from reaper.realtor_rental_property group by zip_code) ttl
on rp.zip_code = ttl.zip_code
where state = 'MI'
group by rp.zip_code, beds,city,state;

create table reaper.historical_property_taxes_stg(
    property_id int,
    year varchar(5),
    taxes varchar(20),
    land_tax varchar(20),
    additions_tax varchar(20),
    total_assessment varchar(20)
);

create table reaper.historical_price_events_stg(
    property_id int,
    event_date varchar(20),
    event_type varchar(20),
    price varchar(255),
    price_per_sqft varchar(255),
    source varchar(255)
);

create table reaper.historical_property_taxes(
    property_id int,
    year varchar(5),
    taxes int,
    land_tax int,
    additions_tax int,
    total_assessment int,
    dt_insert timestamp with time zone default now()
);

create table reaper.historical_price_events(
    property_id int,
    event_date date,
    event_type varchar(20),
    price int,
    price_per_sqft int,
    source varchar(255),
    dt_insert timestamp with time zone default now()
);


create table reaper.realtor_purchase_units_stg(
    id int,
    units varchar(4)
);

