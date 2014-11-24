library(RJSONIO)
library(wordcloud)
library(ggplot2)
#Loading Data in R --------------------------------------------------------------------------------------------------

setwd("C:/Users/Sasikanth.Raghava/Documents/git/bitbucket/algorithms/MachineLearning/Python/OneEBlog/Scrapped")
blogs<-list.files(pattern="\\.json")
bloglists<-lapply(blogs,fromJSON)
allblogs<-unlist(bloglists,recursive=F)
names(allblogs[[1]])
comments.count<- as.numeric(sapply(allblogs,function(x) {if(length(x[[4]])==1 && x[[4]]=="" ) 0 else length(x[[4]])}))
content<- as.character( sapply(allblogs,function(x) paste(x[[5]],collapse=" ")))

#most repeated tags
head(sort(table(as.factor(unlist(sapply(allblogs, function(x){unlist(x[['Tags']])})))),decreasing = T),40)
# time series analysis of blogs
qplot(as.Date(sapply(allblogs, function(x){unlist(x[['Date']])})))
#Time series analysis blog interactions
qplot(as.Date(sapply(allblogs, function(x){unlist(x[['Date']])}))[comments.count>0])
#un answered comments
qplot(as.Date(sapply(allblogs, function(x){unlist(x[['Date']])}))[comments.count=1])
#most tagged areas
head(sort(table(as.factor(unlist(sapply(allblogs, function(x){unlist(x[['Area']])})))),decreasing = T),40)
#top bloggers
head(sort(table(as.factor(unlist(sapply(allblogs, function(x){unlist(x[['Author']])})))),decreasing = T),50)
#ggplot2 and nlp of tm have conflicting issues
detach("package:ggplot2", unload=TRUE)

library(tm)
blogcorp<-Corpus(VectorSource(df$content))
clean<-tm_map(blogcorp,tolower)
clean<-tm_map(blogcorp,removeNumbers)
clean<-tm_map(clean,removeWords,stopwords())
clean<-tm_map(clean,removePunctuation)
clean<-tm_map(clean,stripWhitespace)
clean <- tm_map(clean, PlainTextDocument)
wordcloud(clean, min.freq = 40, random.order = FALSE)
dtm<-DocumentTermMatrix(clean)
#dtm<-removeSparseTerms(dtm, 0.97)
onedict<-findFreqTerms(dtm,lowfreq=1, highfreq=10)
onetrain <- DocumentTermMatrix(clean,list(dictionary = onedict))
#convert_counts <- function(x) {x <- ifelse(x > 0, 1, 0); x <- factor(x, levels = c(0, 1), labels = c("No", "Yes")); return(x)}
# convert to a markhov stochaistic matrix
convert_counts <- function(x) {x <- ifelse(x > 0, 1, 0); return(x)}
b.m <- apply(onetrain, MARGIN = 2, convert_counts)
m.m<-t(t(b.m)/colSums(b.m))

test<-11
#diiferential
d<-b.m-b.m[test,]
#normalize
b.m <- apply(b.m, MARGIN = 2, convert_counts)
#probabilistic scalling

