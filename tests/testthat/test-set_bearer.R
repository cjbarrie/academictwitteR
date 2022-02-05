test_that("get_bearer", {
  skip_on_cran()
  ORI_BEARER <- Sys.getenv("TWITTER_BEARER")
  Sys.setenv("TWITTER_BEARER" = "")
  expect_error(get_bearer())
  Sys.setenv("TWITTER_BEARER" = "ABC")
  expect_error(get_bearer(), NA)
  expect_equal(get_bearer(), "ABC")
  Sys.setenv("TWITTER_BEARER" = ORI_BEARER)  
})

with_mock_api({
  test_that("integration with get_all_tweets", {
    skip_if(!dir.exists("api.twitter.com"))
    emptydir <- academictwitteR:::.gen_random_dir()
    ORI_BEARER <- Sys.getenv("TWITTER_BEARER")
    Sys.setenv("TWITTER_BEARER" = "")
    expect_error(w1 <- capture_warnings(get_all_tweets(query = "#commtwitter", start_tweets = "2021-06-01T00:00:00Z", end_tweets = "2021-06-05T00:00:00Z", verbose = TRUE, data_path = emptydir)))
    Sys.setenv("TWITTER_BEARER" = "ABC")  
    expect_error(w1 <- capture_warnings(get_all_tweets(query = "#commtwitter", start_tweets = "2021-06-01T00:00:00Z", end_tweets = "2021-06-05T00:00:00Z", verbose = TRUE, data_path = emptydir)), NA)
    unlink(emptydir)
    Sys.setenv("TWITTER_BEARER" = ORI_BEARER)  
  })
})
