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

