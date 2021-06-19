#' Get liking users
#' 
#' This function fetches a list of users who liked a tweet or tweets.
#'
#' @param x string containing one tweet id or a vector of tweet ids
#' @param bearer_token string, bearer token
#' @param verbose If `FALSE`, query progress messages are suppressed
#'
#' @return a data frame
#' @export
#'
#' @examples
#' \dontrun{
#' bearer_token <- "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
#' tweet <- "1387744422729748486"
#' get_liking_users(tweet, bearer_token)
#' }
get_liking_users <- function(x, bearer_token = get_bearer(), verbose = TRUE){
  bearer <- check_bearer(bearer_token)
  
  url <- "https://api.twitter.com/2/tweets/"
  
  endpoint <- "/liking_users"
  params <- list(
    "user.fields" = "created_at,description,entities,id,location,name,pinned_tweet_id,profile_image_url,protected,public_metrics,url,username,verified,withheld"
  )
  
  new_df <- data.frame()
  for(i in 1:length(x)){
    cat(paste0("Processing ",x[i],"\n"))
      requrl <- paste0(url,x[i],endpoint)

      # Sending GET Request
      r <- httr::GET(requrl,httr::add_headers(Authorization = bearer),query=params)
      
      # Fix random 503 errors
      count <- 0
      while(httr::status_code(r)==503 & count<4){
        r <- httr::GET(requrl,httr::add_headers(Authorization = bearer),query=params)
        count <- count+1
        Sys.sleep(count*5)
      }
      
      # Catch other errors
      if(httr::status_code(r)!=200){
        stop(paste("something went wrong. Status code:", httr::status_code(r)))
      }
      if(httr::headers(r)$`x-rate-limit-remaining`=="1"){
        warning(paste("x-rate-limit-remaining=1. Resets at",as.POSIXct(as.numeric(httr::headers(r)$`x-rate-limit-reset`), origin="1970-01-01")))
      }
      
      dat <- jsonlite::fromJSON(httr::content(r, "text"))
      next_token <- dat$meta$next_token #this is NULL if there are no pages left
      new_rows <- dat$data
      new_rows$from_id <- x[i]
      new_df <- dplyr::bind_rows(new_df, new_rows) # add new rows
      
      cat("Total data points: ",nrow(new_df), "\n")
      Sys.sleep(1)
      if (is.null(next_token)) {
        if(verbose) {
          cat("This is the last page for ",
              x[i],
              ": finishing collection. \n")
        }
        break
      }
      Sys.sleep(1)
      if(httr::status_code(r)==429){
        cat("Rate limit reached \n Sleeping...\n")
        Sys.sleep(900)
      }
    }
  return(new_df)
}
