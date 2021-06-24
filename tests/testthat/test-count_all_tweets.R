# require(httptest)
# start_capturing(simplify = FALSE)
# ori_test <- "../testdata/commtwitter/"
# res <- count_all_tweets(query = "#commtwitter", start_tweets = "2021-03-01T00:00:00Z", end_tweets = "2021-06-05T00:00:00Z")
# saveRDS(res, "../testdata/count_all_tweets.RDS")
# stop_capturing()

# with_mock_api({
#   test_that("expected behavior, #153", {
#     ori_test <- "../testdata/commtwitter/"
#     res <- count_all_tweets(query = "#commtwitter", start_tweets = "2021-03-01T00:00:00Z", end_tweets = "2021-06-05T00:00:00Z")
#     prev_res <- readRDS("../testdata/count_all_tweets.RDS")
#     expect_equal(nrow(res), nrow(prev_res))
#   })
# })
