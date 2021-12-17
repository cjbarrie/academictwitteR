## These tests are using cases where ids are all valid.

test_that("Corner cases", {
  expect_error(capture_warnings(hydrate_tweets()))
  expect_error(capture_warnings(hydrate_tweets(c())), NA)
  capture_warnings(res <- hydrate_tweets(c()))
  expect_equal(nrow(res), 0)
  expect_equal(class(res), "data.frame")
})

## require(httptest)
## start_capturing(simplify = FALSE)
## fff <- readRDS("../testdata/fff_de.RDS")
## hydrate_tweets(fff, verbose = FALSE)
## stop_capturing()

with_mock_api({
  test_that("normal case: fff de", {
    skip_if(!dir.exists("api.twitter.com"))
    fff <- readRDS("../testdata/fff_de.RDS")
    expect_error(res <- hydrate_tweets(fff, verbose = FALSE), NA)
    expect_equal(nrow(res), length(fff))
  })
  test_that("normal case: verbose", {
    skip_if(!dir.exists("api.twitter.com"))
    fff <- readRDS("../testdata/fff_de.RDS")
    expect_silent(res <- hydrate_tweets(fff, verbose = FALSE))
    expect_output(capture_warnings(res <- hydrate_tweets(fff, verbose = TRUE)))
  })
  test_that("normal case: bind_tweets", {
    skip_if(!dir.exists("api.twitter.com"))
    fff <- readRDS("../testdata/fff_de.RDS")
    emptydir <- academictwitteR:::.gen_random_dir()  
    expect_silent(res <- hydrate_tweets(fff, verbose = FALSE, data_path = emptydir))
    expect_true(length(list.files(emptydir, "json$")) > 0)
    expect_error(z <- bind_tweets(emptydir, verbose = FALSE), NA)
    expect_equal(length(fff), nrow(z))
    unlink(emptydir, recursive = TRUE)
    emptydir <- academictwitteR:::.gen_random_dir()  
    expect_silent(capture_warnings(res <- hydrate_tweets(fff, verbose = FALSE, data_path = emptydir, bind_tweets = FALSE)))
    ## error when data_path is null and bind_tweets is FALSE
    ## the same expected behavior to `get_all_tweets`
    expect_error(capture_warnings(res <- hydrate_tweets(fff, data_path = NULL, bind_tweets = FALSE)))
  })
})

## require(httptest)
## start_capturing(simplify = FALSE)
## fff <- readRDS("../testdata/fff_de.RDS")
## hydrate_tweets(fff, verbose = FALSE, context_annotations = TRUE)
## stop_capturing()

with_mock_api({
  test_that("normal case: context_anntations", {
    skip_if(!dir.exists("api.twitter.com"))
    fff <- readRDS("../testdata/fff_de.RDS")
    ca1 <- hydrate_tweets(fff, verbose = FALSE, context_annotations = TRUE)
    expect_true("context_annotations" %in% colnames(ca1))
    expect_equal(nrow(ca1), length(fff))
    ca0 <- hydrate_tweets(fff, verbose = FALSE, context_annotations = FALSE)
    expect_false("context_annotations" %in% colnames(ca0))
    expect_equal(nrow(ca0), length(fff))
  })
})

## require(httptest)
## start_capturing(simplify = FALSE)
## fff <- readRDS("../testdata/fff_de.RDS")
## manyf <- c(fff, fff, fff)
## for (i in c(1, 99, 100, 199, 200, 250)) {
##   hydrate_tweets(manyf[seq_len(i)], verbose = FALSE)
## }
## stop_capturing()

with_mock_api({
  test_that("normal case: different sizes", {
    skip_if(!dir.exists("api.twitter.com"))
    fff <- readRDS("../testdata/fff_de.RDS")
    manyf <- c(fff, fff, fff)
    for (i in c(1, 99, 100, 199, 200, 250)) {
      expect_error(res <- hydrate_tweets(manyf[seq_len(i)], verbose = FALSE), NA)
      expect_equal(nrow(res), i)
    }
  })
})
