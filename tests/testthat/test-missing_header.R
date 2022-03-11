
test_that("test missing header", {
  library(httr)
  skip_if(!file.exists("../testdata/rate_limit_res.RDS"))
  r <- readRDS("../testdata/rate_limit_res.RDS")
  expect_false(academictwitteR:::.check_header_rate_limit(r, verbose = FALSE))
  crazy_r <- r
  crazy_r$headers$`x-rate-limit-remaining` <- "1"
  expect_true(academictwitteR:::.check_header_rate_limit(crazy_r, verbose = FALSE))
  expect_warning(academictwitteR:::.check_header_rate_limit(crazy_r, verbose = TRUE))
  really_crazy_r <- r
  really_crazy_r$headers$`x-rate-limit-remaining` <- NULL
  expect_false(academictwitteR:::.check_header_rate_limit(really_crazy_r, verbose = FALSE))
})
