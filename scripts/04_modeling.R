# Statistical Modeling Script

library(tidyverse)
library(caret)
library(randomForest)

# Load data
df <- read.csv("../data/employee_data_clean.csv")
df <- df %>%
  mutate(across(c(gender, department, promotion_last_5years, 
                  left_company), as.factor))

# ===== MODEL 1: LINEAR REGRESSION - PREDICTING PERFORMANCE =====
cat("=== LINEAR REGRESSION MODEL ===\n")

# Select predictors
model_data <- df %>%
  select(performance_score, training_hours, projects_completed, 
         overtime_hours, years_at_company, satisfaction_score, 
         department)

# Build model
lm_model <- lm(performance_score ~ ., data = model_data)

# Model summary
cat("\nModel Summary:\n")
summary(lm_model)

# Model diagnostics
png("../outputs/figures/lm_diagnostics.png", width = 12, height = 10)
par(mfrow = c(2, 2))
plot(lm_model)
dev.off()

# Extract key insights
cat("\n=== KEY PREDICTORS ===\n")
coef_df <- as.data.frame(summary(lm_model)$coefficients)
coef_df$variable <- rownames(coef_df)
coef_df <- coef_df %>%
  filter(`Pr(>|t|)` < 0.05 & variable != "(Intercept)") %>%
  arrange(desc(abs(Estimate)))
print(coef_df[, c("variable", "Estimate", "Pr(>|t|)")])

# ===== MODEL 2: LOGISTIC REGRESSION - PREDICTING ATTRITION =====
cat("\n\n=== LOGISTIC REGRESSION MODEL ===\n")

# Prepare data
attrition_data <- df %>%
  mutate(left_binary = ifelse(left_company == "Yes", 1, 0)) %>%
  select(left_binary, satisfaction_score, overtime_hours, 
         years_at_company, promotion_last_5years, salary, 
         performance_score)

# Build model
logit_model <- glm(left_binary ~ ., 
                   data = attrition_data, 
                   family = binomial)

cat("\nModel Summary:\n")
summary(logit_model)

# Calculate odds ratios
cat("\n=== ODDS RATIOS ===\n")
odds_ratios <- exp(coef(logit_model))
or_df <- data.frame(
  Variable = names(odds_ratios),
  Odds_Ratio = round(odds_ratios, 3)
)
print(or_df)

# Model performance
predictions <- predict(logit_model, type = "response")
predicted_class <- ifelse(predictions > 0.5, 1, 0)
confusion <- table(Predicted = predicted_class, Actual = attrition_data$left_binary)

cat("\n=== CONFUSION MATRIX ===\n")
print(confusion)

accuracy <- sum(diag(confusion)) / sum(confusion)
cat("\nAccuracy:", round(accuracy * 100, 2), "%\n")

# ===== MODEL 3: RANDOM FOREST - FEATURE IMPORTANCE =====
cat("\n\n=== RANDOM FOREST MODEL ===\n")

# Prepare data
set.seed(123)
rf_data <- df %>%
  select(performance_score, training_hours, projects_completed,
         overtime_hours, years_at_company, satisfaction_score,
         salary, department, gender)

# Build model
rf_model <- randomForest(performance_score ~ ., 
                        data = rf_data,
                        ntree = 500,
                        importance = TRUE)

cat("\nModel Performance:\n")
print(rf_model)

# Feature importance
importance_df <- as.data.frame(importance(rf_model))
importance_df$variable <- rownames(importance_df)
importance_df <- importance_df %>%
  arrange(desc(`%IncMSE`))

cat("\n=== FEATURE IMPORTANCE ===\n")
print(importance_df[, c("variable", "%IncMSE", "IncNodePurity")])

# Plot feature importance
png("../outputs/figures/feature_importance.png", width = 10, height = 6)
varImpPlot(rf_model, main = "Feature Importance for Performance Prediction")
dev.off()

# ===== SAVE MODEL RESULTS =====
cat("\n=== SAVING MODEL RESULTS ===\n")

results <- list(
  linear_model = summary(lm_model),
  logistic_model = summary(logit_model),
  random_forest = rf_model,
  feature_importance = importance_df
)

saveRDS(results, "../outputs/model_results.rds")
cat("Models saved to ../outputs/model_results.rds\n")

cat("\n=== MODELING COMPLETE ===\n")
