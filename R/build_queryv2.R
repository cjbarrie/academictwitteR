#' Build tweet query
#'
#' Build tweet query according to targeted parameters. 
#' 
#' This function is already called within the main
#' \code{\link{get_all_tweets}} function. 
#' 
#' It may also be called separately and the output saved as
#' a character object query string to be input as query parameter to \code{\link{get_all_tweets}}.
#'
#' @param query string or character vector, search query or queries
#' @param users string or character vector, user handles to collect tweets from the specified users
#' @param reply_to string or character vector, user handles to collect replies to the specified users
#' @param retweets_of string or character vector, user handles to collects retweets of tweets by the specified users
#' @param exclude string or character vector, tweets containing the keyword(s) will be excluded
#' 
#' @param is_retweet If `TRUE`, only retweets will be returned; if `FALSE`, retweets will be excluded; if `NULL`, both retweets and other tweet types will be returned.
#' @param is_reply If `TRUE`, only replies will be returned; if `FALSE`, replies will be excluded; if `NULL`, both replies and other tweet types will be returned.
#' @param is_quote If `TRUE`, only quote tweets will be returned; if `FALSE`, quote tweets will be excluded; if `NULL`, both quote tweets and other tweet types will be returned.
#' @param is_verified If `TRUE`, only tweets from verified accounts will be returned; if `FALSE`, tweets from verified accounts will be excluded; if `NULL`, both verified account tweets and tweets from non-verified accounts will be returned.
#' @param remove_promoted If `TRUE`, tweets created for promotion only on ads.twitter.com are removed
#' 
#' @param has_hashtags If `TRUE`, only tweets containing hashtags will be returned; if `FALSE`, tweets containing hashtags will be excluded; if `NULL`, both tweets containing hashtags and tweets without hashtags will be returned.
#' @param has_cashtags If `TRUE`, only tweets containing cashtags will be returned; if `FALSE`, tweets containing cashtags will be excluded; if `NULL`, both tweets containing cashtags and tweets without cashtags will be returned.
#' @param has_links If `TRUE`, only tweets containing links (and media) will be returned; if `FALSE`, tweets containing links (and media) will be excluded; if `NULL`, both tweets containing links (and media) and tweets without links (and media) will be returned.
#' @param has_mentions If `TRUE`, only tweets containing mentions will be returned; if `FALSE`, tweets containing mentions will be excluded; if `NULL`, both tweets containing mentions and tweets without mentions will be returned.
#' @param has_media If `TRUE`, only tweets containing media such as a photo, GIF, or video (as determined by Twitter) will be returned will be returned; if `FALSE`, tweets containing media will be excluded; if `NULL`, both tweets containing media and tweets without media will be returned.
#' @param has_images If `TRUE`, only tweets containing (recognized URLs to) images will be returned will be returned will be returned; if `FALSE`, tweets containing images will be excluded; if `NULL`, both tweets containing images and tweets without images will be returned.
#' @param has_videos If `TRUE`,  only tweets containing contain videos (recognized as native videos uploaded directly to Twitter) will be returned will be returned; if `FALSE`, tweets containing videos will be excluded; if `NULL`, both tweets containing videos and tweets without videos will be returned.
#' 
#' @param has_geo If `TRUE`, only tweets containing geo information (Tweet-specific geolocation data provided by the Twitter user) will be returned; if `FALSE`, tweets containing geo information will be excluded; if `NULL`, both tweets containing geo information and tweets without geo information will be returned.
#' 
#' @param place string, name of place e.g. "London"
#' @param country string, name of country as ISO alpha-2 code e.g. "GB"
#' @param point_radius numeric, a vector of two point coordinates latitude, longitude, and point radius distance (in miles)
#' @param bbox numeric, a vector of four bounding box coordinates from west longitude to north latitude
#' @param lang string, a single BCP 47 language identifier e.g. "fr"
#' @param url string, url
#' @param conversation_id string, return tweets that share the specified conversation ID
#'
#' @return a query string
#' @export
#'
#' @examples
#' \dontrun{
#' query <- build_query(query = "happy", is_retweet = FALSE,
#'                      country = "US",
#'                      place = "seattle",
#'                      point_radius = c(-122.33795253639994, 47.60900846404393, 25),
#'                      lang = "en")
#'                      
#' query <- build_query(query = "twitter",
#'                      point_radius = c(-122.33795253639994, 47.60900846404393, 25),
#'                      lang = "en")
#'                      
#' }
#'
#' @importFrom utils menu
#'
build_query <- function(query = NULL,
                        users = NULL,
                        reply_to = NULL,
                        retweets_of = NULL,
                        exclude = NULL,
                        is_retweet = NULL,
                        is_reply = NULL,
                        is_quote = NULL,
                        is_verified = NULL,
                        remove_promoted = FALSE,
                        has_hashtags = NULL,
                        has_cashtags = NULL,
                        has_links = NULL,
                        has_mentions = NULL,
                        has_media = NULL,
                        has_images = NULL,
                        has_videos = NULL,
                        has_geo = NULL,
                        place = NULL,
                        country = NULL,
                        point_radius = NULL,
                        bbox = NULL,
                        lang= NULL,
                        conversation_id = NULL,
                        url = NULL) {
  
  if(isTRUE(length(query) >1)) {
    query <- paste("(",paste(query, collapse = " OR "),")", sep = "")
  }
  
  if(!is.null(users)){
    query <- paste(query, add_query_prefix(users, "from:"))
  }
  
  if(!is.null(reply_to)){
    query <- paste(query, add_query_prefix(reply_to, "to:"))
  }
  
  if(!is.null(retweets_of)){
    query <- paste(query, add_query_prefix(retweets_of, "retweets_of:"))
  }
  
  if(!is.null(exclude)) {
    query <- paste(query, paste("-", exclude, sep = "", collapse = " "))
  }
  
  if (isTRUE(is_retweet) & isTRUE(is_reply)) {
    stop("A tweet cannot be both a retweet and a reply")
  }
  
  if (isTRUE(is_quote) & isTRUE(is_reply)) {
    stop("A tweet cannot be both a quote tweet and a reply")
  }
  
  if (isTRUE(point_radius) & isTRUE(bbox)) {
    stop("Select either point radius or bounding box")
  }
  
  query <- .process_qparam(is_retweet, "is:retweet", query)
  query <- .process_qparam(is_reply, "is:reply", query)
  query <- .process_qparam(is_quote, "is:quote", query)
  query <- .process_qparam(is_verified, "is:verified", query)
  
  if(isTRUE(remove_promoted)) {
    query <- paste(query, "-is:nullcast")
  }
  
  query <- .process_qparam(has_hashtags, "has:hashtags", query)
  query <- .process_qparam(has_cashtags, "has:cashtags", query)
  query <- .process_qparam(has_links, "has:links", query)
  query <- .process_qparam(has_mentions, "has:mentions", query)
  
  query <- .process_qparam(has_media, "has:media", query)
  query <- .process_qparam(has_images, "has:images", query)
  query <- .process_qparam(has_videos, "has:videos", query)
  
  query <- .process_qparam(has_geo, "has:geo", query)
  
  if(!is.null(place)) {
    query <- paste(query, paste0("place:", place))
  }
  
  if(!is.null(country)) {
    query <- paste(query, paste0("place_country:", country))
  }
  
  if(!is.null(point_radius)) {
    x <- point_radius[1]
    y <- point_radius[2]
    z <- point_radius[3]
    
    zn<- as.numeric(z)
    while(zn>25) {
      cat("Radius must be less than 25 miles")
      z <- readline("Input new radius: ")
      zn<- as.numeric(z)
    }
    
    z <- paste0(z, "mi")
    
    r <- paste(x,y,z)
    query <- paste(query, paste0("point_radius:","[", r,"]"))
  }
  
  if(!is.null(bbox)) {
    w <- bbox[1]
    x <- bbox[2]
    y <- bbox[3]
    z <- bbox[4]
    
    z <- paste(w,x,y,z)
    
    query <- paste(query, paste0("bounding_box:","[", z,"]"))
  }
  
  if(!is.null(lang)) {
    query <- paste(query, paste0("lang:", lang))
  }
  
  if(!is.null(conversation_id)) {
    query <- paste(query, paste0("conversation_id:", conversation_id))
  }
  
  if(!is.null(url)) {
    query <- paste(query, paste0('url:"', url, '"'))
  }
  
  return(query)
}

