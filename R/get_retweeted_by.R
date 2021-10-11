#' Get users who has retweeted a tweet
#' 
#' This function fetches users who retweeted a tweet
#'
#' @param x string containing one tweet id or a vector of tweet ids
#' @param bearer_token string, bearer token
#' @param data_path string, if supplied, fetched data can be saved to the designated path as jsons
#' @param verbose If `FALSE`, query progress messages are suppressed
#'
#' @return a data frame
#' @export
#'
#' @examples
#' \dontrun{
#' tweets <- c("1392887366507970561","1409931481552543749")
#' get_retweeted_by(tweets, bearer_token = get_bearer())
#' }
get_retweeted_by <-
  function(x,
           bearer_token = get_bearer(),
           data_path = NULL,
           verbose = TRUE){    

    # Building parameters for get_tweets()
    params <- list(
      "tweet.fields" = "attachments,author_id,context_annotations,conversation_id,created_at,entities,geo,id,in_reply_to_user_id,lang,public_metrics,possibly_sensitive,referenced_tweets,source,text,withheld",
      "user.fields" = "created_at,description,entities,id,location,name,pinned_tweet_id,profile_image_url,protected,public_metrics,url,username,verified,withheld"
    )
    
    # loop through x
    new_df <- data.frame()
    for(i in seq_along(x)){
      .vcat(verbose, paste0("Processing ",x[i],"\n"))
      endpoint_url <- paste0("https://api.twitter.com/2/tweets/",x[i],"/retweeted_by")

      # Get tweets
      new_rows <- get_tweets(params = params, endpoint_url = endpoint_url, n = Inf, file = NULL, bearer_token = bearer_token, 
                             export_query = FALSE, data_path = data_path, bind_tweets = TRUE, verbose = verbose)
      if (nrow(new_rows) > 0) {
        new_rows$from_tweet_id <- x[i]
        new_df <- dplyr::bind_rows(new_df, new_rows) # add new rows
      }
    }
    new_df # return the df
  }
