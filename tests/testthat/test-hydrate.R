test_that("Corner cases", {
  expect_error(hydrate_tweets())
  expect_error(hydrate_tweets(c()), NA)
})
