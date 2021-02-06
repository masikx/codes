--Create a procedure with name get_products() where ​accepts a categoryname (as input)​,
--and select all products by given category:
--a.In case no data (Create an exception):
--return empty VARRAY;
--b.In case data found: return ​VARRAY OF RECORDS​. Record properties:
--id, name, description, standard_cost as cost. 
--(Useful link:https://stackoverflow.com/questions/15166738/pl-sql-varray-with-a-cursor​)
create or replace PROCEDURE get_products(c_category_id in number ) as 
cursor c_products is
    select product_id, product_name, description , standard_cost as cost, category_id from PRODUCTS where  category_id = c_category_id order by product_id asc;
     type varray_prod is table of c_products%rowtype;
 products_rec varray_prod := varray_prod();
  v_counter number := 1;
begin
    for prodRecs in c_products loop
        products_rec.extend; 
        products_rec(products_rec.count) := prodRecs;     
    end loop;
    for i in products_rec.first .. products_rec.last loop 
        dbms_output.put_line(products_rec(i).product_id || '  ' || products_rec(i).product_name || '  ' || products_rec(i).description || '  ' || products_rec(i).cost);
    end loop;    
exception 
 when NO_DATA_FOUND then
 dbms_output.put_line('empty VARRAY');
end;
--2.Create a function where accepts​ a product record​ 
--(name, description,cost, and category name), your task is import (insert) into yourdatabase:
--a.In case if category is not found: create an exception whichreturns a message “Category not found!”
--b.In case if your database has the same name: create an exceptionwhich returns a message “Product found with same :name!”
--c.Insert a product into your products table and return a message“Product with name :name: successfully inserted into ourdatabase!”
create or replace FUNCTION insert_product(
     f_name in varchar2,
     f_description in varchar2 ,
     f_cost in number, 
     f_category_name in number
) return varchar2 as
    result varchar2(200) ;
    cursor c_products is select product_name 
    from products where product_name = f_name;
    same_exception exception;
    p_name varchar2(200);   
begin
   p_name:= '';
   for c_p in c_products
   loop
      p_name :=c_p.product_name;
        end loop;
  if p_name = f_name then
      raise same_exception;
  else
  insert into products(product_name, description, standard_cost, category_id)
   values(f_name, f_description, f_cost, f_category_name);
   dbms_output.put_line('Product with name : '|| f_name ||' successfully inserted into our database!');
  end if;   
   return result ;
exception 
   when same_exception then 
   dbms_output.put_line('Product found with same name:'|| f_name ||'!'); 
   when NO_DATA_FOUND then
   dbms_output.put_line('Category not found!');
end ;
--3.Create a procedure with name get_analyst(id - canaccept product id (itmeans ​id can be nullable)​) where does below:
--a.In case no data (Create an exception): prints a message “NoData”;
--b.In case id is null: print all products with how many orders youhave by every productc.
--In case id is not null: select product by id and print productwith how many orders did by the productd.
--In case id is not null and not found: print a message “Productwith given id not found!”;
create or replace PROCEDURE get_analyst(f_id in number) as
cursor c_product is
    select count(order_id) as "count_order",products.product_name from order_items INNER join products ON order_items.product_id = products.product_id
     where producs.product_id = f_id group by products.product_name;
    rec_producs c_product%rowtype;
    empty_input_exception exception;
    not_found_exception exception;
begin
    open c_product;
    loop
        fetch c_product into rec_producs;
        if f_id is null then
        raise empty_input_exception;
        elsif f_id is not null and c_product%rowcount=0 then
        raise not_found_exception;
        else   
            exit when c_product%notfound;
            dbms_output.put_line(rec_producs.count_order||' '||rec_producs.product_name);
        end if;
    end loop;
    exception
    when empty_input_exception then dbms_output.put_line('NoData');
    when not_found_exception then dbms_output.put_line('Product with given id not found!');
  end;