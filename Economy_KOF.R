#select KOF variables
# Import libraries
require(tidyquant)
require(xts)
require(anytime)
library (readr)
library (lattice)
library(chron)
library(reshape)


urlfile="https://raw.githubusercontent.com/KOF-ch/economic-monitoring/master/data/ch.shab.csv"
shab<-data.frame(read_csv(url(urlfile)))
shabkeys<-read.table("shab_keys.csv", sep=";", encoding = "UTF-8", header=T)
shab$rubric<-as.factor(shab$rubric)
shab<-merge(shab, shabkeys, by.x="rubric", by.y="rubric", all.x=T)

shab2<-data.frame(date=as.POSIXct(paste(shab$time, "00:00:00", sep=" ")),
                      value=shab$value,
                      topic="Wirtschaft",
                      variable_short=shab$variable_short,
                      variable_long=shab$variable_long,
                      location="CH",
                      unit="Anzahl",
                      source="Schweizerisches Handelsamtsblatt SHAB",
                      update="täglich",
                      public="ja",
                      description="https://github.com/KOF-ch/economic-monitoring")


################################
# Download data
urlfile="https://raw.githubusercontent.com/KOF-ch/economic-monitoring/master/data-statistikZH-monitoring/kof_indicators.csv"
kof<-data.frame(read_csv(url(urlfile)))
################################
#jahre vor 2019 rausnehmen 

kof<-rbind(kof, shab2)
kof<-subset(kof, date>=as.Date("2019-01-01") & variable_short!="stellen_jobroom")

#write the final file for publication
write.table(kof, "Economy_KOF.csv", sep=",", fileEncoding="UTF-8", row.names = F)

range(kof$date)






