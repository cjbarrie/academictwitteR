## NOTE: This test will only test various params of get_all_tweets, also the behaviours before and after the httr::GET (wrapped in fetch_data, which in turn wrapped in get_tweet)

## Also, we cannot test params: query, page_n, start_time, end_time with mock_api because these params are related to the GET request.

## Github secret has not been set yet!

test_that("defensive programming", {
  expect_error(capture_warnings(get_all_tweets(query = "#commtwitter", end_tweets = "2021-06-05T00:00:00Z")))
  expect_error(capture_warnings(get_all_tweets(query = "#commtwitter", start_tweets = "2021-06-05T00:00:00Z")))
})


## require(httptest)
## start_capturing(simplify = FALSE)
## get_all_tweets(query = "#commtwitter", start_tweets = "2021-06-01T00:00:00Z", end_tweets = "2021-06-05T00:00:00Z", data_path = "../testdata/commtwitter")
## stop_capturing()


with_mock_api({
  test_that("params: default", {
    skip_if(!dir.exists("api.twitter.com"))
    emptydir <- academictwitteR:::.gen_random_dir()
    ## "Normal" usage; at least the default
    expect_error(w0 <- capture_warnings(get_all_tweets(query = "#commtwitter", start_tweets = "2021-06-01T00:00:00Z", end_tweets = "2021-06-05T00:00:00Z")), NA)
    unlink(emptydir, recursive = TRUE)
  })
  test_that("params: data_path", {
    skip_if(!dir.exists("api.twitter.com"))
    emptydir <- academictwitteR:::.gen_random_dir()
    expect_error(w1 <- capture_warnings(get_all_tweets(query = "#commtwitter", start_tweets = "2021-06-01T00:00:00Z", end_tweets = "2021-06-05T00:00:00Z", verbose = TRUE, data_path = emptydir)), NA)
    expect_match(w1, "Tweets will be bound", all = FALSE)
    expect_true(length(list.files(emptydir)) != 0) ### side effect is there
    ## warning message when the data_path is not empty
    w2 <- capture_warnings(get_all_tweets(query = "#commtwitter", start_tweets = "2021-06-01T00:00:00Z", end_tweets = "2021-06-05T00:00:00Z", verbose = TRUE, data_path = emptydir))
    expect_match(w2, "Tweets will be bound", all = FALSE)
    expect_match(w2, "Directory already exists", all = FALSE)
    unlink(emptydir, recursive = TRUE)
  })
  test_that("param: bind_tweets", {
    skip_if(!dir.exists("api.twitter.com"))
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
    unlink(emptydir, recursive = TRUE)
    ## No data_path; no side effect
    emptydir <- academictwitteR:::.gen_random_dir()
    expect_error({
      w4 <- capture_warnings(get_all_tweets(query = "#commtwitter", start_tweets = "2021-06-01T00:00:00Z", end_tweets = "2021-06-05T00:00:00Z", verbose = TRUE, bind_tweets = TRUE))
    }, NA)
    expect_true(length(list.files(emptydir)) == 0) ## No side effect
    expect_false(identical(w4, character(0))) ## tons of warnings
    unlink(emptydir, recursive = TRUE)
  })
  test_that("param: verbose", {
    skip_if(!dir.exists("api.twitter.com"))
    emptydir <- academictwitteR:::.gen_random_dir()  
    expect_silent(get_all_tweets(query = "#commtwitter", start_tweets = "2021-06-01T00:00:00Z", end_tweets = "2021-06-05T00:00:00Z", verbose = FALSE, data_path = emptydir, bind_tweets = FALSE))
    unlink(emptydir, recursive = TRUE)
    ## warning suppression, no data_path
    emptydir <- academictwitteR:::.gen_random_dir()
    expect_silent(get_all_tweets("#commtwitter", start_tweets = "2021-06-01T00:00:00Z", 
                                 end_tweets = "2021-06-05T00:00:00Z", bind_tweets = TRUE, 
                                 data_path = NULL, verbose = FALSE))
    unlink(emptydir, recursive = TRUE)
    ## existing dir
    emptydir <- academictwitteR:::.gen_random_dir()  
    dir.create(emptydir)
    expect_silent(get_all_tweets(query = "#commtwitter", start_tweets = "2021-06-01T00:00:00Z", end_tweets = "2021-06-05T00:00:00Z", verbose = FALSE, data_path = emptydir, bind_tweets = FALSE))
    unlink(emptydir, recursive = TRUE)    
    ## test for output
    emptydir <- academictwitteR:::.gen_random_dir()  
    expect_output(get_all_tweets(query = "#commtwitter", start_tweets = "2021-06-01T00:00:00Z", end_tweets = "2021-06-05T00:00:00Z", verbose = TRUE, data_path = emptydir, bind_tweets = FALSE))
    unlink(emptydir, recursive = TRUE)
  })
  test_that("param: file", {
    skip_if(!dir.exists("api.twitter.com"))
    emptydir <- academictwitteR:::.gen_random_dir()
    temp_RDS <- "aaa.RDS"
    expect_error(capture_warnings(get_all_tweets(query = "#commtwitter", start_tweets = "2021-06-01T00:00:00Z", end_tweets = "2021-06-05T00:00:00Z", verbose = TRUE, data_path = emptydir, bind_tweets = FALSE, file = temp_RDS)), NA)
    expect_true(file.exists(temp_RDS))
    expect_false(file.exists(paste0(temp_RDS, ".rds")))
    x <- readRDS(temp_RDS)
    expect_true("data.frame" %in% class(x))
    unlink(temp_RDS)
    unlink(emptydir, recursive = TRUE)
  })

  test_that("param: export_query", {
    skip_if(!dir.exists("api.twitter.com"))
    emptydir <- academictwitteR:::.gen_random_dir()  
    capture_warnings(get_all_tweets(query = "#commtwitter", start_tweets = "2021-06-01T00:00:00Z", end_tweets = "2021-06-05T00:00:00Z", verbose = TRUE, data_path = emptydir, bind_tweets = FALSE, export_query = TRUE))
    expect_true(file.exists(paste0(emptydir, "/query")))
    unlink(emptydir, recursive = TRUE)

    emptydir <- academictwitteR:::.gen_random_dir()  
    capture_warnings(get_all_tweets(query = "#commtwitter", start_tweets = "2021-06-01T00:00:00Z", end_tweets = "2021-06-05T00:00:00Z", verbose = TRUE, data_path = emptydir, bind_tweets = FALSE, export_query = FALSE))
    expect_false(file.exists(paste0(emptydir, "/query")))
    unlink(emptydir, recursive = TRUE)
  })  
})

