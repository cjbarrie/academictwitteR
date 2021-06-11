test_that("bind_tweet_jsons", {
  lifecycle::expect_deprecated(bind_tweet_jsons("../testdata/commtwitter"))
})

test_that("bind_user_jsons", {
  lifecycle::expect_deprecated(bind_user_jsons("../testdata/commtwitter"))
})

