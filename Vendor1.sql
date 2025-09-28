

----------Freight Summary-------

select VendorName,round(sum(Freight),2) as Freight into Freight_Summary  from dbo.vendor_invoice
group by VendorName


----------Purchase Summary------------

select p.Brand,p.VendorNumber,p.VendorName,pp.Volume,p.PurchasePrice,pp.Price as Actual_Price,p.Description, sum(p.Quantity) Total_PurchaseQuantity
,round(sum(p.Dollars),2) as Total_PurchaseAmount into purchase_summary
from dbo.purchases as p join dbo.purchase_prices as pp
on p.Brand = pp.Brand
where p.PurchasePrice>0
group by p.VendorNumber , p.VendorName,p.Brand,pp.Price ,pp.Volume,p.PurchasePrice,p.Description
order by Total_PurchaseQuantity 

----------Sales Summary----------

select  VendorName,VendorNo,round(Sum(SalesQuantity),2) as Total_PurchaseQuantity,
round(SUm(SalesDollars),2) As Total_PurchaseAmount,round(Sum(SalesPrice),2) Total_SalePrice 
into Vendor_sales_summary
from dbo.sales
group by VendorName,VendorNo
order by Total_PurchaseQuantity desc


--------------Creating Vendor Summary Table-------------

SELECT
    pp.VendorName,
    pp.VendorNumber,
    pp.Price AS ActualPrice,
    pp.PurchasePrice,
    ROUND(SUM(CAST(s.SalesQuantity AS DECIMAL(18,2))), 2) AS TotalSalesQuantity,
    ROUND(SUM(CAST(s.SalesPrice AS DECIMAL(18,2))), 2) AS TotalSalesPrice,
    ROUND(SUM(CAST(s.SalesDollars AS DECIMAL(18,2))), 2) AS TotalSalesDollars,
    ROUND(SUM(CAST(s.ExciseTax AS DECIMAL(18,2))), 2) AS TotalSalesExiceTax,
    ROUND(SUM(CAST(vi.Quantity AS DECIMAL(18,2))), 2) AS TotalPurchaseQuantity,
    ROUND(SUM(CAST(vi.Dollars AS DECIMAL(18,2))), 2) AS TotalPurchaseDollars,
    ROUND(SUM(CAST(vi.Freight AS DECIMAL(18,2))), 2) AS TotalFreightCost
    into VendorSummary
FROM purchase_prices AS pp
JOIN sales AS s
    ON pp.VendorNumber = s.VendorNo AND pp.Brand = s.Brand
JOIN vendor_invoice AS vi
    ON pp.VendorNumber = vi.VendorNumber
GROUP BY pp.VendorName,pp.VendorNumber, pp.Price, pp.PurchasePrice;

-------------Alternative option usnig CTE's-------------
 WITH FreightSummary AS(
        SELECT 
            VendorNumber, 
            round(SUM(Freight),2) AS FreightCost 
        FROM vendor_invoice 
        GROUP BY VendorNumber
    ), 
    
    PurchaseSummary AS (
        SELECT 
            p.VendorNumber,
            p.VendorName,
            p.Brand,
            p.Description,
            p.PurchasePrice,
            pp.Price AS ActualPrice,
            pp.Volume,
            round(SUM(p.Quantity),2) AS TotalPurchaseQuantity,
            round(SUM(p.Dollars),2) AS TotalPurchaseDollars
        FROM purchases p
        JOIN purchase_prices pp
            ON p.Brand = pp.Brand
        WHERE p.PurchasePrice > 0
        GROUP BY p.VendorNumber, p.VendorName, p.Brand, p.Description, p.PurchasePrice, pp.Price, pp.Volume
    ), 
    
    SalesSummary AS (
        SELECT 
            VendorNo,
            Brand,
            round(SUM(SalesQuantity),2) AS TotalSalesQuantity,
            round(SUM(SalesDollars),2) AS TotalSalesDollars,
            round(SUM(SalesPrice),2) AS TotalSalesPrice,
            round(SUM(ExciseTax),2) AS TotalExciseTax
        FROM sales
        GROUP BY VendorNo, Brand
    ) 
    
    SELECT 
        ps.VendorNumber,
        ps.VendorName,
        ps.Brand,
        ps.Description,
        ps.PurchasePrice,
        ps.ActualPrice,
        ps.Volume,
        ps.TotalPurchaseQuantity,
        ps.TotalPurchaseDollars,
        ss.TotalSalesQuantity,
        ss.TotalSalesDollars,
        ss.TotalSalesPrice,
        ss.TotalExciseTax,
        fs.FreightCost  into Vendor_sale_summary
    FROM PurchaseSummary ps
    LEFT JOIN SalesSummary ss 
        ON ps.VendorNumber = ss.VendorNo 
        AND ps.Brand = ss.Brand
    LEFT JOIN FreightSummary fs 
        ON ps.VendorNumber = fs.VendorNumber
    ORDER BY ps.TotalPurchaseDollars DESC

