# Load necessary libraries
library(readr)
library(tibble)
library(dplyr)

# Load the data
book_reviews_df <- read_csv("book_reviews.csv")
# Use glimpse() to understand the dataset
glimpse(book_reviews_df)
#glimpse()
#Dataset Size: The dataset contains n rows and m columns. (glimpse() will tell you the exact number of rows and columns.)
#Column Names and Representations: The column names are shown, along with the first few entries of each column. This helps us understand what each column represents.
#Data Types: glimpse() also provides the data types of each column. It's important to check if any numeric data is stored as character strings.

#Check for Missing Values and Remove Incomplete Rows
# Check for missing values in each column
for (col in colnames(book_reviews_df)) {
  missing_count <- sum(is.na(book_reviews_df[[col]]))
  cat("Column:", col, "- Missing values:", missing_count, "\n")
}

# Create a new dataset without missing data
book_reviews_df_clean <- book_reviews_df %>% filter(complete.cases(.))
# Note the dimensions of the new dataset
cat("Original dimensions:", dim(book_reviews_df), "\n")
cat("New dimensions after removing missing data:", dim(book_reviews_df_clean), "\n")
#The complete.cases() function returns a logical vector indicating whether each row in the dataset has no missing values (TRUE if a row has no missing values, FALSE if it has any missing values).

#Standardize State Names
# Assume state column is named "Province_State"
# Choose to use full state names

book_reviews_df_clean <- book_reviews_df_clean %>%
  mutate(standardized_state = case_when(
    state %in% c("TX", "Texas") ~ "Texas",
    state %in% c("NY", "New York") ~ "New York",
    state %in% c("FL", "Florida") ~ "Florida",
    state %in% c("CA", "California") ~ "California",
    TRUE ~ state  # If the state is already in full form or not listed, keep as is
  ))

# Check the unique states
unique_states <- unique(book_reviews_df_clean$standardized_state)
print(unique_states)

#Convert Reviews to Numerical Form
# Convert reviews to numerical form
book_reviews_df_clean <- book_reviews_df_clean %>%
  mutate(review_num = case_when(
    review == "Poor" ~ 1,
    review == "Fair" ~ 2,
    review == "Good" ~ 3,
    review == "Great" ~ 4,
    review == "Excellent" ~ 5,
    TRUE ~ NA_real_
  ))

# Create a column for high reviews
book_reviews_df_clean <- book_reviews_df_clean %>%
  mutate(is_high_review = review_num >= 4)
book_reviews_df_clean

