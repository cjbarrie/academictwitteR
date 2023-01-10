test_that("real test", {
  skip_on_ci()
  skip_on_cran() ## some cran machines will still run this test despite this directive
  skip_if(Sys.getenv("TWITTER_BEARER") == "")
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
  emptydir <- academictwitteR:::.gen_random_dir()
  expect_error(w1 <- capture_warnings(get_all_tweets(query = "#commtwitter", start_tweets = "2021-06-01T00:00:00Z", end_tweets = "2021-06-05T00:00:00Z", verbose = TRUE, data_path = emptydir)), NA)
  unlink(emptydir, recursive = TRUE)
  ## ori_test <- "../testdata/commtwitter/"
  ## user_ids <- unique(bind_tweets(ori_test, verbose = FALSE)$author_id)[c(6,7,9)]
  ## expect_error(get_user_profile(x = user_ids), NA)
  expect_silent(get_retweeted_by(c("1476155918597373952"), verbose = FALSE))
  expect_error(get_all_tweets("#ichbinhanna", verbose = FALSE), NA)
})
