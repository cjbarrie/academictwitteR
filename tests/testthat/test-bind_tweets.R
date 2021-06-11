test_that("user = FALSE, Expect success in binding two jsons", {
  empty_dir <- academictwitteR:::.gen_random_dir()
  dir.create(empty_dir)
  my_cars <- mtcars
  my_cars$model <- rownames(my_cars)
  jsonlite::write_json(my_cars, 
                       path = file.path(empty_dir, "data_1.json"))
  jsonlite::write_json(my_cars, 
                       path = file.path(empty_dir, "data_2.json"))
  expect_equal(bind_tweets(empty_dir),
               dplyr::bind_rows(my_cars,my_cars))
  unlink(empty_dir, recursive = TRUE)
  ## Error on finding no jsons to bind
  temp_dir <-  academictwitteR:::.gen_random_dir()
  dir.create(temp_dir)
  expect_error(bind_tweets(temp_dir))
  unlink(temp_dir)
})

test_that("user = FALSE, real data", {
  expect_error(bind_tweets("../testdata/commtwitter"), NA)
  ## Trailing slash
  expect_error(bind_tweets("../testdata/commtwitter/"), NA)
  ## Silence
  expect_silent(bind_tweets("../testdata/commtwitter/", verbose = FALSE))
})

test_that("user = TRUE, Expect success in binding two jsons", {
  empty_dir <- academictwitteR:::.gen_random_dir()
  dir.create(empty_dir)
  my_cars <- mtcars
  my_cars$model <- rownames(my_cars)
  jsonlite::write_json(list(users = my_cars, tweets = iris), 
                       path = file.path(empty_dir, "users_1.json"))
  jsonlite::write_json(list(users = my_cars, tweets = iris), 
                       path = file.path(empty_dir, "users_2.json"))
  expect_equal(bind_tweets(empty_dir, user = TRUE),
               dplyr::bind_rows(my_cars,my_cars))
  unlink(empty_dir, recursive = TRUE)
  temp_dir <-  paste0(tempdir(), "/", paste0(sample(letters, 20), collapse = ""))
  dir.create(temp_dir)
  ## Error on finding no jsons to bind
  expect_error(bind_tweets(temp_dir, user = TRUE))
  unlink(temp_dir)
})

test_that("user = TRUE, real data: data_path without trailing slash #97", {
  expect_error(bind_tweets("../testdata/commtwitter", user = TRUE), NA)
})

test_that("user = TRUE, real data: data_path with trailing slash #97", {
  expect_error(bind_tweets("../testdata/commtwitter/", user = TRUE), NA)
})

test_that("user = TRUE, verbose = FALSE", {
  expect_silent(bind_tweets("../testdata/commtwitter/", user = TRUE, verbose = FALSE))
})
