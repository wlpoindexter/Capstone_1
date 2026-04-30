USE sample_sales;

SELECT *
FROM Management
WHERE SalesManager = 'Bo Heap';

-- What is total revenue overall for sales in Massachusetts, plus the start date and end date that tell you what period the data covers?

SELECT Management.SalesManager, 
	Store_Locations.State, Management.Region,
	sum(Sale_Amount) AS Total_Revenue,
	Min(Transaction_Date) AS Start_Date,
	MAX(Transaction_Date) AS End_Date
FROM Management
	JOIN Store_Locations
		ON Management.State = Store_Locations.State
    JOIN Store_Sales 
		ON Store_Locations.StoreId = Store_Sales.Store_ID
WHERE SalesManager = 'Bo Heap'
	GROUP BY Management.SalesManager,Store_Locations.State, Management.Region;
    
-- What is the month by month revenue breakdown for the Massachusetts? (Do line chart for these)

SELECT Management.Region, 
	Management.State, 
    Management.SalesManager,
    YEAR(Transaction_Date) AS sales_year,
    MONTH(Transaction_Date) AS sales_month,
   SUM(Sale_Amount) AS monthly_revenue
FROM Store_Sales
	JOIN Store_Locations
		ON Store_Sales.Store_ID = Store_Locations.StoreId
    JOIN Management
		ON Management.State = Store_Locations.State
WHERE Management.SalesManager = 'Bo Heap'
	GROUP BY sales_year,
    sales_month,
    Management.Region, 
    Management.State;
    
SELECT Management.Region, 
	Management.State, 
    Management.SalesManager,
    MONTH(Transaction_Date) AS sales_month,
   SUM(Sale_Amount) AS monthly_revenue
FROM Store_Sales
	JOIN Store_Locations
		ON Store_Sales.Store_ID = Store_Locations.StoreId
    JOIN Management
		ON Management.State = Store_Locations.State
WHERE Management.SalesManager = 'Bo Heap'
	GROUP BY 
    sales_month,
    Management.Region, 
    Management.State
		ORDER BY sales_month;

    
-- Provide a comparison of total revenue for Massachusetts compared to the entire Northeast region. (Make this a pie chart)

-- Northeast Total Revenue
SELECT SUM(Store_Sales.Sale_Amount) AS Total_Revenue_Northeast
FROM Management
	JOIN Store_Locations
		ON Management.state = Store_Locations.State
    JOIN Store_Sales
		ON Store_Sales.Store_ID = Store_Locations.StoreId
WHERE Region = 'Northeast';

-- Massachsuetts Revenue

SELECT SUM(Store_Sales.Sale_Amount) AS Massachusetts_Revenue
FROM Management
	JOIN Store_Locations
		ON Management.state = Store_Locations.State
    JOIN Store_Sales
		ON Store_Sales.Store_ID = Store_Locations.StoreId
WHERE Management.State = 'Massachusetts';

-- What is the number of transactions per month and average transaction size by product category for Massachusetts?

SELECT YEAR(Transaction_Date) AS sales_year,
    MONTH(Transaction_Date) AS sales_month, 
    Inventory_Categories.Category,
    Products.Categoryid, 
    COUNT(id) as 'Number of Transactions',
    AVG(Store_Sales.Sale_Amount) AS Average_transaction_amount,
    Store_Locations.State
FROM Store_Sales
	JOIN Products
		ON Store_Sales.Prod_Num = Products.ProdNum
    JOIN Store_Locations
		ON Store_Locations.StoreId = Store_Sales.Store_ID
	JOIN Inventory_Categories
		ON Inventory_Categories.Categoryid = Products.Categoryid
WHERE State = 'Massachusetts'
	GROUP BY sales_year, 
    sales_month,
    Products.Categoryid,
    Inventory_Categories.Category
		ORDER BY sales_year, 
        sales_month,
        Average_transaction_amount DESC;
        
    
-- Can you provide a ranking of in-store sales performance by each store in the sales territory, or a ranking of online sales performance by state within an online sales territory?
    
SELECT SUM(Store_Sales.Sale_Amount) AS Total_Revenue,
		Store_Locations.StoreId, 
        Store_Locations.State,
        Store_Locations.StoreLocation
FROM Store_Locations
    JOIN Store_Sales
		ON Store_Locations.StoreId = Store_Sales.Store_ID
WHERE Store_Locations.State = 'Massachusetts' 
    GROUP BY Store_Locations.StoreId, 
        Store_Locations.State
		ORDER BY Total_Revenue DESC
			LIMIT 10;
    
