test_that("Expect success in binding two jsons", {
  empty_dir <- academictwitteR:::.gen_random_dir()
  dir.create(empty_dir)
  my_cars <- mtcars
  my_cars$model <- rownames(my_cars)
  jsonlite::write_json(my_cars, 
                       path = file.path(empty_dir, "errors_1.json"))
  jsonlite::write_json(my_cars, 
                       path = file.path(empty_dir, "errors_2.json"))
  expect_equal(bind_errors(empty_dir),
               dplyr::bind_rows(my_cars,my_cars))
  unlink(empty_dir, recursive = TRUE)
  ## Error on finding no jsons to bind
  temp_dir <-  academictwitteR:::.gen_random_dir()
  dir.create(temp_dir)
  expect_error(bind_errors(temp_dir))
  unlink(temp_dir)
})

test_that("real data", {
  expect_error(bind_errors("../testdata/errordata"), NA)
  ## Trailing slash
  expect_error(bind_errors("../testdata/errordata/"), NA)
  ## Silence
  expect_silent(bind_errors("../testdata/errordata/", verbose = FALSE))
})

