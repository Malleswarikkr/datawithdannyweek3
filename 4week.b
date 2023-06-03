1./*What is the unique count and total amount for each transaction type?*/
Ans:select  txn_type,count(txn_type),sum(txn_amount) from 
data_bank.customer_transactions group by txn_type;

2./*What is the average total historical deposit counts and amounts for 
all customers?*/
with a as(select  customer_id,txn_type,count(*) as count,sum(txn_amount) 
as amount from
data_bank.customer_transactions  where txn_type='deposit' 
group by customer_id,txn_type)
select avg(count),avg(amount) from a;

3.
