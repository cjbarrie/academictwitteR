#' Bind errors stored as JSON files
#'
#' This function binds the errors stored as JSON files. Errors are only returned if requested in the retrieving function.
#' 
#' By default, `bind_errors` binds into a data frame containing tweets (from errors_*id*.json files). 
#'
#' @param data_path string, file path to directory of stored tweets data saved as errors_*id*.json 
#' @param verbose If `FALSE`, messages are suppressed
#' 
#' @return a data.frame containing error information
#' @export
#'
#' @examples
#' \dontrun{
#' # retrieve data with errors and store them locally as .json
#' get_all_tweets(query = "BLM", 
#'                start_tweets = "2020-01-01T00:00:00Z", 
#'                end_tweets = "2020-01-05T00:00:00Z", 
#'                bearer_token = bearer_token, 
#'                data_path = "data/",
#'                n = 500, 
#'                bind_tweets = F,
#'                errors = T)
#' 
#' # bind json files in the directory "data" into a data frame containing errors
#' bind_errors(data_path = "data/")
#' }
bind_errors <- function(data_path, verbose = TRUE) {
  files <- ls_files(data_path, "^errors_")
  if (verbose) {
    pb <- utils::txtProgressBar(min = 0, max = length(files), initial = 0)
  }  
  json.df.all <- data.frame()
  for (i in seq_along(files)) {
    filename <- files[[i]]
    json.df <- jsonlite::read_json(filename, simplifyVector = TRUE)
    json.df.all <- dplyr::bind_rows(json.df.all, json.df)
    if (verbose) {
      utils::setTxtProgressBar(pb, i)
    }
  }
  .vcat(verbose, "\n")
  return(json.df.all)
}