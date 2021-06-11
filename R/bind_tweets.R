#' Bind information stored as JSON files
#'
#' This function binds information stored as JSON files. By default, it binds into a data frame containing tweets (from data_*id*.json files). If users is TRUE, it binds into a data frame containing user information (from users_*id*.json). 
#'
#' @param data_path string, file path to directory of stored tweets data saved as data_*id*.json and users_*id*.json
#' @param user If `FALSE`, this function binds JSON files into a data frame containing tweets; data frame containing user information otherwise
#' @param verbose If `FALSE`, messages are suppressed
#' @return a data.frame containing either tweets or user information
#' @export
#'
#' @examples
#' \dontrun{
#' # bind json files in the directory "data" into a data frame containing tweets
#' bind_tweets(data_path = "data/")
#' # bind json files in the directory "data" into a data frame containing user information
#' bind_tweets(data_path = "data/", user = TRUE)
#' }
bind_tweets <- function(data_path, user = FALSE, verbose = TRUE) {
  if(user) {
    files <- ls_files(data_path, "^users_")
  } else {
    files <- ls_files(data_path, "^data_")
  }
  if (verbose) {
    pb <- utils::txtProgressBar(min = 0, max = length(files), initial = 0)
  }  
  json.df.all <- data.frame()
  for (i in seq_along(files)) {
    filename = files[[i]]
    json.df <- jsonlite::read_json(filename, simplifyVector = TRUE)
    if (user) {
      json.df <- json.df$users
    }
    json.df.all <- dplyr::bind_rows(json.df.all, json.df)
    if (verbose) {
      utils::setTxtProgressBar(pb, i)
    }
  }
  .vcat(verbose, "\n")
  return(json.df.all)
}

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
