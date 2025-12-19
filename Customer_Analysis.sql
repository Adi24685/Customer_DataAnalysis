drop database customer_db;
create database customer_db;
use customer_db;

-- Creating table 
create table customers(
customer_id int primary key,
customer_name varchar(50),
city varchar(50)
);

insert into customers values
(1,'Amit','Pune'),
(2,'Rohit','Mumbai'),
(3,'Sneha','Delhi'),
(4,'Neha','Pune');
select*from customers;

-- Product Table
create table products(
product_id int primary key,
product_name varchar(100),
category varchar(50),
price decimal(10,2)
);

insert into products values
(101,'Laptop','Electronics',50000),
(102,'Mobile','Electronics',20000),
(103,'Headphones','Accessories',3000),
(104,'Chair','Furniture',7000);
select*from products;

-- Orders Table 
create table orders(
order_id int primary key,
customer_id int,
order_date date,
foreign key(customer_id) references customers(customer_id)
);

insert into orders values
(1001,1,'2024-01-10'),
(1002,2,'2024-02-15'),
(1003,3,'2024-02-05'),
(1004,4,'2024-02-20');
select*from orders;

-- Order Items Table
create table order_items(
item_id int primary key,
order_id int,
product_id int,
quantity int,
foreign key(order_id) references orders(order_id),
foreign key(product_id) references products(product_id)
);

insert into order_items values
(1,1001,101,1),
(2,1001,103,2),
(3,1002,102,1),
(4,1003,104,1),
(5,1004,101,1);
select *from order_items;

-- Total Orders per Customers
select customer_id, count(order_id)as total_orders
from orders
group by customer_id;

-- Customers Who Orderd More Than Average
select customer_id
from orders
group by customer_id
having count(order_id)>
(select avg(order_count)
 from (
     select count(order_id) as order_count
     from orders
     group by customer_id
     ) as avg_table
     );
     
     -- Total Revenue Per Customer
     select o.customer_id,
         sum(p.price*oi.quantity) as total_revenue
	from orders o
    join order_items oi on o.order_id= oi.order_id
    join products p on oi.product_id=p.product_id
    group by o.customer_id
    order by total_revenue desc;
    
    -- Most Frequently Purchased Products
    select p.product_name,
       count(oi.product_id) as purchase_count
    from order_items oi
    join products p on oi.product_id=p.product_id
    group by p.product_name
    order by purchase_count desc;
    
    -- Products Never Orderd
    select p.product_name
    from products p
    left join order_items oi
    on p.product_id = oi.product_id
    where oi.product_id is null;
    
    -- Monthly Order Trend
    select date_format(order_date,'%y-%m')as month,
            count(order_id) as total_orders
	from orders
    group by month
    order by month;