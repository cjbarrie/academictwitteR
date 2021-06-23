test_that("defensive programming", {
  expect_error(bind_tweets("../testdata/commtwitter", output_format = "raw"), NA)
  expect_error(bind_tweets("../testdata/commtwitter", output_format = "tidy"), NA)
  expect_error(bind_tweets("../testdata/commtwitter", output_format = "idontknow"))
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
  expect_equal(colnames(y), c("tweet_id", "user_username", "ref_type", "text", "source", "lang", "possibly_sensitive", "created_at", "conversation_id", "author_id", "user_location", "user_verified", "user_url", "user_pinned_tweet_id", "user_name", "user_description", "user_protected", "user_profile_image_url", "user_created_at", "retweet_count", "like_count", "quote_count", "user_tweet_count", "user_list_count", "user_followers_count", "user_following_count", "sourcetweet_id", "sourcetweet_text", "sourcetweet_lang", "sourcetweet_author_id"))
})

## get_all_tweets(build_query("#standwithhongkong", is_retweet = FALSE), n = 300, start_tweets = "2021-06-01T00:00:00Z", end_tweets = "2021-06-22T23:59:59Z", data_path = "../testdata/hk", n = 100)
