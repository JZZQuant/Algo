library(RJSONIO)
library(tm)
library(wordcloud)
library(class)
options(stringsAsFactors = FALSE)
df.raw<-read.csv('Mails.CSV')
specimen1<-readLines('mail.txt',warn=F)
specimen2<-readLines('glass.txt',warn=F)
df.raw[nrow(nrow(df.raw))+1,]<-c(NA,paste(specimen1, collapse = ''),NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA)
df.raw[nrow(nrow(df.raw))+2,]<-c(NA,paste(specimen2, collapse = ''),NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,NA)
#Loading Data in R --------------------------------------------------------------------------------------------------
df.raw$Body<-gsub("From:.*","",df.raw$Body)
df.raw$Body<-gsub("Join Lync Meeting.*","",df.raw$Body)

df.raw$Body<-gsub("\\s+www\\S+","",df.raw$Body)
df.raw$Body<-gsub("\\s+WWW\\S+","",df.raw$Body)

df.raw$Body<-gsub("\\s+http\\S+","",df.raw$Body)
df.raw$Body<-gsub("\\s+HTTP\\S+","",df.raw$Body)

df.raw$Body<-gsub("regards.*","",df.raw$Body)
df.raw$Body<-gsub("Regards.*","",df.raw$Body)


df.raw$Body<-gsub("thanks.*","",df.raw$Body)
df.raw$Body<-gsub("Thanks.*","",df.raw$Body)

# df.raw$From...Name.<-as.factor(df.raw$From...Name.[])
mailcorp<-Corpus(VectorSource(df.raw$Body))
clean <- tm_map(mailcorp, content_transformer(tolower))
clean<-tm_map(clean,removeNumbers)
clean<-tm_map(clean,removeWords,stopwords())
clean<-tm_map(clean,removePunctuation)
clean<-tm_map(clean,stripWhitespace)
dtm<-DocumentTermMatrix(clean)
dtm <- removeSparseTerms(dtm, 0.90)
df.dtm<-as.data.frame(data.matrix(dtm))
dtm.author<-as.data.frame(as.factor(df.raw$From...Name.))

# Random sample 70% for training of data mining model; remainder for test
train.idx <- sample(nrow(df.dtm)-2, ceiling(nrow(df.dtm) * .70))
test.idx <- (1:nrow(df.dtm))[- train.idx]

# K-nearest Neighbor
knn.pred <- knn(df.dtm[train.idx, ], df.dtm[test.idx, ], dtm.author[train.idx,],k=1,prob=T)
prob<-attr(knn.pred,"prob")
# Confusion Matrix
conf.mat <- table("Predictions" = knn.pred, Actual = dtm.author[test.idx,])

# Accuracy
(accuracy <- sum(diag(conf.mat))/length(test.idx) * 100)

mail<-knn.pred[length(test.idx)-1]
glass<-knn.pred[length(test.idx)]

mail
glass

wordcloud(clean, min.freq = 40, random.order = FALSE,colors=brewer.pal(8, "Dark2"))

