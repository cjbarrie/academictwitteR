bearer_token <- "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
test_that("Radius argument must be passed", {
  expect_error({
    tweets <- get_radius_tweets("happy",
                                start_tweets = "2021-01-01T00:00:00Z",
                                end_tweets = "2021-01-01T10:00:00Z",
                                bearer_token = bearer_token, data_path = "data/")
  })
})



