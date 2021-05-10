#' Bind user information stored as JSON files
#'
#' @param data_path string, file path to directory of stored tweets data saved as users_*id*.json
#'
#' @return a data.frame
#' @export
#'
#' @examples
#' \dontrun{
#' bind_user_jsons("data_path = "data/"")
#' }
bind_user_jsons <- function(data_path) {
  # parse and bind
  files <-
    list.files(
      path = file.path(data_path),
      pattern = "^users_",
      recursive = T,
      include.dirs = T
    )
  files <- paste(data_path, files, sep = "")
  
  pb = utils::txtProgressBar(min = 0,
                             max = length(files),
                             initial = 0)
  
  json.df.all <- data.frame()
  for (i in seq_along(files)) {
    filename = files[[i]]
    json.df <- jsonlite::read_json(filename, simplifyVector = TRUE)
    json.df <- json.df$users
    json.df.all <- dplyr::bind_rows(json.df.all, json.df)
    utils::setTxtProgressBar(pb, i)
  }
  return(json.df.all)
}


