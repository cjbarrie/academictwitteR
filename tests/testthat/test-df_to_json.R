test_that("empty input", {
  tempdir <- academictwitteR:::.gen_random_dir()
  academictwitteR:::create_data_dir(tempdir, verbose = FALSE)
  whatever <- list()
  academictwitteR:::df_to_json(df = whatever, data_path = tempdir)
  expect_equal(length(list.files(tempdir)), 0)
  whatever$hello <- iris
  academictwitteR:::df_to_json(df = whatever, data_path = tempdir)
  expect_equal(length(list.files(tempdir)), 0)
  whatever$data <- iris
  whatever$data$id <- 123
  academictwitteR:::df_to_json(df = whatever, data_path = tempdir)
  whatever$includes <- mtcars
  ## should only write when both data and includes are there
  academictwitteR:::df_to_json(df = whatever, data_path = tempdir)
  expect_equal(length(list.files(tempdir)), 2)  
  unlink(tempdir)
})

test_that("empty input, error = TRUE", {
  tempdir <- academictwitteR:::.gen_random_dir()
  academictwitteR:::create_data_dir(tempdir, verbose = FALSE)
  whatever <- list()
  academictwitteR:::df_to_json(df = whatever, data_path = tempdir, errors = TRUE)
  expect_equal(length(list.files(tempdir)), 0)
  whatever$hello <- iris
  academictwitteR:::df_to_json(df = whatever, data_path = tempdir, errors = TRUE)
  expect_equal(length(list.files(tempdir)), 0)
  whatever$data <- iris
  whatever$data$id <- 123
  academictwitteR:::df_to_json(df = whatever, data_path = tempdir, errors = TRUE)
  whatever$includes <- mtcars
  ## should only write when both data and includes are there
  academictwitteR:::df_to_json(df = whatever, data_path = tempdir, errors = TRUE)
  expect_equal(length(list.files(tempdir)), 2)
  whatever$errors <- mtcars
  academictwitteR:::df_to_json(df = whatever, data_path = tempdir, errors = TRUE)
  expect_equal(length(list.files(tempdir)), 3)  
  unlink(tempdir)
})
