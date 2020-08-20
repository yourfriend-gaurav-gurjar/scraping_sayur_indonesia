library(tidyverse)
library(httr)
library(jsonlite)
library(lubridate)

url <- "https://api.pasarnow.com/api/appProductListNotLoggedIn?page=0&category=CAT-20-06-0000004&subcategory=" # the data from the first API URL 
json <- fromJSON(url) # Scraping the json from the URL
json$pages -> total_pages   # Total number of pages of Sayur products
json$total -> total_products  # Total number of products 
pages <- ceiling(total_products/total_pages) # Per page product listing

# Loop to scrape all the products in every page
for (pages in (0:pages)) {
  print(paste0("Getting data from page:", pages)) # Printing the message of all the pages step by step
  pages_url <- paste0("https://api.pasarnow.com/api/appProductListNotLoggedIn?page=", pages, "&category=CAT-20-06-0000004&subcategory=") # Scraping the data from all the URLs of API
  tmp_json <- fromJSON(pages_url)  # Extracting the JSON format from the every page
  tmp_json$products[["description"]] -> description  # Extracting description of the products
  tmp_json$products[["product_name"]] -> product_name # Extracting product names 
  tmp_json$products[["original_price"]] -> original_price # Extracting original prices of products
  tmp_json$products[["resale_price"]] -> resale_price # Extracting the resale prices of products
  data.frame(product_name, description, original_price, resale_price) -> tmp_df # Saving them in dataframe
  
  # Loop to save all the dataframe from the pages
  if(pages == 0){
    sayur_pasarnow <- data.frame(product_name, description, original_price, resale_price) # the first scraping dataframe
  } else {
    sayur_pasarnow <- rbind(sayur_pasarnow, tmp_df)  # Binding the every new dataframes to the existing ones
  }
}
scrape_date <- now() # Current Date
date_stamp <- scrape_date %>% format("%y%m%d") # Formatting the date in YYYY-MM-DD format
write_csv(sayur_pasarnow, path = paste0("scrape_sayur_pasarnow_", date_stamp, ".csv")) # Writing the dataframe into CSV file format