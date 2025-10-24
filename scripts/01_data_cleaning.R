# Load required libraries
library(tidyverse)
library(naniar)

# Read the data
df <- read.csv("../data/employee_data.csv")

# 1. INITIAL INSPECTION
cat("=== DATA STRUCTURE ===\n")
str(df)

cat("\n=== SUMMARY STATISTICS ===\n")
summary(df)

cat("\n=== MISSING VALUES ===\n")
miss_var_summary(df)

# 2. DATA CLEANING

# Convert character variables to factors
df <- df %>%
  mutate(
    gender = as.factor(gender),
    department = as.factor(department),
    promotion_last_5years = as.factor(promotion_last_5years),
    left_company = as.factor(left_company)
  )

# Check for duplicate employee IDs
cat("\n=== CHECKING DUPLICATES ===\n")
cat("Duplicate employee IDs:", sum(duplicated(df$employee_id)), "\n")

# Check for outliers (basic check)
cat("\n=== CHECKING FOR OUTLIERS ===\n")
numeric_cols <- df %>% select(where(is.numeric)) %>% names()

for(col in numeric_cols) {
  q1 <- quantile(df[[col]], 0.25, na.rm = TRUE)
  q3 <- quantile(df[[col]], 0.75, na.rm = TRUE)
  iqr <- q3 - q1
  outliers <- sum(df[[col]] < (q1 - 1.5*iqr) | df[[col]] > (q3 + 1.5*iqr), na.rm = TRUE)
  cat(col, "- Outliers:", outliers, "\n")
}

# 3. HANDLE MISSING VALUES
# For this analysis, we'll use median imputation for numeric variables
df_clean <- df %>%
  mutate(
    satisfaction_score = ifelse(is.na(satisfaction_score), 
                                median(satisfaction_score, na.rm = TRUE), 
                                satisfaction_score),
    training_hours = ifelse(is.na(training_hours), 
                           median(training_hours, na.rm = TRUE), 
                           training_hours),
    overtime_hours = ifelse(is.na(overtime_hours), 
                           median(overtime_hours, na.rm = TRUE), 
                           overtime_hours)
  )

# 4. CREATE DERIVED VARIABLES
df_clean <- df_clean %>%
  mutate(
    age_group = cut(age, breaks = c(0, 30, 40, 50, 100), 
                    labels = c("Under 30", "30-40", "40-50", "Over 50")),
    salary_category = cut(salary, breaks = 3, 
                         labels = c("Low", "Medium", "High")),
    tenure_category = cut(years_at_company, breaks = c(-1, 2, 5, 10, 100),
                         labels = c("New", "Mid", "Senior", "Veteran"))
  )

# 5. SAVE CLEANED DATA
write.csv(df_clean, "../data/employee_data_clean.csv", row.names = FALSE)

cat("\n=== CLEANING COMPLETE ===\n")
cat("Clean dataset saved to: ../data/employee_data_clean.csv\n")
cat("Original rows:", nrow(df), "\n")
cat("Clean rows:", nrow(df_clean), "\n")
cat("Remaining missing values:", sum(is.na(df_clean)), "\n")
