library(rvest)
library(stringr)
library(RSelenium)
library(httr)
library(tidyverse)

rD <- rsDriver(verbose = TRUE,
               port=5046L,
               browser = 'chrome',
               chromever = '83.0.4103.39',
               check = TRUE)
#rd <- rsDriver()
remDr <- rD[["client"]]

#remDr$navigate("https://bayamkangkung.com/product-category/sayuran/")
#loadMoreButton <- remDr$findElement(using = "css selector", "div.products-list-next")
#Sys.sleep(2)
#loadMoreButton$clickElement() 
#Sys.sleep(2)

#webElem <- remDr$findElement("css", "body")
#webElem$sendKeysToElement(list(key = "end"))
#Sys.sleep(10)


#htmlpage <- webElem$getPageSource()
#Sys.sleep(5)
## Stopping the Selenium Server
#rd[['server']]$stop()
#remDr$navigate("https://bayamkangkung.com/product-category/sayuran/")
path <- "https://bayamkangkung.com/product-category/sayuran/"
#webElem <- remDr$findElement("css", "body")
#htmlpage <- webElem$getPageSource()

detection <- str_detect(read_html(path), pattern = "Tampilkan lebih banyak")
###
countLoadMore <- 0
while detection == TRUE {
  loadMoreButton <- remDr$findElement(using = "css selector", "div.products-list-next")
  loadMoreButton$clickElement() 
  detection <- str_detect(read_html(path), pattern = "Tampilkan lebih banyak")
  countLoadMore + 1
  detection
  countLoadMore
}

htmlpage <- webElem$getPageSource()
# Closing the browser
remDr$close()
# Stopping Selenium server
rD[['server']]$stop()




#flag <- str_detect(htmlpage, pattern = "Tampilkan lebih banyak")


if flag == TRUE {
  print(paste0("Loading the data from the site"))
  loadMoreButton <- remDr$findElement(using = "css selector", "div.products-list-next")
  Sys.sleep(1)
  loadMoreButton$clickElement() 
  Sys.sleep(1)
} else {
  webElem <- remDr$findElement("css", "body")
  webElem$sendKeysToElement(list(key = "end"))
  Sys.sleep(5)
  htmlpage <- webElem$getPageSource()
  
}
## Stopping the Selenium Server
rD[['server']]$stop()

