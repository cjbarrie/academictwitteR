test_that("bind_tweets, basic", {
  expect_error(bind_tweets("../testdata/commtwitter", output_format = "tidy2"), NA)
  ## Trailing slash
  expect_error(bind_tweets("../testdata/commtwitter/", output_format = "tidy2"), NA)
  ## Silence
  expect_silent(bind_tweets("../testdata/commtwitter/", output_format = "tidy2", verbose = FALSE))
})

test_that("convert_json, basic", {
  expect_error(convert_json("../testdata/commtwitter/data_1399765322509557763.json", output_format = "tidy2"), NA)
  expect_error(convert_json("../testdata/commtwitter/data_1399765322509557763.json", output_format = "tidy2"), NA)
  expect_silent(convert_json("../testdata/commtwitter/data_1399765322509557763.json", output_format = "tidy2"))
})

test_that("corner cases", {
  ## only organic tweets
  skip_if(!dir.exists("../testdata/hk"))
  skip_if(!dir.exists("../testdata/hk2"))
  skip_if(!dir.exists("../testdata/hk3"))
  skip_if(!dir.exists("../testdata/reuters"))
  res <- bind_tweets("../testdata/hk", output_format = "tidy2")
  ori <- bind_tweets("../testdata/hk", verbose = FALSE)
  expect_equal(nrow(res), nrow(ori))
  ## all types
  res <- bind_tweets("../testdata/hk2", output_format = "tidy2")
  ori <- bind_tweets("../testdata/hk2", verbose = FALSE)
  expect_equal(nrow(res), nrow(ori))
  ## only replies
  res <- bind_tweets("../testdata/hk3", output_format = "tidy2")
  ori <- bind_tweets("../testdata/hk3", verbose = FALSE)
  expect_equal(nrow(res), nrow(ori))
  res <- bind_tweets("../testdata/reuters", output_format = "tidy2")
  ori <- bind_tweets("../testdata/reuters", verbose = FALSE)
  expect_equal(nrow(res), nrow(ori))  

})
