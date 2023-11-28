/*Display the total number of customers based on gender who have placed individual orders of worth at least Rs.3000.*/

SELECT 
    COUNT(cus_id) AS NoOfCustomers,cus_gender
FROM
    customer
WHERE
    cus_id IN (SELECT DISTINCT
            cus_id
        FROM
            `order`
        WHERE
            ORD_AMOUNT >= 3000)
GROUP BY cus_gender;


/**Display all the orders along with product name ordered by a customer having Customer_Id=2 */

select `order`.*, A1.pro_name from `order`
inner join
(select product.pro_name, supplier_pricing.pricing_id from 
product
inner join
supplier_pricing 
on
supplier_pricing.pro_id = product.pro_id ) as A1
on
`order`.pricing_id = A1.pricing_id where `order`.cus_id=2;

/* Display the Supplier details who can supply more than one product.**/

select supplier.* from supplier where supplier.supp_id in
(select supp_id from supplier_pricing group by supp_id having
count(supp_id)>1);

/* Find the least expensive product from each category and print the table with category id, name, product name and price of the product **/

SELECT 
    category.cat_id,
    category.cat_name,
    MIN(t3.min_price) AS Min_Price,
    t3.pro_name
FROM
    category
        INNER JOIN
    (SELECT 
        product.cat_id, product.pro_name, t2.*
    FROM
        product
    INNER JOIN (SELECT 
        pro_id, MIN(supp_price) AS Min_Price
    FROM
        supplier_pricing
    GROUP BY pro_id) AS t2
    WHERE
        t2.pro_id = product.pro_id) AS t3
WHERE
    t3.cat_id = category.cat_id
GROUP BY t3.cat_id;

/*
 Display the Id and Name of the Product ordered after “2021-10-05”.
*/

select product.pro_id,product.pro_name from 
`order` 
inner join 
supplier_pricing 
on supplier_pricing.pricing_id=`order`.pricing_id 
inner join 
product
on 
product.pro_id=supplier_pricing.pro_id where `order`.ord_date>"2021-10-05";

/*Display customer name and gender whose names start or end with character 'A'.
*/

SELECT 
    cus_name, cus_gender
FROM
    customer
WHERE
    cus_name LIKE 'A%' OR cus_name LIKE '%A';
	/*Create a stored procedure to display supplier id, name, Rating(Average rating of all the products sold by every customer) and
Type_of_Service. For Type_of_Service, If rating =5, print “Excellent Service”,If rating >4 print “Good Service”, If rating >2 print “Average
Service” else print “Poor Service”. Note that there should be one rating per supplier.
*/
	
select report.supp_id,report.supp_name,report.Average,
CASE
WHEN report.Average =5 THEN 'Excellent Service'
WHEN report.Average >4 THEN 'Good Service'
WHEN report.Average >2 THEN 'Average Service'
ELSE 'Poor Service'
END AS Type_of_Service from
(select final.supp_id, supplier.supp_name, final.Average from
(select test2.supp_id, avg(test2.rat_ratstars) as Average from
(select supplier_pricing.supp_id, test.ORD_ID, test.RAT_RATSTARS from 
supplier_pricing inner join
(select `order`.pricing_id, rating.ORD_ID, rating.RAT_RATSTARS from 
`order` 
inner join 
rating 
on rating.`ord_id` = `order`.ord_id ) 
as test
on test.pricing_id = supplier_pricing.pricing_id)
as test2 group by supplier_pricing.supp_id)
as final 
inner join 
supplier 
where final.supp_id = supplier.supp_id) as report;


call proc1();

