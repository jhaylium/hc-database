create schema properties;


create table properties.property(
    property_id int generated always as identity primary key,
    street_addr varchar(100),
    zip_code varchar(10),
    state varchar(5),
    rent int,
    beds float,
    baths int,
    sqft int,
    purchase_price int,
    status varchar(50),
    created_at timestamp with time zone default now()

);


create table properties.ownership_in_property (
    id int generated always as identity primary key,
    investor_id int references customers.investors(investor_id),
    property_id int references properties.property(property_id),
    investment_amount int not null,
    ownership_pct float,
    created_at timestamp with time zone default now()
);

create table properties.monthly_financials(
    id int generated always as identity primary key,
    reported_date date,
    property_id int references properties.property(property_id),
    line_item_type varchar(50),
    amount float,
    created_at timestamp with time zone default now()
);

create table properties.monthly_profit(
    id int generated always as identity primary key,
    reported_date date,
    property_id int references properties.property(property_id),
    total_profit float,
    created_at timestamp with time zone default now()
);