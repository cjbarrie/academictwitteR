#' Get tweets from full archive search
#'
#' This function collects tweets by query string or strings
#' between specified date ranges.
#' 
#' The function can also collect tweets by users. These may be specified alongside
#' a query string or without. When no query string is supplied, the function collects
#' all tweets by that user.
#' 
#' If a filename is supplied, the function will 
#' save the result as a RDS file.
#' 
#' If a data path is supplied, the function will also return 
#' tweet-level data in a data/ path as a series of JSONs beginning "data_"; 
#' while user-level data will be returned as a series of JSONs beginning "users_".
#' 
#' When bind_tweets is `TRUE`, the function returns a data frame.
#'
#' @param query string or character vector, search query or queries
#' @param start_tweets string, starting date
#' @param end_tweets  string, ending date
#' @param bearer_token string, bearer token
#' @param n integer, upper limit of tweets to be fetched
#' @param file string, name of the resulting RDS file
#' @param data_path string, if supplied, fetched data can be saved to the designated path as jsons
#' @param export_query If `TRUE`, queries are exported to data_path
#' @param bind_tweets If `TRUE`, tweets captured are bound into a data.frame for assignment
#' @param page_n integer, amount of tweets to be returned by per page
#' @param verbose If `FALSE`, query progress messages are suppressed
#' @param ... arguments will be passed to `build_query()` function. See `?build_query()` for further information.
#' 
#' @return a data.frame
#' @export
#'
#' @examples
#' \dontrun{
#' bearer_token <- "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
#' 
#' get_all_tweets(query = "BLM", 
#'                start_tweets = "2020-01-01T00:00:00Z", 
#'                end_tweets = "2020-01-05T00:00:00Z", 
#'                bearer_token = get_bearer(), 
#'                data_path = "data",
#'                n = 500)
#'   
#' get_all_tweets(users = c("cbarrie", "jack"),
#'                start_tweets = "2021-01-01T00:00:00Z", 
#'                end_tweets = "2021-06-01T00:00:00Z",
#'                bearer_token = get_bearer(), 
#'                n = 1000)
#'                             
#' get_all_tweets(start_tweets = "2021-01-01T00:00:00Z", 
#'                end_tweets = "2021-06-01T00:00:00Z",
#'                bearer_token = get_bearer(), 
#'                n = 1500, 
#'                conversation_id = "1392887366507970561")
#' }
get_all_tweets <-
  function(query = NULL,
           start_tweets,
           end_tweets,
           bearer_token = get_bearer(),
           n = 100,
           file = NULL,
           data_path = NULL,
           export_query = TRUE,
           bind_tweets = TRUE,
           page_n = 500,
           verbose = TRUE,
           ...) {    
    # Check file storage conditions
    check_data_path(data_path = data_path, file = file, bind_tweets = bind_tweets, verbose = verbose)

    # Build query
    built_query <- build_query(query, ...)
        
    create_storage_dir(data_path = data_path, export_query = export_query, built_query = built_query, start_tweets = start_tweets, end_tweets = end_tweets, verbose = verbose)
    
    # Fetch data
    return(fetch_data(built_query = built_query, data_path = data_path, file = file, bind_tweets = bind_tweets, start_tweets = start_tweets, end_tweets = end_tweets, bearer_token = bearer_token, n = n , page_n = page_n, verbose = verbose))
  }
