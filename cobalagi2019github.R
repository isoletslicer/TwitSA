library(twitteR)
library(Rcpp)
library(ROAuth)
library(RCurl)
library(tm)
library(devtools)
library(base64enc)
library(httr)

api_key <- "bHM2s0NfSPOsFg8s0nZiq4Dwn"
api_secret <- "dmmM4l9OzHQT9pxaGPZPTLEbKctcQ7hBngZo5WEhwxlAAchpJU"
access_token <- "875352904399339524-TaeJaKB7wfmdt7UZJJOjANDlkRogVFh"
access_token_secret <- "3zhHq17K4uATFOH7L2yZF1yWDZcR2ZFkiDHJgB6YAJZth"
setup_twitter_oauth(api_key, api_secret, access_token,access_token_secret)

query <- "#JokowiAminMenangDebat"

search_result <-searchTwitter(query, n=15000, since="2019-01-17",until="2019-01-18")
df_search_result1 <- twListToDF(search_result)
library(xlsx)
write.xlsx(df_search_result1, file = "jokowiaminmenangdebat.xlsx",
           sheetName = "jokowiaminmenangdebat", append = FALSE)