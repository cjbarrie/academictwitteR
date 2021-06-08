test_that("get_bearer", {
  ORI_BEARER <- Sys.getenv("TWITTER_BEARER")
  Sys.setenv("TWITTER_BEARER" = "")
  expect_error(get_bearer())
  Sys.setenv("TWITTER_BEARER" = "ABC")
  expect_error(get_bearer(), NA)
  expect_equal(get_bearer(), "ABC")
  Sys.setenv("TWITTER_BEARER" = ORI_BEARER)  
})
