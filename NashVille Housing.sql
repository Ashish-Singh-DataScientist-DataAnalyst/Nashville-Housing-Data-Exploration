
/*
Cleaning Data in SQL Queries
*/


SELECT *
FROM [Portfolio Project].[dbo].[NashVille Housing]


--------------------------------------------------------------------------------------------------------------------------

-- Standardize Date Format


Select SaleDate, CONVERT(Date,SaleDate)
From [Portfolio Project].[dbo].[NashVille Housing]


Update [NashVille Housing]
SET SaleDate = CONVERT(Date,SaleDate)



---- If It Doesn't Update Properly


ALTER TABLE [NashVille Housing]
Add SaleDateConverted Date;

Update [NashVille Housing]
SET SaleDateConverted = CONVERT(Date,SaleDate)

Select SaleDateConverted, CONVERT(Date,SaleDate)
From [Portfolio Project].[dbo].[NashVille Housing]


 --------------------------------------------------------------------------------------------------------------------------

-- Populate Property Address data

Select *
From [Portfolio Project].dbo.[NashVille Housing]
--Where PropertyAddress is null
order by ParcelID



Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
From [Portfolio Project].dbo.[NashVille Housing] a
JOIN [Portfolio Project].dbo.[NashVille Housing] b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null

---- <> Refers to Not Equal

Update a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
From [Portfolio Project].dbo.[NashVille Housing] a
JOIN [Portfolio Project].dbo.[NashVille Housing] b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null

---- Cross Checking The Data By PropertyAddress Attribute Not Null.


Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
From [Portfolio Project].dbo.[NashVille Housing] a
JOIN [Portfolio Project].dbo.[NashVille Housing] b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is not null




--------------------------------------------------------------------------------------------------------------------------
 
-- Breaking out Address into Individual Columns (Address, City, State)


Select PropertyAddress
From [Portfolio Project].dbo.[NashVille Housing]
--Where PropertyAddress is null
--order by ParcelID

SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 ) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1 , LEN(PropertyAddress)) as Address

From [Portfolio Project].dbo.[NashVille Housing]


ALTER TABLE [NashVille Housing]
Add PropertySplitAddress Nvarchar(255);

Update [NashVille Housing]
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 )


ALTER TABLE [NashVille Housing]
Add PropertySplitCity Nvarchar(255);

Update [NashVille Housing]
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress))




Select *
From [Portfolio Project].dbo.[NashVille Housing]





Select OwnerAddress
From [Portfolio Project].dbo.[NashVille Housing]


Select
PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)
From [Portfolio Project].dbo.[NashVille Housing]
Where OwnerAddress is not null


ALTER TABLE [NashVille Housing]
Add OwnerSplitAddress Nvarchar(255);

Update [NashVille Housing]
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)


ALTER TABLE [NashVille Housing]
Add OwnerSplitCity Nvarchar(255);

Update [NashVille Housing]
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)



ALTER TABLE [NashVille Housing]
Add OwnerSplitState Nvarchar(255);

Update [NashVille Housing]
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)



Select *
From [Portfolio Project].[dbo].[NashVille Housing] 




--------------------------------------------------------------------------------------------------------------------------


-- Change Y and N to Yes and No in "Sold as Vacant" field


Select Distinct(SoldAsVacant), Count(SoldAsVacant)
From [Portfolio Project].[dbo].[NashVille Housing]
Group by SoldAsVacant
order by 2



Select SoldAsVacant
, CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END
From [Portfolio Project].dbo.[NashVille Housing]


Update [NashVille Housing]
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'Yes'
When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END

Select Distinct(SoldAsVacant), Count(SoldAsVacant)
From [Portfolio Project].[dbo].[NashVille Housing]
Group by SoldAsVacant
order by 2





-----------------------------------------------------------------------------------------------------------------------------------------------------------

-- Remove Duplicates

WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num

From [Portfolio Project].dbo.[NashVille Housing]
--order by ParcelID
)
Select *
From RowNumCTE
Where row_num > 1
Order by PropertyAddress



WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num

From [Portfolio Project].dbo.[NashVille Housing]
--order by ParcelID
)
DELETE
From RowNumCTE
Where row_num > 1
--Order by PropertyAddress


Select *
From [Portfolio Project].dbo.[NashVille Housing]




---------------------------------------------------------------------------------------------------------

-- Delete Unused Columns



Select *
From [Portfolio Project].dbo.[NashVille Housing]


ALTER TABLE [Portfolio Project].dbo.[NashVille Housing]
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate




---- On Furthur Cleansing of Data

Select *
From [Portfolio Project].dbo.[NashVille Housing]
Where OwnerName is not null





---- More Cleaner & Accurate Data

Select *
From [Portfolio Project].dbo.[NashVille Housing]
Where OwnerName is not null
AND YearBuilt is not null











-----------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------

--- Importing Data using OPENROWSET and BULK INSERT	


--sp_configure 'show advanced options', 1;
--RECONFIGURE;
--GO
--sp_configure 'Ad Hoc Distributed Queries', 1;
--RECONFIGURE;
--GO


--USE [Portfolio Project] 

--GO 

--EXEC master.dbo.sp_MSset_oledb_prop N'Microsoft.ACE.OLEDB.12.0', N'AllowInProcess', 1 

--GO 

--EXEC master.dbo.sp_MSset_oledb_prop N'Microsoft.ACE.OLEDB.12.0', N'DynamicParameters', 1 

--GO 


---- Using BULK INSERT

--USE PortfolioProject;
--GO
--BULK INSERT nashvilleHousing FROM 'C:\Temp\SQL Server Management Studio\Nashville Housing Data for Data Cleaning Project.csv'
--   WITH (
--      FIELDTERMINATOR = ',',
--      ROWTERMINATOR = '\n'
--);
--GO


---- Using OPENROWSET
--USE PortfolioProject;
--GO
--SELECT * INTO nashvilleHousing
--FROM OPENROWSET('Microsoft.ACE.OLEDB.12.0',
--    'Excel 12.0; Database=C:\Users\singh\OneDrive\Documents\SQL Server Management Studio\Nashville Housing Data for Data Cleaning Project.csv', [NashVille Housing]]);
--GO
