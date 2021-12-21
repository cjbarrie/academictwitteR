#' Hydrate Tweets Based On Tweet IDs
#'
#' This function is helpful for hydrating Tweet IDs (i.e. getting the full content of tweets from a list of Tweet IDs).
#' @inheritParams get_all_tweets
#' @param ids a character vector of Tweet IDs
#' @param context_annotations If `TRUE`, context_annotations will be fetched.
#' @param errors logical, if `TRUE`, the error capturing mechanism is enabled. See details below.
#' @return When bind_tweets is `TRUE`, the function returns a data frame. The `data_path` (invisibly) if `bind_tweets` is `FALSE`
#' @details When the error capturing mechanism is enabled, Tweets IDs that cannot be queried (e.g. with error) are stored as `errors_*.json` files. If `bind_tweets` is TRUE, those error Tweets IDs are retained in the returned data.frame with the column `error` indicating the error.
#' @examples
#' \dontrun{
#' hydrate_tweets(c("1266876474440761346", "1266868259925737474", "1266867327079002121",
#' "1266866660713127936", "1266864490446012418", "1266860737244336129",
#' "1266859737615826944", "1266859455586676736", "1266858090143588352",
#' "1266857669157097473"))
#' }
#' @export
hydrate_tweets <- function(ids,  bearer_token = get_bearer(), data_path = NULL,
                           context_annotations = FALSE,
                           bind_tweets = TRUE,
                           verbose = TRUE,
                           errors = FALSE) {
  ## Building parameters for get_tweets()
  if (is.null(data_path) & !bind_tweets) {
    stop("Argument (bind_tweets = FALSE) is valid only when data_path is specified.")
  }
  params <- list(
    tweet.fields = "attachments,author_id,conversation_id,created_at,entities,geo,id,in_reply_to_user_id,lang,public_metrics,possibly_sensitive,referenced_tweets,source,text,withheld", 
    user.fields = "created_at,description,entities,id,location,name,pinned_tweet_id,profile_image_url,protected,public_metrics,url,username,verified,withheld", 
    expansions = "author_id,entities.mentions.username,geo.place_id,in_reply_to_user_id,referenced_tweets.id,referenced_tweets.id.author_id", 
    place.fields = "contained_within,country,country_code,full_name,geo,id,name,place_type"
  )
  if (context_annotations) {
    params[["tweet.fields"]] <- "attachments,author_id,context_annotations,conversation_id,created_at,entities,geo,id,in_reply_to_user_id,lang,public_metrics,possibly_sensitive,referenced_tweets,source,text,withheld"
  }
  ## loop through x in batches of 100 IDs
  new_df <- data.frame()
  if (length(ids) >= 1) {
    n_batches <- ceiling(length(ids) / 100)
  } else {
    n_batches <- 0
  }
  endpoint_url <- "https://api.twitter.com/2/tweets"
  for (i in seq_len(n_batches)) {
    batch <- ids[((i-1)*100+1):min(length(ids),(i*100))]
    params[["ids"]] <- paste0(batch, collapse = ",")
    
    ## Get tweets
    .vcat(verbose, "Batch", i, "out of", ceiling(length(ids) / 100),": ids", utils::head(batch, n = 1), "to", utils::tail(batch, n = 1), "\n")
    new_rows <- get_tweets(params = params, endpoint_url = endpoint_url, n = Inf, file = NULL, bearer_token = bearer_token, 
                           export_query = FALSE, data_path = data_path, bind_tweets = bind_tweets, verbose = FALSE, errors = errors)
    
    if (bind_tweets) {
      if (nrow(new_rows) > 0) { 
        new_df <- dplyr::bind_rows(new_df, new_rows) # add new rows
      }
      if (errors) {
        n_tweets <- nrow(dplyr::filter(new_df, is.na(.data$error)))
        .vcat(verbose, "Total ", nrow(dplyr::filter(new_df, !is.na(.data$error))), " tweet(s) can't be retrieved.\n")
      } else {
        n_tweets <- nrow(new_df)
      }
      .vcat(verbose, "Total of ", n_tweets, " out of ", length(ids), " tweet(s) retrieved.\n")
    }
  }
  if (bind_tweets) {
    return(new_df)
  }
  return(invisible(data_path))
}
