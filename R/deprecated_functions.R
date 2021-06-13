#' Bind user information stored as JSON files
#' `r lifecycle::badge("deprecated")
#' 
#' @param data_path string, file path to directory of stored tweets data saved as users_*id*.json
#' @param verbose If `FALSE`, messages are suppressed
#' @return a data.frame
#' @keywords internal
#' @export
#'
#' @examples
#' \dontrun{
#' bind_user_jsons("data_path = "data/"")
#' }
bind_user_jsons <- function(data_path, verbose = TRUE) {
  lifecycle::deprecate_soft("0.2.0", "bind_user_jsons()", details = "Please use `bind_tweets(user = TRUE)` instead")
  bind_tweets(data_path = data_path, user = TRUE, verbose = verbose)
}

#' Bind tweets stored as JSON files
#' `r lifecycle::badge("deprecated")
#'
#' @param data_path string, file path to directory of stored tweets data saved as data_*id*.json
#' @param verbose If `FALSE`, messages are suppressed
#' @return a data.frame
#' @keywords internal
#' @export
#'
#' @examples
#' \dontrun{
#' bind_tweet_jsons(data_path = "data/")
#' }
bind_tweet_jsons <- function(data_path, verbose = TRUE) {
  lifecycle::deprecate_soft("0.2.0", "bind_user_jsons()", "bind_tweets()")
  bind_tweets(data_path = data_path, user = FALSE, verbose = verbose)
}
