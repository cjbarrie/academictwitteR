#' Manage your bearer token
#'
#' This function attempts to retrieve your bearer token from the environmental variable "TWITTER_BEARER". 
#' The easiest way to setup this environmental variable is to use \code{set_bearer()} 
#' and insert your bearer token to \code{.Renviron} file following the format: TWITTER_BEARER=YOURTOKENHERE. 
#' Replace YOURTOKENHERE with your own token.
#' @return string represents your bearer token, if it the environmental variable "TWITTER_BEARER" has been preset.
#' @export
get_bearer <- function() {
  bearer_token <- Sys.getenv('TWITTER_BEARER')
  if (identical(bearer_token, "")) {
    stop("Please set envvar TWITTER_BEARER or supply your bearer token in every call. See ?get_bearer for more information.", call. = FALSE)
  }
  return(bearer_token)
}
