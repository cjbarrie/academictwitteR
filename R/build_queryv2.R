#' Build tweet query 
#' 
#' Build tweet query according to targeted parameters, can then be input to main `get_all_tweets()` function as query parameter.
#'
#' @param query string, search query
#' @param is_retweet If `TRUE`, only retweets will be returned; if `FALSE` retweets will not be returned
#' @param is_reply If `TRUE`, only reply tweets will be returned
#' @param is_quote If `TRUE`, only quote tweets will be returned
#' @param place string, name of place e.g. "new york city"
#' @param country string, name of country as ISO alpha-2 code e.g. "GB"
#' @param point_radius If `TRUE`, user will be prompted to enter lat. long, and radius
#' @param bbox If `TRUE`, user will be prompted to enter bounding box coordinates from west longitude to north latitude
#' @param remove_promoted If `TRUE`, tweets created for promotion only on ads.twitter.com are removed
#' @param has_hashtags If `TRUE`, only tweets containing hashtags will be returned
#' @param has_cashtags If `TRUE`, only tweets containing cashtags will be returned
#' @param has_links If `TRUE`, only tweets containing links and media will be returned
#' @param has_mentions If `TRUE`, only tweets containing mentions will be returned
#' @param has_media If `TRUE`, only tweets containing a recognized media object, such as a photo, GIF, or video, as determined by Twitter will be returned
#' @param has_images If `TRUE`, only tweets containing a recognized URL to an image will be returned
#' @param has_videos If `TRUE`, only tweets containing contain native Twitter videos, uploaded directly to Twitter will be returned
#' @param has_geo If `TRUE`, only tweets containing Tweet-specific geolocation data provided by the Twitter user will be returned
#' @param lang string, a single BCP 47 language identifier
#'
#' @return
#' @export
#'
#' @examples
#' \dontrun{
#' query <- build_query("happy", is_retweet = FALSE, point_radius = TRUE, place = "new york", country = "US")
#' }
build_query <- function(query, 
                        is_retweet = FALSE, 
                        is_reply = FALSE, 
                        is_quote = FALSE,
                        place = NULL, 
                        country = NULL, 
                        point_radius = FALSE,
                        bbox = FALSE,
                        remove_promoted = FALSE,
                        has_hashtags = FALSE,
                        has_cashtags = FALSE,
                        has_links = FALSE,
                        has_mentions = FALSE,
                        has_media = FALSE,
                        has_images = FALSE,
                        has_videos = FALSE,
                        has_geo = FALSE,
                        lang) {
  
  if (isTRUE(is_retweet) & isTRUE(is_reply)) {
    stop("A tweet cannot be both a retweet and a reply")
  }
  
  if (isTRUE(is_quote) & isTRUE(is_reply)) {
    stop("A tweet cannot be both a quote tweet and a reply")
  }
  
  if (isTRUE(point_radius) & isTRUE(bbox)) {
    stop("Select either point radius or bounding box")
  }
  
  if(isTRUE(is_retweet)) {
    query <- paste(query, "is:retweet")
  }
  
  if(isFALSE(is_retweet)) {
    query <- paste(query, "-is:retweet")
  }
  
  if(isTRUE(is_reply)) {
    query <- paste(query, "is:reply")
  }
  
  if(isTRUE(is_quote)) {
    query <- paste(query, "is:quote")
  }
  
  if(!is.null(place)) {
    query <- paste(query, paste0("place:", place))
  }
  
  if(!is.null(country)) {
    query <- paste(query, paste0("place_country:", country))
  }
  
  if(isTRUE(point_radius)) {
    x <- readline("What is longitude? ")  
    y <- readline("What is latitude? ")  
    z <- readline("What is radius? ")
    
    zn<- as.integer(z)
    while(zn>25) {
      cat("Radius must be less than 25 miles")
      z <- readline("What is radius? ")
      zn<- as.integer(z)
    }
    
    z <- paste0(z, "mi")
    
    r <- paste(x,y,z)
    query <- paste(query, paste0("point_radius:","[", r,"]"))
  }
  
  if(isTRUE(bbox)) {
    w <- readline("What is west longitude? ")  
    x <- readline("What is south latitude? ")  
    y <- readline("What is east longitude? ")
    z <- readline("What is north latitude? ")
    
    z <- paste(w,x,y,z)
    
    query <- paste(query, paste0("bounding_box:","[", z,"]"))
  }
  
  if(isTRUE(remove_promoted)) {
    query <- paste(query, "-is:nullcast")
  }
  
  if(isTRUE(has_hashtags)) {
    query <- paste(query, "has:hashtags")
  }
  
  if(isTRUE(has_cashtags)) {
    query <- paste(query, "has:cashtags")
  }
  
  if(isTRUE(has_links)) {
    query <- paste(query, "has:links")
  }
  
  if(isTRUE(has_mentions)) {
    query <- paste(query, "has:mentions")
  }
  
  if(isTRUE(has_media)) {
    query <- paste(query, "has:media")
  }
  
  if(isTRUE(has_images)) {
    query <- paste(query, "has:images")
  }
  
  if(isTRUE(has_videos)) {
    query <- paste(query, "has:videos")
  }
  
  if(isTRUE(has_geo)) {
    query <- paste(query, "has:geo")
  }
  
  if(!is.null(lang)) {
    query <- paste(query, paste0("lang:", lang))
    
  }
  
  return(query)
}
