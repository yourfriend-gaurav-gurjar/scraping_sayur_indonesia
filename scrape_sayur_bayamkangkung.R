library(RSelenium) # For Chrome Dev tools usage
library(rvest) # Harvesting the data from the internet
library(tidyverse) # Tidying data
library(httr) # http handling library
# uncomment the following line to install the library
#install.packages("splitstackshap", dependencies = T)
library(splitstackshape) # String manipulation library
library(lubridate) # Date related work on CSV
# Starting the remote driver
rD <- rsDriver(verbose = TRUE,
               port=6399L,
               browser = 'chrome',
               chromever = '83.0.4103.39',
               check = TRUE)
remDr <- rD[["client"]]
# Loading the URL of target
remDr$navigate("https://bayamkangkung.com/product-category/sayuran/")
Sys.sleep(2) 
# Hammering the LoadMoreButton for pulling out the entries of products over and over again until we get the last entry
repeat{
  loadMoreButton <- remDr$findElement(using = "css selector", "div.products-list-next")
  loadMoreButton$clickElement()
  Sys.sleep(3)
  
  webElem <- remDr$findElement("css", "body")
  
  htmlpage <- webElem$getPageSource()
  
  df_bayamkangkung <- read_html(htmlpage[[1]])
  button_text  <- df_bayamkangkung %>% html_node("div.products-list-next") %>% html_text() %>% trimws()
  
  button_text_temp  <- df_bayamkangkung %>% html_node("div.products-list-next") 
  if(is.na(button_text)) {
    article <- df_bayamkangkung %>% html_nodes("article.productbox")
    i <- 1
    product_temp = list()
    description_temp = list()
    price_temp = list()
    for (val in article) {
      product_temp[[i]] <- val %>% html_node("div.detail") %>% html_node("h3") %>% html_text() %>% trimws()
      description_temp[[i]] <- val %>% html_node("div.detail") %>% html_node("div.desc") %>% html_node("p") %>% html_text() %>% trimws() 
      price_temp[[i]] <- val %>% html_node("div.pricing") %>% html_text() %>% trimws()
      i <- i + 1
    }
    datalist <- data.frame(unlist(product_temp), unlist(description_temp), unlist(price_temp))
    names(datalist) <- c("product_name", "description", "price")
    break 
  }
}
# closing the driver
remDr$close()
# stopping the Selenium Driver
rD[['server']]$stop()
# cleaning the dataset
cleaned_data <- cSplit(datalist, "description", "|") %>%
  rename(unit = description_1, description_1 = description_2, description_2 = description_3, description_3 = description_4) %>% tibble()
# writing the CSV file
#write.table(cleaned_data,"./cleaned_data.csv", sep = ",", row.names = FALSE)

scrape_date <- now() # Current Date
date_stamp <- scrape_date %>% format("%y%m%d") # Formatting the date in YYYY-MM-DD format
write_csv(cleaned_data, path = paste0("scrape_sayur_bayamkangkung_", date_stamp, ".csv")) # Writing the dataframe into CSV file format
