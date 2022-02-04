

## require(httptest)
## start_capturing(simplify = FALSE)
## ori_test <- "../testdata/commtwitter/"
## user_ids <- unique(bind_tweets(ori_test, verbose = FALSE)$author_id)[c(1,2,3)]
## res <- get_user_profile(x = user_ids)
## saveRDS(res, "../testdata/user_profiles.RDS")
## stop_capturing()

## start_capturing(simplify = FALSE)
## res2 <- get_user_following(x = user_ids)
## saveRDS(res2, "../testdata/user_following.RDS")
## stop_capturing()


## start_capturing(simplify = FALSE)
## res3 <- get_user_followers(x = user_ids)
## saveRDS(res3, "../testdata/user_followers.RDS")
## stop_capturing()

with_mock_api({
  test_that("get_user_profile: expected behaviour", {
    skip_if(!dir.exists("api.twitter.com"))
    ori_test <- "../testdata/commtwitter/"
    user_ids <- unique(bind_tweets(ori_test, verbose = FALSE)$author_id)[c(1,2,3)]
    res <- get_user_profile(x = user_ids)
    expect_equal(readRDS("../testdata/user_profiles.RDS"), res)
  })
})

with_mock_api({
  test_that("get_user_following: expected behaviour", {
    skip_if(!dir.exists("api.twitter.com"))
    ori_test <- "../testdata/commtwitter/"
    user_ids <- unique(bind_tweets(ori_test, verbose = FALSE)$author_id)[c(1,2,3)]
    res <- get_user_following(x = user_ids)
    expect_equal(nrow(readRDS("../testdata/user_following.RDS")), nrow(res))
  })
})

with_mock_api({
  test_that("get_user_following: expected behaviour", {
    skip_if(!dir.exists("api.twitter.com"))
    ori_test <- "../testdata/commtwitter/"
    user_ids <- unique(bind_tweets(ori_test, verbose = FALSE)$author_id)[c(1,2,3)]
    res <- get_user_followers(x = user_ids)
    expect_equal(nrow(readRDS("../testdata/user_followers.RDS")), nrow(res))
  })
})
