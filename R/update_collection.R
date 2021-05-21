#' Update previous collection session
#'
#' This function continues previous collection session with a new end date. 
#' For this function to work, export_query must be set to "TRUE" during the original collection.
#'
#' @param data_path string, name of an existing data_path
#' @param end_tweets  string, new end date for data collection, it must be later then the original start date.
#' @param bearer_token string, bearer token
#' @param ... arguments will be passed to `get_all_tweets()` function. See `?get_all_tweets()` for further information.
#' 
#' @return a data.frame
#' @export
#'
#' @examples
#' \dontrun{
#' bearer_token <- "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
#' update_collection(data_path = "data", "2020-01-03T00:00:00Z", bearer_token)
#' }

update_collection <- function(data_path, end_tweets, bearer_token, ...){
  if(!dir.exists(file.path(data_path))){
    stop("Directory ", data_path, " doesn't exist.")
  }
  if(missing(end_tweets)){
    stop("Argument end_tweets is missing.")
  }
  metadata <- readLines(file.path(data_path,"query"))
  lastquery <- metadata[1]
  original_start <- metadata[2]
  
  # Get the date of last tweet
  existing_df <- bind_tweet_jsons(data_path)
  start_tweets <- max(existing_df$created_at) 
  
  # add "/" at the end
  if(substr(data_path, nchar(data_path), nchar(data_path)) != "/"){
    data_path <- paste0(data_path,"/")
  }
  filecon <- file(paste0(data_path,"query"))
  writeLines(c(lastquery,original_start,end_tweets), filecon)
  close(filecon)
  
  cat("Query:",lastquery,"\n Original start date:",original_start,"\n Collection start date:",start_tweets,"\n End date:",end_tweets,"\n")
  get_all_tweets(lastquery, start_tweets, end_tweets, bearer_token, data_path = data_path, export_query = FALSE, ...)
}