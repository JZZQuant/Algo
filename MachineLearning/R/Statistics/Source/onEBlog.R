library(RJSONIO)

#Loading Data in R --------------------------------------------------------------------------------------------------

setwd("C:\\Users\\Sasikanth.Raghava\\workspace\\OneEBlog\\ScrappedData")
blogs<-list.files(pattern="\\.json")
bloglists<-lapply(blogs,fromJSON)
allblogs<-unlist(bloglists,recursive=F)
