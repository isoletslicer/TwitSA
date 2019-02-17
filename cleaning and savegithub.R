library(tm)
library(wordcloud2)
library(readxl)
## asosiasi
## mengaambil data tweet saja
apacoba <- read_excel("nama file")
komen <- apacoba$text
komenc <- Corpus(VectorSource(komen))
#Membersihkan Data
removeURL <- function(x) gsub("http[^[:space:]]*", "", x)
twitclean <- tm_map(komenc, removeURL)
removeNL <- function(y) gsub("\n", " ", y)
twitclean <- tm_map(twitclean, removeNL)
replacecomma <- function(y) gsub(",", "", y)
twitclean <- tm_map(twitclean, replacecomma)
removeRT <- function(y) gsub("RT ", "", y)
twitclean <- tm_map(twitclean, removeRT)
removetitik2 <- function(y) gsub(":", "", y)
twitclean <- tm_map(twitclean, removetitik2)
removetitikkoma <- function(y) gsub(";", " ", y)
twitclean <- tm_map(twitclean, removetitikkoma)
removetitik3 <- function(y) gsub("p.", "", y)
twitclean <- tm_map(twitclean, removetitik3)
removeamp <- function(y) gsub("&amp;", "", y)
twitclean <- tm_map(twitclean, removeamp)
removeUN <- function(z) gsub("@\\w+", "", z)
twitclean <- tm_map(twitclean, removeUN)
remove.all <- function(xy) gsub("[^[:alpha:][:space:]]*", "", xy)
twitclean <- tm_map(twitclean,remove.all)
twitclean <- tm_map(twitclean, removePunctuation)
twitclean <- tm_map(twitclean, tolower)

#Menghapus stopword
#Load stopwords
myStopwords = readLines("nama file stopword")
twitclean <- tm_map(twitclean,removeWords,myStopwords)
#Build a term-document matrix
{
  dtm <- TermDocumentMatrix(twitclean)
  m <- as.matrix(dtm)
  v <- sort(rowSums(m),decreasing=TRUE)
  d <- data.frame(word = names(v),freq=v)
}

head(d,n=10)

#Membuat Wordcloud
wordcloud2(d,shape = "cloud",
           backgroundColor = "black",
           color = 'random-light' ,
           size = 0.5)
## save data
dataframe<-data.frame(text=unlist(sapply(twitclean, `[`)), stringsAsFactors=F)
View(dataframe)


library(openxlsx)
write.xlsx(dataframe, file = "serah",
           sheetName = "serah", append = FALSE)
