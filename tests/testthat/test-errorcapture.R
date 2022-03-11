## require(httptest)
## start_capturing(simplify = FALSE)

## test_that("normal case: errors = TRUE", {
##     skip_if(!dir.exists("api.twitter.com"))
##     fff <- readRDS("../testdata/fff_de.RDS")
##     params <- list(
##       tweet.fields = "attachments,author_id,conversation_id,created_at,entities,geo,id,in_reply_to_user_id,lang,public_metrics,possibly_sensitive,referenced_tweets,source,text,withheld", 
##       user.fields = "created_at,description,entities,id,location,name,pinned_tweet_id,profile_image_url,protected,public_metrics,url,username,verified,withheld", 
##       expansions = "author_id,entities.mentions.username,geo.place_id,in_reply_to_user_id,referenced_tweets.id,referenced_tweets.id.author_id", 
##       place.fields = "contained_within,country,country_code,full_name,geo,id,name,place_type"
##     )
##     endpoint_url <- "https://api.twitter.com/2/tweets"
##     emptydir <- academictwitteR:::.gen_random_dir()  

##     for (i in seq_len(3)) {
##       index <- c(1, 21, 41)[i]
##       index_end <- index+19
##       x <- fff[index:index_end]
##       params[["ids"]] <- paste0(x, collapse = ",")
##       expect_error(new_rows <- get_tweets(params = params, endpoint_url = endpoint_url, n = Inf, file = NULL, bearer_token = get_bearer(), export_query = FALSE, data_path = emptydir, bind_tweets = TRUE, verbose = FALSE, errors = TRUE), NA)
##       Sys.sleep(0.5)
##       expect_equal(length(list.files(emptydir)), i * 3)
##       expect_equal(length(list.files(emptydir, "^errors")), i)
##       df <- bind_tweets(emptydir, verbose = FALSE)
##       expect_equal(nrow(df), i * 20)
##     }
##     unlink(emptydir, recursive = TRUE)
##   })

## stop_capturing()

with_mock_api({
  test_that("normal case: errors = TRUE; bind_tweets = TRUE", {
    skip_if(!dir.exists("api.twitter.com"))
    fff <- readRDS("../testdata/fff_de.RDS")
    params <- list(
      tweet.fields = "attachments,author_id,conversation_id,created_at,entities,geo,id,in_reply_to_user_id,lang,public_metrics,possibly_sensitive,referenced_tweets,source,text,withheld", 
      user.fields = "created_at,description,entities,id,location,name,pinned_tweet_id,profile_image_url,protected,public_metrics,url,username,verified,withheld", 
      expansions = "author_id,entities.mentions.username,geo.place_id,in_reply_to_user_id,referenced_tweets.id,referenced_tweets.id.author_id", 
      place.fields = "contained_within,country,country_code,full_name,geo,id,name,place_type"
    )
    endpoint_url <- "https://api.twitter.com/2/tweets"
    emptydir <- academictwitteR:::.gen_random_dir()

    for (i in seq_len(3)) {
      index <- c(1, 21, 41)[i]
      index_end <- index+19
      x <- fff[index:index_end]
      params[["ids"]] <- paste0(x, collapse = ",")
      expect_error(new_rows <- get_tweets(params = params, endpoint_url = endpoint_url, n = Inf, file = NULL, bearer_token = get_bearer(), export_query = FALSE, data_path = emptydir, bind_tweets = TRUE, verbose = FALSE, errors = TRUE), NA)
      expect_true("error" %in% colnames(new_rows))
      ## Sys.sleep(0.5)
      expect_equal(length(list.files(emptydir)), i * 3)
      expect_equal(length(list.files(emptydir, "^errors")), i)
      df <- bind_tweets(emptydir, verbose = FALSE)
      expect_equal(nrow(df), i * 20)
    }
    unlink(emptydir, recursive = TRUE)
  })
})

