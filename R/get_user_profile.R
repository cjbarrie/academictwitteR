#' Get user profile
#' 
#' This function fetch a variety of information about one or more users specified by the requested ids.
#'
#' @param x string containing one user id or a vector of user ids
#' @param bearer_token string, bearer token
#'
#' @return a data frame
#' @export
#'
#' @examples
#' \dontrun{
#' bearer_token <- "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
#' users <- c("2244994945", "6253282")
#' get_user_profile(users, bearer_token)
#' }
get_user_profile <- function(x, bearer_token){
  if(missing(bearer_token)){
    stop("bearer token must be specified.")  
  }
  if(substr(bearer_token,1,7)=="Bearer "){
    bearer <- bearer_token
  } else{
    bearer <- paste0("Bearer ",bearer_token)
  }
  
  #endpoint
  url <- "https://api.twitter.com/2/users"
  
  new_df <- data.frame()
  # dividing into slices of 100 each
  slices <- seq(1, length(x), 100) 
  for(i in slices){
    if(length(x) < (i+99)){
      end <- length(x)
    } else {
      end <- (i+99)
    }
    cat(paste0("Processing from ",i," to ", end,"\n"))
    slice <- x[i:end]
    #parameters
    params <- list(
      "ids" = paste(slice, collapse = ","),
      "user.fields" = "created_at,description,entities,id,location,name,pinned_tweet_id,profile_image_url,protected,public_metrics,url,username,verified,withheld"
    )
    # Sending GET Request
    r <- httr::GET(url,httr::add_headers(Authorization = bearer), query=params)
    
    # Fix random 503 errors
    count <- 0
    while(httr::status_code(r)==503 & count<4){
      r <- httr::GET(url,httr::add_headers(Authorization = bearer),query=params)
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
    # rownames(dat) <- NULL
    new_df <- dplyr::bind_rows(new_df, dat$data) # add new rows
  }
  return(new_df)
}