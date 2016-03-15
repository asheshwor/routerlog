library(XML)
library(httr)
dev.url <- "http://192.168.0.1/DEV_device.htm" #this one is for netgear router; modify accordingly
user.name <- "adminUserName"
user.password <- "adminPassword"
dev.html <- GET(dev.url, authenticate(user.name, user.password)) #get the html
dev.html <- htmlParse(dev.html) #see handling errors below
dev.html.table <- getNodeSet(dev.html, "//table")[[2]] #access devices table
dev.table <- readHTMLTable(dev.html.table, skip.rows = 1,
                     header = c("sno","ip","name", "mac"),
                     colClasses = c("numeric","character","character", "character"),
                     trim = TRUE, stringsAsFactors = FALSE)
dev.table #display table on console


#handling errors
if (http_error(dev.html)) print(http_status(dev.url)) else
  dev.html <- htmlParse(dev.html)