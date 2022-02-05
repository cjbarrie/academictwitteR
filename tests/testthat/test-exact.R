test_that("basic test", {
  expect_equal("Black Lives Matter", build_query(query = "Black Lives Matter"))
  expect_equal("\"Black Lives Matter\"", build_query(query = "Black Lives Matter", exact_phrase = TRUE))
  expect_equal("\"Black Lives Matter\" (retweets_of:ACLU)", build_query(query = "Black Lives Matter", exact_phrase = TRUE, retweets_of = "ACLU"))
  expect_equal("Black Lives Matter (retweets_of:ACLU)", build_query(query = "Black Lives Matter", exact_phrase = FALSE, retweets_of = "ACLU"))
})

## integration test
## see https://github.com/cjbarrie/academictwitteR/issues/235#issuecomment-945080851

## require(httptest)
## start_capturing(simplify = FALSE)
## tweets1 <-
##   get_all_tweets(
##     query = "Black Lives Matter",
##     retweets_of = "ACLU",
##     exact_phrase = TRUE, start_tweets = "2021-01-04T00:00:00Z", 
##     end_tweets = "2021-01-04T00:45:00Z", 
##     n = Inf)
## stop_capturing()

with_mock_api({
  test_that("basic test", {
    skip_if(!dir.exists("api.twitter.com"))
    tweets1 <-
      suppressWarnings(get_all_tweets(
        query = "Black Lives Matter",
        retweets_of = "ACLU",
        exact_phrase = TRUE, start_tweets = "2021-01-04T00:00:00Z", 
        end_tweets = "2021-01-04T00:45:00Z", 
        n = Inf))
    expect_true(nrow(tweets1) > 0)
  })
})