-- What is your recommendation for where to focus sales attention in the next quarter?
Select 
	Store_Locations.StoreId,
    Store_Locations.State,
    SUM(Store_Sales.Sale_Amount) AS Total_Sales,
    COUNT(Store_Sales.id) AS Number_of_transactions
FROM Store_Sales
	JOIN Store_Locations
		ON Store_Sales.Store_ID = Store_Locations.StoreId
WHERE Store_Locations.State = 'Massachusetts'
	GROUP BY Store_Locations.StoreId,
    Store_Locations.State
		ORDER BY Total_Sales ASC;
        
-- (BONUS) What product at store 817 is making them the store withthe most total revenue?

SELECT  Store_Sales.Store_ID,
	Inventory_Categories.Category,
    Inventory_Categories.Categoryid,
    Products.Product,
    SUM(Store_Sales.Sale_Amount) AS Total_revenue,
    Inventory_Subategories.Subcategory
FROM Products
	JOIN Store_Sales
		ON Products.ProdNum = Store_Sales.Prod_Num
	JOIN Inventory_Categories
		ON Inventory_Categories.Categoryid = Products.Categoryid
	JOIN Inventory_Subategories
		ON Inventory_Subategories.Subcategoryid = Products.Subcategoryid
WHERE Store_ID = 817
	Group BY Store_Sales.Store_ID,
	Inventory_Categories.Category,
    Inventory_Categories.Categoryid,
    Products.Product,
    Inventory_Subategories.Subcategory
		ORDER BY Total_revenue DESC;
        
-- STORE 808 (Store doing the worst)
SELECT  Store_Sales.Store_ID,
	Inventory_Categories.Category,
    Inventory_Categories.Categoryid,
    Products.Product,
    SUM(Store_Sales.Sale_Amount) AS Total_revenue,
    Inventory_Subategories.Subcategory
FROM Products
	JOIN Store_Sales
		ON Products.ProdNum = Store_Sales.Prod_Num
	JOIN Inventory_Categories
		ON Inventory_Categories.Categoryid = Products.Categoryid
	JOIN Inventory_Subategories
		ON Inventory_Subategories.Subcategoryid = Products.Subcategoryid
WHERE Store_ID = 808
	Group BY Store_Sales.Store_ID,
	Inventory_Categories.Category,
    Inventory_Categories.Categoryid,
    Products.Product,
    Inventory_Subategories.Subcategory
		ORDER BY Total_revenue DESC;
        
	-- Laptops are the top seller both onliine and in stores for Massachusetts

SELECT *
FROM Online_Sales
	JOIN Products
		ON Products.ProdNum = Online_Sales.ProdNum
WHERE ShiptoState = 'Massachusetts'
	ORDER BY SalesTotal DESC;

-- Cooreleation between Month and amount of sales in revenue (Trying to se which had theh most sales)

SELECT Management.Region, 
	Management.State, 
    Management.SalesManager,
    MONTH(Transaction_Date) AS sales_month,
   SUM(Sale_Amount) AS monthly_revenue
FROM Store_Sales
	JOIN Store_Locations
		ON Store_Sales.Store_ID = Store_Locations.StoreId
    JOIN Management
		ON Management.State = Store_Locations.State
WHERE Management.SalesManager = 'Bo Heap'
	GROUP BY 
    sales_month,
    Management.Region, 
    Management.State
		ORDER BY monthly_revenue DESC;
        
        
-- Product Mix for 808 

SELECT  Store_Sales.Store_ID,
	Inventory_Categories.Category,
    Inventory_Categories.Categoryid,
    SUM(Store_Sales.Sale_Amount) AS Total_revenue
FROM Products
	JOIN Store_Sales
		ON Products.ProdNum = Store_Sales.Prod_Num
	JOIN Inventory_Categories
		ON Inventory_Categories.Categoryid = Products.Categoryid
	JOIN Inventory_Subategories
		ON Inventory_Subategories.Subcategoryid = Products.Subcategoryid
WHERE Store_ID = 808
	Group BY Store_Sales.Store_ID,
	Inventory_Categories.Category,
    Inventory_Categories.Categoryid
		ORDER BY Total_revenue  DESC;
        
-- Product Mix for 817

SELECT  Store_Sales.Store_ID,
	Inventory_Categories.Category,
    Inventory_Categories.Categoryid,
    SUM(Store_Sales.Sale_Amount) AS Total_revenue
