# Data Visualization Script

library(tidyverse)
library(ggthemes)
library(scales)

# Load data
df <- read.csv("../data/employee_data_clean.csv")
df <- df %>%
  mutate(across(c(gender, department, promotion_last_5years, 
                  left_company, age_group, salary_category, 
                  tenure_category), as.factor))

# Set theme
theme_set(theme_minimal() + 
          theme(plot.title = element_text(face = "bold", size = 14)))

# 1. SALARY DISTRIBUTION BY DEPARTMENT
p1 <- ggplot(df, aes(x = department, y = salary, fill = department)) +
  geom_boxplot(alpha = 0.7) +
  scale_y_continuous(labels = dollar_format()) +
  labs(title = "Salary Distribution by Department",
       x = "Department", y = "Salary") +
  theme(legend.position = "none",
        axis.text.x = element_text(angle = 45, hjust = 1))

ggsave("../outputs/figures/salary_by_dept.png", p1, width = 10, height = 6)

# 2. PERFORMANCE VS SATISFACTION
p2 <- ggplot(df, aes(x = satisfaction_score, y = performance_score)) +
  geom_point(alpha = 0.5, color = "steelblue") +
  geom_smooth(method = "lm", color = "red", se = TRUE) +
  labs(title = "Performance Score vs Satisfaction Score",
       x = "Satisfaction Score", y = "Performance Score")

ggsave("../outputs/figures/performance_vs_satisfaction.png", p2, width = 10, height = 6)

# 3. ATTRITION BY DEPARTMENT
p3 <- df %>%
  group_by(department, left_company) %>%
  summarise(count = n(), .groups = "drop") %>%
  group_by(department) %>%
  mutate(pct = count / sum(count) * 100) %>%
  filter(left_company == "Yes") %>%
  ggplot(aes(x = reorder(department, pct), y = pct, fill = department)) +
  geom_col() +
  coord_flip() +
  labs(title = "Attrition Rate by Department",
       x = "Department", y = "Attrition Rate (%)") +
  theme(legend.position = "none")

ggsave("../outputs/figures/attrition_by_dept.png", p3, width = 10, height = 6)

# 4. TRAINING HOURS IMPACT
p4 <- df %>%
  mutate(training_cat = cut(training_hours, breaks = 4, 
                            labels = c("Low", "Medium", "High", "Very High"))) %>%
  group_by(training_cat) %>%
  summarise(
    avg_performance = mean(performance_score),
    se = sd(performance_score) / sqrt(n())
  ) %>%
  ggplot(aes(x = training_cat, y = avg_performance, fill = training_cat)) +
  geom_col() +
  geom_errorbar(aes(ymin = avg_performance - se, ymax = avg_performance + se),
                width = 0.2) +
  labs(title = "Average Performance Score by Training Hours",
       x = "Training Hours Category", y = "Average Performance Score") +
  theme(legend.position = "none")

ggsave("../outputs/figures/training_impact.png", p4, width = 10, height = 6)

# 5. TENURE AND SATISFACTION
p5 <- ggplot(df, aes(x = years_at_company, y = satisfaction_score)) +
  geom_point(alpha = 0.3, color = "darkgreen") +
  geom_smooth(method = "loess", color = "orange", size = 1.5) +
  labs(title = "Satisfaction Score vs Years at Company",
       x = "Years at Company", y = "Satisfaction Score")

ggsave("../outputs/figures/tenure_satisfaction.png", p5, width = 10, height = 6)

# 6. COMPREHENSIVE DASHBOARD PLOT
p6 <- df %>%
  group_by(department, gender) %>%
  summarise(
    avg_salary = mean(salary),
    avg_performance = mean(performance_score),
    .groups = "drop"
  ) %>%
  ggplot(aes(x = department, y = avg_salary, fill = gender)) +
  geom_col(position = "dodge") +
  scale_y_continuous(labels = dollar_format()) +
  labs(title = "Average Salary by Department and Gender",
       x = "Department", y = "Average Salary",
       fill = "Gender") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

ggsave("../outputs/figures/salary_dept_gender.png", p6, width = 12, height = 6)

cat("All visualizations saved to ../outputs/figures/\n")
