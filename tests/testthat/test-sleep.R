## reset at 2021-06-25 13:50:37

expect_snapshot({
  r <- readRDS("../testdata/rate_limit_res.RDS")
  .trigger_sleep(r, ref_time = as.POSIXlt("2021-06-25 13:50:30"), verbose = TRUE, really_sleep = FALSE)
  .trigger_sleep(r, ref_time = as.POSIXlt("2021-06-25 13:50:30"), verbose = FALSE, really_sleep = FALSE)
  .trigger_sleep(r, ref_time = as.POSIXlt("2021-06-25 13:50:33"), verbose = TRUE, really_sleep = TRUE)
  .trigger_sleep(r, ref_time = as.POSIXlt("2021-06-25 13:50:36"), verbose = FALSE, really_sleep = TRUE)
})

  
