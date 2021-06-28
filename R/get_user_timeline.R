#' Get tweets by a single user
#'
#' This function collects tweets by an user ID from the users endpoint. 
#' 
#' Only the most recent 3,200 Tweets can be retrieved.
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
#' @param x string containing one user id or a vector of user ids
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
#' 
#' get_user_timeline("2244994945",
#'                   start_tweets = "2020-01-01T00:00:00Z", 
#'                   end_tweets = "2021-05-14T00:00:00Z",
#'                   bearer_token = get_bearer(),
#'                   n = 200)
#' }
get_user_timeline <-
  function(x,
           start_tweets,
           end_tweets,
           bearer_token = get_bearer(),
           n = 100,
           file = NULL,
           data_path = NULL,
           export_query = TRUE,
           bind_tweets = TRUE,
           page_n = 100,
           verbose = TRUE,
           ...) {    
    if (missing(start_tweets)) {
      stop("Start time must be specified.")
    }
    if (missing(end_tweets)) {
      stop("End time must be specified.")
    }
    
    # Check file storage conditions
    check_data_path(data_path = data_path, file = file, bind_tweets = bind_tweets, verbose = verbose)
    
    # Building parameters for get_tweets()
    params <- list(
      "max_results" = page_n,
      "start_time" = start_tweets,
      "end_time" = end_tweets,
      "tweet.fields" = "attachments,author_id,context_annotations,conversation_id,created_at,entities,geo,id,in_reply_to_user_id,lang,public_metrics,possibly_sensitive,referenced_tweets,source,text,withheld",
      "user.fields" = "created_at,description,entities,id,location,name,pinned_tweet_id,profile_image_url,protected,public_metrics,url,username,verified,withheld",
      "expansions" = "author_id,entities.mentions.username,geo.place_id,in_reply_to_user_id,referenced_tweets.id,referenced_tweets.id.author_id",
      "place.fields" = "contained_within,country,country_code,full_name,geo,id,name,place_type"
    )
    
    new_df <- data.frame()
    for(user in x){
      .vcat(verbose, "user: ", user, "\n")
      
      # Building url using user_id
      endpoint_url <- paste0("https://api.twitter.com/2/users/", user, "/tweets")
      
      # Get tweets
      new_rows <- get_tweets(params = params, endpoint_url = endpoint_url, page_token_name = "pagination_token", n = n, file = file, bearer_token = bearer_token, 
                             export_query = export_query, data_path = data_path, bind_tweets = bind_tweets, verbose = verbose)
      new_df <- dplyr::bind_rows(new_df, new_rows)
    }
    new_df
  }
