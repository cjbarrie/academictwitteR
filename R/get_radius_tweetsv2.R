#' Get tweets within radius buffer
#'
#' This function collects tweets containing strings or hashtags 
#' between specified date ranges filtering by radius buffer. Tweet-level data is stored in a data/ 
#' path as a series of JSONs beginning "data_"; User-level data is stored as a series of 
#' JSONs beginning "users_". If a filename is supplied, this function will 
#' save the result as a RDS file, otherwise it will return the results as a data.frame.
#' Note: radius must be less than 25mi.
#'
#' @param radius numeric, a vector of two point coordinates latitude, longitude, and point radius distance (in miles)
#' @inheritParams get_all_tweets
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
           bearer_token = get_bearer(),
           n = 100,
           file = NULL,
           data_path = NULL,
           bind_tweets = TRUE,
           verbose = TRUE,
           ...) {
    #stop clause for if user sets no place
    if (missing(radius)) {
      stop("radius must be specified for get_radius_tweets() function")
    }
    get_all_tweets(query = query, start_tweets = start_tweets, end_tweets = end_tweets, bearer_token = bearer_token, n = n, file = file, data_path = data_path, bind_tweets = bind_tweets, verbose = verbose, point_radius = radius, ...)
  }
