# 1. Time Series Analysis: Death Statistics (UK & England/Wales)

#### Introduction

This project focuses on forecasting vital statistics related to annual death registrations in the UK, based on data from the Office for National Statistics (ONS) and regional agencies. The dataset includes age-standardized death counts, recorded by place of occurrence, not residence, with data typically registered within five days (though some delays may occur). Forecasting these death statistics is critical for public health planning and policymaking, helping authorities anticipate future trends and allocate resources effectively.

#### Execution

- Open `time_series_deaths.R` in RStudio.
- Ensure necessary packages are installed.
- Run the script to:
  - Load and preprocess the dataset
  - Conduct time series decomposition and stationarity tests
  - Forecast future death counts using ARIMA and Holt-Winters methods

#### Libraries Used

- `readxl` – Load Excel files
- `TTR` – Moving averages
- `ggplot2` – Visualization
- `forecast` – ARIMA, Holt-Winters models
- `tseries`, `zoo` – Stationarity testing and interpolation




# 2. Statistical Analysis using R: Wine Quality Analysis (Red & White Wine)

#### Introduction

This project investigates how physicochemical properties of wine influence its quality rating (scored from 0 to 10). The analysis includes exploratory data analysis, regression modeling, and statistical hypothesis testing. The goal is to identify which features most strongly predict wine quality and explore significant differences between red and white wines.

#### Analysis Workflow

- **Exploratory Data Analysis (EDA)**: Distributions, correlations, and relationships
- **Simple Linear Regression (SLR)**: Effect of alcohol content on quality
- **Multiple Linear Regression (MLR)**: Combined influence of multiple predictors
- Time series decomposition, seasonal adjustments, and stationarity tests are performed.
- **Hypothesis Testing**:
  - *T-test*: Quality difference between red and white wines
  - *-test*: Quality difference between red and white wines
  - *ANOVA*: Variation in alcohol content across quality levels
  - *Chi-Square Test*: Association between wine type and quality categories

These insights aim to guide winemakers in optimizing key chemical attributes that influence product quality.

####  Dataset Overview

- **Red Wine**: 1,599 records  
- **White Wine**: 4,898 records  
- **Features**: Continuous variables including alcohol, pH, sulphates, citric acid, residual sugar, etc.
- **Preprocessing**: Data was cleaned, merged, and checked for duplicates and missing values.

#### Execution

- Open `wine_quality_analysis.R` in RStudio.
- Install any missing packages.
- Run the script to:
  - Perform EDA with visualizations
  - Conduct statistical tests
  - Fit regression models and evaluate performance (RMSE)

#### Libraries Used

- `ggplot2` – Data visualization
- `dplyr` – Data manipulation
- `corrplot` – Correlation matrix
- `e1071`, `car` – Hypothesis testing and diagnostics


## Tools & Technologies

- R Programming Language
- RStudio IDE
- Libraries: `ggplot2`, `forecast`, `dplyr`, `car`, `corrplot`, `TTR`, `tseries`, `zoo`, `e1071`, `readxl`


