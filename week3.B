1.How many customers has Foodie-Fi ever had?
Ans:select count(distinct customer_id) from foodie_fi.subscriptions

2.What is the monthly distribution of trial plan start_date values for our dataset - use the start of the month as the group by value?
Ans:
select month(start_date) as month,count(*) from foodie_fi.subscriptions  as s 
where plan_id=0 group by month order by  month

3.What plan start_date values occur after the year 2020 for our dataset? Show the breakdown by count of events for each plan_name?
Ans:
select plan_name,count(plan_name) from foodie_fi.plans as p inner join foodie_fi.subscriptions 
as s on p.plan_id=s.plan_id where year(start_date)>'2020-12-31'  group by plan_name

4.What is the customer count and percentage of customers who have churned rounded to 1 decimal place?
Ans:select count(*),round(count(*)*100/(select count(*) from 
foodie_fi.subscriptions),1) 
from foodie_fi.subscriptions 
where plan_id=4


5.How many customers have churned straight after their initial free trial - what percentage is this rounded to the nearest whole number?
Ans:with a as (SELECT * FROM foodie_fi.subscriptions where plan_id=4)
  select distinct count(*),round(count(*) *100/(select count(*) from foodie_fi.subscriptions),0)
  from a inner join (SELECT * FROM foodie_fi.subscriptions where plan_id=0) as b on
  a.customer_id=b.customer_id where a.start_date between b.start_date and b.start_date+ interval 7 day





6.What is the number and percentage of customer plans after their
 initial free trial?
Ans:with a as (SELECT * FROM foodie_fi.subscriptions where plan_id!=4)
  select distinct count(*),round(count(*) *100/(select count(*) from foodie_fi.subscriptions),0)
  from a inner join (SELECT * FROM foodie_fi.subscriptions where plan_id=0) as b on
  a.customer_id=b.customer_id where a.start_date>b.start_date+ interval 7 day
  
 7.What is the customer count and percentage breakdown of all 5 plan_name values at 2020-12-31?
 Ans:
 select plan_name,count(customer_id) as count,
round(count(customer_id)*100/( select count(customer_id) from foodie_fi.subscriptions 
 where start_date<='2020-12-31'),1) as percentage 
from foodie_fi.subscriptions  as s right join foodie_fi.plans as p on 
p.plan_id=s.plan_id where s.start_date<='2020-12-31' group by plan_name
  
8.How many customers have upgraded to an annual plan in 2020?
Ans:
select count(*) from foodie_fi.subscriptions where plan_id=3 and year(start_date)='2020'


9.How many days on average does it take for a customer to an annual plan from the day they 
join Foodie-Fi?
with c as (with  b as(select distinct s.customer_id,s.start_date as join_date,a.start_date as annal_date from foodie_fi.subscriptions  as s join (select * from foodie_fi.subscriptions where plan_id=0) as a on
a.customer_id=s.customer_id
where s.plan_id=3)
select *,datediff(join_date,annal_date) as diff from b )
select round(avg(diff),0) as avg_day from c

10.Can you further breakdown this average value into 30 day periods (i.e. 0-30 days, 31-60 days etc)
Ans:with annal as(select customer_id,start_date  as annal_day  from foodie_fi.subscriptions where plan_id=3),
 trail as (select customer_id,start_date as tril_day from foodie_fi.subscriptions where plan_id=0),
 day_period  as
 (select datediff(annal_day,tril_day) as diff from  annal  join trail on trail.customer_id=annal.customer_id 
where  annal_day is not null ),
bins as (select *,floor(diff/30) as bins from day_period)
select  concat((bins*30)+1,'_',(bins+1)*30,'days') as days,count(diff) as total from bins group by bins order by bins

11.How many customers downgraded from a pro monthly to a basic monthly plan in 2020?
Ans:with dpro as(select * from foodie_fi.subscriptions where plan_id=2),
 basic as( select * from foodie_fi.subscriptions where plan_id=1) 
 select count(basic.customer_id) from dpro join basic on dpro.customer_id=basic.customer_id where dpro.start_date<basic.start_date




C. Challenge Payment Question
The Foodie-Fi team wants you to create a new payments table for the year 2020 that includes amounts paid by each customer in the subscriptions table with the following requirements:

monthly payments always occur on the same day of month as the original start_date of any monthly paid plan
upgrades from basic to monthly or pro plans are reduced by the current paid amount in that month and start immediately
upgrades from pro monthly to pro annual are paid at the end of the current billing period and also starts at the end of the month period
once a customer churns they will no longer make payments
Ans:ITH cte AS (
  SELECT
    s.customer_id,s.plan_id,
    p.plan_name,
    p.price,
    s.start_date,
    YEAR(s.start_date) AS start_year,
    LEAD(s.start_date) OVER (PARTITION BY s.customer_id ORDER BY s.start_date, s.plan_id) AS next_start_date
  FROM
    foodie_fi.subscriptions AS s
    INNER JOIN foodie_fi.plans AS p ON p.plan_id = s.plan_id
  WHERE
    s.plan_id NOT IN (0, 4)
    AND YEAR(s.start_date) = 2020
),
cte_count AS (
  SELECT
    cte.*,
    ROW_NUMBER() OVER (PARTITION BY cte.customer_id ORDER BY cte.start_date, cte.plan_id) AS row_num
  FROM
    cte
)
SELECT
  cte_count.*,
  (SELECT COUNT(*) FROM cte_count sub WHERE sub.customer_id = cte_count.customer_id AND sub.row_num <= cte_count.row_num) AS cumulative_count
FROM
  cte_count;
