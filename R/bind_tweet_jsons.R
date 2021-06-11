ls_files <- function(data_path, pattern) {
  ## parse and bind
  files <-
    list.files(
      path = file.path(data_path),
      pattern = pattern,
      recursive = T,
      include.dirs = T,
      full.names = T
    )
  
  if (length(files) < 1) {
    stop(paste0("There are no files matching the pattern `", pattern, "` in the specified directory."), call. = FALSE)
  }
  return(files)
}

#' Bind tweets stored as JSON files
#'
#' @param data_path string, file path to directory of stored tweets data saved as data_*id*.json
#' @param verbose If `FALSE`, messages are suppressed
#' @return a data.frame
#' @export
#'
#' @examples
#' \dontrun{
#' bind_tweet_jsons(data_path = "data/")
#' }
bind_tweet_jsons <- function(data_path, verbose = TRUE) {
  bind_tweets(data_path = data_path, user = FALSE, verbose = verbose)
}
