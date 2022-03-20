-- load schools_queue
insert into reaper.schools_queue(
        zip_code,
        city,
        state)
select
       zip_code,
       city,
       state
from reaper.realtor_purchase_property
group by zip_code, city, state
order by city, state;


--load purchase/locations queue
insert into reaper.locations_queue
(
     id,
     realtor_city_format,
     zillow_city_format,
     zip_code)
select
    id,
    realtor_city_format,
    zillow_city_format,
    zip_code
from reaper.locations lt
where not exists(
    select from reaper.locations_queue lq
    where lt.id = lq.id
    )
and lt.active = 1;


-- load rentals_queue
insert into reaper.rental_queue(
        zip_code,
        city,
        state)
select
       zip_code,
       city,
       state
from reaper.realtor_purchase_property
group by zip_code, city, state
order by city, state;

-- update realtor_purchase_property units
update reaper.realtor_purchase_property pp
set units = pu.units::int
from reaper.realtor_purchase_units_stg pu
where pp.property_id = pu.id;


-- update historical pricing events
insert into reaper.historical_price_events(
    property_id,
    event_date,
    event_type,
    price,
    price_per_sqft,
    source)
select
    property_id,
    to_date(stg.event_date, 'MM/DD/YYYY') as event_date,
    event_type,
    case
        when price = '0' then NULL
        else price::int
    end as price,
    case
        when price_per_sqft = '0' then Null
        else price_per_sqft::int
    end as price_per_sqft,
    source
from reaper.historical_price_events_stg stg
where not exists(
    select from reaper.historical_price_events fin
    where stg.property_id = fin.property_id
    and to_date(stg.event_date, 'MM/DD/YYYY') = fin.event_date
    );
	
-- update historical taxes
insert into reaper.historical_property_taxes(
    property_id,
    year,
    taxes,
    land_tax,
    additions_tax,
    total_assessment)
select
    property_id,
    year,
    taxes::int,
    case
        when land_tax = 'N/A' then Null
        else land_tax::int
    end as land_tax,
    case
        when additions_tax = 'N/A' then Null
        else additions_tax::int
    end as additions_tax,
    case
        when total_assessment = 'N/A' then Null
        else total_assessment::int
    end as total_assessment
from reaper.historical_property_taxes_stg stg
where not exists(
    select from reaper.historical_property_taxes fin
    where stg.property_id =  fin.property_id
    and stg.year = fin.year
    )
