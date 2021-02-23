#' Get tweets from user
#' 
#' This function loops through list of users and collects tweets between specified date ranges. Tweet-level data is stored in a data/ path as a series of JSONS; User-level data is stored in a includes/ path as a series of JSONS. If a filename is supplied, this function will save the result as a RDS file, otherwise, it will return the results as a dataframe.
#'
#' @param users character vector, user handles to collect data from
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
#' users <- c("uoessps", "spsgradschool")
#' get_user_tweets(users, "2020-01-01T00:00:00Z", "2020-01-05T00:00:00Z", bearer_token, file = "testing.rds")
#' }
get_user_tweets <- function(users, start_tweets, end_tweets, bearer_token, file = NULL, data_path = "data/", users_path = "includes/"){
  #create folders for storage
  ifelse(!dir.exists(file.path(data_path)),
         dir.create(file.path(data_path), showWarnings = FALSE),
         FALSE)
  ifelse(!dir.exists(file.path(users_path)),
         dir.create(file.path(users_path), showWarnings = FALSE),
         FALSE)

  #get tweets
  nextoken <- ""
  i <- 1
  
  while (!is.null(nextoken)) {
    query <- paste0('from:', users[[i]])
    userhandle <- users[[i]]
    df <-
      get_tweets(
        q = query ,
        n = 500,
        start_time = start_tweets,
        end_time = end_tweets,
        token = bearer_token,
        next_token = nextoken
      )
    jsonlite::write_json(df$data,
                         paste0(data_path, "data_", userhandle, df$data$id[nrow(df$data)], ".json"))
    jsonlite::write_json(df$includes,
                         paste0(users_path, "includes_", userhandle, df$data$id[nrow(df$data)], ".json"))
    nextoken <-
      df$meta$next_token #this is NULL if there are no pages left
    cat(query, ": ", "(", nrow(df$data), ") ", "\n", sep = "")
    Sys.sleep(3.1) #sleep between calls to avoid rate limiting
    if (is.null(nextoken)) {
      cat("next_token is now NULL for",
          userhandle,
          " moving to next account \n")
      nextoken <- ""
      i = i + 1
      if (i > length(users)) {
        cat("No more accounts to capture")
        break
      }
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

