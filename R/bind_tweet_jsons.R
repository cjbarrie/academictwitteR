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
#'
#' @return a data.frame
#' @export
#'
#' @examples
#' \dontrun{
#' bind_tweet_jsons(data_path = "data/")
#' }
bind_tweet_jsons <- function(data_path) {
  files <- ls_files(data_path, "^data_")
  pb = utils::txtProgressBar(min = 0,
                             max = length(files),
                             initial = 0)
  
  json.df.all <- data.frame()
  for (i in seq_along(files)) {
    filename = files[[i]]
    json.df <- jsonlite::read_json(filename, simplifyVector = TRUE)
    json.df.all <- dplyr::bind_rows(json.df.all, json.df)
    utils::setTxtProgressBar(pb, i)
  }
  cat("\n")
  return(json.df.all)
}
