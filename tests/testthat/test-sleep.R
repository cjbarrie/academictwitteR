## reset at 2021-06-25 13:50:37 CEST
## or 2021-06-25 11:50:37 UTC
library(httr)

test_that("test .trigger_sleep", {
  r <- readRDS("../testdata/rate_limit_res.RDS")
  expect_snapshot({
    academictwitteR:::.trigger_sleep(r, ref_time = as.POSIXlt("2021-06-25 11:50:30", tz = "UTC"), verbose = TRUE, really_sleep = FALSE, tzone = "UTC")
  })
  expect_snapshot({
    academictwitteR:::.trigger_sleep(r, ref_time = as.POSIXlt("2021-06-25 11:50:30", tz = "UTC"), verbose = FALSE, really_sleep = FALSE, tzone = "UTC")
  })
  expect_snapshot({
    academictwitteR:::.trigger_sleep(r, ref_time = as.POSIXlt("2021-06-25 11:50:33", tz = "UTC"), verbose = TRUE, really_sleep = TRUE, tzone = "UTC")
  })
  expect_snapshot({
    academictwitteR:::.trigger_sleep(r, ref_time = as.POSIXlt("2021-06-25 11:50:36", tz = "UTC"), verbose = FALSE, really_sleep = TRUE, tzone = "UTC")
  })
})
