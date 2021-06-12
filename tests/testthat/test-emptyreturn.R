## require(httptest)
## start_capturing(simplify = FALSE)
## get_all_tweets("#Figliuolo", "2020-12-01T00:00:00Z", "2020-12-31T00:00:00Z", n=100000, data_path= emptydir, lang = "it", bind_tweets = FALSE)
## stop_capturing()
ORI_BEARER <- Sys.getenv("TWITTER_BEARER")

Sys.setenv("TWITTER_BEARER" = "ABC")

with_mock_api({
  test_that("empty return, #88", {
    emptydir <- academictwitteR:::.gen_random_dir()
    expect_error(get_all_tweets("#Figliuolo", "2020-12-01T00:00:00Z", "2020-12-31T00:00:00Z", n=100000, data_path= emptydir, lang = "it", bind_tweets = FALSE), NA)
    unlink(emptydir, recursive = TRUE)
  })
})

Sys.setenv("TWITTER_BEARER" = ORI_BEARER)
