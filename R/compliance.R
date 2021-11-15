post_query <- function(url, params, bearer_token = get_bearer(), verbose = TRUE) {
  bearer_token <- check_bearer(bearer_token)
    r <- httr::POST(url, httr::add_headers(Authorization = bearer_token), body = params, encode = "json")
    status_code <- httr::status_code(r)
    if (!status_code %in% c(200)) {
      stop(paste("something went wrong. Status code:", httr::status_code(r)))
    }
    r
}

#' Create Compliance Job
#'
#' This function creates a new compliance job and upload the Tweet IDs or user IDs.
#' 
#' @param file a text file, each line contains a Tweet ID or user ID.
#' @param type the type of the job, whether "tweets" or "users".
#' @param bearer_token string, bearer token
#' 
#' @return 
#' @export
#' 
#' @examples
#' \dontrun{
#' create_compliance_job("tweetids.txt", "tweets")
#' }
create_compliance_job <- function(file,
                                  type,
                                  bearer_token = get_bearer()){
  r <- post_query(url = "https://api.twitter.com/2/compliance/jobs",
                  bearer_token,
                  params = list("type" = type))
  rcontent <- jsonlite::fromJSON(httr::content(r, "text"))
  cat("Job ID: ", rcontent$data$id, "\n")
  r <- httr::PUT(rcontent$data$upload_url,
                 body = httr::upload_file(file))
  if(r$status_code == 200){
    cat("Upload Completed")
  } else {
    cat("Status Code: ", r$status_code)
  }
}

#' List Compliance Jobs
#' 
#' This function lists all compliance jobs.
#' @param type the type of the job, whether "tweets" or "users".
#' @param bearer_token string, bearer token
#' 
#' @return a data frame 
#' @export
#' 
#' @examples
#' \dontrun{
#' list_compliance_job()
#' }
list_compliance_job <-function(type = "tweets", 
                               bearer_token = get_bearer()){
  make_query("https://api.twitter.com/2/compliance/jobs",
             params = list("type" = type), 
             bearer_token = bearer_token)
}

#' Get Compliance Result
#' 
#' This function retrieves the information for a single compliance job.
#' 
#' @param id string, the id of the compliance job
#' @param bearer_token string, bearer token
#' 
#' @return a data frame 
#' @export
#' 
#' @examples
#' \dontrun{
#' get_compliance_result("1460077048991555585")
#' }
get_compliance_result <- function(id, 
                                  bearer_token = get_bearer()){
  r <- make_query(paste0("https://api.twitter.com/2/compliance/jobs/",id),
                  params = list(), 
                  bearer_token = bearer_token)
  status <- r$data$status
  if(status == "in_progress"){
    cat("Compliance check in progress...\n")
  } else if (status == "complete"){ 
    # Download if ready
    cat("Downloading...\n")
    dl <- httr::GET(r$data$download_url)
    filename <- paste0(id,".json")
    writeLines(httr::content(dl, "text", encoding = "UTF-8"), filename)
    jsonlite::stream_in(file(filename), verbose = FALSE)
  } else if (status == "expired"){
    cat("Upload expired, please retry.\n")
  } else {
    cat("Status: ", status)
  }
}