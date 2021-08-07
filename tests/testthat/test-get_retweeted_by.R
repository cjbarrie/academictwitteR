# require(httptest)
# start_capturing(simplify = FALSE)
# res <- get_retweeted_by("1423714771384340481")
# stop_capturing()

with_mock_api({
  test_that("expected behavior, #153", {
    res <- get_retweeted_by("1423714771384340481")
    expect_equal(nrow(res), 2) ## no page flipping
  })
})
