-- Create database Homework_session05_02
create database Homework_session05_02;
-- create table customers
create table customers(
	customer_id serial primary key,
	customer_name varchar(50) not null,
	city varchar(50)
);
-- create table orders
create table orders(
	order_id int primary key,
	customer_id int references customers(customer_id),
	order_date date,
	total_price numeric(10,2)
);
-- create table order_items
create table order_items(
	item_id int primary key,
	order_id int references orders(order_id),
	product_id int,
	quantity int,
	price numeric(10,2)
);
-- insert data
insert into customers(customer_name, city) values
('Nguyễn Văn A', 'Hà Nội'),
('Trần Thị B', 'Đà Nẵng'),
('Lê Văn C', 'Hồ Chí Minh'),
('Phạm Thị D', 'Hà Nội');

insert into orders(order_id, customer_id, order_date, total_price) values
(101, 1, '2024-12-20', 3000),
(102, 2, '2025-01-05', 1500),
(103, 1, '2025-02-10', 2500),
(104, 3, '2025-02-15', 4000),
(105, 4, '2025-03-01', 800);

insert into order_items(item_id, order_id, product_id, quantity, price) values
(1, 101, 1, 2, 1500),
(2, 102, 2, 1, 1500),
(3, 103, 3, 5, 500),
(4, 104, 2, 4, 1000);

select * from customers;
select * from orders;
select * from order_items;

-- list query
-- sum of revenus, orders
select c.customer_name, sum(o.total_price) as total_revenus, count(o.order_id) as order_count
from customers c join orders o on c.customer_id = o.customer_id
group by c.customer_id, c.customer_name
having sum(total_price) > 2000;

-- average revenus
select c.customer_name, sum(o.total_price) as total_revenus
from customers c join orders o on c.customer_id = o.customer_id
group by c.customer_id, c.customer_name
having sum(o.total_price) > (
	select sum(total_price) / count(distinct customer_id)
	from orders
);

-- filter city with the highest revenue
select c1.city, sum(o1.total_price) as city_revenue
from customers c1 join orders o1 on c1.customer_id = o1.customer_id
group by c1.city
having sum(o1.total_price) >= all (
	select sum(total_price)
	from customers c2 join orders o2 on c2.customer_id = o2.customer_id
	group by c2.city
);

-- inner join
select c.customer_name, c.city, sum(oi.quantity) as total_products_bought, sum(oi.quantity * oi.price) as total_spent_calculated
from customers c 
join orders o on c.customer_id = o.customer_id
join order_items oi on o.order_id = oi.order_id
group by c.customer_id, c.customer_name, c.city;