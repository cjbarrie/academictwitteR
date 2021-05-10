#' Resume previous collection
#'
#' This function resumes a previous interrupted collection session.
#' For this function to work, export_query must be set to "TRUE" during the original collection.
#' 
#' @param data_path string, name of an existing data_path
#' @param bearer_token string, bearer token
#' @param ... arguments will be passed to `get_all_tweets()` function. See `?get_all_tweets()` for further information.
#' 
#' @return a data.frame
#' @export
#'
#' @examples
#' \dontrun{
#' bearer_token <- "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
#' resume_collection(data_path = "data", bearer_token)
#' }

resume_collection <- function(data_path, bearer_token, ...){
  if(!dir.exists(file.path(data_path))){
    stop("Directory ", data_path, " doesn't exist.")
  }
  metadata <- readLines(file.path(data_path,"query"))
  lastquery <- metadata[1]
  startdate <- metadata[2]
  
  existing_df <- bind_tweet_jsons(data_path)
  enddate <- min(existing_df$created_at)
  
  cat("Query:",lastquery,"\nStart date:",startdate,"\n End date:",enddate,"\n")
  get_all_tweets(lastquery, startdate, enddate, bearer_token, data_path = data_path, export_query = FALSE, ...)
}