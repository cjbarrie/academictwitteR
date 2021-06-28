#' Set bearer token
#' 
#' This function lets the user add their bearer token to the \code{.Renviron} file. 
#' 
#' It is in general not safe to 1) hard code your bearer token in your R script or 
#' 2) have your bearer token in your command history. 
#' 
#' \code{set_bearer} opens the .Renviron file
#' for the user and provides instructions on how to add the bearer token, which requires the
#' addition of just one line in the \code{.Renviron} file, following the format TWITTER_BEARER=YOURTOKENHERE. 
#' 
#' Replace YOURTOKENHERE with your own token.
#' 
#' @importFrom usethis edit_r_environ ui_info ui_line ui_silence
#' @export
set_bearer <- function() {
  ui_silence(edit_r_environ())
  ui_line("Instructions:")
  ui_info("1. Add line: TWITTER_BEARER=YOURTOKENHERE to .Renviron on new line, replacing YOURTOKENHERE with  actual bearer token")
  ui_info("2. Restart R")
}
