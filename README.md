# Australian Student Visa Forecasting Analysis

**[📊 View Interactive Analysis Report](https://varun-2901.github.io/student-visa-forecasting/outputs/ANALYSIS_REPORT.html)** ← Click here!

A comprehensive time-series forecasting analysis of Australian international student visa grants using ARIMA, ETS, and Structural Regression models.

---

## 📊 Quick Summary

- **Dataset:** 21 years of Australian student visa data (2005-06 to 2025-26)
- **Data Source:** Department of Home Affairs Student Visa Program (BP0015)
- **Forecast:** 3-year projections (2026-27 to 2028-29)
- **Models:** ARIMA, ETS, Linear Regression (consensus: 337,500 annual visas)
- **Key Finding:** COVID-19 caused -60% decline in 2020-21, followed by +119% recovery in 2022-23

---

## 🎯 Project Highlights

✅ **Statistical Rigor** - ARIMA(1,1,0), ETS(AAN), structural regression with formal diagnostics  
✅ **Data Engineering** - ETL pipeline transforming raw Excel to processed CSVs  
✅ **Visualization** - 8 publication-quality charts with exploratory analysis  
✅ **Professional Report** - Interactive HTML dashboard with key findings  
✅ **Reproducible Code** - Fully documented R scripts, production-ready  

---

## 📁 Project Structure

```
student-visa-forecasting/
│
├── README.md                           # This file
├── LICENSE                             # MIT License
│
├── data/
│   ├── raw/
│   │   └── bp0015l-student-visas-granted-report-locked-at-2026-06-30-v100.xlsx
│   └── processed/
│       ├── student_visas_total.csv
│       ├── student_visas_by_type.csv
│       └── student_visas_detailed.csv
│
├── scripts/
│   ├── 01_data_processing.R            # Extract, clean, transform raw Excel
│   ├── 02_exploratory_analysis.R       # EDA visualizations & statistics
│   ├── 03_time_series_forecasting.R    # Fit ARIMA, ETS, and regression models
│   └── 04_generate_html_report_FIXED.R # Generate interactive HTML report
│
├── outputs/
│   ├── ANALYSIS_REPORT.html            # ⭐ Main deliverable - open in browser
│   │
│   ├── visualizations/
│   │   ├── 01_time_series.png          # 21-year historical trend
│   │   ├── 02_yoy_growth.png           # Year-on-year percentage changes
│   │   ├── 03_primary_secondary.png    # Applicant type breakdown
│   │   ├── 04_period_comparison.png    # Box plots by COVID period
│   │   ├── 05_forecast_comparison.png  # 3 models converging
│   │   ├── 06_arima_diagnostics.png    # Model stability check
│   │   ├── 07_acf_pacf.png             # Autocorrelation analysis
│   │   └── 08_regression_diagnostics.png # Residual validation
│   │
│   ├── models/
│   │   ├── 09_arima_model.rds
│   │   ├── 10_ets_model.rds
│   │   ├── 11_lm_model.rds
│   │   ├── 01_summary_statistics.rds
│   │   ├── 02_df_by_type.rds
│   │   └── 02_df_total.rds
│   │
│   └── summaries/
│       ├── 00_detailed_statistics.csv
│       ├── 05_forecast_summary.csv
│       └── 12_forecast_summary.rds
│
└── Statistical Forecasting of International Student Visa Growth.Rproj
```

---

## 🚀 Quick Start

### View the Report
Open `outputs/ANALYSIS_REPORT.html` in your web browser to see the interactive analysis with all visualizations.

### Reproduce the Analysis
Run the R scripts in order:

```r
# 1. Data processing (extract & clean)
source("scripts/01_data_processing.R")

# 2. Exploratory analysis (visualizations & stats)
source("scripts/02_exploratory_analysis.R")

# 3. Time-series modeling (ARIMA, ETS, regression)
source("scripts/03_time_series_forecasting.R")

# 4. Generate HTML report (optional - report already included)
source("scripts/04_generate_html_report_FIXED.R")
```

---

## 📈 Key Results

### Historical Analysis (2005-2026)
| Metric | Value |
|--------|-------|
| Mean Annual Visas | 313,475 |
| Peak Year (2022-23) | 577,295 |
| Minimum Year (2005-06) | 191,318 |
| YoY Range | -34.74% to +118.89% |

### COVID-19 Impact
| Period | Years | Mean Visas | Change |
|--------|-------|-----------|--------|
| Pre-COVID | 2005-2019 | 291,658 | +2.5% p.a. |
| Border Closure | 2020-2021 | 286,451 | -60% (2020-21) |
| Recovery Spike | 2022-2023 | 420,516 | +119% (2022-23) |
| Stabilization | 2024-2026 | 340,000+ | +5-10% p.a. |

### Forecast Consensus (2026-2029)
All three models converge on **~337,500 annual student visas**:
- **ARIMA(1,1,0):** 337,527
- **ETS(AAN):** ~340,000
- **Linear Regression:** 337,527

This represents stable equilibrium 16% above pre-pandemic levels but 36% below peak recovery.

---

## 🔬 Methodology

### ARIMA Modeling
- **Model:** ARIMA(1,1,0) selected via AIC
- **Purpose:** Captures temporal autocorrelation
- **Strength:** Handles non-stationary data effectively
- **Forecast:** 337,527 visas (stable baseline)

### Exponential Smoothing (ETS)
- **Model:** ETS(AAN) - Additive error, Additive trend, No seasonality
- **Purpose:** Flexible adaptive learning
- **Strength:** Works well with small datasets (21 obs)
- **Forecast:** ~340,000 visas

### Structural Regression
- **Model:** `visas ~ time_index + covid_indicator + recovery_indicator`
- **Purpose:** Explicitly model COVID-19 shock
- **Strength:** Interpretable policy impact quantification
- **Fit Quality:** R² = 0.94 (explains 94% of variance)
- **Forecast:** 337,527 visas
- **COVID Impact:** -88,306 visas (2020-21 shock)
- **Recovery Effect:** +62,301 visas (2022+ rebound)

### Model Validation
- Ljung-Box test: p = 0.82 (no serial correlation)
- Residuals: Centered at zero, normally distributed
- Confidence intervals: 95% bounds captured actual data

---

## 📊 Visualizations

**1. Historical Time Series** - Full 21-year trend with COVID-19 period highlighted in red

**2. Year-on-Year Growth** - Percentage changes revealing COVID shock (-35%) and recovery (+119%)

**3. Primary vs Secondary** - Consistent 85% primary / 15% secondary split across all periods

**4. Period Comparison** - Box plots showing distribution shifts across COVID phases

**5. Forecast Comparison** - Three models converging toward 337.5k consensus

**6. ARIMA Diagnostics** - Roots plot confirming model stability (all within unit circle)

**7. ACF/PACF Analysis** - Lag-1 autocorrelation indicating differencing requirement

**8. Regression Diagnostics** - Residuals vs fitted (homoscedasticity) + Q-Q plot (normality)

---

## 📖 How to Use

### For Recruiters/Stakeholders
1. Open `outputs/ANALYSIS_REPORT.html` in your browser
2. Review executive summary and key findings
3. Scroll through visualizations and forecast tables
4. Check model diagnostics section for technical rigor

### For Replication
1. Data flows through 3 sequential R scripts
2. Each script outputs to `outputs/` folder
3. CSV data in `data/processed/` is clean and ready
4. Model objects (RDS) stored for quick reload
5. All dependencies listed in code comments

### For Enhancement
- Add exogenous variables (AUD/INR exchange rate, source-country GDP)
- Implement multivariate ARIMAX models
- Develop real-time monitoring dashboard
- Incorporate policy change indicators
- Test GARCH models for variance forecasting

---

## 🛠️ Technical Stack

**Language:** R 4.x  
**Key Libraries:** tidyverse, forecast, ggplot2, lubridate, scales  
**Data Format:** Excel (raw) → CSV (processed) → RDS (models)  
**Visualization:** ggplot2  
**Report:** Self-contained HTML (no external dependencies)  

---

## 📊 Key Insights

**Finding 1: Structural Stability**
The 85% primary / 15% secondary applicant split remains consistent across all 21 years, even during COVID-19 border closures. This suggests structural demand patterns independent of short-term shocks.

**Finding 2: Policy-Driven Cycles**
Regression analysis clearly attributes visa volatility to policy changes (border closures, reopening) rather than demand-side factors. This enables evidence-based policy evaluation.

**Finding 3: Robust Convergence**
Three independent statistical methods (ARIMA, ETS, OLS) converge within 1% on forecast estimates, indicating model robustness and reduced forecast uncertainty.

**Finding 4: Recovery Plateau**
Post-recovery stabilization at 337k visas suggests new equilibrium ~16% above pre-pandemic but 36% below peak. This indicates sustainable normalized demand rather than temporary spike.

---

## 🎯 Recommendations

### For Policy Makers
- Plan processing capacity for 330-350k annual visas through 2028-29
- Expect stable demand without rapid fluctuations
- Monitor policy changes in competitor countries (UK, Canada, USA)

### For Universities
- Expect consistent international student recruitment at elevated levels
- Develop pipelines focused on primary applicants (85% of volume)
- Strengthen secondary applicant support (dependent visa pathways)

### For Future Analysis
- Incorporate causal variables (exchange rates, source-country GDP)
- Develop rolling forecasts with monthly data
- Build scenario models for policy changes
- Track leading indicators (visa applications, approval rates)

---

## 📝 Data Dictionary

### student_visas_total.csv
- `financial_year` - Financial year (2005-06 to 2025-26)
- `visas_granted` - Total student visas granted
- `yoy_pct_change` - Year-on-year percentage change
- `period` - COVID classification (Pre-COVID, Closure, Recovery, Post-Recovery)

### student_visas_by_type.csv
- `financial_year` - Financial year
- `applicant_type` - Primary or Secondary
- `visas_granted` - Count for each type
- `proportion` - Percentage of total

### student_visas_detailed.csv
- `financial_year` - Financial year
- `applicant_type` - Primary or Secondary
- `sector` - Education sector (University, Vocational, Secondary, Elicos, etc.)
- `visas_granted` - Count by sector

---

## 🎓 Analysis Timeline

| Year | Event | Impact |
|------|-------|--------|
| 2005-2019 | Steady growth | +2.5% annual baseline |
| 2020 | Border closure announcement | -60% shock |
| 2021 | Extended restrictions | -50% below pre-COVID |
| 2022 | Rapid reopening | +119% explosive recovery |
| 2023 | Peak demand | 577k visas (all-time high) |
| 2024-2026 | Stabilization | ~340k annual (new normal) |

---

## 📄 License

This project is licensed under the MIT License - see LICENSE file for details.

---

## 👤 Author

**Varun Sridhar**  
Data Engineering Analyst | Melbourne, Australia  
GitHub: [github.com/varun-2901](https://github.com/varun-2901)

---

## 📞 Questions?

For inquiries about methodology, model selection, or forecast accuracy, refer to the detailed diagnostics section in `outputs/ANALYSIS_REPORT.html`.

---

**Last Updated:** August 2026  
**Data Period:** 2005-06 to 2025-26  
**Forecast Horizon:** 2026-29  
