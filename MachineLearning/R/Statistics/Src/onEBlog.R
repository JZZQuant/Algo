library(RJSONIO)

#Loading Data in R --------------------------------------------------------------------------------------------------

setwd("C:/Users/Sasikanth.Raghava/Desktop 3/Workspace/oneblog")
blogs<-list.files(pattern="\\.json")
bloglists<-lapply(blogs,fromJSON)
allblogs<-unlist(bloglists,recursive=F)
names(allblogs[[1]])
comments.count<- as.numeric(sapply(allblogs,function(x) length(x[[4]])))
content<- as.character( sapply(allblogs,function(x) paste(x[[5]],collapse=" ")) )
df<-data.frame(content=content,comments=comments.count)
install.packages("tm")
library(tm)
blogcorp<-Corpus(VectorSource(df$content))
clean<-tm_map(blogcorp,tolower)
clean<-tm_map(blogcorp,removenumbers)
clean<-tm_map(clean,removeWords,stopwords())
clean<-tm_map(clean,removePunctuation)
clean<-tm_map(clean,stripWhitespace)
dtm<-DocumentTermMatrix(clean)
install.packages("wordcloud")
library(wordcloud)
wordcloud(clean, min.freq = 40, random.order = FALSE)


onedict<-findFreqTerms(dtm, 5)
onetrain <- DocumentTermMatrix(clean,list(dictionary = onedict))
convert_counts <- function(x) {
  x <- ifelse(x > 0, 1, 0)
  x <- factor(x, levels = c(0, 1), labels = c("No", "Yes"))
  return(x)
}
onetrain <- apply(onetrain, MARGIN = 2, convert_counts)
install.packages("e1071")
library(e1071)
classifier <- naiveBayes(onetrain, comments.count)
