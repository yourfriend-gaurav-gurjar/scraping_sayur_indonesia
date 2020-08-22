library(tidyverse)
library(httr)
library(jsonlite)

scrape_pasarnow <- function() {
  url <- "https://api.pasarnow.com/api/appProductListNotLoggedIn?page=0&category=CAT-20-06-0000004&subcategory="
  json$pages -> total_pages   # Total number of pages of Sayur products
  json$total -> total_products  # Total number of products 
  
path <- "https://api.pasarnow.com/api/appProductListNotLoggedIn?page=", pages, "&category=CAT-20-06-0000004&subcategory="
json <- fromJSON(url)
  
json$pages -> total_pages   # Total number of pages of Sayur products
json$total -> total_products  # Total number of products 

json$products

}

###################
url <- "https://api.pasarnow.com/api/appProductListNotLoggedIn?page=0&category=CAT-20-06-0000004&subcategory="
json <- fromJSON(url)
json$pages -> total_pages   # Total number of pages of Sayur products
json$total -> total_products  # Total number of products 
pages <- ceiling(total_products/total_pages)

for (pages in (0:pages)) {
  print(paste0("Getting data from page:", pages))
  pages_url <- paste0("https://api.pasarnow.com/api/appProductListNotLoggedIn?page=", pages, "&category=CAT-20-06-0000004&subcategory=")
  tmp_json <- fromJSON(pages_url)
  tmp_json$products[["description"]] -> description 
  tmp_json$products[["product_name"]] -> product_name
  tmp_json$products[["original_price"]] -> original_price
  tmp_json$products[["resale_price"]] -> resale_price
  data.frame(product_name, description, original_price, resale_price) -> tmp_df
  
  if(pages == 0){
    sayur_pasarnow <- data.frame(product_name, description, original_price, resale_price)
  } else {
    sayur_pasarnow <- rbind(sayur_pasarnow, tmp_df)
  }
}
View(sayur_pasarnow)
