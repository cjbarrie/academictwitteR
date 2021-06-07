empty_dir <- tempdir()

my_cars <- mtcars
my_cars$model <- rownames(my_cars)

jsonlite::write_json(my_cars, 
                     path = file.path(empty_dir, "data_1.json"))
jsonlite::write_json(my_cars, 
                     path = file.path(empty_dir, "data_2.json"))

test_that("Expect sucess in binding two jsons", {
  expect_equal(bind_tweet_jsons(empty_dir),
               dplyr::bind_rows(my_cars,my_cars))
})

unlink(empty_dir, recursive = TRUE)

temp_dir <-  paste0(tempdir(), "/", paste0(sample(letters, 20), collapse = ""))
dir.create(temp_dir)

test_that("Error on finding no jsons to bind", {
  expect_error(bind_tweet_jsons(temp_dir))
})


test_that("real data", {
  expect_error(bind_tweet_jsons("../testdata/commtwitter"), NA)
})

test_that("trailing slash", {
  expect_error(bind_tweet_jsons("../testdata/commtwitter/"), NA)
})

unlink(temp_dir)
