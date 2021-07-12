# How to shorten URLs with R 
# https://www.listendata.com/2021/06/how-to-shorten-urls-with-r.html?fbclid=IwAR1Cwpncd5I6IcuxO2gK_jKa9T9cupXAYMp0l6-Zw16FfGYPvghxsWsmhH0
# URL Shortener with R
#In the code below, we are using is.gd and v.gd API services. The only difference between them is that v.gd shows link preview and does not redirect automatically to the original long URL. Whereas is.gd will take you to the original automatically without showing any preview. By default linkPreview is set FALSE in the below user defined R function. 

library(httr)
library(jsonlite)

ShortURL <- function(link, linkPreview = FALSE) {
  
  api <- if(linkPreview) {"http://v.gd/create.php?format=json"} else {"http://is.gd/create.php?format=json"}
  query <- list(url = link)
  request <- httr::GET(api, query = query)
  content <- httr::content(request, as = "text", encoding = "utf-8")
  result <- jsonlite::fromJSON(content)
  
  return(result)
  
}

ShortURL("https://www.listendata.com/2021/01/run-sas-in-python-without-installation.html")

#Test if shortened URL is working

Shorter <- ShortURL("https://www.listendata.com/2021/01/run-sas-in-python-without-installation.html")
browseURL(Shorter$shorturl)

