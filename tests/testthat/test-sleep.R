## reset at 2021-06-25 13:50:37
Sys.setenv(TZ='"Europe/Berlin"')

library(httr)

test_that("test .trigger_sleep", {
  r <- readRDS("../testdata/rate_limit_res.RDS")
  expect_snapshot({
    academictwitteR:::.trigger_sleep(r, ref_time = as.POSIXlt("2021-06-25 13:50:30"), verbose = TRUE, really_sleep = FALSE)
  })
  expect_snapshot({
    academictwitteR:::.trigger_sleep(r, ref_time = as.POSIXlt("2021-06-25 13:50:30"), verbose = FALSE, really_sleep = FALSE)
  })
  expect_snapshot({
    academictwitteR:::.trigger_sleep(r, ref_time = as.POSIXlt("2021-06-25 13:50:33"), verbose = TRUE, really_sleep = TRUE)
  })
  expect_snapshot({
    academictwitteR:::.trigger_sleep(r, ref_time = as.POSIXlt("2021-06-25 13:50:36"), verbose = FALSE, really_sleep = TRUE)
  })
})

Sys.unsetenv("TZ")
