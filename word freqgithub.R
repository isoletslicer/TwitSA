library("tm")
library("stringr")
library("SnowballC")
library("wordcloud")
library("wordcloud2")
library("RColorBrewer")
library("dplyr")


stopwordId <- readLines("stopword-id.txt")
docs <- Corpus(VectorSource(jokowiaminmenangdebat_17Jan_text))
inspect(docs) #melihat isi dokumen

#text transformation, misalkan mengganti karakter "@"."/" menjadi spasi
toSpace <- content_transformer(function (x, pattern) gsub (pattern, " ",x))
docs <- tm_map(docs, toSpace, "/")
docs <- tm_map(docs, toSpace, "@")
docs <- tm_map(docs, toSpace, "\\|")


#cleaning text, misalkan menghapus angka, stopword, tanda baca, dll
docs <- tm_map(docs, content_transformer(tolower))
docs <- tm_map(docs, removeNumbers)
docs <- tm_map(docs, removeWords, stopwords("english"))
docs <- tm_map(docs, removePunctuation)
docs <- tm_map(docs, stripWhitespace)




clean_tweet = gsub("&amp", "", docs)
clean_tweet = gsub("(RT|via)((?:\\b\\W*@\\w+)+)", "", docs)
clean_tweet = gsub("@\\w+", "", docs)
clean_tweet = gsub("[[:punct:]]", "", docs)
clean_tweet = gsub("[[:digit:]]", "", docs)
clean_tweet = gsub("http\\w+", "", docs)
clean_tweet = gsub("https://t.co/[a-z,A-Z,0-9]", "", docs)
clean_tweet = gsub("[ \t]{2,}", "", docs)
clean_tweet = gsub("^\\s+|\\s+$", "", docs)
clean_tweet = gsub("tco", "", docs)
clean_tweet = gsub("https", "", docs)

myDf <- data.frame(text = sapply(clean_tweet, paste, collapse = " "), stringsAsFactors = FALSE)


  

stopwordId <- readLines("stopword-id.txt")
clean_tweet <- tm_map(clean_tweet, removeWords, c(stopwordId))


#membangun term-document matrix
dtm <- TermDocumentMatrix(docs)
m <- as.matrix(dtm)
v <- sort(rowSums(m),decreasing=TRUE)
d <- data.frame(word = names (v), freq=v)
head(d,30) #menampilkan 10 kata paling banyak muncul

wordcloud2(d,shape = "cloud",
           backgroundColor = "black",
           color = 'random-light' ,
           size = 0.5)

#tampilkan kata sebagai wordcloud
set.seed(1234)
wordcloud(words = prabowoindonesiamenang$word, freq = prabowoindonesiamenang$freq, min.freq=50, max.words=2000, random.order=FALSE, rot.per=0.35, colors=brewer.pal(8, "Dark2"))

#menemukan kata yang berasosiasi (keluar bersamaan) corlimit-->minimal derajat korelasi
findAssocs(dtm, terms = "Pa", corlimit = 0.2)


library(xlsx)
write.xlsx(d, file = "s",
           sheetName = "a", append = FALSE)

