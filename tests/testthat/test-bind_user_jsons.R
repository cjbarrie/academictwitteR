## context("bind_tweet_jsons")

empty_dir <- tempdir(check = TRUE)

my_cars <- mtcars
my_cars$model <- rownames(my_cars)

jsonlite::write_json(list(users = my_cars, tweets = iris), 
                     path = file.path(empty_dir, "users_1.json"))
jsonlite::write_json(list(users = my_cars, tweets = iris), 
                     path = file.path(empty_dir, "users_2.json"))

test_that("Expect sucess in binding two jsons", {
  expect_equal(bind_user_jsons(empty_dir),
               dplyr::bind_rows(my_cars,my_cars))
})

unlink(empty_dir, recursive = TRUE)
temp_dir <- tempdir()

test_that("Error on finding no jsons to bind", {
  expect_error(bind_tweet_jsons(temp_dir))
})


test_that("real data: data_path without trailing slash #97", {
  expect_error(bind_user_jsons("../testdata/commtwitter"), NA)
})

test_that("real data: data_path with trailing slash #97", {
  expect_error(bind_user_jsons("../testdata/commtwitter/"), NA)
})

