#' Count tweets from full archive search
#'
#' This function returns aggregate counts of tweets by query string or strings
#' between specified date ranges. 
#'
#' @param query string or character vector, search query or queries
#' @param start_tweets string, starting date
#' @param end_tweets  string, ending date
#' @param bearer_token string, bearer token
#' @param n integer, upper limit of tweet counts to be fetched (i.e., for 365 days n must be at least 365). Default is 100. 
#' @param file string, name of the resulting RDS file
#' @param data_path string, if supplied, fetched data can be saved to the designated path as jsons
#' @param export_query If `TRUE`, queries are exported to data_path
#' @param bind_tweets If `TRUE`, tweets captured are bound into a data.frame for assignment
#' @param granularity string, the granularity for the search counts results. Options are "day"; "hour"; "minute". Default is day. 
#' @param verbose If `FALSE`, query progress messages are suppressed
#' @param ... arguments will be passed to `build_query()` function. See `?build_query()` for further information.
#' 
#' @return a data.frame
#' @export
#'
#' @examples
#' \dontrun{
#' 
#' count_all_tweets(query = "Hogmanay", 
#'           start_tweets = "2019-12-2700:00:00Z", 
#'           end_tweets = "2020-01-05T00:00:00Z", 
#'           bearer_token = get_bearer())
#'           
#' count_all_tweets(query = "Hogmanay", 
#'           start_tweets = "2019-12-27T00:00:00Z", 
#'           end_tweets = "2020-01-05T00:00:00Z", 
#'           bearer_token = get_bearer(),
#'           granularity = "hour",
#'           n = 500)
#' }
count_all_tweets <-
  function(query = NULL,
           start_tweets,
           end_tweets,
           bearer_token = get_bearer(),
           n = 100,
           file = NULL,
           data_path = NULL,
           export_query = TRUE,
           bind_tweets = TRUE,
           granularity = "day",
           verbose = TRUE,
           ...) {    
    if (missing(start_tweets)) {
      stop("Start time must be specified.")
    }
    if (missing(end_tweets)) {
      stop("End time must be specified.")
    }
    
    # Build query
    built_query <- build_query(query, ...)
    
    # Building parameters for get_tweets()
    params <- list(
      "query" = built_query,
      "start_time" = start_tweets,
      "end_time" = end_tweets,
      "granularity" = granularity
      )
    endpoint_url <- "https://api.twitter.com/2/tweets/counts/all"
    .vcat(verbose, "query: ", params[["query"]], "\n")
    
    # Get tweets
    get_tweets(params = params, endpoint_url = endpoint_url, n = n, file = file, bearer_token = bearer_token, 
               export_query = export_query, data_path = data_path, bind_tweets = bind_tweets, verbose = verbose)
  }
