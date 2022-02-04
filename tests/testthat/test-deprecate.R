test_that("bind_tweet_jsons", {
  lifecycle::expect_deprecated(bind_tweet_jsons("../testdata/commtwitter"))
})

test_that("bind_user_jsons", {
  lifecycle::expect_deprecated(bind_user_jsons("../testdata/commtwitter"))
})

## require(httptest)
## start_capturing(simplify = FALSE)
## get_retweets_of_user(users = "kfc", start_tweets = "2021-06-01T00:00:00Z", end_tweets = "2021-06-05T00:00:00Z")
## stop_capturing()

with_mock_api({
  test_that("get_retweets_of_user", {
    skip_if(!dir.exists("api.twitter.com"))
    emptydir <- academictwitteR:::.gen_random_dir()
    lifecycle::expect_deprecated(get_retweets_of_user(users = "kfc", start_tweets = "2021-06-01T00:00:00Z", end_tweets = "2021-06-05T00:00:00Z", data_path = emptydir, bind_tweets = FALSE, verbose = FALSE))
    unlink(emptydir, recursive = TRUE)
  })
})

## require(httptest)
## start_capturing(simplify = FALSE)
## get_to_tweets(users = "kfc", start_tweets = "2021-06-01T00:00:00Z", end_tweets = "2021-06-05T00:00:00Z")
## stop_capturing()

with_mock_api({
  test_that("get_to_tweets", {
    skip_if(!dir.exists("api.twitter.com"))
    emptydir <- academictwitteR:::.gen_random_dir()
    lifecycle::expect_deprecated(get_to_tweets(users = "kfc", start_tweets = "2021-06-01T00:00:00Z", end_tweets = "2021-06-05T00:00:00Z", data_path = emptydir, bind_tweets = FALSE, verbose = FALSE))
    unlink(emptydir, recursive = TRUE)
  })
})

## require(httptest)
## start_capturing(simplify = FALSE)
## z <- get_user_tweets(users = "kfc", start_tweets = "2021-06-01T00:00:00Z", end_tweets = "2021-06-05T00:00:00Z")
## stop_capturing()

with_mock_api({
  test_that("get_users_tweets", {
    skip_if(!dir.exists("api.twitter.com"))
    emptydir <- academictwitteR:::.gen_random_dir()
    lifecycle::expect_deprecated(get_user_tweets(users = "kfc", start_tweets = "2021-06-01T00:00:00Z", end_tweets = "2021-06-05T00:00:00Z", data_path = emptydir, bind_tweets = FALSE, verbose = FALSE))
    unlink(emptydir, recursive = TRUE)
  })
})

## require(httptest)
## start_capturing(simplify = FALSE)
## z <- get_video_tweets(query = "#FallonTonight", start_tweets = "2021-06-01T00:00:00Z", end_tweets = "2021-06-05T00:00:00Z")
## stop_capturing()

with_mock_api({
  test_that("get_video_tweets", {
    skip_if(!dir.exists("api.twitter.com"))
    emptydir <- academictwitteR:::.gen_random_dir()
    lifecycle::expect_deprecated(get_video_tweets(query = "#FallonTonight", start_tweets = "2021-06-01T00:00:00Z", end_tweets = "2021-06-05T00:00:00Z", data_path = emptydir, bind_tweets = FALSE, verbose = FALSE))
    unlink(emptydir, recursive = TRUE)
  })
})

## require(httptest)
## start_capturing(simplify = FALSE)
## z <- get_radius_tweets(query = "happy", start_tweets = "2021-06-01T00:00:00Z", end_tweets = "2021-06-05T00:00:00Z", radius = c(-0.131969125179604,51.50847878040284, 25))
## stop_capturing()

with_mock_api({
  test_that("get_radius_tweets", {
    skip_if(!dir.exists("api.twitter.com"))
    emptydir <- academictwitteR:::.gen_random_dir()
    lifecycle::expect_deprecated(get_radius_tweets(query = "happy", start_tweets = "2021-06-01T00:00:00Z", end_tweets = "2021-06-05T00:00:00Z", radius = c(-0.131969125179604,51.50847878040284, 25), data_path = emptydir, bind_tweets = FALSE, verbose = FALSE))
    unlink(emptydir, recursive = TRUE)
  })
})

## require(httptest)
## start_capturing(simplify = FALSE)
## z <- get_bbox_tweets(query = "happy", start_tweets = "2021-06-01T00:00:00Z", end_tweets = "2021-06-05T00:00:00Z", bbox = c(-0.222473,51.442453,0.072784,51.568534))
## stop_capturing()

with_mock_api({
  test_that("get_bbox_tweets", {
    skip_if(!dir.exists("api.twitter.com"))
    emptydir <- academictwitteR:::.gen_random_dir()
    lifecycle::expect_deprecated(get_bbox_tweets(query = "happy", start_tweets = "2021-06-01T00:00:00Z", end_tweets = "2021-06-05T00:00:00Z", bbox = c(-0.222473,51.442453,0.072784,51.568534), data_path = emptydir, bind_tweets = FALSE, verbose = FALSE))
    unlink(emptydir, recursive = TRUE)
  })
})

## require(httptest)
## start_capturing(simplify = FALSE)
## z <- get_mentions_tweets(query = "happy", start_tweets = "2021-06-01T00:00:00Z", end_tweets = "2021-06-05T00:00:00Z")
## stop_capturing()

with_mock_api({
  test_that("get_mentions_tweets", {
    skip_if(!dir.exists("api.twitter.com"))
    emptydir <- academictwitteR:::.gen_random_dir()
    lifecycle::expect_deprecated(get_mentions_tweets(query = "happy", start_tweets = "2021-06-01T00:00:00Z", end_tweets = "2021-06-05T00:00:00Z", data_path = emptydir, bind_tweets = FALSE, verbose = FALSE))
    unlink(emptydir, recursive = TRUE)
  })
})

