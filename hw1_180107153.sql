-- 1a

SELECT L.city, count(p.product_id) 
FROM products p inner join INVENTORIES I on p.product_id = I.product_id 
LEFT OUTER JOIN WAREHOUSES W on I.WAREHOUSE_ID = W.WAREHOUSE_ID 
LEFT OUTER JOIN LOCATIONS L on W.LOCATION_ID = L.LOCATION_ID 
GROUP BY city;

--2 a,b

set SERVEROUTPUT on
DECLARE
    message varchar2(20):= 'Hello, World!';
BEGIN
  dbms_output.put_line(message);
END;

-- 3 a 

SET SERVEROUTPUT ON 
DECLARE
  type grades IS VARRAY(5) OF INTEGER;
  v_id grades := grades(82, 83, 84, 33, 44);
  v_first_name employees.first_name%TYPE;
  v_last_name employees.last_name%TYPE;
  v_phone employees.phone%TYPE;
  v_website customers.website%TYPE;
  v_address customers.address%TYPE;
BEGIN
  FOR i IN 1..v_id.count loop
    SELECT first_name, last_name, phone 
      INTO v_first_name, v_last_name, v_phone
      FROM employees
      WHERE EMPLOYEE_ID = v_id(i); 
    SELECT website, address
      INTO v_website, v_address
      FROM customers
      WHERE CUSTOMER_ID = v_id(i);
      DBMS_OUTPUT.PUT_LINE('FIRST NAME: '|| v_first_name ||', LAST NAME: '|| v_last_name ||', PHONE: '|| v_phone || ', WEBSITE: ' || v_website || ', ADDRESS ' || v_address );
  END LOOP;
END;

--3 b

SET SERVEROUTPUT ON
DECLARE
     sum_standard_cost number;
BEGIN
    SELECT SUM(standard_cost)
    INTO sum_standard_cost
    FROM PRODUCTS;
    DBMS_OUTPUT.PUT_LINE(sum_standard_cost);
END;

--4a

SET SERVEROUTPUT ON
DECLARE
  sum_standard_cost number;
  sum_list_price number;
BEGIN
  SELECT SUM(STANDARD_COST) , SUM(LIST_PRICE)
  INTO 
   sum_standard_cost, sum_list_price
  FROM
    PRODUCTS;
  IF sum_standard_cost > sum_list_price  THEN
    DBMS_OUTPUT.PUT_LINE(sum_standard_cost);
  ELSE
    DBMS_OUTPUT.PUT_LINE(sum_list_price);
  END IF;
END;

--4b 

SET SERVEROUTPUT ON
DECLARE
  CURSOR c_product
  IS
    SELECT 
        product_name, standard_cost
    FROM 
        products 
    where
    standard_cost<(select avg(standard_cost) from products )
    ORDER BY standard_cost DESC;
    
BEGIN
  FOR r_product IN c_product
  LOOP
    dbms_output.put_line( r_product.product_name || ': $' ||  r_product.standard_cost );
  END LOOP;
END;

-- 5

SET SERVEROUTPUT ON
DECLARE
  CURSOR a_product
  IS
    SELECT 
        product_name
    FROM 
        products 
    WHERE product_name like '%Samsung%';
BEGIN
  FOR r_product IN a_product
  LOOP
    dbms_output.put_line( r_product.product_name );
  END LOOP;
END;



