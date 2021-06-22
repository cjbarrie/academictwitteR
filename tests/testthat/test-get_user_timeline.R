# require(httptest)
# start_capturing(simplify = FALSE)
# ori_test <- "../testdata/commtwitter/"
# user_ids <- unique(bind_tweets(ori_test, verbose = FALSE)$author_id)
# res <- get_user_timeline(user_ids, "2021-05-30T14:12:24.000Z", "2021-06-02T21:15:24.000Z")
# saveRDS(res, "../testdata/user_timeline.RDS")
# res2 <- get_user_timeline("45648666", "2021-05-30T14:12:24.000Z", "2021-06-02T21:15:24.000Z")
# stop_capturing()

with_mock_api({
  test_that("expected behavior, #153", {
    ori_test <- "../testdata/commtwitter/"
    user_ids <- unique(bind_tweets(ori_test, verbose = FALSE)$author_id)
    res <- get_user_timeline(user_ids, "2021-05-30T14:12:24.000Z", "2021-06-02T21:15:24.000Z")
    prev_res <- readRDS("../testdata/user_timeline.RDS")
    expect_equal(nrow(res), nrow(prev_res))
    res2 <- get_user_timeline("45648666", "2021-05-30T14:12:24.000Z", "2021-06-02T21:15:24.000Z")
    expect_lt(nrow(res2), 10) ## no page flipping
  })
})

