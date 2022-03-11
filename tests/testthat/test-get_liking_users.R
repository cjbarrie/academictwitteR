## require(httptest)
## start_capturing(simplify = FALSE)
## ori_test <- "../testdata/commtwitter/"
## tweet_ids <- unique(bind_tweets(ori_test, verbose = FALSE)$id)
## res <- get_liking_users(x = tweet_ids)
## saveRDS(res, "../testdata/liking_users.RDS")
## res2 <- get_liking_users("1405327120163872777")
## stop_capturing()

with_mock_api({
  test_that("expected behavior, #153", {
    skip_if(!dir.exists("api.twitter.com"))
    ori_test <- "../testdata/commtwitter/"
    tweet_ids <- unique(bind_tweets(ori_test, verbose = FALSE)$id)
    res <- get_liking_users(x = tweet_ids)
    prev_res <- readRDS("../testdata/liking_users.RDS")
    expect_equal(nrow(res), nrow(prev_res))
    res2 <- get_liking_users("1405327120163872777")
    expect_lt(nrow(res2), 300) ## no page flipping
  })
})
