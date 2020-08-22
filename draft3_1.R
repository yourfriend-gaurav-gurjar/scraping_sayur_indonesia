library(RSelenium)
library(rvest)
rD <- rsDriver(verbose = TRUE,
               port=5148L,
               browser = 'chrome',
               chromever = '83.0.4103.39',
               check = TRUE)
#rd <- rsDriver()
remDr <- rD[["client"]]

remDr$navigate("https://bayamkangkung.com/product-category/sayuran/")
loadMoreButton <- remDr$findElement(using = "css selector", "div.products-list-next")
Sys.sleep(2)
loadMoreButton$clickElement() 
Sys.sleep(2)
#loadMoreButton$clickElement() 
#Sys.sleep(2)
#loadMoreButton$clickElement() 
#Sys.sleep(2)

webElem <- remDr$findElement("css", "body")
htmlpage <- webElem$getPageSource()
Sys.sleep(5)

df_bayamkangkung <- read_html(htmlpage[[1]])
product <- df_bayamkangkung %>% html_nodes("div.detail") %>% html_nodes("h3") %>% html_text() %>% trimws()
description <- df_bayamkangkung %>% html_nodes("div.detail") %>% html_nodes("div.desc") %>% html_nodes("p") %>% html_text() %>% trimws()
price <- df_bayamkangkung %>% html_nodes("div.pricing") %>% html_text() %>% trimws()

data.frame(product, description, price)
#rD[['server']]$stop()
