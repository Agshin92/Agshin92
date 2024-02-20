-- cleaning data in SQL Queries

select * from [Nasville Housing]..NashvilleHo


-- standardize date format

select SaleDateConverted, Convert(date,saledate)
from [Nasville Housing]..NashvilleHo


Update NashvilleHo
Set Saledate = COnvert(date,saledate)


ALTER TABLE NashvilleHo
Add SaleDateConverted Date;

Update NashvilleHo
Set SaleDateConverted = COnvert(date,saledate)



-- populate property address data

select *
from [Nasville Housing]..NashvilleHo
--where PropertyAddress is null
order by ParcelID




select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, isnull(a.PropertyAddress, b.PropertyAddress)
from [Nasville Housing]..NashvilleHo a
join [Nasville Housing]..NashvilleHo b
	on a.ParcelID=b.ParcelID
	and a.[UniqueID ]<>b.[UniqueID ]
where a.PropertyAddress is null



Update a
Set PropertyAddress=isnull(a.PropertyAddress, b.PropertyAddress)
from [Nasville Housing]..NashvilleHo a
join [Nasville Housing]..NashvilleHo b
	on a.ParcelID=b.ParcelID
	and a.[UniqueID ]<>b.[UniqueID ]
where a.PropertyAddress is null





-- Breaking out Address into Individual Columns (Address, City, State)

select PropertyAddress
from [Nasville Housing]..NashvilleHo
--where PropertyAddress is null
--order by ParcelID


select 
SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress)-1) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress) + 1, len(PropertyAddress)) as Address
from [Nasville Housing]..NashvilleHo



ALTER TABLE NashvilleHo
Add PropertySplitAddress Nvarchar(255);

Update NashvilleHo
Set PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress)-1)


ALTER TABLE NashvilleHo
Add PropertySplitCity Nvarchar(255);

Update NashvilleHo
Set PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress) + 1, len(PropertyAddress))


select * 
from [Nasville Housing]..NashvilleHo




select OwnerAddress
from [Nasville Housing]..NashvilleHo


select
parsename(replace(OwnerAddress, ',','.'), 3)
, parsename(replace(OwnerAddress, ',','.'), 2)
, parsename(replace(OwnerAddress, ',','.'), 1)
from [Nasville Housing]..NashvilleHo


ALTER TABLE NashvilleHo
Add OwnerSplitAddress Nvarchar(255);

Update NashvilleHo
Set OwnerSplitAddress = parsename(replace(OwnerAddress, ',','.'), 3)


ALTER TABLE NashvilleHo
Add OwnerSplitCity Nvarchar(255);

Update NashvilleHo
Set OwnerSplitCity = parsename(replace(OwnerAddress, ',','.'), 2)


ALTER TABLE NashvilleHo
Add OwnerSplitState Nvarchar(255);

Update NashvilleHo
Set OwnerSplitState = parsename(replace(OwnerAddress, ',','.'), 1)



select * from [Nasville Housing]..NashvilleHo






-- Change Y and N to Yes and No in "Sold as Vacant" field

select distinct(SoldAsVacant), count(SoldAsVacant)
from [Nasville Housing]..NashvilleHo
group by SoldAsVacant
order by 2


select SoldAsVacant
, case when SoldAsVacant = 'Y' then 'Yes'
	   when SoldAsVacant = 'N' then 'No'
	   else SoldAsVacant
	   end
from [Nasville Housing]..NashvilleHo



update NashvilleHo
set SoldAsVacant = case when SoldAsVacant = 'Y' then 'Yes'
	   when SoldAsVacant = 'N' then 'No'
	   else SoldAsVacant
	   end




-- remove duplicates

WITH RowNumCTE AS(
select *,
	row_number() over (
	partition by ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 order by 
					UniqueID
					) row_num
from [Nasville Housing]..NashvilleHo
--order by ParcelID
)
select * 
from RowNumCTE
where row_num > 1
order by PropertyAddress





-- delete unused columns

select * 
from [Nasville Housing]..NashvilleHo


alter table [Nasville Housing]..NashvilleHo
drop column OwnerAddress, TaxDistrict, PropertyAddress


alter table [Nasville Housing]..NashvilleHo
drop column SaleDate	