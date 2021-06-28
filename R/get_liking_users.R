#' Get liking users
#' 
#' This function fetches users who liked a tweet or tweets.
#'
#' @param x string containing one tweet id or a vector of tweet ids
#' @param bearer_token string, bearer token
#' @param verbose If `FALSE`, query progress messages are suppressed
#'
#' @return a data frame
#' @export
#'
#' @examples
#' \dontrun{
#' tweet <- "1387744422729748486"
#' get_liking_users(tweet, bearer_token = get_bearer())
#' }
get_liking_users <- function(x, bearer_token = get_bearer(), verbose = TRUE){
  bearer_token <- check_bearer(bearer_token)
  
  url <- "https://api.twitter.com/2/tweets/"
  
  endpoint <- "/liking_users"
  params <- list(
    "user.fields" = "created_at,description,entities,id,location,name,pinned_tweet_id,profile_image_url,protected,public_metrics,url,username,verified,withheld"
  )
  
  new_df <- data.frame()
  for(i in seq_along(x)){
    cat(paste0("Processing ",x[i],"\n"))
    requrl <- paste0(url,x[i],endpoint)
    next_token <- ""
    while(!is.null(next_token)) {
      if(next_token!=""){
        params[["pagination_token"]] <- next_token
      }
      dat <- make_query(url = requrl, params = params, bearer_token = bearer_token, verbose = verbose)
      next_token <- dat$meta$next_token #this is NULL if there are no pages left
      new_rows <- dat$data
      new_rows$from_id <- x[i]
      new_df <- dplyr::bind_rows(new_df, new_rows) # add new rows
      
      cat("Total data points: ",nrow(new_df), "\n")
      Sys.sleep(1)
      if (is.null(next_token)) {
        if(verbose) {
          cat("This is the last page for ",
              x[i],
              ": finishing collection. \n")
        }
        break
      }
    }
  }
  return(new_df)
}
