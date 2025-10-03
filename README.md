# python_cleaning_data_project
Order Data Cleaning & Feature Engineering
📌 Overview

This project processes raw order data to produce a cleaned dataset with additional features for analysis. The notebook order_cleaned.ipynb demonstrates data cleaning, feature engineering, and exploratory data analysis (EDA).

✨ Key Features

Data Cleaning

Fixes invalid or missing dates

Handles null values in critical fields (OrderID, CustomerID, ShipCity)

Removes non-numeric or negative values in cost columns

Standardizes inconsistent formatting

Feature Engineering

DeliveryDays: Days between order and shipment

DeliveryStatus: Categorizes shipments as OnTime, Late, or Unknown

IsDomestic: Flags local vs. international orders

Analysis

Grouping and aggregation for insights

Exploratory Data Analysis (EDA) on order distributions, missing values, and patterns

Output

A cleaned dataset suitable for analytics, reporting, or loading into a data warehouse

🛠️ Requirements

Install dependencies:

pip install pandas numpy matplotlib seaborn jupyter

🚀 Usage

Clone this repository or download the files.

Open the notebook:

jupyter notebook order_cleaned.ipynb


Run the cells step by step to clean and transform the dataset.

Export the final cleaned dataset for further analysis.

📂 Files

order_cleaned.ipynb — Main notebook for cleaning and feature engineering

Orders_with_issues.csv — Input dataset (raw)

orders_clean.csv (optional) — Cleaned dataset output

👤 Author

Created by [Your Name] — Data Engineering & Analytics
