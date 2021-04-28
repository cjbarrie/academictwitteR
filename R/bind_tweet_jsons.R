#' Bind tweets stored as JSON files
#'
#' @param data_path string, file path to directory of stored tweets data saved as data_*id*.json
#'
#' @return
#' @export
#'
#' @examples
#' \dontrun{
#' bind_tweet_jsons("data_path = "data/"")
#' }
bind_tweet_jsons <- function(data_path) {
  # parse and bind
  files <-
    list.files(
      path = file.path(data_path),
      pattern = "^data_",
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
    json.df.all <- dplyr::bind_rows(json.df.all, json.df)
    utils::setTxtProgressBar(pb, i)
  }
  return(json.df.all)
}
