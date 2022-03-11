test_that("accepting deep path (absolute), issue 263", {
  emptydir <- academictwitteR:::.gen_random_dir()
  deep_path1 <- file.path(emptydir, "whatever")
  deep_path2 <- file.path(emptydir, "whatever", "whatever")
  expect_error(x <- create_data_dir(deep_path1, verbose = FALSE), NA)
  expect_warning(x <- create_data_dir(deep_path1, verbose = TRUE))
  expect_true(dir.exists(x))
  expect_error(x <- create_data_dir(deep_path2), NA)
  expect_true(dir.exists(x))
  unlink(emptydir, recursive = TRUE)  
})

test_that("accepting deep path (relative), issue 263", {
  previous_wp <- getwd()
  emptydir <- academictwitteR:::.gen_random_dir()
  dir.create(emptydir)
  expect_true(dir.exists(emptydir))
  setwd(emptydir)
  expect_false(dir.exists("test_2"))
  expect_false(dir.exists("test_2/more_test"))
  expect_error(x <- create_data_dir("test_2/more_test", verbose = FALSE), NA)
  expect_true(dir.exists(file.path(emptydir, "test_2/more_test")))
  unlink(emptydir, recursive = TRUE)
  setwd(previous_wp)
})

## we can't test relative path, because httptest depends on the working directory being the default.
## But non-mocking API test shows that it works.

with_mock_api({
  test_that("absolute path", {
    skip_if(!dir.exists("api.twitter.com"))
    emptydir <- file.path(academictwitteR:::.gen_random_dir(), "test/test")
    expect_error(w1 <- capture_warnings(get_all_tweets(query = "#commtwitter", start_tweets = "2021-06-01T00:00:00Z", end_tweets = "2021-06-05T00:00:00Z", verbose = TRUE, data_path = emptydir)), NA)
    expect_match(w1, "Tweets will be bound", all = FALSE)
    expect_true(length(list.files(emptydir)) != 0) ### side effect is there
    unlink(emptydir, recursive = TRUE)
  })
})
