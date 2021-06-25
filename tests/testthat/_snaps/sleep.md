# test .trigger_sleep

    Code
      academictwitteR:::.trigger_sleep(r, ref_time = as.POSIXlt("2021-06-25 13:50:30"),
      verbose = TRUE, really_sleep = FALSE)
    Output
      Rate limit reached. Rate limit will reset at 2021-06-25 13:50:37 
      Sleeping for 8 seconds. 
      ================================================================================

---

    Code
      academictwitteR:::.trigger_sleep(r, ref_time = as.POSIXlt("2021-06-25 13:50:30"),
      verbose = FALSE, really_sleep = FALSE)

---

    Code
      academictwitteR:::.trigger_sleep(r, ref_time = as.POSIXlt("2021-06-25 13:50:33"),
      verbose = TRUE, really_sleep = TRUE)
    Output
      Rate limit reached. Rate limit will reset at 2021-06-25 13:50:37 
      Sleeping for 5 seconds. 
      ================================================================================

---

    Code
      academictwitteR:::.trigger_sleep(r, ref_time = as.POSIXlt("2021-06-25 13:50:36"),
      verbose = FALSE, really_sleep = TRUE)

