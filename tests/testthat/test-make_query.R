
## require(httptest)
## params <- list(
##   "query" = "#standwithhongkong",
##   "max_results" = 500,
##   "start_time" = "2020-06-20T00:00:00Z",
##   "end_time" = "2020-06-21T00:00:00Z",
##   "tweet.fields" = "attachments,author_id,conversation_id,created_at,entities,geo,id,in_reply_to_user_id,lang,public_metrics,possibly_sensitive,referenced_tweets,source,text,withheld",
##   "user.fields" = "created_at,description,entities,id,location,name,pinned_tweet_id,profile_image_url,protected,public_metrics,url,username,verified,withheld",
##     "expansions" = "author_id,entities.mentions.username,geo.place_id,in_reply_to_user_id,referenced_tweets.id,referenced_tweets.id.author_id",
##     "place.fields" = "contained_within,country,country_code,full_name,geo,id,name,place_type"
## )

## start_capturing(simplify = FALSE)
## res <- academictwitteR:::make_query(url = "https://api.twitter.com/2/tweets/search/all", params = params, bearer_token = get_bearer())
## stop_capturing()

## start_capturing(simplify = FALSE)
## wrong_params <- params
## wrong_params[["start_time"]] <- "2020-06-21T01:00:00Z"
## academictwitteR:::make_query(url = "https://api.twitter.com/2/tweets/search/all", params = wrong_params, bearer_token = get_bearer())
## wrong_params2 <- params
## wrong_params2[["q"]] <- "#CPC100Years"
## academictwitteR:::make_query(url = "https://api.twitter.com/2/tweets/search/all", params = wrong_params2, bearer_token = "THISISFAKE")
## academictwitteR:::make_query(url = "https://api.twitter.com/2/tweets/search/allall", params = params, bearer_token = get_bearer())
## stop_capturing()


with_mock_api({
  test_that("Make query and errors", {
    skip_if(!dir.exists("api.twitter.com"))
    params <- list(
      "query" = "#standwithhongkong",
      "max_results" = 500,
      "start_time" = "2020-06-20T00:00:00Z",
      "end_time" = "2020-06-21T00:00:00Z",
      "tweet.fields" = "attachments,author_id,conversation_id,created_at,entities,geo,id,in_reply_to_user_id,lang,public_metrics,possibly_sensitive,referenced_tweets,source,text,withheld",
      "user.fields" = "created_at,description,entities,id,location,name,pinned_tweet_id,profile_image_url,protected,public_metrics,url,username,verified,withheld",
      "expansions" = "author_id,entities.mentions.username,geo.place_id,in_reply_to_user_id,referenced_tweets.id,referenced_tweets.id.author_id",
      "place.fields" = "contained_within,country,country_code,full_name,geo,id,name,place_type"
    )
    expect_error(academictwitteR:::make_query(url = "https://api.twitter.com/2/tweets/search/all", params = params, bearer_token = get_bearer()), NA)
    wrong_params <- params
    wrong_params[["start_time"]] <- "2020-06-21T01:00:00Z"
    expect_error(academictwitteR:::make_query(url = "https://api.twitter.com/2/tweets/search/all", params = wrong_params, bearer_token = get_bearer()))
    wrong_params2 <- params
    wrong_params2[["q"]] <- "#CPC100Years"
    expect_error(academictwitteR:::make_query(url = "https://api.twitter.com/2/tweets/search/all", params = wrong_params2, bearer_token = "THISISFAKE"))
    expect_error(academictwitteR:::make_query(url = "https://api.twitter.com/2/tweets/search/allall", params = params, bearer_token = get_bearer()))
  })
})

 
  
