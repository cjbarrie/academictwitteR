## require(httptest)
## start_capturing(simplify = FALSE)
## list_compliance_jobs()
## list_compliance_jobs(type = "users")
## get_compliance_result("1460701905789886472", verbose = FALSE)
## get_compliance_result("1460694452490674183", verbose = FALSE)
## stop_capturing()


## require(httptest)
## start_capturing(simplify = FALSE)
## res <- create_compliance_job(file = "../testdata/bad_tweet_ids.txt", type = "tweets")
## res <- create_compliance_job(file = "../testdata/bad_user_ids.txt", type = "users")
## stop_capturing()

with_mock_api({
  test_that("create_compliance_job (tweets basic)", {
    skip_if(!dir.exists("api.twitter.com"))
    expect_output(res <- create_compliance_job(file = "../testdata/bad_tweet_ids.txt", type = "tweets"))
    expect_length(res, 1)
    expect_silent(create_compliance_job(file = "../testdata/bad_tweet_ids.txt", type = "tweets", verbose = FALSE))
    expect_error(create_compliance_job(file = "", type = "tweets"))
    expect_error(create_compliance_job(file = "../testdata/bad_tweet_ids.txt", type = "wat"))

  })
  test_that("create_compliance_job (tweets basic)", {
    skip_if(!dir.exists("api.twitter.com"))
    expect_output(res <- create_compliance_job(file = "../testdata/bad_user_ids.txt", type = "users"))
    expect_length(res, 1)
    expect_silent(create_compliance_job(file = "../testdata/bad_user_ids.txt", type = "users", verbose = FALSE))
    expect_error(create_compliance_job(file = "", type = "users"))
  })
  test_that("list_compliance_jobs (tweets / users)", {
    skip_if(!dir.exists("api.twitter.com"))
    expect_true(class(list_compliance_jobs()) == "data.frame")
    expect_true(class(list_compliance_jobs(type = "tweets")) == "data.frame")
    expect_true(class(list_compliance_jobs(type = "users")) == "data.frame")
    expect_error(list_compliance_jobs(type = "wat"))
  })
  test_that("get_compliance_result (tweets)",{
    skip_if(!dir.exists("api.twitter.com"))
    expect_output(res <- get_compliance_result("1460701905789886472"))
    expect_silent(get_compliance_result("1460701905789886472", verbose = FALSE))
    expect_true(class(res) == "data.frame")
    expect_output(res <- get_compliance_result("1460694452490674183"))
    expect_silent(get_compliance_result("1460694452490674183", verbose = FALSE))
    expect_true(class(res) == "data.frame")    
  })
})
