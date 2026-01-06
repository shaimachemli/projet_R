# ================================
# 01 - DATA EXPLORATION
# ================================

# Libraries
library(tidyverse)

# Load data
data <- read.csv("data/screen_time_children.csv", stringsAsFactors = FALSE)

# Dimensions
dim(data)

# Column names
names(data)

# Data structure
str(data)

# First rows
head(data, 10)

# Summary statistics (quick overview)
summary(data)

# Missing values per column
colSums(is.na(data))

# Unique values (categorical variables)
unique(data$Gender)
unique(data$Primary_Device)
unique(data$Urban_or_Rural)
unique(data$Health_Impacts)
