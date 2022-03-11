## require(httptest)
## start_capturing(simplify = FALSE)
## emptydir <- academictwitteR:::.gen_random_dir()
## get_all_tweets("#Figliuolo", "2020-12-01T00:00:00Z", "2020-12-31T00:00:00Z", n=100000, data_path= emptydir, lang = "it", bind_tweets = FALSE)
## unlink(emptydir, recursive = TRUE)
## stop_capturing()

with_mock_api({
  test_that("empty return, #88", {
    skip_if(!dir.exists("api.twitter.com"))
    emptydir <- academictwitteR:::.gen_random_dir()
    expect_error(get_all_tweets("#Figliuolo", "2020-12-01T00:00:00Z", "2020-12-31T00:00:00Z", n=100000, data_path= emptydir, lang = "it", bind_tweets = FALSE), NA)
    unlink(emptydir, recursive = TRUE)
  })
})

