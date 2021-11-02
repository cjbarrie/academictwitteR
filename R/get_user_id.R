#' Get user id
#' 
#' This function get the user ID given a user name.
#'
#' @param username string containing the screen name of the user
#' @param bearer_token string, bearer token
#' @param all logic, default FALSE. Set TRUE for getting also the screen name
#'
#' @return default a string vector with the id of each of the users. 
#' If all = TRUE a data.frame with the id, name (showed on the screen) and username
#' @export
#'
#' @examples
#' \dontrun{
#' bearer_token <- "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
#' users <- c("Twitter", "TwitterDev")
#' get_user_id(users, bearer_token)
#' }
get_user_id <- function(usernames, bearer_token = get_bearer(), all = FALSE){
  bearer_token <- check_bearer(bearer_token)
  
  url <- "https://api.twitter.com/2/users/by"

  params <- list(
    "usernames" = paste(usernames, collapse = ",")
  )
  
  dat <- make_query(url = url,
                    params = params,
                    bearer_token = bearer_token, verbose = TRUE)

  dat <- dat[[1]] # results are returned in a list
  
  if(all) return(dat)
  else {
    ids <- dat$id
    names(ids) <- usernames
    return(ids)
  }
  
}