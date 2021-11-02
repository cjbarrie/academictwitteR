#' Get user id
#' 
#' This function get the user IDs (e.g. 1349149096909668363) of given usernames, e.g. "potus".
#'
#' @param usernames character vector containing screen names to be queried
#' @param bearer_token string, bearer token
#' @param all logical, default FALSE to get a character vector of user IDs. Set it to TRUE to get a data frame, see below
#' @param keep_na logical, default TRUE to keep usernames that cannot be queried. Set it to TRUE to exclude those usernames. Only useful when all is FALSE
#' @return a string vector with the id of each of the users unless all = TRUE. If all = TRUE, a data.frame with ids, names (showed on the screen) and usernames is returned.
#' @export
#'
#' @examples
#' \dontrun{
#' bearer_token <- "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
#' users <- c("Twitter", "TwitterDev")
#' get_user_id(users, bearer_token)
#' }
get_user_id <- function(usernames, bearer_token = get_bearer(), all = FALSE, keep_na = TRUE) {
  bearer_token <- check_bearer(bearer_token)
  
  url <- "https://api.twitter.com/2/users/by"

  params <- list(
    "usernames" = paste(usernames, collapse = ",")
  )
  
  dat <- make_query(url = url,
                    params = params,
                    bearer_token = bearer_token, verbose = TRUE)

  dat <- dat$data
  
  if (all) {
    return(dat)
  }
  if (!keep_na) {
    ids <- dat$id
    names(ids) <- dat$username
    return(ids)
  }
  ids <- ifelse(tolower(usernames) %in% tolower(dat$username), dat$id, NA)
  names(ids) <- usernames
  return(ids)
}
