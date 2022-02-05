# require(httptest)
# start_capturing(simplify = FALSE)
# ori_test <- "../testdata/commtwitter/"
# res <- count_all_tweets(query = "#commtwitter", start_tweets = "2021-03-01T00:00:00Z", end_tweets = "2021-06-05T00:00:00Z")
# saveRDS(res, "../testdata/count_all_tweets.RDS")
# res2 <- count_all_tweets(query = "#commtwitter", start_tweets = "2021-03-01T00:00:00Z", end_tweets = "2021-06-05T00:00:00Z")
# stop_capturing()

with_mock_api({
  test_that("expected behavior, #153", {
    skip_if(!dir.exists("api.twitter.com"))
    ori_test <- "../testdata/commtwitter/"
    res <- count_all_tweets(query = "#commtwitter", start_tweets = "2021-03-01T00:00:00Z", end_tweets = "2021-06-05T00:00:00Z")
    prev_res <- readRDS("../testdata/count_all_tweets.RDS")
    expect_equal(nrow(res), nrow(prev_res))
    res2 <- count_all_tweets(query = "#commtwitter", start_tweets = "2021-03-01T00:00:00Z", end_tweets = "2021-06-05T00:00:00Z")
    expect_lt(nrow(res2), 99) ## no page flipping
    expect_error(z <- capture_warnings(count_all_tweets(query = "#commtwitter", start_tweets = "2021-03-01T00:00:00Z", end_tweets = "2021-06-05T00:00:00Z")), NA)
    expect_identical(z, character(0))
  })
})