FROM Products
	JOIN Store_Sales
		ON Products.ProdNum = Store_Sales.Prod_Num
	JOIN Inventory_Categories
		ON Inventory_Categories.Categoryid = Products.Categoryid
	JOIN Inventory_Subategories
		ON Inventory_Subategories.Subcategoryid = Products.Subcategoryid
WHERE Store_ID = 817
	Group BY Store_Sales.Store_ID,
	Inventory_Categories.Category,
    Inventory_Categories.Categoryid
		ORDER BY Total_revenue  DESC;
        
-- Product Mix for 807

SELECT  Store_Sales.Store_ID,
	Inventory_Categories.Category,
    Inventory_Categories.Categoryid,
    Products.Product,
    SUM(Store_Sales.Sale_Amount) AS Total_revenue,
    Inventory_Subategories.Subcategory
FROM Products
	JOIN Store_Sales
		ON Products.ProdNum = Store_Sales.Prod_Num
	JOIN Inventory_Categories
		ON Inventory_Categories.Categoryid = Products.Categoryid
	JOIN Inventory_Subategories
		ON Inventory_Subategories.Subcategoryid = Products.Subcategoryid
WHERE Store_ID = 807
	Group BY Store_Sales.Store_ID,
	Inventory_Categories.Category,
    Inventory_Categories.Categoryid,
    Products.Product,
    Inventory_Subategories.Subcategory
		ORDER BY Total_revenue DESC;
-- 807 laptop purchasers are more gaming laptops

-- Worchester has a student population of roughly 35k, while lowell has a student pop of roughly 19k


-- Product Mix for every store in massachusetts

SELECT  Store_Sales.Store_ID,
	Inventory_Categories.Category,
    Inventory_Categories.Categoryid,
    SUM(Store_Sales.Sale_Amount) AS Total_revenue
FROM Products
	JOIN Store_Sales
		ON Products.ProdNum = Store_Sales.Prod_Num
	JOIN Inventory_Categories
		ON Inventory_Categories.Categoryid = Products.Categoryid
	JOIN Store_Locations
		ON Store_Locations.StoreId = Store_Sales.Store_ID
	WHERE State = 'Massachusetts'
	Group BY Store_Sales.Store_ID,
	Inventory_Categories.Category,
    Inventory_Categories.Categoryid
		ORDER BY Store_ID DESC;
        

-- Because 817 has so many more transactions even with the average transaction amount being loweer than other stores, we can guess they must be one of the only stores in the area
-- To help other stores or 808 specifaically they should run bundles, promotions, promote hire priced laptops
-- For other stores they could be going to best buy or any other stores to buy their stuff
-- To boost sales you can run reward programs to get discounts for store 808 and other stores
-- Find out how other stores can boost foot traffic
-- Raise or lower ppricesto beat competition (like best buy)
-- Worchester (store 817) can raise prices to make up where 808 is lacking in sales
-- Worchester makes more money so they can charge more
-- Lowell city has a student population makes less money, so students have to buy cheaper options 
-- Trying monthy trials are sometimes too low, go for quartelry trials

SELECT COUNT(id) as 'Number of Transactions',
    AVG(Store_Sales.Sale_Amount) AS Average_transaction_amount,
    Store_Locations.State,
    Store_Locations.StoreId
FROM Store_Sales
	JOIN Products
		ON Store_Sales.Prod_Num = Products.ProdNum
    JOIN Store_Locations
		ON Store_Locations.StoreId = Store_Sales.Store_ID
	JOIN Inventory_Categories
		ON Inventory_Categories.Categoryid = Products.Categoryid
WHERE State = 'Massachusetts'
	GROUP BY Store_Locations.StoreId
		ORDER BY Average_transaction_amount DESC;
        
-- Because 817 has so many more transactions even with the average transaction amount being loweer than other stores, we can guess they must be one of the only stores in the area
-- To help other stores or 808 specifaically they should run bundles, promotions, promote hire priced laptops
-- For other stores they could be going to best buy or any other stores to buy their stuff
-- To boost sales you can run reward programs to get discounts for store 808 and other stores
-- Find out how other stores can boost foot traffic
-- Raise or lower ppricesto beat competition (like best buy)
-- Worchester (store 817) can raise prices to make up where 808 is lacking in sales
-- Worchester makes more money so they can charge more
-- Lowell city has a student population makes less money, so students have to buy cheaper options 
-- Trying monthy trials are sometimes too low, go for quartelry trials

        
