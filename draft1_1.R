library(c("httr", "jsonlite"))
library(broom)
library(tidyverse)
path <- "https://api.pasarnow.com/api/appProductListNotLoggedIn"
path2 <- "https://api.pasarnow.com/api/appProductListNotLoggedIn?category=CAT-20-06-0000004"
res = GET("https://api.pasarnow.com/api/appProductListNotLoggedIn")
df <- jsonlite::fromJSON(path)
jsonlite::fromJSON(path2)
write



url <- "https://api.pasarnow.com/api/appProductListNotLoggedIn?page=0&category=CAT-20-06-0000004&subcategory="

jsonlite::fromJSON(url)

pages <- jsonlite::fromJSON(url)$pages 
total <- jsonlite::fromJSON(url)$total


for (pages in (1:)) {
  print(paste0("Getting data from page:", ))
}
description <- jsonlite::fromJSON(url)$products[["description"]]
product_name <- jsonlite::fromJSON(url)$products[["product_name"]]
original_price <- jsonlite::fromJSON(url)$products[["original_price"]]
resale_price <- jsonlite::fromJSON(url)$products[["resale_price"]]

df <- tibble(product_name, description, original_price, resale_price)
df %>% View()
