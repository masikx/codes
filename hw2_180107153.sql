--1.Display all location addresses using of cursor and while loop
DECLARE 
   c_address locations.address%type; 
   CURSOR c_locations is 
      SELECT address FROM locations; 
BEGIN 
   OPEN c_locations;
   WHILE true
   LOOP 
   FETCH c_locations into c_address; 
      EXIT WHEN c_locations%notfound; 
      dbms_output.put_line(c_address ); 
   END LOOP; 
   CLOSE c_locations; 
END;
--2.Calculate the average of list price of products using cursor-definedrecord, cursor

DECLARE 
   CURSOR c_products is 
      select avg(list_price) as avg_list_price from products; 
   products_rec c_products%rowtype; 
BEGIN 
   OPEN c_products; 
   LOOP 
      FETCH c_products into products_rec; 
      EXIT WHEN c_products%notfound; 
      DBMS_OUTPUT.put_line(products_rec.avg_list_price); 
   END LOOP; 
END;
--3.Create a record for employee Ava Sullivan (from employees table) and
--display how many products she sold at all time.
--in this task usecursor, record and while loop.
DECLARE 
   CURSOR c_employees is 
      select count(STATUS) as count_orders,FIRST_NAME 
      from  employees,orders where FIRST_NAME like 'Ava' 
      and LAST_NAME like 'Sullivan' and 
      employees.employee_id=orders.salesman_id group by FIRST_NAME;
   employees_rec c_employees%rowtype; 
BEGIN 
   OPEN c_employees; 
   LOOP 
      FETCH c_employees into employees_rec; 
      EXIT WHEN c_employees%notfound; 
      DBMS_OUTPUT.put_line(employees_rec.count_orders||' '||employees_rec.FIRST_NAME); 
   END LOOP; 
END;
--4.Create a cursor which accepts category name, then display following:
--a.Displays how many products in this categoryb.Minimum, Maximum,
--Mean for standard cost of productsc.
DECLARE  
   CURSOR c_categories is 
    select CATEGORY_NAME,count(PRODUCT_ID) as 
    count_product,max(STANDARD_COST) as max_cost,min(STANDARD_COST) 
    as min_cost,avg(STANDARD_COST) as mean_cost 
    from product_categories,products 
    where product_categories.category_id=products.category_id --and CATEGORY_NAME like''
    group by CATEGORY_NAME;
    categories_rec c_categories%rowtype; 
BEGIN 
   OPEN c_categories; 
   LOOP 
      FETCH c_categories into categories_rec; 
      EXIT WHEN c_categories%notfound; 
      DBMS_OUTPUT.put_line(categories_rec.CATEGORY_NAME||' '||categories_rec.count_product||' '||categories_rec.max_cost||' '||categories_rec.min_cost||' '||categories_rec.mean_cost); 
   END LOOP; 
END;
--Displays top 10 products according to sales rate. (In plainexplanation) 
DECLARE  
   CURSOR c_categories is 
    select CATEGORY_NAME,PRODUCT_ID,PRODUCT_NAME 
    from product_categories,products where product_categories.category_id=products.category_id; --and CATEGORY_NAME like''
    categories_rec c_categories%rowtype; 
BEGIN 
   OPEN c_categories; 
   LOOP 
      FETCH c_categories into categories_rec; 
      EXIT WHEN c_categories%notfound; 
      DBMS_OUTPUT.put_line(categories_rec.CATEGORY_NAME||' '||categories_rec.PRODUCT_ID||' '||categories_rec.PRODUCT_NAME); 
   END LOOP; 
END;
--Display most frequently sold products in a 
--givencategory (according to orders table).
DECLARE  
   CURSOR c_categories is 
    select PRODUCT_ID,PRODUCT_NAME,order_date from product_categories,products,orders,order_items where product_categories.category_id=products.category_id and order_items.order_id=orders.order_id and order_items.product_id=products.product_id;
    categories_rec c_categories%rowtype; 
BEGIN 
   OPEN c_categories; 
   LOOP 
      FETCH c_categories into categories_rec; 
      EXIT WHEN c_categories%notfound; 
      DBMS_OUTPUT.put_line(categories_rec.PRODUCT_ID||' '||categories_rec.PRODUCT_NAME); 
   END LOOP; 
END;
--Note: if category is not found display: “Category is not found!”

--5.Create a cursor which accepts country name and displays how manyproducts
--in given county and quantity in sum.
DECLARE  
   --c_country_name varchar(30); 
   CURSOR c_countries is 
      select COUNTRY_NAME,count(product_id) as count_product,sum(QUANTITY)as sum_quantity  from countries,locations,warehouses,inventories 
      where countries.country_id=locations.country_id and warehouses.location_id=locations.location_id
      and inventories.warehouse_id=warehouses.warehouse_id  group by COUNTRY_NAME;
    countries_rec c_countries%rowtype; 
BEGIN 
   OPEN c_countries; 
   LOOP 
      FETCH c_countries into countries_rec; 
      EXIT WHEN c_countries%notfound; 
      DBMS_OUTPUT.put_line(countries_rec.COUNTRY_NAME||' '||countries_rec.count_product||' '||countries_rec.sum_quantity); 
   END LOOP; 
END;