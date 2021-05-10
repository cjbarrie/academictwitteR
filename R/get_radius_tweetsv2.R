#' Get tweets within radius buffer
#'
#' This function collects tweets containing strings or hashtags 
#' between specified date ranges filtering by radius buffer. Tweet-level data is stored in a data/ 
#' path as a series of JSONs beginning "data_"; User-level data is stored as a series of 
#' JSONs beginning "users_". If a filename is supplied, this function will 
#' save the result as a RDS file, otherwise it will return the results as a data.frame.
#' Note: radius must be less than 25mi.
#'
#' @param query string or character vector, search query or queries
#' @param radius numeric, a vector of two point coordinates latitude, longitude, and point radius distance (in miles)
#' @param start_tweets string, starting date
#' @param end_tweets  string, ending date
#' @param bearer_token string, bearer token
#' @param file string, name of the resulting RDS file
#' @param data_path string, if supplied, fetched data can be saved to the designated path as jsons
#' @param bind_tweets If `TRUE`, tweets captured are bound into a data.frame for assignment
#' @param verbose If `FALSE`, query progress messages are suppressed
#' @param ... arguments will be passed to `build_query()` function. See `?build_query()` for further information.
#' 
#' @return a data.frame
#' @export
#'
#' @examples
#' \dontrun{
#' bearer_token <- "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
#' tweets <- get_radius_tweets("happy", radius = c(-0.131969125179604,51.50847878040284, 25), 
#'                            start_tweets = "2021-01-01T00:00:00Z", 
#'                            end_tweets = "2021-01-01T10:00:00Z", 
#'                            bearer_token = bearer_token, data_path = "data/")
#' }
get_radius_tweets <-
  function(query,
           radius,
           start_tweets,
           end_tweets,
           bearer_token,
           file = NULL,
           data_path = NULL,
           bind_tweets = TRUE,
           verbose = TRUE,
           ...) {
    #stop clause for if user sets no place
    if (missing(radius)) {
      stop("radius must be specified for get_radius_tweets() function")
    }
    get_all_tweets(query, start_tweets, end_tweets, bearer_token, point_radius = radius, ...)

  }
