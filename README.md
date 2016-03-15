# Introduction

This project came to mind when I wanted to check the hourly pattern of connections to my home router. The idea was to access devices table from the router via a password protected url at certain intervals and store the count of devices. The following code illustrates the devices table extraction process using **XML** and **httr** packages.

## Load packages

```{r warning=FALSE}
library(XML)
library(httr)
```

## Router specific parameters

We need the exact url for the devices page. This varies by router; please modify accordingly. Admin username and password are needed to authenticate access. Please note that if you are storing your login credentials in plaintext whith this code; use a temporary password or change your password afterwards.

```R
dev.url <- "http://192.168.0.1/device.htm" #this one is for my router; modify accordingly
user.name <- "adminUserName"
user.password <- "adminPassword" #remember to change your password afterwards
```

## Get the table

Again, this will depend on the html structure of the devices page. Please modify accordingly.

```R
dev.html <- GET(dev.url, authenticate(user.name, user.password)) #get the html
dev.html <- htmlParse(dev.html)
dev.html.table <- getNodeSet(dev.html, "//table")[[2]] #access devices table
dev.table <- readHTMLTable(dev.html.table, skip.rows = 1,
                     header = c("sno","ip","name", "mac"),
                     colClasses = c("numeric","character","character", "character"),
                     trim = TRUE, stringsAsFactors = FALSE)
dev.table #display table on console
```

```
##    sno           ip                     name               mac
## 1    1  192.168.0.2                       XX AA:BB:CC:00:11:DD
## 2    2  192.168.0.3                IPHONEXXX AA:BB:CC:00:11:DD
## 3    3  192.168.0.4                MACBOOKXX AA:BB:CC:00:11:DD
## 4    4  192.168.0.5 ANDROID-XXXXXXXXXXXXXXXX AA:BB:CC:00:11:DD
## 5    5  192.168.0.9                XXXXXXXXX AA:BB:CC:00:11:DD
## 6    6 192.168.0.10                XXXXXXXXX AA:BB:CC:00:11:DD
## 7    7 192.168.0.11                       XX AA:BB:CC:00:11:DD
## 8    8 192.168.0.12                XXXXXXXXX AA:BB:CC:00:11:DD
## 9    9 192.168.0.13                   IPHONE AA:BB:CC:00:11:DD
```

Voilà!

## Handling errors

In case the url returns error, the above code will return a blank table. The following code catches the error and reports error details.

```R
dev.html <- GET(dev.url, authenticate(user.name, user.password)) #get the html
if (http_error(dev.html)) print(http_status(dev.url)) else
  dev.html <- htmlParse(dev.html)
dev.html.table <- getNodeSet(dev.html, "//table")[[2]] #access devices table
dev.table <- readHTMLTable(dev.html.table, skip.rows = 1,
                     header = c("sno","ip","name", "mac"),
                     colClasses = c("numeric","character","character", "character"),
                     trim = TRUE, stringsAsFactors = FALSE)
dev.table #display table on console
```