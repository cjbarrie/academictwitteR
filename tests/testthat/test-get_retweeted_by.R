## require(httptest)
## start_capturing(simplify = FALSE)
## res <- get_retweeted_by("1423714771384340481")
## stop_capturing()

with_mock_api({
  test_that("expected behavior, #153", {
    skip_if(!dir.exists("api.twitter.com"))
    res <- get_retweeted_by("1423714771384340481")
    expect_equal(nrow(res), 2) ## no page flipping
  })
})

## require(httptest)
## start_capturing(simplify = FALSE)
## res <- get_retweeted_by("1399797349296197635")
## stop_capturing()

with_mock_api({
  test_that("zero row behavior", {
    skip_if(!dir.exists("api.twitter.com"))
    expect_error(res <- get_retweeted_by("1399797349296197635"), NA)
    expect_equal(nrow(res), 0)
  })
})

with_mock_api({
  test_that("x is a vector", {
    skip_if(!dir.exists("api.twitter.com"))
    expect_error(res <- get_retweeted_by(c("1399797349296197635", "1423714771384340481")), NA)
    expect_equal(nrow(res), 2)
  })
})

with_mock_api({
  test_that("verbose behaviour", {
    skip_if(!dir.exists("api.twitter.com"))
    expect_silent(get_retweeted_by(c("1399797349296197635", "1423714771384340481"), verbose = FALSE))
    expect_output(get_retweeted_by(c("1399797349296197635", "1423714771384340481"), verbose = TRUE))
  })
})
