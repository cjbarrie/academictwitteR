test_that("set_bearer and get_bearer are working", {
  skip_on_cran() # writing in ~ is not forbidden on CRAN, only test this on local or CI
  random_bear <- paste(sample(LETTERS, 10, replace = TRUE), collapse = "")
  loc <- tempfile(tmpdir = "~")
  expect_error(set_bearer(random_bear, loc), NA)
  expect_equal(get_bearer(loc), random_bear)
  unlink(loc)
})

test_that("set_bearer interactive", {
  skip_on_cran() # writing in ~ is not forbidden on CRAN, only test this on local or CI
  random_bear <- paste(sample(LETTERS, 10, replace = TRUE), collapse = "")
  loc <- tempfile(tmpdir = "~")
  temp_input <- tempfile(tmpdir = "~")
  writeLines(paste(c(random_bear), collapse = "\n"), con = temp_input)
  inputs <- file(temp_input)
  options("academictwitteR.connection" = inputs)
  set_bearer(path = loc)
  close(inputs)
  expect_equal(get_bearer(loc), random_bear)
  options("academictwitteR.connection" = NULL)
  unlink(loc)
  unlink(inputs)
})
