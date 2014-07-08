#Produce plot showing the number of tweets over time including #rcatladies
#Results are plotted with a cat silhouette in the background using rphylopic 

library(devtools)
install_github("twitteR", username="geoffjentry")
library(twitteR)
library(lubridate)
library(plyr)
library(ggplot2)
theme_set(theme_bw())
install_github("rphylopic", "sckott")
library(rphylopic)

# The following code is specific to my user key and token for the twitter API (details removed)
# The authentication process can be replicated with your Twitter account
# I found the instructions on this blog post helpful: 
# http://thinktostart.wordpress.com/2013/05/22/twitter-authentification-with-r/

# account info should be inserted within quotes
# api_key <- ""
# api_secret <- ""
# access_token <- ""
# access_token_secret <- ""
# 
# setup_twitter_oauth(api_key,api_secret,access_token,access_token_secret)
# 
# 
# #retrieve all #rcatladies tweets since the inception of the hashtag: 6-30-2014 
# rcat_tweets <- searchTwitter("#rcatladies", n = 1000) #format to dataframe
# #retrieve treats under #rcatsladies alias
# rcats_tweets <- searchTwitter("#rcatsladies", n = 1000) #format to dataframe
# 
# save(rcat_tweets, file = "rcat_tweets.Rdata")
# save(rcats_tweets, file = "rcats_tweets.Rdata")


#load tweets from file
load("rcat_tweets.Rdata")
load("rcats_tweets.Rdata")

#place search results into data frames
rcat.df <- do.call("rbind", lapply(rcat_tweets, as.data.frame))
rcats.df <- do.call("rbind", lapply(rcats_tweets, as.data.frame))

#combine tweets using both spellings
rcat.df.all <- rbind(rcat.df, rcats.df) 

#format dates
rcat.df.all$created <- as.Date( rcat.df.all$created) 

#summarize number of tweets per day
cat_nums <- ddply(rcat.df.all, .(created), summarise, 
                  tweet_num = length(text))


#eliminate last partial day
cat_nums <- subset(cat_nums, created <= as.Date("2014-07-07"))

#retrieve cat phylopic
cat <- get_image("23cd6aa4-9587-4a2e-8e26-de42885004c9", size = 512)[[1]]


ggplot(aes(created, tweet_num), data = cat_nums) + geom_point(aes(size = 1.5)) + 
  geom_smooth(size = 1.2) + add_phylopic(cat) +
  xlab("Date") + ylab("Number of #RCatLadies tweets") +
  theme(legend.position="none")
ggsave("rcatladies_tweets_July072014.png")
