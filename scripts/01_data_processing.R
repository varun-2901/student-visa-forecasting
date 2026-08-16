# ============================================================================
# AUSTRALIAN STUDENT VISA FORECASTING PROJECT
# PURPOSE: Read raw Excel data, clean, and reshape to time series format
# ============================================================================

# Load libraries
library(tidyverse)
library(readxl)
library(lubridate)

cat("\n")
cat("================================================================================\n")
cat("DATA PROCESSING: Australian Student Visa Dataset\n")
cat("================================================================================\n\n")

# ============================================================================
# 1. SET UP DIRECTORIES
# ============================================================================

# Create output directories
if (!dir.exists("data")) dir.create("data")
if (!dir.exists("data/processed")) dir.create("data/processed")
if (!dir.exists("outputs")) dir.create("outputs")

cat("✓ Directories created/verified\n")

# ============================================================================
# 2. READ RAW EXCEL FILE
# ============================================================================

# File location
raw_file <- "data/bp0015l-student-visas-granted-report-locked-at-2026-06-30-v100.xlsx"

# Check if file exists
if (!file.exists(raw_file)) {
  cat("✗ Error: File not found at", raw_file, "\n")
  cat("  Make sure your Excel file is in the 'data' folder\n")
  stop("Raw data file not found")
}

# Read the raw data (header is in row 15, index 14)
df_raw <- read_excel(raw_file, sheet = "Granted (Month)", col_names = FALSE)

cat("✓ Raw Excel file loaded\n")
cat("  Dimensions:", nrow(df_raw), "rows x", ncol(df_raw), "columns\n")

# ============================================================================
# 3. EXTRACT HEADERS AND DATA
# ============================================================================

# Row 15 (index 14) contains the financial year headers
headers <- as.character(df_raw[15, 3:23])

cat("\n✓ Financial year headers extracted\n")
cat("  Years span from", headers[1], "to", headers[length(headers)], "\n")

# Extract data rows: Primary Total (row 23), Secondary Total (row 31), Grand Total (row 32)
# These correspond to indices 22, 30, 31 in 0-based indexing
# CORRECT: Match row indices dynamically by string search
row_primary <- fit_row <- which(apply(df_raw, 1, function(r) any(str_detect(r, "Primary Total"))))[1]
row_secondary <- which(apply(df_raw, 1, function(r) any(str_detect(r, "Secondary Total"))))[1]
row_grand <- which(apply(df_raw, 1, function(r) any(str_detect(r, "Grand Total"))))[1]

df_primary <- as.numeric(df_raw[row_primary, 3:23])
df_secondary <- as.numeric(df_raw[row_secondary, 3:23])
df_grand_total <- as.numeric(df_raw[row_grand, 3:23])

cat("✓ Data rows extracted:\n")
cat("  - Primary Total (row 23)\n")
cat("  - Secondary Total (row 31)\n")
cat("  - Grand Total (row 32)\n")

# ============================================================================
# 4. BUILD TIME SERIES DATAFRAME
# ============================================================================

# Create long format dataframe
df_ts <- tibble(
  financial_year = rep(headers, 3),
  applicant_type = c(
    rep("Primary Total", length(headers)),
    rep("Secondary Total", length(headers)),
    rep("Grand Total", length(headers))
  ),
  visas_granted = c(df_primary, df_secondary, df_grand_total)
) %>%
  mutate(visas_granted = as.numeric(visas_granted)) %>%
  drop_na(visas_granted) %>%
  arrange(financial_year)

cat("\n✓ Time series dataframe created\n")
cat("  Total records:", nrow(df_ts), "\n")
cat("  Applicant types:", n_distinct(df_ts$applicant_type), "\n")

# ============================================================================
# 5. ADD DATE COLUMN
# ============================================================================

# Convert financial year to date (end of FY = June 30)
# E.g., "2005-06" → "2006-06-30"
df_ts <- df_ts %>%
  mutate(
    # Extract start year from financial year (e.g., "2005" from "2005-06")
    start_year = as.numeric(str_extract(financial_year, "^\\d{4}")),
    # End year is start year + 1
    end_year = start_year + 1,
    # Create date at end of financial year (June 30)
    date = as.Date(paste0(end_year, "-06-30")),
    # Extract calendar year
    year = year(date)
  ) %>%
  select(date, financial_year, year, applicant_type, visas_granted) %>%
  arrange(date)

cat("✓ Date column added\n")
cat("  Date range:", min(df_ts$financial_year), "to", max(df_ts$financial_year), "\n")

# ============================================================================
# 6. CREATE TOTAL SERIES WITH GROWTH METRICS
# ============================================================================

df_ts_total <- df_ts %>%
  filter(applicant_type == "Grand Total") %>%
  select(date, financial_year, year, visas_granted) %>%
  arrange(date) %>%
  # Calculate year-over-year changes
  mutate(
    yoy_change = visas_granted - lag(visas_granted),
    yoy_pct_change = (yoy_change / lag(visas_granted)) * 100
  ) %>%
  # Add period labels based on COVID impact
  mutate(
    period = case_when(
      year < 2020 ~ "Pre-COVID",
      year %in% c(2020, 2021) ~ "COVID-19 Border Closure",
      year %in% c(2022, 2023) ~ "Recovery Phase",
      TRUE ~ "Post-Recovery"
    )
  )

cat("\n✓ Total series created with growth metrics\n")
cat("  Observations:", nrow(df_ts_total), "\n")

# ============================================================================
# 7. CREATE PRIMARY VS SECONDARY SERIES
# ============================================================================

