test_that("No duplication ", {
  ori_test <- "../testdata/commtwitter/"
  test_dir <- academictwitteR:::.gen_random_dir()
  dir.create(test_dir)
  z <- file.copy(list.files(ori_test, full.names = TRUE, recursive = TRUE), test_dir, recursive = TRUE)
  update_collection(test_dir, end_tweets = "2021-06-14T23:59:59Z", bind_tweets = FALSE)
  a1 <- bind_tweets(test_dir)
  ## a2 <- bind_tweets(ori_test)
  testthat::expect_true(length(unique(a1$id)) == length(a1$id))
  testthat::expect_true(length(table(a1$id)[table(a1$id) == 2]) == 0)
})
