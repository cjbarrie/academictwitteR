#' Get users who has retweeted a tweet
#' 
#' This function fetches users who retweeted a tweet
#'
#' @param x string containing one tweet id or a vector of tweet ids
#' @inheritParams get_all_tweets
#' @return a data frame
#' @export
#'
#' @examples
#' \dontrun{
#' tweets <- c("1392887366507970561","1409931481552543749")
#' get_retweeted_by(tweets, bearer_token = get_bearer())
#' }
get_retweeted_by <- function(x, bearer_token = get_bearer(), data_path = NULL, verbose = TRUE) {
  url <- "https://api.twitter.com/2/tweets/"
  endpoint <- "/retweeted_by"
  ## Building parameters for get_tweets()
  params <- list(
    "tweet.fields" = "attachments,author_id,context_annotations,conversation_id,created_at,entities,geo,id,in_reply_to_user_id,lang,public_metrics,possibly_sensitive,referenced_tweets,source,text,withheld",
    "user.fields" = "created_at,description,entities,id,location,name,pinned_tweet_id,profile_image_url,protected,public_metrics,url,username,verified,withheld"
  )  
  ## loop through x
  new_df <- data.frame()
  for(i in seq_along(x)){
    .vcat(verbose, paste0("Processing ", x[i], "\n"))
    requrl <- paste0(url, x[i], endpoint)
    next_token <- ""
    while(!is.null(next_token)) {
      if(next_token != ""){
        params[["pagination_token"]] <- next_token
      }
      dat <- make_query(url = requrl, params = params, bearer_token = bearer_token, verbose = verbose)
      next_token <- dat$meta$next_token #this is NULL if there are no pages left
      if (!is.null(dat$data)) {
        new_rows <- dat$data
        new_rows$from_id <- x[i]
        new_df <- dplyr::bind_rows(new_df, new_rows) # add new rows
        .vcat(verbose, "Total data points: ",nrow(new_df), "\n")
      }
      Sys.sleep(1)
      if (is.null(next_token)) {
        .vcat(verbose, "This is the last page for ",  x[i], ": finishing collection. \n")
        params[["pagination_token"]] <- NULL
        break
      }
    }
  }
  return(new_df)
}
