#' Get user followers
#' 
#' This function fetches a list of users who are followers of the specified user ID.
#'
#' @param x string containing one user id or a vector of user ids
#' @param bearer_token string, bearer token
#' @param ... arguments passed to other backend functions
#'
#' @return a data frame
#' @export
#'
#' @examples
#' \dontrun{
#' bearer_token <- "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
#' users <- "2244994945"
#' get_user_followers(users, bearer_token)
#' }
get_user_followers <- function(x, bearer_token = get_bearer(), ...){
  get_user_edges(x = x, bearer_token = bearer_token, wt = "followers", ...)
}

#' Get user following
#' 
#' This function fetches a list of users the specified user ID is following.
#'
#' @param x string containing one user id or a vector of user ids
#' @param bearer_token string, bearer token
#' @param ... arguments passed to other backend functions
#'
#' @return a data frame
#' @export
#'
#' @examples
#' \dontrun{
#' bearer_token <- "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
#' users <- "2244994945"
#' get_user_following(users, bearer_token)
#' }
get_user_following <- function(x, bearer_token = get_bearer(), ...){
  get_user_edges(x = x, bearer_token = bearer_token, wt = "following", ...)
}

get_user_edges <- function(x, bearer_token, wt, verbose = TRUE){
  bearer <- check_bearer(bearer_token)
  
  url <- "https://api.twitter.com/2/users/"
  
  if(wt == "followers"){
    endpoint <- "/followers"
    params <- list(
      "max_results" = 1000,
      "user.fields" = "created_at,description,entities,id,location,name,pinned_tweet_id,profile_image_url,protected,public_metrics,url,username,verified,withheld"
    )
  } else if (wt == "following"){
    endpoint <- "/following"
    params <- list(
      "max_results" = 1000,
      "user.fields" = "created_at,description,entities,id,location,name,pinned_tweet_id,profile_image_url,protected,public_metrics,url,username,verified,withheld"
    )
  } else if (wt == "liked_tweets"){
    endpoint <- "/liked_tweets"
    params <- list(
      "max_results" = 100,
      "tweet.fields" = "attachments,author_id,context_annotations,conversation_id,created_at,entities,geo,id,in_reply_to_user_id,lang,public_metrics,possibly_sensitive,referenced_tweets,source,text,withheld",
      "user.fields" = "created_at,description,entities,id,location,name,pinned_tweet_id,profile_image_url,protected,public_metrics,url,username,verified,withheld",
      "expansions" = "author_id,entities.mentions.username,geo.place_id,in_reply_to_user_id,referenced_tweets.id,referenced_tweets.id.author_id",
      "place.fields" = "contained_within,country,country_code,full_name,geo,id,name,place_type"
    )
  } else {
    stop("Unknown request type")
  }
  
  new_df <- data.frame()
  for(i in seq_along(x)){
    cat(paste0("Processing ",x[i],"\n"))
    next_token <- ""
    while (!is.null(next_token)) {
      requrl <- paste0(url,x[i],endpoint)
      
      if(next_token!=""){
        params[["pagination_token"]] <- next_token
      }
      
      # Sending GET Request
      r <- httr::GET(requrl,httr::add_headers(Authorization = bearer),query=params)
      
      # Fix random 503 errors
      count <- 0
      while(httr::status_code(r)==503 & count<4){
        r <- httr::GET(requrl,httr::add_headers(Authorization = bearer),query=params)
        count <- count+1
        Sys.sleep(count*5)
      }
      if(httr::status_code(r)==429){
        cat("Rate limit reached, sleeping... \n")
        Sys.sleep(900)
        r <- httr::GET(requrl,httr::add_headers(Authorization = bearer),query=params)
      }
      
      # Catch other errors
      if(httr::status_code(r)!=200){
        stop(paste("something went wrong. Status code:", httr::status_code(r)))
      }
      if(httr::headers(r)$`x-rate-limit-remaining`=="1"){
        warning(paste("x-rate-limit-remaining=1. Resets at",as.POSIXct(as.numeric(httr::headers(r)$`x-rate-limit-reset`), origin="1970-01-01")))
      }
      
      dat <- jsonlite::fromJSON(httr::content(r, "text"))
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
      Sys.sleep(1)
    }
  }
  return(new_df)
}
