
empty_dir <- tempdir()
jsonlite::write_json(jsonlite::toJSON(mtcars), 
                     path = file.path(empty_dir, "data_1.json"))
jsonlite::write_json(jsonlite::toJSON(mtcars), 
                     path = file.path(empty_dir, "data_2.json"))

test_that("Error on non-twitter json binding", {
  expect_error(bind_tweet_jsons(empty_dir))
})
