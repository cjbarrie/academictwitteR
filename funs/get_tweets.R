get_tweets <- function(q="",n=10,start_time,end_time,token,next_token=""){
  if(n>500){
    warning("n too big. Using 500 instead")
    n <- 500
  }
  if(n<5){
    warning("n too small Using 10 instead")
    n <- 500
  }
  if(missing(token)){
    stop("bearer token must be specified.")  
  }
  if(missing(end_time)){
    end_time <- gsub(" ","T",paste0(as.character(Sys.time()),"Z"))
  }
  if(missing(start_time)){
    start_time <- paste0(Sys.Date(),"T00:00:00Z")
  }
  if(substr(token,1,7)=="Bearer "){
    bearer <- token
  } else{
    bearer <- paste0("Bearer ",token)
  }
  #endpoint
  url <- "https://api.twitter.com/2/tweets/search/all"
  #parameters
  params = list(
    "query" = q,
    "max_results" = n,
    "start_time" = start_time,
    "end_time" = end_time, 		
    "tweet.fields" = "attachments,author_id,context_annotations,conversation_id,created_at,entities,geo,id,in_reply_to_user_id,lang,public_metrics,possibly_sensitive,referenced_tweets,source,text,withheld",
    "user.fields" = "created_at,description,entities,id,location,name,pinned_tweet_id,profile_image_url,protected,public_metrics,url,username,verified,withheld",
    "expansions" = "author_id,entities.mentions.username,geo.place_id,in_reply_to_user_id,referenced_tweets.id,referenced_tweets.id.author_id",
    "place.fields" = "contained_within,country,country_code,full_name,geo,id,name,place_type"
  )
  if(next_token!=""){
    params[["next_token"]] <- next_token
  }
  r <- httr::GET(url,httr::add_headers(Authorization = bearer),query=params)
  
  #fix random 503 errors
  count <- 0
  while(httr::status_code(r)==503 & count<4){
    r <- httr::GET(url,httr::add_headers(Authorization = bearer),query=params)
    count <- count+1
    Sys.sleep(count*5)
  }
  
  if(httr::status_code(r)!=200){
    stop(paste("something went wrong. Status code:", httr::status_code(r)))
  }
  if(httr::headers(r)$`x-rate-limit-remaining`=="1"){
    warning(paste("x-rate-limit-remaining=1. Resets at",as.POSIXct(as.numeric(httr::headers(r)$`x-rate-limit-reset`), origin="1970-01-01")))
  }
  dat <- jsonlite::fromJSON(httr::content(r, "text"))
  dat
}