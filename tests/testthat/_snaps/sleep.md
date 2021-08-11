# test .trigger_sleep

    Code
      academictwitteR:::.trigger_sleep(r, ref_time = as.POSIXlt("2021-06-25 11:50:30",
        tz = "UTC"), verbose = TRUE, really_sleep = FALSE, tzone = "UTC")
    Output
      Rate limit reached. Rate limit will reset at 2021-06-25 11:50:37 
      Sleeping for 8 seconds. 
      ================================================================================

---

    Code
      academictwitteR:::.trigger_sleep(r, ref_time = as.POSIXlt("2021-06-25 11:50:30",
        tz = "UTC"), verbose = FALSE, really_sleep = FALSE, tzone = "UTC")

---

    Code
      academictwitteR:::.trigger_sleep(r, ref_time = as.POSIXlt("2021-06-25 11:50:33",
        tz = "UTC"), verbose = TRUE, really_sleep = TRUE, tzone = "UTC")
    Output
      Rate limit reached. Rate limit will reset at 2021-06-25 11:50:37 
      Sleeping for 5 seconds. 
      ================================================================================

---

    Code
      academictwitteR:::.trigger_sleep(r, ref_time = as.POSIXlt("2021-06-25 11:50:36",
        tz = "UTC"), verbose = FALSE, really_sleep = TRUE, tzone = "UTC")

# disable adaptive sleeping if ref_time is later than reset_time in r, #213

    Code
      academictwitteR:::.trigger_sleep(r, ref_time = as.POSIXlt("2021-06-25 11:50:40",
        tz = "UTC"), verbose = TRUE, really_sleep = FALSE, tzone = "UTC")
    Output
      Rate limit reached. Cannot estimate adaptive sleep time. Sleeping for 900 seconds. 
      ================================================================================

---

    Code
      academictwitteR:::.trigger_sleep(r, ref_time = as.POSIXlt("2021-06-25 11:50:40",
        tz = "UTC"), verbose = FALSE, really_sleep = FALSE, tzone = "UTC")

