#' Resume previous collection
#'
#' This function resumes a previous interrupted collection session.
#' 
#' For this function to work, export_query must be set to "TRUE" during the original collection.
#' 
#' @inheritParams update_collection
#'
#' @return a data.frame
#' @export
#'
#' @examples
#' \dontrun{
#' resume_collection(data_path = "data", bearer_token = get_bearer())
#' }

resume_collection <- function(data_path, bearer_token = get_bearer(), verbose = TRUE, ...){
  if(!dir.exists(file.path(data_path))){
    stop("Directory ", data_path, " doesn't exist.")
  }
  metadata <- readLines(file.path(data_path,"query"))
  lastquery <- metadata[1]
  startdate <- metadata[2]
  
  existing_df <- bind_tweets(data_path, verbose = verbose)
  enddate <- min(existing_df$created_at)
  
  .vcat(verbose, "Query:",lastquery,"\nStart date:",startdate,"\n End date:",enddate,"\n")
  get_all_tweets(lastquery, startdate, enddate, bearer_token, data_path = data_path, export_query = FALSE, verbose = verbose, ...)
}
