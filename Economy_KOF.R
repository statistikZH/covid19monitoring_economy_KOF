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
shab<-data.frame(read.csv(url(urlfile)))


#filter out sundays and feasts (no shab-meldungen)
sun<-data.frame(sun=apply(with(shab, tapply(value, list(time, rubric), sum)), 1, sum)==0)
shab<-droplevels(subset(shab, time%in%rownames(sun)[sun$sun==F]))
shabkeys<-read.table("shab_keys.csv", sep=";", encoding = "UTF-8", header=T)
shab$rubric<-as.factor(shab$rubric)
shab<-merge(shab, shabkeys, by.x="rubric", by.y="rubric", all.x=T)
shab2<-data.frame(date=shab$time,
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

shab2<-shab2[order(shab2$variable_short, shab2$date),]
################################
# Download data
urlfile="https://raw.githubusercontent.com/KOF-ch/economic-monitoring/master/data-statistikZH-monitoring/kof_indicators.csv"
kof<-data.frame(read.csv(url(urlfile)))
################################
#jahre vor 2019 rausnehmen 

#kof<-rbind(kof, shab2)

kof<-subset(kof, as.Date(date)>=as.Date("2019-01-01") & as.Date(date)!=Sys.Date() & variable_short!="stellen_jobroom")

#write the final file for publication
kof<-kof[order(kof$variable_short, kof$date),]

write.table(kof, "Economy_KOF.csv", sep=",", fileEncoding="UTF-8", row.names = F)

range(as.Date(kof$date))






