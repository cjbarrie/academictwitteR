#' Update previous collection session
#'
#' This function continues a previous collection session with a new end date. 
#' For this function to work, export_query must be set to "TRUE" during the original collection.
#'
#' @param data_path string, name of an existing data_path
#' @param ... arguments will be passed to `get_all_tweets()` function. See `?get_all_tweets()` for further information.
#' @inheritParams get_all_tweets
#' @return a data.frame
#' @export
#'
#' @examples
#' \dontrun{
#' update_collection(data_path = "data", "2020-01-03T00:00:00Z", bearer_token = get_bearer())
#' }

update_collection <- function(data_path, end_tweets, bearer_token = get_bearer(), verbose = TRUE, ...){
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
  existing_df <- bind_tweets(data_path, verbose = verbose)
  start_tweets <- .shift_second(max(existing_df$created_at))
  filecon <- file(file.path(data_path, "query"))
  writeLines(c(lastquery,original_start,end_tweets), filecon)
  close(filecon)
  
  .vcat(verbose, "Query:",lastquery,"\n Original start date:",original_start,"\n Collection start date:",start_tweets,"\n End date:",end_tweets,"\n")
  get_all_tweets(lastquery, start_tweets, end_tweets, bearer_token, data_path = data_path, export_query = FALSE, verbose = verbose, ...)
}

.shift_second <- function(input_date_str, added_sec = 1) {
  newdate <- lubridate::ymd_hms(input_date_str) + lubridate::seconds(added_sec)
  base::format(newdate, "%Y-%m-%dT%H:%M:%SZ")
}
