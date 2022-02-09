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

## issue #287

## require(httptest)
## start_capturing(simplify = FALSE)
## res <- get_retweeted_by("1476155918597373952")
## stop_capturing()

with_mock_api({
  test_that("issue #287", {
    skip_if(!dir.exists("api.twitter.com"))
    expect_silent(get_retweeted_by(c("1476155918597373952"), verbose = FALSE))
    expect_output(get_retweeted_by(c("1476155918597373952"), verbose = TRUE))
  })
})

## require(httptest)
## start_capturing(simplify = FALSE)
## res <- get_retweeted_by("1483379681206415361")
## stop_capturing()

with_mock_api({
  test_that("issue #287, integration", {
    skip_if(!dir.exists("api.twitter.com"))
    ids <- c("1399797349296197635", "1476155918597373952", "1483379681206415361")
    expect_output(res <- get_retweeted_by(ids, verbose = TRUE))
    expect_false("1399797349296197635" %in% unique(res$from_id))
    expect_true("1476155918597373952" %in% unique(res$from_id))
    expect_true("1483379681206415361" %in% unique(res$from_id))
  })
})
