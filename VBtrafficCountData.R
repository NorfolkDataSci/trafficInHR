#traffic counts from
#https://www.vbgov.com/government/departments/public-works/traffic/Pages/traffic-count-data.aspx

library(XML)

#get traffic data
tableHTML <- 'http://vbgov.ms2soft.com/tcds/rpt_AADT.aspx?a=72'
trafficData <- readHTMLTable(tableHTML, header=T, which=2,stringsAsFactors=F)

#intial data cleaning
keep <- c(1:5,7,9,11,13)
trafficData_clean1 <- trafficData[,keep]
#clean up "Â" from data set to NA
for(i in 5:NCOL(trafficData_clean1)){
  for(j in 1:NROW(trafficData_clean1)){
    if(trafficData_clean1[j,i] == "Â"){
      trafficData_clean1[j,i] <- NA
    }
    if(grepl(",",trafficData_clean1[j,i])){
      trafficData_clean1[j,i] <- gsub(",","",trafficData_clean1[j,i])
    }
  }
  trafficData_clean1[,i] <- as.numeric(trafficData_clean1[,i])
}

