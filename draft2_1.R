library(tidyverse)
library(rvest)
library(httr)
library(RSelenium)

# Reading the html from the bayamkangkung website
bayamkangkung_readed <- read_html("https://bayamkangkung.com/product-category/sayuran/")

detail <- trimws(html_text(html_node(bayamkangkung_readed, css = "#product-549 > div > div.detail")))

rD <- rsDriver(verbose = TRUE,
               port=4837L,
               browser = 'chrome',
               chromever = '83.0.4103.39',
               check = TRUE)
remDr <- rD[["client"]]
remDr$navigate("https://bayamkangkung.com/product-category/sayuran/")
ViewAllButton <- remDr$findElement(using = "css selector", "div.products-list-next")
Sys.sleep(3)
ViewAllButton$clickElement()
Sys.sleep(3)

webElem <- remDr$findElement("css", "body")
webElem$sendKeysToElement(list(key = "end"))

Sys.sleep(10)
remDr$close()
rD[['server']]$stop()

htmlpage <- webElem$getPageSource()
Sys.sleep(5)
remDr$close()




test <- read_html(htmlpage[[1]])

singlepageScraper <- function(x) {
  
}
######################################





