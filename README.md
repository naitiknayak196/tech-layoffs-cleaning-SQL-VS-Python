# tech-layoffs-cleaning-SQL-VS-Python

## Overview
This project focuses on cleaning and analyzing a dataset containing information on layoffs in the tech industry. The dataset includes details on affected companies, industries, locations, and funding levels. The goal is to clean and process the data using **both MySQL and Python (Pandas)** to compare their effectiveness in handling data cleaning and analysis.

## 📂 Files in This Repository
- **layoffs_cleaning.sql** – SQL script for cleaning the dataset using MySQL.
- **layoffs_cleaning.ipynb** – Jupyter Notebook replicating the cleaning process using Python (Pandas).
- **layoffs.csv** – The original raw dataset.
- **layoffs_cleaned.csv** – The cleaned dataset after processing.
- **README.md** – This file, which provides project details and comparisons between MySQL and Python.

## Data Cleaning Process
### **Using MySQL**
1. Created a staging table to preserve raw data.
2. Identified and removed duplicates using `ROW_NUMBER()`.
3. Standardized company and country names using `TRIM()` and `LIKE`.
4. Converted the `date` column to a proper `DATE` format using `STR_TO_DATE()`.
5. Handled missing values by filling them based on related records.
6. Removed rows where critical numerical values were missing.
7. Performed analysis on layoffs by industry, company, country, and year.

### **Using Python (Pandas)**
1. Loaded the dataset using Pandas.
2. Removed duplicates with `groupby()` and `cumcount()`.
3. Standardized text fields by converting them to lowercase and stripping special characters.
4. Converted the `date` column to `datetime` format using `pd.to_datetime()`.
5. Filled missing values using grouped data (mode per country).
6. Identified and removed outliers using the interquartile range (IQR) method.
7. Analyzed layoffs by company, industry, country, and year.

## 🔍 **MySQL vs. Python (Pandas): A Comparison**
| Feature                | MySQL                              | Python (Pandas)                  |
|------------------------|---------------------------------|----------------------------------|
| **Duplicate Removal**  | Uses `ROW_NUMBER()` & `DELETE` | Uses `groupby().cumcount()` & `drop_duplicates()` |
| **Text Standardization** | Uses `TRIM()` & `LIKE`          | Uses `str.strip()` & `apply()`  |
| **Date Conversion**    | Uses `STR_TO_DATE()` & `ALTER`  | Uses `pd.to_datetime()`         |
| **Handling Missing Data** | Uses `UPDATE` & `JOIN` | Uses `fillna()` & `map()` |
| **Performance**        | Faster for large structured data | More flexible for complex transformations |
| **Ease of Use**        | Requires SQL queries            | More programmatic and adaptable |

## 🏆 Key Takeaways
- **MySQL** is efficient for handling structured datasets stored in databases.
- **Python (Pandas)** is more flexible for complex data transformations and analysis.
- Both approaches work well, but **Python simplifies handling missing values dynamically**.

## 🚀 How to Use This Repository
### **Running MySQL Script**
1. Import `layoffs.csv` into MySQL.
2. Execute `layoffs_cleaning.sql`.
3. Query `layoffs_clean2` for the cleaned dataset.

### **Running Python Script**
1. Open `layoffs_cleaning.ipynb` in Jupyter Notebook.
2. Run all cells to process the dataset.
3. The cleaned dataset will be saved as `layoffs_cleaned.csv`.

## 📢 Insights & Discussion
This project explores **layoff trends in the tech industry**, highlighting affected companies, industries, and regions. The **comparison between MySQL and Python** demonstrates how both tools handle data cleaning efficiently but with different strengths.

---
### 🌟 **Contributions & Feedback**
If you have suggestions or improvements, feel free to contribute or raise an issue!

---
 **Author:** Naitik Nayak


