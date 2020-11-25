library(RSelenium)

library(rvest)

library(tidyverse)



system('docker run -d -p 4445:4444 selenium/standalone-chrome')

#system("docker restart portainer")

Sys.sleep(5)



selenium_server_name = "localhost"

shopee_user = "hermandr@gmail.com"

shopee_password = "Nawamrad1"



remDr <-  RSelenium::remoteDriver(
  
  remoteServerAddr = selenium_server_name,
  
  port = 4445L,
  
  browserName = "chrome"
  
)

url="https://seller.shopee.co.id"
remDr$open()
remDr$navigate(url)
remDr$getCurrentUrl(url)

# assert "https://seller.shopee.co.id/account/signin?next=%2F"



# Before login

cookies = remDr$getAllCookies()


  
#    Convert to tibble

cookies %>%  as.matrix %>% as_tibble(.name_repair = "unique") %>% rename(V1=1) %>% 
  
  mutate( domain = map_chr(V1,"domain"),
          
          httpOnly = map_chr(V1,"httpOnly"),
          
          expiry = map(V1,"expiry"),
          
          #exp_length = map_int(expiry,length),
          
          name = map_chr(V1,"name"),
          
          path = map_chr(V1,"path"),
          
          secure = map_chr(V1,"secure"),
          
          value = map_chr(V1,"value")
          
  ) -> before_cookies



# Focus on username input dialog

Sys.sleep(5)

#                             #app > div.app-container > div > div > div > div > div.login.col-6 > div > div > div > form > div:nth-child(1) > div > div > div > div > input

webElem <- remDr$findElement(using = "css",
                             
                             '#app > div.app-container > div > div > div > div > div.login.col-6 > div > div > div > form > div:nth-child(1) > div > div > div > div > input')

#                            '#app > div.app-container > div > div > div > div > div.login.col-6 > div > div > div > form > div:nth-child(1) > div > div > div > div > input')



# Enter user name and password

webElem$sendKeysToElement(list(shopee_user,key="tab",
                               
                               shopee_password))



# Before click login

remDr$getCurrentUrl()

# assert "https://seller.shopee.co.id/account/signin?next=%2F"



# Show screen

remDr$maxWindowSize()

remDr$screenshot(file="before_login.png")



# Click on login button

#                             #app > div.app-container > div > div > div > div > div.login.col-6 > div > div > div > form > button

webElem <- remDr$findElement(using = "css",
                             
                             '#app > div.app-container > div > div > div > div > div.login.col-6 > div > div > div > form > button')

webElem$clickElement()



# wait 5 secs to render

Sys.sleep(5)



# after login

remDr$getCurrentUrl()

# assert "https://seller.shopee.co.id/"

# assert != "https://seller.shopee.co.id/account/signin?next=%2F"



remDr$maxWindowSize()

remDr$screenshot(file="after_login.png")



# After login get cookies

cookies = remDr$getAllCookies()

cookies %>%  as.matrix %>% as_tibble(.name_repair = "unique") %>% rename(V1=1) %>%
  
  mutate( domain = map_chr(V1,"domain"),
          
          httpOnly = map_chr(V1,"httpOnly"),
          
          expiry = map(V1,"expiry"),
          
          #exp_length = map_int(expiry,length),
          
          name = map_chr(V1,"name"),
          
          path = map_chr(V1,"path"),
          
          secure = map_chr(V1,"secure"),
          
          value = map_chr(V1,"value")
          
  ) -> after_cookies



after_cookies %>% unnest(expiry) -> after_cookies_with_expiry



after_cookies %>%
  
  select(name,value) %>%
  
  mutate(cookie_string = paste(name,value,sep="=")) %>%
  
  summarise(big_cookie = paste0(cookie_string,collapse = ";")) %>% pull(big_cookie) %>% write("big_cookie.txt")



readr::write_csv(after_cookies %>% select(-V1, -expiry),path="cookies_all.csv")



write_csv(after_cookies_with_expiry %>% select(-V1),path="cookies_with_expiry.csv")






##################


https://seller.shopee.co.id/webchat/api/v1.2/mini/login?source=sc&_uid=0-240284413&_v=4.7.0&_api_source=sc


