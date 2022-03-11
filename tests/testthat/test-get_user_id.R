
## require(httptest)
## start_capturing(simplify = FALSE)
## usernames <- c("icahdq", "POTUS", "hadleywickhaM", "_R_Foundation", "adljfhjsd")
## get_user_id(usernames)
## stop_capturing()

with_mock_api({
  test_that("expected behavior, #153", {
    skip_if(!dir.exists("api.twitter.com"))
    usernames <- c("icahdq", "POTUS", "hadleywickhaM", "_R_Foundation", "adljfhjsd")
    expect_error(get_user_id(usernames), NA) ## no error
    expect_true(is.data.frame(get_user_id(usernames, all = TRUE)))
    expect_false(is.data.frame(get_user_id(usernames, all = FALSE)))
    expect_true(length(get_user_id(usernames, keep_na = TRUE)) == 5)
    expect_false(length(get_user_id(usernames, keep_na = FALSE)) == 5)
    expect_false("adljfhjsd" %in% names(get_user_id(usernames, keep_na = FALSE)))
    expect_true("adljfhjsd" %in% names(get_user_id(usernames)))
    ## Keeping the original weird casing
    expect_true("hadleywickhaM" %in% names(get_user_id(usernames, keep_na = TRUE)))
    expect_false("hadleywickham" %in% names(get_user_id(usernames, keep_na = TRUE)))
  })
})
