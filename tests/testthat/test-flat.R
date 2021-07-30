test_that("defensive programming", {
  expect_error(bind_tweets("../testdata/commtwitter", output_format = "raw"), NA)
  expect_error(bind_tweets("../testdata/commtwitter", output_format = "tidy"), NA)
  expect_error(bind_tweets("../testdata/commtwitter", output_format = "idontknow"))
  expect_error(convert_json("../testdata/commtwitter/data_1399765322509557763.json"), NA)
  expect_error(convert_json("../testdata/commtwitter/data_1399765322509557763.json", output_format = "raw"), NA)
  expect_error(convert_json("../testdata/commtwitter/data_1399765322509557763.json", output_format = "tidy"), NA)
  expect_error(convert_json("../testdata/commtwitter/data_1399765322509557763.json", output_format = "idontknow"))
})

test_that("convert_json", {
  x <- convert_json("../testdata/commtwitter/data_1399765322509557763.json")
  expect_equal(colnames(x), c("tweet_id", "user_username", "text", "source", "conversation_id", "author_id", "created_at", "possibly_sensitive", "lang", "user_profile_image_url", "user_location", "user_url", "user_name", "user_pinned_tweet_id", "user_protected", "user_created_at", "user_verified", "user_description", "retweet_count", "like_count", "quote_count", "user_tweet_count", "user_list_count", "user_followers_count", "user_following_count", "sourcetweet_type", "sourcetweet_id", "sourcetweet_text", "sourcetweet_lang", "sourcetweet_author_id"))
  expect_true("tbl_df" %in% class(x))
  y <- convert_json("../testdata/commtwitter/data_1399765322509557763.json", output_format = "raw")
  expect_equal(class(y), "list")
})

test_that("expected format", {
  x <- bind_tweets("../testdata/commtwitter", output_format = "raw")
  expect_equal(class(x), "list")
  x <- bind_tweets("../testdata/commtwitter", output_format = "tidy")
  expect_true("tbl_df" %in% class(x))
})

test_that("expected dimensionality", {
  x <- bind_tweets("../testdata/commtwitter", output_format = NA, verbose = FALSE)
  y <- bind_tweets("../testdata/commtwitter", output_format = "tidy")
  expect_equal(nrow(x), nrow(y))
  expect_equal(colnames(y), c("tweet_id", "user_username", "text", "source", "conversation_id", "author_id", "created_at", "possibly_sensitive", "lang", "user_profile_image_url", "user_location", "user_url", "user_name", "user_pinned_tweet_id", "user_protected", "user_created_at", "user_verified", "user_description", "retweet_count", "like_count", "quote_count", "user_tweet_count", "user_list_count", "user_followers_count", "user_following_count", "sourcetweet_type", "sourcetweet_id", "sourcetweet_text", "sourcetweet_lang", 
"sourcetweet_author_id"))
})

## x <- get_all_tweets(build_query("#standwithhongkong", is_retweet = FALSE, is_quote = FALSE, is_reply = FALSE), n = 3000, start_tweets = "2021-06-01T00:00:00Z", end_tweets = "2021-06-22T23:59:59Z", data_path = "../testdata/hk")

## x <- get_all_tweets(build_query("#standwithhongkong"), n = 3000, start_tweets = "2021-06-01T00:00:00Z", end_tweets = "2021-06-22T23:59:59Z", data_path = "../testdata/hk2")

## x <- get_all_tweets(build_query("#standwithhongkong"), n = 3000, start_tweets = "2021-06-01T00:00:00Z", end_tweets = "2021-06-22T23:59:59Z", data_path = "../testdata/hk3", is_retweet = FALSE, is_quote = FALSE, is_reply = TRUE)

test_that(".simple_unnest", {
  x <- readRDS("../testdata/hkx.RDS")
  pki <- readRDS("../testdata/hkx_pki.RDS")
  expect_error(academictwitteR:::.simple_unnest(x, pki), NA)
  x <- readRDS("../testdata/c1.RDS")
  pki <- readRDS("../testdata/c1_pki.RDS")
  expect_error(academictwitteR:::.simple_unnest(x, pki), NA)
})

test_that("corner cases", {
  ## only organic tweets
  res <- bind_tweets("../testdata/hk", output_format = "tidy")
  ori <- bind_tweets("../testdata/hk", verbose = FALSE)
  expect_equal(nrow(res), nrow(ori))
  ## all types
  res <- bind_tweets("../testdata/hk2", output_format = "tidy")
  ori <- bind_tweets("../testdata/hk2", verbose = FALSE)
  expect_equal(nrow(res), nrow(ori))
  ## only replies
  res <- bind_tweets("../testdata/hk3", output_format = "tidy")
  ori <- bind_tweets("../testdata/hk3", verbose = FALSE)
  expect_equal(nrow(res), nrow(ori))  
})