with_mock_api({
  test_that("normal case: errors = TRUE; bind_tweets = FALSE", {
    skip_if(!dir.exists("api.twitter.com"))
    fff <- readRDS("../testdata/fff_de.RDS")
    params <- list(
      tweet.fields = "attachments,author_id,conversation_id,created_at,entities,geo,id,in_reply_to_user_id,lang,public_metrics,possibly_sensitive,referenced_tweets,source,text,withheld", 
      user.fields = "created_at,description,entities,id,location,name,pinned_tweet_id,profile_image_url,protected,public_metrics,url,username,verified,withheld", 
      expansions = "author_id,entities.mentions.username,geo.place_id,in_reply_to_user_id,referenced_tweets.id,referenced_tweets.id.author_id", 
      place.fields = "contained_within,country,country_code,full_name,geo,id,name,place_type"
    )
    endpoint_url <- "https://api.twitter.com/2/tweets"
    emptydir <- academictwitteR:::.gen_random_dir()

    for (i in seq_len(3)) {
      index <- c(1, 21, 41)[i]
      index_end <- index+19
      x <- fff[index:index_end]
      params[["ids"]] <- paste0(x, collapse = ",")
      expect_error(new_rows <- get_tweets(params = params, endpoint_url = endpoint_url, n = Inf, file = NULL, bearer_token = get_bearer(), export_query = FALSE, data_path = emptydir, bind_tweets = FALSE, verbose = FALSE, errors = TRUE), NA)
      ## Sys.sleep(0.5)
      expect_equal(length(list.files(emptydir)), i * 3)
      expect_equal(length(list.files(emptydir, "^errors")), i)
      df <- bind_tweets(emptydir, verbose = FALSE)
      expect_equal(nrow(df), i * 20)
    }
    unlink(emptydir, recursive = TRUE)
  })
})

with_mock_api({
  test_that("normal case: errors = FALSE; bind_tweets = TRUE", {
    skip_if(!dir.exists("api.twitter.com"))
    fff <- readRDS("../testdata/fff_de.RDS")
    params <- list(
      tweet.fields = "attachments,author_id,conversation_id,created_at,entities,geo,id,in_reply_to_user_id,lang,public_metrics,possibly_sensitive,referenced_tweets,source,text,withheld", 
      user.fields = "created_at,description,entities,id,location,name,pinned_tweet_id,profile_image_url,protected,public_metrics,url,username,verified,withheld", 
      expansions = "author_id,entities.mentions.username,geo.place_id,in_reply_to_user_id,referenced_tweets.id,referenced_tweets.id.author_id", 
      place.fields = "contained_within,country,country_code,full_name,geo,id,name,place_type"
    )
    endpoint_url <- "https://api.twitter.com/2/tweets"
    emptydir <- academictwitteR:::.gen_random_dir()

    for (i in seq_len(3)) {
      index <- c(1, 21, 41)[i]
      index_end <- index+19
      x <- fff[index:index_end]
      params[["ids"]] <- paste0(x, collapse = ",")
      expect_error(new_rows <- get_tweets(params = params, endpoint_url = endpoint_url, n = Inf, file = NULL, bearer_token = get_bearer(), export_query = FALSE, data_path = emptydir, bind_tweets = TRUE, verbose = FALSE, errors = FALSE), NA)
      ## Sys.sleep(0.5)
      expect_false("error" %in% colnames(new_rows))
      expect_equal(length(list.files(emptydir)), i * 2)
      expect_equal(length(list.files(emptydir, "^errors")), 0)
      df <- bind_tweets(emptydir, verbose = FALSE)
      expect_equal(nrow(df), i * 20)
    }
    unlink(emptydir, recursive = TRUE)
  })
})

