## reset at 2021-06-25 13:50:37

library(httr)

expect_snapshot({
  r <- readRDS("../testdata/rate_limit_res.RDS")
  academictwitteR:::.trigger_sleep(r, ref_time = as.POSIXlt("2021-06-25 13:50:30"), verbose = TRUE, really_sleep = FALSE)
  academictwitteR:::.trigger_sleep(r, ref_time = as.POSIXlt("2021-06-25 13:50:30"), verbose = FALSE, really_sleep = FALSE)
  academictwitteR:::.trigger_sleep(r, ref_time = as.POSIXlt("2021-06-25 13:50:33"), verbose = TRUE, really_sleep = TRUE)
  academictwitteR:::.trigger_sleep(r, ref_time = as.POSIXlt("2021-06-25 13:50:36"), verbose = FALSE, really_sleep = TRUE)
})

  
