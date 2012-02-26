library(twitteR)
library(tm)
library(wordcloud)
setwd(getwd())
source('hashTag.R')

qantas=hashTag("#qantas", 7)
findAssocs(qantas$TextMatrix, 'virgin', 0.3)

allianz=hashTag("#allianz", 7)
findAssocs(allianz$TextMatrix, 'allianz', 0.3)

asx=hashTag("#asx", 7)
findAssocs(asx$TextMatrix, 'allianz', 0.3)