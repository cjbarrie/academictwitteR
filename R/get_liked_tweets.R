#' Get liked tweets
#' 
#' This function fetches returns tweets liked by a user or users.
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
#' users <- c("2244994945", "95226101")
#' get_liked_tweets(users, bearer_token = get_bearer())
#' }
get_liked_tweets <- function(x, bearer_token = get_bearer(), ...){
  get_user_edges(x, bearer_token, wt = "liked_tweets", ...)
}
