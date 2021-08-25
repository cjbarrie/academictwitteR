## https://developer.twitter.com/en/docs/twitter-api/rate-limits
## Issue #231
## it is a real test, not via mock api

test_that("running two make_query in rapid succession will not trigger HTTP 429", {
  skip_on_cran()
  skip_on_ci()
  params <- 
list(query = "from:Peter_Tolochko -is:retweet", max_results = 15, 
     start_time = "2020-02-03T00:00:00Z", end_time = "2020-11-03T00:00:00Z", 
     tweet.fields = "attachments,author_id,conversation_id,created_at,entities,geo,id,in_reply_to_user_id,lang,public_metrics,possibly_sensitive,referenced_tweets,source,text,withheld", 
     user.fields = "created_at,description,entities,id,location,name,pinned_tweet_id,profile_image_url,protected,public_metrics,url,username,verified,withheld", 
     expansions = "author_id,entities.mentions.username,geo.place_id,in_reply_to_user_id,referenced_tweets.id,referenced_tweets.id.author_id", 
     place.fields = "contained_within,country,country_code,full_name,geo,id,name,place_type")
  endpoint_url <- "https://api.twitter.com/2/tweets/search/all"
  expect_snapshot(academictwitteR:::make_query(url = endpoint_url, params = params, bearer_token = get_bearer()))
  expect_snapshot(academictwitteR:::make_query(url = endpoint_url, params = params, bearer_token = get_bearer()))
})
