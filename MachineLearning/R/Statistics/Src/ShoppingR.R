install.packages("stringr")
library(RODBC)
library(stringr)
dbhandle <- odbcDriverConnect('driver={SQL Server};server=localhost;database=Shopping2;trusted_connection=true')
res <- sqlQuery(dbhandle, 'select * from sys.Tables')
res<-as.array(res[[1]][c(1:63,65:74)])
alltables <-lapply(res,function(x) data.frame(sqlQuery(dbhandle, paste('select * from ', x) )))
applications <- data.frame(sqlQuery(dbhandle, 'select ApplicationId, RequestItemType, DisplayName, Reshoppable, NonSMS, SitewideInstall, Mandatory, ApplicationType, Cost, MarkedForDeletion, SMSInstallProgram, SMSUninstallProgram, TypeOfApproval, ApplicationRef, LastIconLocation, RentalSettings, DTStamp, ADIntegrated, UserADGroup, ComputerADGroup, OrderCompletedNotification, SmsCollectionId, SmsCollectionName, OneTimeApproval, NoOfRequests, AdditionalNotificationText, AdvertId, Comment, ExternalIdentifier, AppModelType, AppModelStatus, EnableADGroupRemoval, RevokeADGroupMembership, Enabled from tb_Application'))

# --Analytics--
mean(applications[applications$Cost>0,]$Cost)
hist(applications[applications$Cost>0,]$Cost)

#Make sure the package is installed 
library(stringr)
#Lets see if there is any correlation between display length and cost
costtab<-applications[applications$Cost>0,]
cor(str_length(costtab$DisplayName),costtab$Cost)
cor(str_length(costtab$Comment),costtab$Cost)

#relation between cost of the application vs approval requests
tapply(costtab$Cost,costtab$TypeOfApproval,mean)
tapply(applications$Cost,applications$TypeOfApproval,mean)
hist(applications$NoOfRequests)
plot(applications$NoOfRequests,applications$Cost)
