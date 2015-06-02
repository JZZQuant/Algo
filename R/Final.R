library(RJSONIO)

#Loading Data in R --------------------------------------------------------------------------------------------------

#LabVIEW Data 
setwd("E:\\Dump\\DataAnalysis\\stack Overflow\\PageData\\Labview")
LVfiles<-list.files(pattern="\\.json")
LVjsonlist<-lapply(LVfiles,fromJSON)
lvdata<-unlist(LVjsonlist,recursive=F)

#Matlab data
setwd("E:\\Dump\\DataAnalysis\\stack Overflow\\PageData\\Matlab")
MatlabFiles<-list.files(pattern="\\.json")
Matlabjsonlist<-lapply(MatlabFiles,fromJSON)
MatlabData<-unlist(Matlabjsonlist,recursive=F)

#C++ data
setwd("E:\\Dump\\DataAnalysis\\stack Overflow\\PageData\\C++")
Cfiles<-list.files(pattern="\\.json")
Cjsonlist<-lapply(Cfiles,fromJSON)
Cdata<-unlist(Cjsonlist,recursive=F)

#Question date and answer data for all entries -----------------------------------------------------------------------

#LabVIEW
lvqdate<-strptime(as.character(sapply(lvdata,function(x) as.character(x$question$date[[1]]))),"%Y-%m-%d %H:%M:%S")
lvansdate<-strptime(as.character(sapply(lvdata,function(x) as.character(x$answers[[1]]$date[[1]]))),"%Y-%m-%d %H:%M:%S")

#Matlab
MatlabQuesData<-strptime(as.character(sapply(MatlabData,function(x) as.character(x$question$date[[1]]))),"%Y-%m-%d %H:%M:%S")
MatlabAnsDate<-strptime(as.character(sapply(MatlabData,function(x) as.character(x$answers[[1]]$date[[1]]))),"%Y-%m-%d %H:%M:%S")

#question date and answer data forall entries
CQuesdate<-strptime(as.character(sapply(Cdata,function(x) as.character(x$question$date[[1]]))),"%Y-%m-%d %H:%M:%S")
CAnsDate<-strptime(as.character(sapply(Cdata,function(x) as.character(x$answers[[1]]$date[[1]]))),"%Y-%m-%d %H:%M:%S")


#Getting Response Time, Month and Year posted --------------------------------------------------------------------------

#LabVIEW
x1<--(lvqdate-lvansdate)
x1[x1<0]=NA
LVmonth<- strftime(lvqdate, "%m")
LVyear <- strftime(lvqdate, "%y")
table1<-data.frame(lvqdate,lvansdate,x1,LVmonth,LVyear)

#Matlab
x2<--(MatlabQuesData-MatlabAnsDate)
x2[x2<0]=NA
MatlabMonth <- strftime(MatlabQuesData, "%m")
MatlabYear <- strftime(MatlabQuesData, "%y")
table2<-data.frame(MatlabQuesData,MatlabAnsDate,x2,MatlabMonth,MatlabYear)

#C++
x3<--(CQuesdate-CAnsDate)
x3[x3<0]=NA
CMonth <- strftime(CQuesdate, "%m")
CYear <- strftime(CQuesdate, "%y")
table3<-data.frame(CQuesdate,CAnsDate,x3,CMonth,CYear)


#response distribution , confines with statistical model 
par(mfrow=c(2,2))
hist(log(as.numeric(x1)), breaks=15, main="LabVIEW -- Response time distribution", xlab="Log response time", col = "Sky Blue")
hist(log(as.numeric(x2)), breaks=15, main="Matlab -- Response time distribution", xlab="Log response time", col = "lavender")
hist(log(as.numeric(x3)), breaks=15, main="C++ -- Response time distribution", xlab="Log response time", col = "8")


#can be merged to poisson distribution, monthly question and answer distribution exponential
hist(table1$lvqdate, "months", format = "%y", main="Month-wise graph for Frequency of LabVIEW questions", xlab="Month-wise")
hist(table1$lvansdate, "months", format = "%y")


