## NOTE: This test will only test various params of get_all_tweets, also the behaviours before and after the httr::GET (wrapped in fetch_data, which in turn wrapped in get_tweet)

## Also, we cannot test params: query, page_n, start_time, end_time with mock_api because these params are related to the GET request.

test_that("defensive programming", {
  expect_error(capture_warnings(get_all_tweets(query = "#commtwitter", end_tweets = "2021-06-05T00:00:00Z")))
  expect_error(capture_warnings(get_all_tweets(query = "#commtwitter", start_tweets = "2021-06-05T00:00:00Z")))
})


with_mock_api({
  test_that("params: default", {
    emptydir <- academictwitteR:::.gen_random_dir()
    ## "Normal" usage; at least the default
    expect_error(w0 <- capture_warnings(get_all_tweets(query = "#commtwitter", start_tweets = "2021-06-01T00:00:00Z", end_tweets = "2021-06-05T00:00:00Z", )), NA)
    unlink(emptydir)
  })
  test_that("params: data_path", {
  emptydir <- academictwitteR:::.gen_random_dir()
  expect_error(w1 <- capture_warnings(get_all_tweets(query = "#commtwitter", start_tweets = "2021-06-01T00:00:00Z", end_tweets = "2021-06-05T00:00:00Z", verbose = TRUE, data_path = emptydir)), NA)
  expect_match(w1, "Tweets will be bound", all = FALSE)
  expect_true(length(list.files(emptydir)) != 0) ### side effect is there
  ## warning message when the data_path is not empty
  w2 <- capture_warnings(get_all_tweets(query = "#commtwitter", start_tweets = "2021-06-01T00:00:00Z", end_tweets = "2021-06-05T00:00:00Z", verbose = TRUE, data_path = emptydir))
  expect_match(w2, "Tweets will be bound", all = FALSE)
  expect_match(w2, "Directory already exists", all = FALSE)
  unlink(emptydir)
  })
  test_that("param: bind_tweets", {
    emptydir <- academictwitteR:::.gen_random_dir()

    ## bind_tweets is FALSE and data_path is NULL: error
    expect_error(capture_warnings({
      get_all_tweets(query = "#commtwitter", start_tweets = "2021-06-01T00:00:00Z", end_tweets = "2021-06-05T00:00:00Z", verbose = TRUE, bind_tweets = FALSE)
    }))
    ## "NORMAL" USAGE
    expect_error(w3 <- capture_warnings({
      z1 <- get_all_tweets(query = "#commtwitter", start_tweets = "2021-06-01T00:00:00Z", end_tweets = "2021-06-05T00:00:00Z", verbose = TRUE, data_path = emptydir, bind_tweets = FALSE)
    }), NA)
    expect_equal(z1, NULL) ## nothing is returned; only side effect
    expect_true(identical(w3, character(0))) ## no warning
    unlink(emptydir)
    ## No data_path; no side effect
    emptydir <- academictwitteR:::.gen_random_dir()
    expect_error({
      w4 <- capture_warnings(get_all_tweets(query = "#commtwitter", start_tweets = "2021-06-01T00:00:00Z", end_tweets = "2021-06-05T00:00:00Z", verbose = TRUE, bind_tweets = TRUE))
    }, NA)
    expect_true(length(list.files(emptydir)) == 0) ## No side effect
    expect_false(identical(w4, character(0))) ## tons of warnings
    unlink(emptydir)
  })
  test_that("param: verbose", {
    ## verbose should also be tested; but there is still message in all cases

    ## emptydir <- academictwitteR:::.gen_random_dir()  
    ## expect_silent(get_all_tweets(query = "#commtwitter", start_tweets = "2021-06-01T00:00:00Z", end_tweets = "2021-06-05T00:00:00Z", verbose = FALSE, data_path = emptydir, bind_tweets = FALSE))
    ## unlink(emptydir)
    ## test for output
    emptydir <- academictwitteR:::.gen_random_dir()  
    expect_output(get_all_tweets(query = "#commtwitter", start_tweets = "2021-06-01T00:00:00Z", end_tweets = "2021-06-05T00:00:00Z", verbose = TRUE, data_path = emptydir, bind_tweets = FALSE))
    unlink(emptydir)
  })
  ## Until issue #144 is resolved
  ## test_that("param: file", {
  ##   emptydir <- academictwitteR:::.gen_random_dir()
  ##   temp_RDS <- "aaa.RDS"
  ##   expect_error(get_all_tweets(query = "#commtwitter", start_tweets = "2021-06-01T00:00:00Z", end_tweets = "2021-06-05T00:00:00Z", verbose = TRUE, data_path = emptydir, bind_tweets = FALSE, file = temp_RDS), NA)
  ##   expect_true(file.exists(temp_RDS))
  ##   x <- readRDS(temp_RDS)
  ##   expect_true("data.frame" %in% class(x))
  ## })

  test_that("param: export_query", {
    emptydir <- academictwitteR:::.gen_random_dir()  
    capture_warnings(get_all_tweets(query = "#commtwitter", start_tweets = "2021-06-01T00:00:00Z", end_tweets = "2021-06-05T00:00:00Z", verbose = TRUE, data_path = emptydir, bind_tweets = FALSE, export_query = TRUE))
    expect_true(file.exists(paste0(emptydir, "/query")))
    unlink(emptydir)

    emptydir <- academictwitteR:::.gen_random_dir()  
    capture_warnings(get_all_tweets(query = "#commtwitter", start_tweets = "2021-06-01T00:00:00Z", end_tweets = "2021-06-05T00:00:00Z", verbose = TRUE, data_path = emptydir, bind_tweets = FALSE, export_query = FALSE))
    expect_false(file.exists(paste0(emptydir, "/query")))
    unlink(emptydir)
  })  
})
