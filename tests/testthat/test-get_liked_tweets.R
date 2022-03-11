## require(httptest)
## start_capturing(simplify = FALSE)
## x <- get_all_tweets("from:k_sze OR from:noahwp", start_tweets = "2021-01-01T00:00:00Z", end_tweets = "2021-06-01T00:00:00Z", verbose = FALSE)
## user_ids <- unique(x$author_id)
## res <- get_liked_tweets(x = user_ids)
## saveRDS(res, "../testdata/liked_tweets.RDS")
## stop_capturing()

with_mock_api({
  test_that("expected behavior", {
    skip_if(!dir.exists("api.twitter.com"))
    x <- get_all_tweets("from:k_sze OR from:noahwp", start_tweets = "2021-01-01T00:00:00Z", end_tweets = "2021-06-01T00:00:00Z", verbose = FALSE)
    user_ids <- unique(x$author_id)
    res <- get_liked_tweets(x = user_ids)
    expect_equal(nrow(readRDS("../testdata/liked_tweets.RDS")), nrow(res))
  })
})