with_mock_api({
  test_that("normal case: errors = FALSE; bind_tweets = FALSE", {
    skip_if(!dir.exists("api.twitter.com"))
    fff <- readRDS("../testdata/fff_de.RDS")
    params <- list(
      tweet.fields = "attachments,author_id,conversation_id,created_at,entities,geo,id,in_reply_to_user_id,lang,public_metrics,possibly_sensitive,referenced_tweets,source,text,withheld", 
      user.fields = "created_at,description,entities,id,location,name,pinned_tweet_id,profile_image_url,protected,public_metrics,url,username,verified,withheld", 
      expansions = "author_id,entities.mentions.username,geo.place_id,in_reply_to_user_id,referenced_tweets.id,referenced_tweets.id.author_id", 
      place.fields = "contained_within,country,country_code,full_name,geo,id,name,place_type"
    )
    endpoint_url <- "https://api.twitter.com/2/tweets"
    emptydir <- academictwitteR:::.gen_random_dir()

    for (i in seq_len(3)) {
      index <- c(1, 21, 41)[i]
      index_end <- index+19
      x <- fff[index:index_end]
      params[["ids"]] <- paste0(x, collapse = ",")
      expect_error(new_rows <- get_tweets(params = params, endpoint_url = endpoint_url, n = Inf, file = NULL, bearer_token = get_bearer(), export_query = FALSE, data_path = emptydir, bind_tweets = FALSE, verbose = FALSE, errors = FALSE), NA)
      ## Sys.sleep(0.5)
      expect_equal(length(list.files(emptydir)), i * 2)
      expect_equal(length(list.files(emptydir, "^errors")), 0)
      df <- bind_tweets(emptydir, verbose = FALSE)
      expect_equal(nrow(df), i * 20)
    }
    unlink(emptydir, recursive = TRUE)
  })
})

params <- list(
  tweet.fields = "attachments,author_id,conversation_id,created_at,entities,geo,id,in_reply_to_user_id,lang,public_metrics,possibly_sensitive,referenced_tweets,source,text,withheld", 
  user.fields = "created_at,description,entities,id,location,name,pinned_tweet_id,profile_image_url,protected,public_metrics,url,username,verified,withheld", 
  expansions = "author_id,entities.mentions.username,geo.place_id,in_reply_to_user_id,referenced_tweets.id,referenced_tweets.id.author_id", 
  place.fields = "contained_within,country,country_code,full_name,geo,id,name,place_type"
)

endpoint_url <- "https://api.twitter.com/2/tweets"


## require(httptest)
## start_capturing(simplify = FALSE)
## fff <- readRDS("../testdata/fff_de.RDS")
## pollutions <- seq(0, 15, 1)

## for (n_polluted in pollutions) {
##   emptydir <- academictwitteR:::.gen_random_dir()
##   x <- fff[1:15]
##   print(n_polluted)
##   for (i in seq_len(n_polluted)) {
##     x[i] <- as.character(i)
##   }
##   print(x)
##   params[["ids"]] <- paste0(x, collapse = ",")
##   expect_error(new_rows <- get_tweets(params = params, endpoint_url = endpoint_url, n = Inf, file = NULL, bearer_token = get_bearer(), export_query = FALSE, data_path = emptydir, bind_tweets = TRUE, verbose = FALSE, errors = TRUE), NA)
##   errs <- jsonlite::read_json(list.files(emptydir, "^errors", full.names = TRUE))
##   tw <- bind_tweets(emptydir, verbose = FALSE)
##   expect_equal(length(errs), n_polluted)
##   expect_equal(nrow(tw), 15 - n_polluted)
##   unlink(emptydir, recursive = TRUE)
## }
## stop_capturing()

with_mock_api({
  test_that("polluted case: errors = TRUE; bind_tweets = TRUE", {
    skip_if(!dir.exists("api.twitter.com"))
    pollutions <- seq(0, 15, 1)
    ## The idea is to pollute x with n_polluted number of junk
    fff <- readRDS("../testdata/fff_de.RDS")
    for (n_polluted in pollutions) {
      emptydir <- academictwitteR:::.gen_random_dir()
      x <- fff[1:15]
      for (i in seq_len(n_polluted)) {
        x[i] <- as.character(i)
      }
      params[["ids"]] <- paste0(x, collapse = ",")
      expect_error(new_rows <- get_tweets(params = params, endpoint_url = endpoint_url, n = Inf, file = NULL, bearer_token = get_bearer(), export_query = FALSE, data_path = emptydir, bind_tweets = TRUE, verbose = FALSE, errors = TRUE), NA)
      expect_true("data.frame" %in% class(new_rows))
      expect_equal(nrow(new_rows), 15) ## it includes rows with errors
      expect_true("error" %in% colnames(new_rows))
      expect_true(length(list.files(emptydir, "^errors", full.names = TRUE)) != 0)
      errs <- jsonlite::read_json(list.files(emptydir, "^errors", full.names = TRUE))
      tw <- bind_tweets(emptydir, verbose = FALSE)
      expect_equal(length(errs), n_polluted)
      expect_equal(nrow(tw), 15 - n_polluted)
      unlink(emptydir, recursive = TRUE)
    }
  })
})

