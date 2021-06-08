#' Get tweets with country parameter
#'
#' This function collects tweets containing strings or hashtags 
#' between specified date ranges filtering by country. Tweet-level data is stored in a data/ 
#' path as a series of JSONs beginning "data_"; User-level data is stored as a series of 
#' JSONs beginning "users_". If a filename is supplied, this function will 
#' save the result as a RDS file, otherwise it will return the results as a data.frame.
#'
#' @param country, string, name of country as ISO alpha-2 code e.g. "GB"
#' @inheritParams get_all_tweets
#' @return a data.frame
#' @export
#'
#' @examples
#' \dontrun{
#' bearer_token <- "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
#' get_country_tweets("happy", country = "GB", 
#'                    "2021-01-01T00:00:00Z", "2021-01-01T00:10:00Z", 
#'                    bearer_token, data_path = "data/")
#' }
get_country_tweets <-
  function(query,
           country,
           start_tweets,
           end_tweets,
           bearer_token = get_bearer(),
           n = 100,
           file = NULL,
           data_path = NULL,
           bind_tweets = TRUE,
           verbose = TRUE,
           ...) {
    #stop clause for if user sets no place
    if (missing(country)) {
      stop("country must be specified for get_country_tweets() function")
    }
    get_all_tweets(query = query, start_tweets = start_tweets, end_tweets = end_tweets, bearer_token = bearer_token, n = n, file = file, data_path = data_path, bind_tweets = bind_tweets, verbose = verbose, country = country, ...)
  }
