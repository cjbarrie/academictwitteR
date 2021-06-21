#' Get user profile
#' 
#' This function fetches user-level information for a vector of user IDs.
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
get_user_profile <- function(x, bearer_token = get_bearer()){
  bearer_token <- check_bearer(bearer_token)
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
    dat <- make_query(url = url, params = params, bearer_token = bearer_token, verbose = TRUE)
    # rownames(dat) <- NULL
    new_df <- dplyr::bind_rows(new_df, dat$data) # add new rows
  }
  return(new_df)
}
