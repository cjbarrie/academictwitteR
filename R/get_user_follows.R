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
get_user_followers <- function(x, bearer_token, ...){
  get_user_follows(x, bearer_token, wt = "followers", ...)
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
get_user_following <- function(x, bearer_token, ...){
  get_user_follows(x, bearer_token, wt = "following", ...)
}

get_user_follows <- function(x, bearer_token, wt, verbose = TRUE){
  if(missing(bearer_token)){
    stop("bearer token must be specified.")
  }
  if(substr(bearer_token,1,7)=="Bearer "){
    bearer <- bearer_token
  } else{
    bearer <- paste0("Bearer ",bearer_token)
  }
  
  #endpoint
  url <- "https://api.twitter.com/2/users"
  
  if(wt == "followers"){
    follows <- "/followers"
  } else if (wt == "following"){
    follows <- "/following"
  } else {
    stop("Unknown wt")
  }
  
  new_df <- data.frame()
  for(i in 1:length(x)){
    cat(paste0("Processing ",i,"\n"))
    next_token <- ""
    while (!is.null(next_token)) {
      userurl <- paste0(url,"/",x[i],follows)
      
      params = list()
      if(next_token!=""){
        params[["pagination_token"]] <- next_token
      }
      
      # Sending GET Request
      r <- httr::GET(userurl,httr::add_headers(Authorization = bearer),query=params)
      
      # Fix random 503 errors
      count <- 0
      while(httr::status_code(r)==503 & count<4){
        r <- httr::GET(userurl,httr::add_headers(Authorization = bearer),query=params)
        count <- count+1
        Sys.sleep(count*5)
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
      new_rows$from <- x[i]
      new_df <- dplyr::bind_rows(new_df, new_rows) # add new rows
      
      cat("Total follows: ",nrow(new_df), "\n")
      Sys.sleep(60)
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