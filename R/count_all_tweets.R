#' Count tweets from full archive search
#'
#' This function returns aggregate counts of tweets by query string or strings
#' between specified date ranges. 
#'
#' @param n integer, upper limit of tweet counts to be fetched (i.e., for 365 days n must be at least 365). Default is 100. 
#' @param granularity string, the granularity for the search counts results. Options are "day"; "hour"; "minute". Default is day.
#' @inheritParams get_all_tweets
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
    
    # Build query
    built_query <- build_query(query, ...)
    
    # Building parameters for get_tweets()
    params <- list(
      "query" = built_query,
      "granularity" = granularity
    )
    if (!missing(start_tweets)) {
      params$start_time <- start_tweets
    }
    if (!missing(end_tweets)) {
      params$end_time <- end_tweets
    }
    if ("start_time" %in% names(params) & "end_time" %in% names(params)) {
      ## For backward compatibility with test cases
      params <- params[c("query", "start_time", "end_time", "granularity")]
    }

    endpoint_url <- "https://api.twitter.com/2/tweets/counts/all"
    .vcat(verbose, "query: ", params[["query"]], "\n")
    
    # Get tweets
    get_tweets(params = params, endpoint_url = endpoint_url, n = n, file = file, bearer_token = bearer_token, 
               export_query = export_query, data_path = data_path, bind_tweets = bind_tweets, verbose = verbose)
  }
