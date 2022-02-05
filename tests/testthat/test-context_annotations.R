## unit test

test_that("add_context_annotations works", {
  old_params <- list(
    "query" = "#standwithhongkong",
    "max_results" = 500,
    "start_time" = "2020-06-20T00:00:00Z",
    "end_time" = "2020-06-21T00:00:00Z",
    "tweet.fields" = "attachments,author_id,conversation_id,created_at,entities,geo,id,in_reply_to_user_id,lang,public_metrics,possibly_sensitive,referenced_tweets,source,text,withheld",
    "user.fields" = "created_at,description,entities,id,location,name,pinned_tweet_id,profile_image_url,protected,public_metrics,url,username,verified,withheld",
    "expansions" = "author_id,entities.mentions.username,geo.place_id,in_reply_to_user_id,referenced_tweets.id,referenced_tweets.id.author_id",
    "place.fields" = "contained_within,country,country_code,full_name,geo,id,name,place_type"
  )
  expect_silent(academictwitteR:::add_context_annotations(old_params, verbose = FALSE))
  expect_output(x <- academictwitteR:::add_context_annotations(old_params, verbose = TRUE))
  another_params <- old_params
  another_params[["max_results"]] <- 99
  expect_silent(y <- academictwitteR:::add_context_annotations(another_params, verbose = TRUE))
  expect_equal(x[["max_results"]], 100)
  expect_equal(y[["max_results"]], 99) # no change
  outfields <- "attachments,author_id,context_annotations,conversation_id,created_at,entities,geo,id,in_reply_to_user_id,lang,public_metrics,possibly_sensitive,referenced_tweets,source,text,withheld"
  expect_equal(x[["tweet.fields"]], outfields)
  expect_equal(y[["tweet.fields"]], outfields)
})

## integration test


## require(httptest)
## start_capturing(simplify = FALSE)
## x <- get_all_tweets(query = "#commtwitter", start_tweets = "2021-06-01T00:00:00Z", end_tweets = "2021-06-05T00:00:00Z", context_annotations = FALSE)
## stop_capturing()
## start_capturing(simplify = FALSE)
## y <- get_all_tweets(query = "#commtwitter", start_tweets = "2021-06-01T00:00:00Z", end_tweets = "2021-06-05T00:00:00Z", context_annotations = TRUE)
## stop_capturing()
## start_capturing(simplify = FALSE)
## z <- get_all_tweets(query = "#commtwitter", start_tweets = "2021-06-01T00:00:00Z", end_tweets = "2021-06-05T00:00:00Z", context_annotations = TRUE, page_n = 99)
## stop_capturing()

with_mock_api({
  test_that("expected output", {
    skip_if(!dir.exists("api.twitter.com"))
    capture_warnings(x <- get_all_tweets(query = "#commtwitter", start_tweets = "2021-06-01T00:00:00Z", end_tweets = "2021-06-05T00:00:00Z", context_annotations = FALSE))
    expect_false("context_annotations" %in% colnames(x))
    capture_warnings(y <- get_all_tweets(query = "#commtwitter", start_tweets = "2021-06-01T00:00:00Z", end_tweets = "2021-06-05T00:00:00Z", context_annotations = TRUE))
    expect_true("context_annotations" %in% colnames(y))
    capture_warnings(z <- get_all_tweets(query = "#commtwitter", start_tweets = "2021-06-01T00:00:00Z", end_tweets = "2021-06-05T00:00:00Z", context_annotations = TRUE, page_n = 99))
    expect_true("context_annotations" %in% colnames(z))  
  })
})

with_mock_api({
  test_that("visual output", {
    skip_if(!dir.exists("api.twitter.com"))
    skip_if(!dir.exists("_snaps"))
    expect_snapshot({
    capture_warnings(x <- get_all_tweets(query = "#commtwitter", start_tweets = "2021-06-01T00:00:00Z", end_tweets = "2021-06-05T00:00:00Z", context_annotations = FALSE, verbose = TRUE))
    capture_warnings(y <- get_all_tweets(query = "#commtwitter", start_tweets = "2021-06-01T00:00:00Z", end_tweets = "2021-06-05T00:00:00Z", context_annotations = TRUE, verbose = TRUE))
    capture_warnings(z <- get_all_tweets(query = "#commtwitter", start_tweets = "2021-06-01T00:00:00Z", end_tweets = "2021-06-05T00:00:00Z", context_annotations = TRUE, page_n = 99, verbose = TRUE))
    capture_warnings(x1 <- get_all_tweets(query = "#commtwitter", start_tweets = "2021-06-01T00:00:00Z", end_tweets = "2021-06-05T00:00:00Z", context_annotations = FALSE, verbose = FALSE))
    capture_warnings(y1 <- get_all_tweets(query = "#commtwitter", start_tweets = "2021-06-01T00:00:00Z", end_tweets = "2021-06-05T00:00:00Z", context_annotations = TRUE, verbose = FALSE))
    capture_warnings(z1 <- get_all_tweets(query = "#commtwitter", start_tweets = "2021-06-01T00:00:00Z", end_tweets = "2021-06-05T00:00:00Z", context_annotations = TRUE, page_n = 99, verbose = FALSE))
    })
  })
})

