#' Get tweets from user
#' 
#' This function loops through list of users and collects tweets between specified date ranges. If a filename is supplied, this function will save the result as a RDS file, otherwise, it will return the results as a dataframe.
#'
#' @param query string, search query, use "+" to separate query terms.
#' @param start_tweets string, starting date
#' @param end_tweets  string, ending date
#' @param bearer_token string, bearer token
#' @param file string, name of the resulting RDS file. Will return a dataframe if not supplied.
#' @param data_path string, path for saving jsons containing main tweet parameters
#' @param users_path string, path for saving jsons containing user-level information
#'
#' @return a data frame
#' @export
#'
#' @examples
#' \dontrun{
#' bearer_token <- "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
#' get_hashtag_tweets("#BLM+#BlackLivesMatter", "2020-01-01T00:00:00Z", "2020-01-05T00:00:00Z", bearer_token)
#' }
get_hashtag_tweets <- function(query, start_tweets, end_tweets, bearer_token, file = NULL, data_path = "data/", users_path = "includes/"){
  #create folders for storage
  ifelse(!dir.exists(file.path(data_path)),
         dir.create(file.path(data_path), showWarnings = FALSE),
         FALSE)
  ifelse(!dir.exists(file.path(users_path)),
         dir.create(file.path(users_path), showWarnings = FALSE),
         FALSE)
  
  nextoken <- ""
  
  while (!is.null(nextoken)) {
    df <-
      get_tweets(
        q = query ,
        n = 500,
        start_time = start_tweets,
        end_time = end_tweets,
        token = bearer_token,
        next_token = nextoken
      )
    jsonlite::write_json(df$data, paste0("data/", "data_", df$data$id[nrow(df$data)], ".json"))
    jsonlite::write_json(df$includes,
                         paste0("includes/", "includes_", df$data$id[nrow(df$data)], ".json"))
    nextoken <-
      df$meta$next_token #this is NULL if there are no pages left
    cat(query, ": ", "(", nrow(df$data), ") ", "\n", sep = "")
    Sys.sleep(3.1)
    if (is.null(nextoken)) {
      cat("next_token is now NULL for", query, ": finishing collection.")
      break
    }
  }
  
  #parse and bind
  files <-
    list.files(
      path = file.path(data_path),
      recursive = T,
      include.dirs = T
    )
  files <- paste(data_path, files, sep = "")
  
  pb = utils::txtProgressBar(min = 0,
                      max = length(files),
                      initial = 0)
  
  df.all <- data.frame()
  for (i in seq_along(files)) {
    filename = files[[i]]
    df <- jsonlite::read_json(filename, simplifyVector = TRUE)
    df.all <- dplyr::bind_rows(df.all, df)
    utils::setTxtProgressBar(pb, i)
  }
  if(!is.null(file)){
    saveRDS(df.all, file = file)
  } else {
    return(df.all)
  }
}
