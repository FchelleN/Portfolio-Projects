
-- CLEANING DATA IN SQL QUERIES

SELECT *
FROM NashvilleHousing

-- STANDARDIZING THE DATE FORMAT

SELECT SaleDate, CONVERT(Date, SaleDate)
FROM NashvilleHousing

UPDATE NashvilleHousing
SET SaleDate = CONVERT(Date, SaleDate)

-- Adding a Table
ALTER TABLE NashvilleHousing
Add SaleDateConverted Date;

UPDATE NashvilleHousing
SET SaleDateConverted = CONVERT(Date, SaleDate)

--Populate Property Address DATA

SELECT *
FROM NashvilleHousing
WHERE propertyaddress IS NUll 
--AND parcelid = '025 07 0 031.00'	
ORDER BY ParcelID

SELECT a.parcelID, b.parcelid, a.propertyaddress, b.propertyaddress, ISNULL(a.propertyaddress, b.propertyaddress)
FROM NashvilleHousing a
JOIN NashvilleHousing b
	ON a.ParcelID = b.ParcelID
	AND a.uniqueID <> b.UniqueID
--WHERE a.propertyaddress IS NUll 
--AND a.parcelid = '025 07 0 031.00'

 UPDATE a
 SET propertyaddress = ISNULL(a.propertyaddress, b.propertyaddress)
 FROM NashvilleHousing a
JOIN NashvilleHousing b
	ON a.ParcelID = b.ParcelID
	AND a.uniqueID <> b.UniqueID
WHERE a.propertyaddress IS NUll 

-- Breaking out Address into Individual Columns (Address, City, State)

SELECT PropertyAddress
FROM NashvilleHousing
--WHERE PropertyAddress is NULL
--ORDER BY ParcelID

--Use a substring and using character index

SELECT
Substring(PropertyAddress, 1, CHARINDEX(',',PropertyAddress)-1) AS Address
, SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress)+1, LEN(PropertyAddress)) AS Address
FROM NashvilleHousing

-- Adding a Table
ALTER TABLE NashvilleHousing
Add PropertySplitAddress nvarchar(255);

UPDATE NashvilleHousing
SET PropertySplitAddress = Substring(PropertyAddress, 1, CHARINDEX(',',PropertyAddress)-1)

-- Adding a Table
ALTER TABLE NashvilleHousing
Add PropertySplitCity nvarchar(255);

UPDATE NashvilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress)+1, LEN(PropertyAddress))

--REVIEWING
SELECT *
FROM NashvilleHousing

--Owner Address (PARSING)
SELECT OwnerAddress
FROM NashvilleHousing

SELECT 
PARSENAME(REPLACE(OwnerAddress, ',','.'),3),
PARSENAME(REPLACE(OwnerAddress, ',','.'),2),
PARSENAME(REPLACE(OwnerAddress, ',','.'),1)
FROM NashvilleHousing

 -- Adding a Table for Address
ALTER TABLE NashvilleHousing
Add OwnerSplitAddress nvarchar(255);

UPDATE NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',','.'),3)

-- Adding a Table
ALTER TABLE NashvilleHousing
Add OwnerSplitCity nvarchar(255);

UPDATE NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',','.'),2)

-- Adding a Table
ALTER TABLE NashvilleHousing
Add OwnerSplitState nvarchar(255);

UPDATE NashvilleHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',','.'),1)

SELECT *
FROM NashvilleHousing

--Change Y and N to Yes and No in Sold AS Vacant


SELECT SoldAsVacant,
CASE 
	WHEN SoldAsVacant = 'Y' THEN 'Yes'
	WHEN SoldAsVacant = 'N' THEN 'NO'
	ELSE SoldAsVacant
END
FROM NashvilleHousing

UPDATE NashvilleHousing
SET SoldAsVacant =	
CASE 
	WHEN SoldAsVacant = 'Y' THEN 'Yes'
	WHEN SoldAsVacant = 'N' THEN 'NO'
	ELSE SoldAsVacant
END

--Removing Duplication and Unused columns

WITH RowNumCTE AS 
(
SELECT *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
	PropertyAddress,
	SalePrice,
	SaleDate,
	LegalReference
	ORDER BY
	UniqueID
	) row_num

FROM NashvilleHousing
--ORDER BY ParcelID
)

SELECT *
FROM RowNumCTE

-- DELETE UNUSED COLUMNS

ALTER TABLE NashVilleHousing
DROP COLUMN SaleDate

SELECT *
FROM NashvilleHousing