Select trim(VendorName) from Vendor_sale_summary

Select VendorName,(TotalSalesDollars-TotalPurchaseDollars) as GrossProfit from Vendor_sale_summary

Select VendorName,((TotalSalesDollars-TotalPurchaseDollars)/TotalSalesDollars)*100 as ProfitMargin from Vendor_sale_summary

Select VendorName,TotalSalesQuantity/TotalPurchaseQuantity as StockTurnOver from Vendor_Sale_Summary

Select VendorName, TotalSalesDollars/TotalPurchaseDollars as SalesToPurchase_Ratio From Vendor_sale_summary

Select * ,
(TotalSalesDollars-TotalPurchaseDollars) as GrossProfit ,
((TotalSalesDollars-TotalPurchaseDollars)/TotalSalesDollars)*100 as ProfitMargin,
(TotalSalesQuantity/TotalPurchaseQuantity) as StockTurnOver,
(TotalSalesDollars/TotalPurchaseDollars) as SalesToPurchase_Ratio into VendorSales_summary
from Vendor_sale_summary