df_ts_by_type <- df_ts %>%
  filter(applicant_type != "Grand Total") %>%
  select(date, financial_year, year, applicant_type, visas_granted) %>%
  pivot_wider(
    names_from = applicant_type,
    values_from = visas_granted
  ) %>%
  rename(primary = `Primary Total`, secondary = `Secondary Total`) %>%
  mutate(
    total = primary + secondary,
    primary_pct = (primary / total) * 100,
    secondary_pct = (secondary / total) * 100
  ) %>%
  arrange(date)

cat("✓ Primary vs. Secondary breakdown created\n")

# ============================================================================
# 8. EXPORT PROCESSED DATA
# ============================================================================

write_csv(df_ts_total, "data/processed/student_visas_total.csv")
write_csv(df_ts_by_type, "data/processed/student_visas_by_type.csv")
write_csv(df_ts, "data/processed/student_visas_detailed.csv")

cat("\n✓ Files exported:\n")
cat("  - data/processed/student_visas_total.csv\n")
cat("  - data/processed/student_visas_by_type.csv\n")
cat("  - data/processed/student_visas_detailed.csv\n")

# ============================================================================
# 9. PRINT SUMMARY STATISTICS
# ============================================================================

cat("\n")
cat("================================================================================\n")
cat("SUMMARY STATISTICS\n")
cat("================================================================================\n\n")

cat("Dataset: Australian Student Visa Grants\n")
cat("Time period:", df_ts_total$financial_year[1], "to", 
    df_ts_total$financial_year[nrow(df_ts_total)], "\n")
cat("Number of observations:", nrow(df_ts_total), "\n\n")

# Summary stats
summary_stats <- df_ts_total %>%
  summarise(
    mean_visas = mean(visas_granted),
    median_visas = median(visas_granted),
    min_visas = min(visas_granted),
    max_visas = max(visas_granted),
    sd_visas = sd(visas_granted),
    cv = (sd_visas / mean_visas) * 100
  )

cat("Mean annual visas:", format(round(summary_stats$mean_visas), big.mark = ","), "\n")
cat("Median annual visas:", format(round(summary_stats$median_visas), big.mark = ","), "\n")
cat("Min annual visas:", format(round(summary_stats$min_visas), big.mark = ","), "\n")
cat("Max annual visas:", format(round(summary_stats$max_visas), big.mark = ","), "\n")
cat("Std Dev:", format(round(summary_stats$sd_visas), big.mark = ","), "\n")

# YoY growth stats
growth_stats <- df_ts_total %>%
  filter(!is.na(yoy_pct_change)) %>%
  summarise(
    mean_growth = mean(yoy_pct_change),
    median_growth = median(yoy_pct_change),
    min_growth = min(yoy_pct_change),
    max_growth = max(yoy_pct_change),
    sd_growth = sd(yoy_pct_change)
  )

cat("\nYear-on-Year Growth Statistics:\n")
cat("Mean YoY Growth:", round(growth_stats$mean_growth, 2), "%\n")
cat("Median YoY Growth:", round(growth_stats$median_growth, 2), "%\n")
cat("Min YoY Growth (Max Decline):", round(growth_stats$min_growth, 2), "%\n")
cat("Max YoY Growth:", round(growth_stats$max_growth, 2), "%\n")

# Key turning points
cat("\n\nLargest YoY Changes:\n")
cat("Top 3 Growth Years:\n")
top_growth <- df_ts_total %>%
  filter(!is.na(yoy_pct_change)) %>%
  arrange(desc(yoy_pct_change)) %>%
  slice(1:3) %>%
  select(financial_year, visas_granted, yoy_pct_change, period)

for (i in 1:nrow(top_growth)) {
  row <- top_growth[i, ]
  cat(sprintf("  %s | Visas: %8.0f | YoY: %+6.1f%% | %s\n",
              row$financial_year, row$visas_granted, row$yoy_pct_change, row$period))
}

cat("\nTop 3 Decline Years:\n")
top_decline <- df_ts_total %>%
  filter(!is.na(yoy_pct_change)) %>%
  arrange(yoy_pct_change) %>%
  slice(1:3) %>%
  select(financial_year, visas_granted, yoy_pct_change, period)

for (i in 1:nrow(top_decline)) {
  row <- top_decline[i, ]
  cat(sprintf("  %s | Visas: %8.0f | YoY: %+6.1f%% | %s\n",
              row$financial_year, row$visas_granted, row$yoy_pct_change, row$period))
}

# Period summary
cat("\n\nVisas Granted by Period:\n")
period_summary <- df_ts_total %>%
  group_by(period) %>%
  summarise(
    n_years = n(),
    mean_visas = mean(visas_granted),
    median_visas = median(visas_granted),
    total_visas = sum(visas_granted),
    min_visas = min(visas_granted),
    max_visas = max(visas_granted),
    .groups = "drop"
  ) %>%
  arrange(factor(period, levels = c("Pre-COVID", "COVID-19 Border Closure", 
                                     "Recovery Phase", "Post-Recovery")))

for (i in 1:nrow(period_summary)) {
  row <- period_summary[i, ]
  cat(sprintf("%-30s | n=%2.0f | avg=%9.0f | total=%12.0f\n",
              row$period, row$n_years, row$mean_visas, row$total_visas))
}

cat("\n")
cat("================================================================================\n")
cat("✓ DATA PROCESSING COMPLETE\n")
cat("================================================================================\n")
cat("\nNext step: Run 02_exploratory_analysis.R\n\n")

# Save summary statistics to file
summary_list <- list(
  overall_stats = summary_stats,
  growth_stats = growth_stats,
  period_summary = period_summary
)

saveRDS(summary_list, "outputs/01_summary_statistics.rds")
cat("✓ Summary statistics saved to outputs/01_summary_statistics.rds\n\n")
