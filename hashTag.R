hashTag<-function (hashTag, minFreq){
tweets<- searchTwitter(hashTag, n=200)
#convert to a data frame
df <- do.call("rbind", lapply(tweets, as.data.frame))

###################################################
#PREPROCESSING-eg. lower case
##################################################
# build a corpus, which is a collection of text documents
# VectorSource specifies that the source is character vectors.
myCorpus <- Corpus(VectorSource(df$text))
#After that, the corpus needs a couple of transformations,
#including changing letters to lower case, removing 
#punctuations/numbers and removing stop words. The general
#English stop-word list is tailored by adding "available" and "via".
myCorpus <- tm_map(myCorpus, function(x) iconv(enc2utf8(x), sub = "byte"))
myCorpus <- tm_map(myCorpus, tolower)
# remove punctuation
myCorpus <- tm_map(myCorpus, removePunctuation)
# remove numbers
myCorpus <- tm_map(myCorpus, removeNumbers)
# remove stopwords
myStopwords <- c(stopwords('english'), "available", "via")
myCorpus <- tm_map(myCorpus, removeWords, myStopwords)

####################################################
#STEMMING
######################################################
#In many cases, words need to be stemmed to retrieve their
#radicals. For instance, "example" and "examples" are both
#stemmed to "exampl". However, after that, one may want to
#complete the stems to their original forms, so that the 
#words would look "normal".

dictCorpus <- myCorpus
# stem words in a text document with the snowball stemmers,
# which requires packages Snowball, RWeka, rJava, RWekajars
myCorpus <- tm_map(myCorpus, stemDocument)
# stem completion
#browser()
myCorpus <- tm_map(myCorpus, stemCompletion, dictionary=dictCorpus)
myDtm <- TermDocumentMatrix(myCorpus, control = list(minWordLength = 1))

#findAssocs(myDtm, 'miners', 0.30)

######################################################
#WORDCLOUD
#######################################################
m <- as.matrix(myDtm)
# calculate the frequency of words
v <- sort(rowSums(m), decreasing=TRUE)
myNames <- names(v)
d <- data.frame(word=myNames, freq=v)
wordcloud(d$word, d$freq, min.freq=minFreq)
list(freq=v, TextMatrix=myDtm)
}