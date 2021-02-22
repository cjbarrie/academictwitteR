# Test Script

bearer_token <- "" # Insert bearer token

# Getting user tweets
users <- c("volkspartei", "SPOE_at")
get_user_tweets(users, "2020-01-01T00:00:00Z", "2020-01-05T00:00:00Z", bearer_token, path = "data/")

# Getting hashtag tweets
get_hashtag_tweets("#BLM+#BlackLivesMatter", "2020-01-01T00:00:00Z", "2020-01-02T00:00:00Z", bearer_token)
