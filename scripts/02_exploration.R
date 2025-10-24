# Exploratory Data Analysis Script

library(tidyverse)
library(skimr)
library(corrplot)

# Load cleaned data
df <- read.csv("../data/employee_data_clean.csv")

# Convert factors
df <- df %>%
  mutate(across(c(gender, department, promotion_last_5years, 
                  left_company, age_group, salary_category, 
                  tenure_category), as.factor))

# 1. COMPREHENSIVE SUMMARY
cat("=== COMPREHENSIVE DATA SUMMARY ===\n")
skim(df)

# 2. DEPARTMENT ANALYSIS
cat("\n=== DEPARTMENT BREAKDOWN ===\n")
dept_summary <- df %>%
  group_by(department) %>%
  summarise(
    count = n(),
    avg_salary = round(mean(salary)),
    avg_performance = round(mean(performance_score), 1),
    avg_satisfaction = round(mean(satisfaction_score), 1),
    turnover_rate = round(mean(left_company == "Yes") * 100, 1)
  ) %>%
  arrange(desc(avg_salary))

print(dept_summary)

# 3. CORRELATION ANALYSIS
cat("\n=== CORRELATION MATRIX ===\n")
numeric_data <- df %>%
  select(age, years_at_company, salary, performance_score, 
         satisfaction_score, projects_completed, training_hours, 
         overtime_hours)

cor_matrix <- cor(numeric_data, use = "complete.obs")
print(round(cor_matrix, 2))

# Save correlation plot
png("../outputs/figures/correlation_plot.png", width = 800, height = 800)
corrplot(cor_matrix, method = "color", type = "upper", 
         addCoef.col = "black", number.cex = 0.7,
         tl.col = "black", tl.srt = 45)
dev.off()

# 4. KEY INSIGHTS
cat("\n=== KEY INSIGHTS ===\n")

# Performance by department
perf_dept <- df %>%
  group_by(department) %>%
  summarise(avg_perf = mean(performance_score)) %>%
  arrange(desc(avg_perf))
cat("Top performing department:", perf_dept$department[1], "\n")

# Satisfaction by promotion status
sat_promo <- df %>%
  group_by(promotion_last_5years) %>%
  summarise(avg_sat = mean(satisfaction_score))
cat("\nAverage satisfaction (promoted):", 
    round(sat_promo$avg_sat[sat_promo$promotion_last_5years == "Yes"], 1), "\n")
cat("Average satisfaction (not promoted):", 
    round(sat_promo$avg_sat[sat_promo$promotion_last_5years == "No"], 1), "\n")

# Attrition analysis
attrition <- df %>%
  group_by(left_company) %>%
  summarise(
    count = n(),
    avg_satisfaction = mean(satisfaction_score),
    avg_overtime = mean(overtime_hours)
  )
print(attrition)

cat("\n=== EXPLORATION COMPLETE ===\n")
