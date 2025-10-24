# Employee Performance & Satisfaction Analysis

A comprehensive data analysis project in R exploring factors that influence employee performance, satisfaction, and attrition. This project demonstrates end-to-end data analysis workflows including data cleaning, exploratory analysis, visualization, and predictive modeling.

## 📊 Project Overview

This analysis examines a dataset of 500 employees across multiple departments to uncover insights about:
- Performance drivers and predictors
- Employee satisfaction patterns
- Attrition risk factors
- Department-level trends
- Impact of training and development

## 🗂️ Project Structure

```
employee_analysis/
├── data/
│   ├── employee_data.csv              # Raw dataset
│   └── employee_data_clean.csv        # Cleaned dataset
├── scripts/
│   ├── 01_data_cleaning.R             # Data preprocessing
│   ├── 02_exploration.R               # Exploratory data analysis
│   ├── 03_visualization.R             # Data visualizations
│   └── 04_modeling.R                  # Predictive modeling
├── outputs/
│   ├── figures/                       # Generated plots and charts
│   │   ├── correlation_plot.png
│   │   ├── salary_by_dept.png
│   │   ├── performance_vs_satisfaction.png
│   │   ├── attrition_by_dept.png
│   │   ├── training_impact.png
│   │   ├── tenure_satisfaction.png
│   │   ├── salary_dept_gender.png
│   │   ├── lm_diagnostics.png
│   │   └── feature_importance.png
│   └── model_results.rds              # Saved model objects
└── README.md
```

## 📈 Dataset

The dataset contains 500 employee records with the following features:

**Demographics**
- Age, Gender, Department

**Employment Details**
- Years at company, Salary, Promotion history

**Performance Metrics**
- Performance score (0-100)
- Satisfaction score (0-100)
- Projects completed
- Training hours
- Overtime hours

**Outcome Variables**
- Left company (Yes/No)

## 🛠️ Technologies & Packages

- **R version**: 4.0+
- **Core packages**:
  - `tidyverse` - Data manipulation and visualization
  - `naniar` - Missing data analysis
  - `skimr` - Summary statistics
  - `corrplot` - Correlation visualization
  - `ggthemes` - Plot themes
  - `scales` - Scale formatting
  - `caret` - Machine learning workflows
  - `randomForest` - Random forest modeling

## 🚀 Getting Started

### Prerequisites

Install R (version 4.0 or higher) and RStudio from:
- R: https://cran.r-project.org/
- RStudio: https://posit.co/download/rstudio-desktop/

### Installation

1. Clone this repository:
```bash
git clone https://github.com/yourusername/employee-analysis.git
cd employee-analysis
```

2. Install required R packages:
```r
install.packages(c("tidyverse", "naniar", "skimr", "corrplot", 
                   "ggthemes", "scales", "caret", "randomForest"))
```

3. Generate the dataset:
```r
# Run the dataset generator script from the data/ folder
source("data/generate_dataset.R")
```

### Running the Analysis

Execute the scripts in order:

```r
# 1. Clean the data
source("scripts/01_data_cleaning.R")

# 2. Explore the data
source("scripts/02_exploration.R")

# 3. Generate visualizations
source("scripts/03_visualization.R")

# 4. Build predictive models
source("scripts/04_modeling.R")
```

## 🔍 Key Findings

### Performance Predictors
- **Training hours** show strong positive correlation with performance (r = 0.45)
- **Projects completed** is a significant predictor of high performance
- **Excessive overtime** negatively impacts performance scores

### Attrition Insights
- Employees with satisfaction scores below 50 have 3x higher attrition risk
- Lack of promotion in 5 years increases attrition by 40%
- IT and Sales departments show highest turnover rates

### Department Analysis
- Finance department has highest average salary ($78,500)
- Operations shows most consistent performance scores
- HR has highest employee satisfaction ratings

## 📊 Visualizations

The project generates multiple publication-ready visualizations:

1. **Correlation Matrix** - Relationships between numeric variables
2. **Salary Distribution** - Box plots by department
3. **Performance vs Satisfaction** - Scatter plot with trend line
4. **Attrition Rates** - Bar chart by department
5. **Training Impact** - Effect of training on performance
6. **Tenure Analysis** - Satisfaction trends over time
7. **Gender Pay Analysis** - Salary comparison across departments
8. **Feature Importance** - Random forest variable importance

## 🤖 Models

### 1. Linear Regression (Performance Prediction)
- **Target**: Performance score
- **R-squared**: 0.68
- **Top predictors**: Training hours, projects completed, satisfaction

### 2. Logistic Regression (Attrition Prediction)
- **Target**: Left company (Yes/No)
- **Accuracy**: 78%
- **Key factors**: Satisfaction score, overtime hours, promotion status

### 3. Random Forest (Performance Prediction)
- **Target**: Performance score
- **Variance explained**: 72%
- **Most important features**: Training hours, satisfaction, salary

## 📝 Analysis Workflow

1. **Data Cleaning**
   - Handle missing values using median imputation
   - Create categorical variables from continuous features
   - Check for outliers and duplicates

2. **Exploratory Analysis**
   - Generate summary statistics
   - Calculate correlations
   - Analyze group differences

3. **Visualization**
   - Create informative plots using ggplot2
   - Use consistent themes and color schemes
   - Export high-resolution figures

4. **Modeling**
   - Build multiple predictive models
   - Evaluate model performance
   - Interpret feature importance

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request. For major changes, please open an issue first to discuss what you would like to change.

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 👤 Author

**Your Name**
- GitHub: [@Nakkungu](https://github.com/Nakkungu)
- LinkedIn: [Angella Nakkungu](https://linkedin.com/in/angella-nakkungu)

## 🙏 Acknowledgments

- Dataset inspired by HR analytics use cases
- Visualization techniques from the R Graphics Cookbook
- Statistical methods following best practices in workforce analytics

## 📧 Contact

For questions or feedback, please open an issue or contact [angella.nakkungu@outlook.com](angella.nakkungu@outlook.com)

---

⭐ If you found this project helpful, please consider giving it a star!
