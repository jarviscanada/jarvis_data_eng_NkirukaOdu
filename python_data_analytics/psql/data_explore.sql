-- Show table schema 
\d+ retail;

-- Show first 10 rows
select * 
from retail 
limit 10;
-- Check # of records
select count(*)
from retail;

-- number of clients (e.g. unique client ID)

select count(distinct customer_id)
from retail;
     
-- invoice date range (e.g. max/min dates)
   
   select  max(invoice_date), min(invoice_date)
from retail r;

-- number of SKU/merchants (e.g. unique stock code)
    select count(distinct stock_code)
    from retail;
   
-- average invoice amount excluding invoices with a negative amount (e.g. canceled orders have negative amount)
-- an invoice consists of one or more items where each item is a row in the df
    
    select
  AVG(total_amount) 
from 
  (
    select 
      sum(quantity * unit_price) as total_amount 
    from 
      retail 
    group by 
      invoice_no 
    having 
      sum(quantity * unit_price) > 0
  ) as customer_total_amount;
-- total revenue (e.g. sum of unit_price * quantity)
select 
  sum(quantity * unit_price) 
from 
  retail;
  -- fxn to return yyyymm timestamp as int  
   create OR replace function pg_temp.get_year_month(ts timestamp) returns int as
$$
declare
  year_value text;
  month_value text;
begin
  select EXTRACT(YEAR from ts) into year_value;
  select LPAD(EXTRACT(MONTH from ts)::text, 2, '0') into month_value;
  return (select CONCAT(year_value, month_value)) as int;
end;
$$
  language PLPGSQL;
    
-- total revenue by YYYYMM
select 
  pg_temp.get_year_month(invoice_date) as yyyymm, 
  sum(quantity * unit_price) 
from 
  retail 
groupby 
  yyyymm 
order by yyyymm;