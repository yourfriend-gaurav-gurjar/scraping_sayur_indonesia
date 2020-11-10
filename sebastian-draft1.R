library(RSelenium)
library(rvest)
library(tidyverse)
library(httr)

# Starting the remote driver
remDr <- remoteDriver(remoteServerAddr = "localhost", port = 4445L, browserName = "firefox")
remDr$open()
# remDr <- rD[["client"]]
# Loading the URL of target
remDr$navigate("https://coinmarketcap.com/currencies/bitcoin/historical-data/?start=20200101&end=20201103")

Sys.sleep(5)
# Selector
#__next > div.sc-1mezg3x-0.fHFmDM.cmc-app-wrapper.cmc-app-wrapper--env-prod.cmc-theme--day > div.container.cmc-main-section > div.cmc-main-section__content > div.aiq2zi-0.jvxWIy.cmc-currencies > div.v5fhlm-0.jdAFKL.cmc-details-panel-tabs.col-xs-12 > div > ul.cmc-tabs__body > li.sc-10kr9hg-0.eDLUd.cmc-tab.cmc-tab--selected > div > div > div.sc-1yv6u5n-0.gCAyTd.cmc-table > div:nth-child(3) > div > table > tbody

remDr$getTitle()

table_historical_data <- remDr$findElement(using = "css selector", "div.sc-1yv6u5n-0.gCAyTd.cmc-table")
htmlpage <- table_historical_data$getPageSource()
read_xml(table_historical_data)
df_table <- htmlpage %>%
  html_node("table") %>%
  html_node("tbody") %>%
  html_text() %>%
  trimws()