## require(httptest)
## start_capturing(simplify = FALSE)
## z <- get_lang_tweets(query = "#IchBinHanna", start_tweets = "2021-06-01T00:00:00Z", end_tweets = "2021-06-13T00:00:00Z", lang = "de")
## stop_capturing()

with_mock_api({
  test_that("get_lang_tweets", {
    skip_if(!dir.exists("api.twitter.com"))
    emptydir <- academictwitteR:::.gen_random_dir()
    lifecycle::expect_deprecated(get_lang_tweets(query = "#IchBinHanna", start_tweets = "2021-06-01T00:00:00Z", end_tweets = "2021-06-13T00:00:00Z", lang = "de", data_path = emptydir, bind_tweets = FALSE, verbose = FALSE))
    unlink(emptydir, recursive = TRUE)
  })
})

## require(httptest)
## start_capturing(simplify = FALSE)
## z <- get_country_tweets(query = "#IchBinHanna", start_tweets = "2021-06-01T00:00:00Z", end_tweets = "2021-06-13T00:00:00Z", country = "DE")
## stop_capturing()

with_mock_api({
  test_that("get_country_tweets", {
    skip_if(!dir.exists("api.twitter.com"))
    emptydir <- academictwitteR:::.gen_random_dir()
    lifecycle::expect_deprecated(get_country_tweets(query = "#IchBinHanna", start_tweets = "2021-06-01T00:00:00Z", end_tweets = "2021-06-13T00:00:00Z", country = "DE", data_path = emptydir, bind_tweets = FALSE, verbose = FALSE))
    unlink(emptydir, recursive = TRUE)
  })
})

## require(httptest)
## start_capturing(simplify = FALSE)
## z <- get_place_tweets(query = "#IchBinHanna", start_tweets = "2021-06-01T00:00:00Z", end_tweets = "2021-06-13T00:00:00Z", place = "Berlin")
## stop_capturing()

with_mock_api({
  test_that("get_place_tweets", {
    skip_if(!dir.exists("api.twitter.com"))
    emptydir <- academictwitteR:::.gen_random_dir()
    lifecycle::expect_deprecated(get_place_tweets(query = "#IchBinHanna", start_tweets = "2021-06-01T00:00:00Z", end_tweets = "2021-06-13T00:00:00Z", place = "Berlin", data_path = emptydir, bind_tweets = FALSE, verbose = FALSE))
    unlink(emptydir, recursive = TRUE)
  })
})

## require(httptest)
## start_capturing(simplify = FALSE)
## z <- get_image_tweets(query = "#IchBinHanna", start_tweets = "2021-06-01T00:00:00Z", end_tweets = "2021-06-13T00:00:00Z")
## stop_capturing()

with_mock_api({
  test_that("get_image_tweets", {
    skip_if(!dir.exists("api.twitter.com"))
    emptydir <- academictwitteR:::.gen_random_dir()
    lifecycle::expect_deprecated(get_image_tweets(query = "#IchBinHanna", start_tweets = "2021-06-01T00:00:00Z", end_tweets = "2021-06-13T00:00:00Z", data_path = emptydir, bind_tweets = FALSE, verbose = FALSE))
    unlink(emptydir, recursive = TRUE)
  })
})

## require(httptest)
## start_capturing(simplify = FALSE)
## z <- get_media_tweets(query = "#IchBinHanna", start_tweets = "2021-06-01T00:00:00Z", end_tweets = "2021-06-13T00:00:00Z")
## stop_capturing()

with_mock_api({
  test_that("get_media_tweets", {
    skip_if(!dir.exists("api.twitter.com"))
    emptydir <- academictwitteR:::.gen_random_dir()
    lifecycle::expect_deprecated(get_media_tweets(query = "#IchBinHanna", start_tweets = "2021-06-01T00:00:00Z", end_tweets = "2021-06-13T00:00:00Z", data_path = emptydir, bind_tweets = FALSE, verbose = FALSE))
    unlink(emptydir, recursive = TRUE)
  })
})

## require(httptest)
## start_capturing(simplify = FALSE)
## z <- get_url_tweets(query = "cdc.gov", start_tweets = "2021-06-01T00:00:00Z", end_tweets = "2021-06-13T00:00:00Z")
## stop_capturing()

with_mock_api({
  test_that("get_url_tweets", {
    skip_if(!dir.exists("api.twitter.com"))
    emptydir <- academictwitteR:::.gen_random_dir()
    lifecycle::expect_deprecated(get_url_tweets(query = "cdc.gov", start_tweets = "2021-06-01T00:00:00Z", end_tweets = "2021-06-13T00:00:00Z", data_path = emptydir, bind_tweets = FALSE, verbose = FALSE))
    unlink(emptydir, recursive = TRUE)
  })
})

## require(httptest)
## start_capturing(simplify = FALSE)
## z <- get_geo_tweets(query = "#rstats", start_tweets = "2021-06-01T00:00:00Z", end_tweets = "2021-06-13T00:00:00Z")
## stop_capturing()

with_mock_api({
  test_that("get_geo_tweets", {
    skip_if(!dir.exists("api.twitter.com"))
    emptydir <- academictwitteR:::.gen_random_dir()
    lifecycle::expect_deprecated(get_geo_tweets(query = "#rstats", start_tweets = "2021-06-01T00:00:00Z", end_tweets = "2021-06-13T00:00:00Z", data_path = emptydir, bind_tweets = FALSE, verbose = FALSE))
    unlink(emptydir, recursive = TRUE)
  })
})
