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
#' @return 
#' @export
create_compliance_job <- function(file,
                                  type,
                                  bearer_token = get_bearer(),
                                  verbose = TRUE){
  r <- post_query(url = "https://api.twitter.com/2/compliance/jobs",
                  bearer_token,
                  params = list("type" = type))
  rcontent <- jsonlite::fromJSON(httr::content(r, "text"))$data$upload_url
  print(rcontent)
  cat("Job ID: ", rcontent$data$id)
  r <- httr::PUT(rcontent$data$upload_url,
                 body = httr::upload_file(file))
  if(r$status_code == 200){
    cat("Upload Completed")
  } else {
    cat("Status Code: ", r$status_code)
  }
}

#' Get Compliance Result
#' @return output
#' @export
get_compliance_result <- function(id, bearer_token = get_bearer()){
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
    return(dl)
  } else if (status == "expired"){
    cat("Upload expired, please retry.\n")
  } else {
    cat("Status: ", status)
  }
}