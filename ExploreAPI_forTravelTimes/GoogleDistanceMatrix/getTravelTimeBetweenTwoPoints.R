#' Created on Sat Sep 10 15:03:26 2016
#' 
#' author: christopher.brossman
#' 
#' This gets the time and duration between newport news and norfolk
#' using google https://developers.google.com/maps/documentation/distance-matrix/intro
#' 
#' this opens a csv and stores the information every fifteen minutes into a csv file using windows scheduler

library(RCurl)
library(jsonlite)

path = 'C:\\Users\\christopher.brossman\\Documents\\'
setwd(path)
fname = 'NorfolkToNewportNews_TravelTimes.csv'
df = read.csv(paste0(path,fname))

baseURL = 'https://maps.googleapis.com/maps/api/distancematrix/json?units=imperial&origins='
origin = 'Norfolk, VA'
destination = 'Newport News, VA'
YOUR_API_KEY = '<put your API key here>'

getTravelTime <- function(origin,destination,APIkey){
  baseURL = 'https://maps.googleapis.com/maps/api/distancematrix/json?units=imperial&'
  params <- paste0('destinations=',URLencode(destination),'&origins=',URLencode(origin),'&key=',URLencode(APIkey))
  url <- paste0(baseURL,params)
  r <- getURL(url)
  ts <- as.character(Sys.time())
  data <- fromJSON(r)
  distText <- data$rows$elements[[1]]$distance$text
  durText <- data$rows$elements[[1]]$duration$text
  info <- cbind.data.frame(Time = ts, dist = distText, duration = durText)
  return(info)
}

travelInfo <- getTravelTime(origin,destination,YOUR_API_KEY)
df <- rbind(df,travelInfo)
write.csv(df,paste0(path,fname,'.csv'))