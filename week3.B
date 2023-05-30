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

5.
