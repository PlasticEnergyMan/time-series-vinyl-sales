# Time Series Analysis of U.S. Vinyl Record Sales

## Overview
This project analyzes U.S. vinyl record sales data to model long-term trends and generate forecasts using time series methods. The goal is to compare competing models and assess forecast uncertainty for future sales.

## Methods
- Exploratory time series analysis
- Stationarity testing (ADF test)
- ARIMA modeling
- Exponential smoothing
- Model comparison using AIC and residual diagnostics

## Evaluation
Models were evaluated using AIC, residual tests, and forecast behavior. Competing ARIMA specifications were compared to identify stable short- and long-term forecasts.

## Key Findings
- Vinyl sales from 2000–2024 show a strong upward trend with no clear seasonal component  
- ARIMA models outperformed exponential smoothing based on AIC and residual diagnostics  
- ARIMA(1,1,0) and ARIMA(2,1,0) produced the most stable forecasts with narrower confidence intervals  
- Forecasts indicate continued growth, with uncertainty increasing over longer horizons  

## Data
The dataset consists of annual U.S. vinyl record sales figures sourced from public RIAA data. The raw data file is not included in this repository.

## Repo Structure
- `analysis/`: R script containing time series analysis and forecasting
- `report/`: final project report (PDF)

## How to Run
1. Open the script in `analysis/` using RStudio  
2. Install required packages listed at the top of the file  
3. Run the script sequentially to reproduce analysis and forecasts
