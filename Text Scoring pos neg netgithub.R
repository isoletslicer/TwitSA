library(tm)
library(wordcloud)
library(wordcloud2)
library(readxl)

kalimat2<-read_excel("namafile")
View(kalimat2)
#ambil kata kata untuk skoring
positif <- scan("tes positif.txt",what="character",comment.char=";")
negatif <- scan("tes negatif.txt",what="character",comment.char=";")
kata.positif = c(positif)
kata.negatif = c(negatif)
kata.positif = c(positif,"apacoba","inisatu")
score.sentiment = function(kalimat2, kata.positif, kata.negatif, .progress='none')
{
  require(plyr)
  require(stringr)
  scores = laply(kalimat2, function(kalimat, kata.positif, kata.negatif) {
    kalimat = gsub('[[:punct:]]', '', kalimat)
    kalimat = gsub('[[:cntrl:]]', '', kalimat)
    kalimat = gsub('\\d+', '', kalimat)
    kalimat = tolower(kalimat)
    
    list.kata = str_split(kalimat, '\\s+')
    kata2 = unlist(list.kata)
    positif.matches = match(kata2, kata.positif)
    negatif.matches = match(kata2, kata.negatif)
    positif.matches = !is.na(positif.matches)
    negatif.matches = !is.na(negatif.matches)
    score = sum(positif.matches) - (sum(negatif.matches))
    return(score)
  }, kata.positif, kata.negatif, .progress=.progress )
  scores.df = data.frame(score=scores, text=kalimat2)
  return(scores.df)
}


#melakukan skoring text
hasil=score.sentiment(kalimat2$text, kata.positif, kata.negatif)
head(hasil)

#Barplot of the number of words

positif = sum(hasil$score > 0)
negatif = sum(hasil$score < 0)
netral = sum(hasil$score == 0)

SentimentAnalysis = c(positif, netral, negatif)
SentimentAnalysis = data.frame(SentimentAnalysis)
barplot(SentimentAnalysis$SentimentAnalysis, data = SentimentAnalysis, names = SentimentAnalysis$Words, xlab = "Words", ylab = "Score", main = "Predictive score for words", col = c("Green", "Blue", "Red"), names.arg=c("Positif","Netral","Negatif") )


#CONVERT SCORE TO SENTIMENT
hasil$klasifikasi<- ifelse(hasil$score > '0', 'positif', ifelse(hasil$score < '0', 'negatif', 'netral'))


hasil$klasifikasi
View(hasil)

library(openxlsx)

#Tukar Row
data <- hasil[c(3,1,2)]
View(data)
write.xlsx(data, file = "data ter labeli.csv")

#Memisahkan twit
data.pos <- hasil[hasil$score>0,]
View(data.pos)
write.xlsx(data.pos, file = "data-pos.csv")

data.neg <- hasil[hasil$score<0,]
View(data.neg)
write.xlsx(data.neg, file = "data-neg.csv")

data.net <- hasil[hasil$score==0,]

write.xlsx(data.neg, file = "ye",
           sheetName = "tes", append = FALSE)
