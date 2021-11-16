post_query <- function(url, params, bearer_token = get_bearer()) {
  bearer_token <- check_bearer(bearer_token)
    r <- httr::POST(url, httr::add_headers(Authorization = bearer_token), body = params, encode = "json")
    status_code <- httr::status_code(r)
    if (!status_code %in% c(200)) {
      stop(paste("Something went wrong. Status code:", httr::status_code(r)))
    }
    r
}

#' Create Compliance Job
#'
#' This function creates a new compliance job and upload the Tweet IDs or user IDs.
#' 
#' @param file a text file, each line contains a Tweet ID or user ID.
#' @param type the type of the job, whether "tweets" or "users".
#' @inheritParams get_all_tweets
#' 
#' @return the job ID (invisibly)
#' @export
#' 
#' @examples
#' \dontrun{
#' create_compliance_job("tweetids.txt", "tweets")
#' }
create_compliance_job <- function(file,
                                  type = "tweets",
                                  bearer_token = get_bearer(),
                                  verbose = TRUE){
  r <- post_query(url = "https://api.twitter.com/2/compliance/jobs",
                  bearer_token,
                  params = list("type" = type))
  rcontent <- jsonlite::fromJSON(httr::content(r, "text"))
  .vcat(verbose, "Job ID: ", rcontent$data$id, "\n")
  r <- httr::PUT(rcontent$data$upload_url,
                 body = httr::upload_file(file))
  if(r$status_code == 200){
    .vcat(verbose, "Upload Completed", "\n")
  } else {
    stop(paste("Something went wrong. Status code:", r$status_code, "\n"))
  }
  invisible(rcontent$data$id)
}

#' List Compliance Jobs
#' 
#' This function lists all compliance jobs.
#' @inheritParams create_compliance_job
#' 
#' @return a data frame 
#' @export
#' 
#' @examples
#' \dontrun{
#' list_compliance_jobs()
#' }
list_compliance_jobs <-function(type = "tweets", 
                               bearer_token = get_bearer()){
  res <- make_query("https://api.twitter.com/2/compliance/jobs",
                    params = list("type" = type), 
                    bearer_token = bearer_token)
  return(res$data)
}

#' Get Compliance Result
#' 
#' This function retrieves the information for a single compliance job.
#' 
#' @param id string, the job id
#' @inheritParams create_compliance_job
#' 
#' @return a data frame 
#' @export
#' 
#' @examples
#' \dontrun{
#' get_compliance_result("1460077048991555585")
#' }
get_compliance_result <- function(id, 
                                  bearer_token = get_bearer(), verbose = TRUE){
  r <- make_query(paste0("https://api.twitter.com/2/compliance/jobs/",id),
                  params = list(), 
                  bearer_token = bearer_token)
  status <- r$data$status
  if(status == "in_progress"){
    stop("Compliance check is still in progress.\n")
  } else if (status == "complete"){ 
    # Download if ready
    .vcat(verbose, "Downloading...\n")
    dl <- httr::GET(r$data$download_url)
    filename <- paste0(id,".json")
    writeLines(httr::content(dl, "text", encoding = "UTF-8"), filename)
    return(jsonlite::stream_in(file(filename), verbose = FALSE))
  } else if (status == "expired"){
    stop("Upload expired, please retry.\n")
  } else {
    stop(paste("Something went wrong. Status:", status, "\n"))
  }
}
