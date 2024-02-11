select * from production.products

select * from production.products where list_price>1000 and model_year between 2019 and 2022

select * from sales.customers

select cus.customer_id, first_name, last_name  from sales.customers as cus
inner join sales.orders as so on cus.customer_id=so.customer_id 
inner join sales.stores as st on st.store_id=so.store_id 
inner join sales.order_items as oi on so.order_id=oi.order_id 
where st.city='New York' 
group by cus.customer_id, cus.first_name, cus.last_name
having sum(oi.quantity*oi.list_price)>2000




SELECT c.customer_id, c.first_name, c.last_name
FROM sales.customers c
JOIN sales.orders o ON c.customer_id = o.customer_id
JOIN sales.stores s ON o.store_id = s.store_id
JOIN sales.order_items oi ON o.order_id = oi.order_id
WHERE s.city = 'Rowlett'
GROUP BY c.customer_id, c.first_name, c.last_name
HAVING SUM(oi.quantity * oi.list_price) > 1000



select * from production.products

select top 5 pp.product_name, oi.quantity, oi.list_price from production.products as pp
inner join sales.order_items as oi on pp.product_id=oi.product_id 
order by sum(oi.quantity*oi.list_price)
group by oi.quantity, oi.list_price 
oi.quantity*oi.list_price



SELECT TOP 5 p.product_name, SUM(oi.quantity) AS total_quantity_sold
FROM production.products p
JOIN sales.order_items oi ON p.product_id = oi.product_id
GROUP BY p.product_name
ORDER BY total_quantity_sold DESC;


select * from sales.stores 

select * from sales.staffs

select sta.staff_id, sta.first_name, sta.last_name from sales.staffs as sta
where sta.staff_id in (
select ord.staff_id from sales.orders as ord
join sales.customers as cus on ord.customer_id=cus.customer_id
where cus.city='Los Angeles' and cus.city='San Francisco'
group by cus.city having sta.manager_id=Null
)




select sta.staff_id, sta.first_name, sta.last_name from sales.staffs as sta
where sta.manager_id is NUll and sta.staff_id in (
select ord.staff_id from sales.orders as ord
join sales.stores as sto on ord.store_id=sto.store_id
where sto.city='Santa Cruz' and sto.city='Baldwin'
group by ord.staff_id 
having count(distinct sto.city)=1

)



SELECT s.staff_id, s.first_name, s.last_name
FROM sales.staffs s
WHERE s.manager_id IS NULL
  AND s.staff_id IN (
    SELECT o1.staff_id
    FROM sales.orders o1
    JOIN sales.stores s1 ON o1.store_id = s1.store_id
    WHERE s1.city = 'Los Angeles'
    GROUP BY o1.staff_id
    HAVING COUNT(DISTINCT s1.city) = 1
  )
  AND s.staff_id IN (
    SELECT o2.staff_id
    FROM sales.orders o2
    JOIN sales.stores s2 ON o2.store_id = s2.store_id
    WHERE s2.city = 'San Francisco'
    GROUP BY o2.staff_id
    HAVING COUNT(DISTINCT s2.city) = 1
  );




  select * from production.categories


  select * from sales.customers


  select cus.customer_id, cus.first_name, cus.last_name from sales.customers as cus
  where cus.customer_id in (
  select ord.customer_id from sales.orders as ord
  join  sales.order_items as it on ord.order_id=it.order_id
  join production.products as pro on it.product_id=pro.product_id
  join production.categories as cat on pro.category_id=cat.category_id
  where cat.category_name='Electric Bikes'
  )
   
  SELECT c.customer_id, c.first_name, c.last_name
FROM sales.customers c
WHERE c.customer_id IN (
    SELECT o.customer_id
    FROM sales.orders o
    JOIN sales.order_items oi ON o.order_id = oi.order_id
    JOIN production.products p ON oi.product_id = p.product_id
    JOIN production.categories cat ON p.category_id = cat.category_id
    WHERE cat.category_name = 'Bikes'
)




SELECT c.customer_id, c.first_name, c.last_name
FROM sales.customers c
WHERE c.customer_id IN (
    SELECT o.customer_id
    FROM sales.orders o
    JOIN sales.order_items oi ON o.order_id = oi.order_id
    JOIN production.products p ON oi.product_id = p.product_id
    JOIN production.categories cat ON p.category_id = cat.category_id
    WHERE cat.category_name = 'Bikes'

AND c.customer_id IN (
    SELECT o.customer_id
    FROM sales.orders o
    JOIN sales.order_items oi ON o.order_id = oi.order_id
    JOIN production.products p ON oi.product_id = p.product_id
    JOIN production.categories cat ON p.category_id = cat.category_id
    WHERE cat.category_name = 'Accessories'
);