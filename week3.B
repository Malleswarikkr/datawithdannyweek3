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

10.
