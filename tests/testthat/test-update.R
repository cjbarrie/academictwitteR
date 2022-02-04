## require(httptest)
## start_capturing(simplify = FALSE)
## ori_test <- "../testdata/commtwitter/"
## test_dir <- academictwitteR:::.gen_random_dir()
## dir.create(test_dir)
## z <- file.copy(list.files(ori_test, full.names = TRUE, recursive = TRUE), test_dir, recursive = TRUE)
## update_collection(test_dir, end_tweets = "2021-06-14T23:59:59Z", bind_tweets = FALSE)
## unlink(test_dir, recursive = TRUE)
## stop_capturing()

test_that("defensive programming", {
    ori_test <- "../testdata/commtwitter/"
    test_dir <- academictwitteR:::.gen_random_dir()
    dir.create(test_dir)
    z <- file.copy(list.files(ori_test, full.names = TRUE, recursive = TRUE), test_dir, recursive = TRUE)
    expect_error(update_collection(test_dir, bind_tweets = FALSE))
    expect_error(update_collection(academictwitteR:::.gen_random_dir(), bind_tweets = FALSE))
    unlink(test_dir)
})


with_mock_api({
  test_that("No duplication #143", {
    skip_if(!dir.exists("api.twitter.com"))
    ori_test <- "../testdata/commtwitter/"
    test_dir <- academictwitteR:::.gen_random_dir()
    dir.create(test_dir)
    z <- file.copy(list.files(ori_test, full.names = TRUE, recursive = TRUE), test_dir, recursive = TRUE)
    capture_warnings(update_collection(test_dir, end_tweets = "2021-06-14T23:59:59Z", bind_tweets = FALSE))
    a1 <- bind_tweets(test_dir)
  ## a2 <- bind_tweets(ori_test)
    testthat::expect_true(length(unique(a1$id)) == length(a1$id))
    testthat::expect_true(length(table(a1$id)[table(a1$id) == 2]) == 0)
    unlink(test_dir, recursive = TRUE)
  })
})

with_mock_api({
  test_that("verbose #143", {
    skip_if(!dir.exists("api.twitter.com"))
    ori_test <- "../testdata/commtwitter/"
    test_dir <- academictwitteR:::.gen_random_dir()
    dir.create(test_dir)
    z <- file.copy(list.files(ori_test, full.names = TRUE, recursive = TRUE), test_dir, recursive = TRUE)
    expect_silent(update_collection(test_dir, end_tweets = "2021-06-14T23:59:59Z", bind_tweets = FALSE, verbose = FALSE))
    unlink(test_dir, recursive = TRUE)
  })
})