with_mock_api({
  test_that("polluted case: errors = TRUE; bind_tweets = FALSE", {
    skip_if(!dir.exists("api.twitter.com"))
    pollutions <- seq(0, 15, 1)
    ## The idea is to pollute x with n_polluted number of junk
    fff <- readRDS("../testdata/fff_de.RDS")
    for (n_polluted in pollutions) {
      emptydir <- academictwitteR:::.gen_random_dir()
      x <- fff[1:15]
      for (i in seq_len(n_polluted)) {
        x[i] <- as.character(i)
      }
      params[["ids"]] <- paste0(x, collapse = ",")
      expect_error(new_rows <- get_tweets(params = params, endpoint_url = endpoint_url, n = Inf, file = NULL, bearer_token = get_bearer(), export_query = FALSE, data_path = emptydir, bind_tweets = FALSE, verbose = FALSE, errors = TRUE), NA)
      expect_false("data.frame" %in% class(new_rows))
      expect_equal(nrow(new_rows), NULL) ## It's not a data.frame
      expect_true(length(list.files(emptydir, "^errors", full.names = TRUE)) != 0)
      errs <- jsonlite::read_json(list.files(emptydir, "^errors", full.names = TRUE))
      tw <- bind_tweets(emptydir, verbose = FALSE)
      expect_equal(length(errs), n_polluted)
      expect_equal(nrow(tw), 15 - n_polluted)
      unlink(emptydir, recursive = TRUE)
    }
  })
})

with_mock_api({
  test_that("polluted case: errors = FALSE, bind_tweets = TRUE", {
    skip_if(!dir.exists("api.twitter.com"))
    pollutions <- seq(0, 15, 1)
    fff <- readRDS("../testdata/fff_de.RDS")
    for (n_polluted in pollutions) {
      emptydir <- academictwitteR:::.gen_random_dir()
      x <- fff[1:15]
      for (i in seq_len(n_polluted)) {
        x[i] <- as.character(i)
      }
      params[["ids"]] <- paste0(x, collapse = ",")
      expect_error(new_rows <- get_tweets(params = params, endpoint_url = endpoint_url, n = Inf, file = NULL, bearer_token = get_bearer(), export_query = FALSE, data_path = emptydir, bind_tweets = TRUE, verbose = FALSE, errors = FALSE), NA)
      expect_true("data.frame" %in% class(new_rows))
      expect_false("error" %in% colnames(new_rows))
      expect_equal(nrow(new_rows), 15 - n_polluted)
      expect_true(length(list.files(emptydir, "^errors", full.names = TRUE)) == 0)
      tw <- bind_tweets(emptydir, verbose = FALSE)
      expect_equal(nrow(tw), 15 - n_polluted)
      unlink(emptydir, recursive = TRUE)
    }
  })
})

with_mock_api({
  test_that("polluted case: errors = FALSE, bind_tweets = FALSE", {
    skip_if(!dir.exists("api.twitter.com"))
    pollutions <- seq(0, 15, 1)
    fff <- readRDS("../testdata/fff_de.RDS")
    for (n_polluted in pollutions) {
      emptydir <- academictwitteR:::.gen_random_dir()
      x <- fff[1:15]
      for (i in seq_len(n_polluted)) {
        x[i] <- as.character(i)
      }
      params[["ids"]] <- paste0(x, collapse = ",")
      expect_error(new_rows <- get_tweets(params = params, endpoint_url = endpoint_url, n = Inf, file = NULL, bearer_token = get_bearer(), export_query = FALSE, data_path = emptydir, bind_tweets = FALSE, verbose = FALSE, errors = FALSE), NA)
      expect_false("data.frame" %in% class(new_rows))
      expect_equal(nrow(new_rows), NULL)
      expect_true(length(list.files(emptydir, "^errors", full.names = TRUE)) == 0)
      tw <- bind_tweets(emptydir, verbose = FALSE)
      expect_equal(nrow(tw), 15 - n_polluted)
      unlink(emptydir, recursive = TRUE)
    }
  })
})
