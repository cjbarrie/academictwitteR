#' Get tweets for query containing geo information
#'
#' This function collects tweets containing strings or 
#' hashtags between specified date ranges that also contain Tweet-specific geolocation data provided by the 
#' Twitter user. This can be either a location in the form of a Twitter place, with the corresponding display 
#' name, geo polygon, and other fields, or in rare cases, a geo lat-long coordinate. Note: Operators matching 
#' on place (Tweet geo) will only include matches from original tweets. Tweet-level data is stored in a data/ 
#' path as a series of JSONs beginning "data_"; User-level data is stored as a series of JSONs beginning "users_". 
#' If a filename is supplied, this function will save the result as a RDS file, otherwise it will return the results as a dataframe.
#'
#' @inheritParams get_all_tweets
#' @return a data.frame
#' @export
#'
#' @examples
#' \dontrun{
#' bearer_token <- "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
#' get_geo_tweets("protest", "2020-01-01T00:00:00Z", "2020-01-05T00:00:00Z", 
#'                bearer_token, data_path = "data/")
#' }
get_geo_tweets <-
  function(query,
           start_tweets,
           end_tweets,
           bearer_token = get_bearer(),
           n = 100,
           file = NULL,
           data_path = NULL,
           bind_tweets = TRUE,
           verbose = TRUE,
           ...) {
    query <- paste0('has:geo ', query)
    get_all_tweets(query = query, start_tweets = start_tweets, end_tweets = end_tweets, bearer_token = bearer_token, n = n, file = file, data_path = data_path, bind_tweets = bind_tweets, verbose = verbose,...)
  }
