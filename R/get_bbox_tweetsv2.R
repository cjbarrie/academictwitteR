#' Get tweets within bounding box
#'
#' This function collects tweets containing strings or hashtags 
#' between specified date ranges filtering by bounding box. Tweet-level data is stored in a data/ 
#' path as a series of JSONs beginning "data_"; User-level data is stored as a series of 
#' JSONs beginning "users_". If a filename is supplied, this function will 
#' save the result as a RDS file, otherwise it will return the results as a dataframe.
#' Note: width and height of the bounding box must be less than 25mi.
#'
#' @param bbox numeric, a vector of four bounding box coordinates from west longitude to north latitude
#' @inheritParams get_all_tweets
#' @return a data.frame
#' @export
#'
#' @examples
#' \dontrun{
#' bearer_token <- "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
#' tweets <- get_bbox_tweets("happy", bbox= c(-0.222473,51.442453,0.072784,51.568534), 
#'                            "2021-01-01T00:00:00Z", "2021-02-01T10:00:00Z", 
#'                            bearer_token, data_path = "data/")
#' }
get_bbox_tweets <-
  function(query,
           bbox,
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
    if (missing(bbox)) {
      stop("bbox coordinates must be specified for get_bbox_tweets() function")
    }
    get_all_tweets(query = query, start_tweets = start_tweets, end_tweets = end_tweets, bearer_token = bearer_token, n = n, file = file, data_path = data_path, bind_tweets = bind_tweets, verbose = verbose, bbox = bbox, ...)
  }
