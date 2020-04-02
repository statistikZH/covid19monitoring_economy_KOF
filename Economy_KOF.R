#select KOF variables
# Import libraries
require(tidyquant)
require(xts)
require(anytime)
library (readr)
library (lattice)
library(chron)
library(reshape)



################################
# Download data
urlfile="https://raw.githubusercontent.com/KOF-ch/economic-monitoring/master/data-statistikZH-monitoring/kof_indicators.csv"
kof<-data.frame(read_csv(url(urlfile)))
################################
# 


#write the final file for publication
write.table(kof, "Economy_KOF.csv", sep=",", fileEncoding="UTF-8", row.names = F)

