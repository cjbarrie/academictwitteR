#' Bind information stored as JSON files
#'
#' This function binds information stored as JSON files. The experimental function `convert_json` converts individual JSON files into either "raw" or "tidy" format. 
#' 
#' By default, `bind_tweets` binds into a data frame containing tweets (from data_*id*.json files). 
#' 
#' If users is TRUE, it binds into a data frame containing user information (from users_*id*.json). 
#' 
#' For the "tidy" and "tidy2" format, parallel processing with furrr is supported. In order to enable parallel processing, workers need to be set manually through [future::plan()]. See examples
#' 
#' Note that output of the tidy2 vars returns results of the Twitter API, rather than from tweet text. Therefore, certain variables, especially context annotations and quoted_variables, may not be present in older data.
#'
#' @param data_path string, file path to directory of stored tweets data saved as data_*id*.json and users_*id*.json
#' @param user If `FALSE`, this function binds JSON files into a data frame containing tweets; data frame containing user information otherwise. Ignore if `output_format` is not NA
#' @param verbose If `FALSE`, messages are suppressed
#' @param output_format
#' `r lifecycle::badge("experimental")` string, if it is not NA, this function return an unprocessed data.frame containing either tweets or user information. Currently, this function supports the following format(s)
#' \itemize{
#'    \item{"raw"}{List of data frames; Note: not all data frames are in Boyce-Codd 3rd Normal Form}
#'    \item{"tidy"}{Tidy format; all essential columns are available}
#'    \item{"tidy2"}{Tidy format; additional variables (see vars) are available. Untruncates retweet text and adds indicators for retweets, quotes and replies. Automatically drops duplicated tweets. Handling of quoted tweets can be specified (see quoted_variables)}
#' }
#' 
#' @param vars
#' `r lifecycle::badge("experimental")` vector of strings, determining the variables provided by the tidy2 format. Can be any (or all) of the following:
#' \itemize{
#'    \item{"text"}{Text of the tweet, including language classification, indicator of sensitive content and (if applicable) sourcetweet text}
#'    \item{"user"}{Information on the user in addition to their ID}
#'    \item{"tweet_metrics"}{Tweet metrics, specifically the like, retweet and quote counts}
#'    \item{"user_metrics"}{User metrics, specifically their tweet, list, follower and following counts}
#'    \item{"hashtags"}{Hashtags contained in the tweet. Untrunctated for retweets}
#'    \item{"ext_urls"}{Shortened and expanded URLs contained in the tweet, excluding those internal to Twitter (e.g. retweet URLs). Includes additional data provided by Twitter, such as the unwound URL, their title and description (if available). Untrunctated for retweets}
#'    \item{"mentions"}{Mentioned usernames and their IDs, excluding retweeted users. Untrunctated for retweets. Note that quoted users are only mentioned here if explicitly named in the tweet text. This was usually the case with older versions of Twitter, but is no longer the standard behaviour. Extracting mentions allows the usernames of the RT authors (rather than only their ID) to be preserved}
#'    \item{"annotations"}{Annotations provided by Twitter, including their probability and type. Basically Named Entities. See https://developer.twitter.com/en/docs/twitter-api/annotations/overview for details}
#'    \item{"context_annotations"}{Context annotations provided by Twitter, including additional data on their domains. See https://developer.twitter.com/en/docs/twitter-api/annotations/overview for details}
#' }
#' 
#' @param quoted_variables
#' `r lifecycle::badge("experimental")` Should additional vars be returned for the quoted tweet? Defaults to FALSE. TRUE returns additional "_quoted" var-columns containing the vars (mentions, hashtags, etc.) of the quoted tweet in addition to the actual tweet's data
#' 
#' @return a data.frame containing either tweets or user information
#' @export
#'
#' @examples
#' \dontrun{
#' # bind json files in the directory "data" into a data frame containing tweets
#' bind_tweets(data_path = "data/")
#' 
#' # bind json files in the directory "data" into a data frame containing user information
#' bind_tweets(data_path = "data/", user = TRUE)
#' 
#' # bind json files in the directory "data" into a "tidy" data frame / tibble
#' bind_tweets(data_path = "data/", user = TRUE, output_format = "tidy")
#' 
#' # bind json files in the directory "data" into a "tidy2" data frame / tibble, get hashtags and
#' # URLs for both original and quoted tweets
#' bind_tweets(data_path = "data/", user = TRUE, output_format = "tidy2", 
#'             vars = c("hashtags", "ext_urls"),
#'             quoted_variables = T)
#'             
#' # bind json files in the directory "data" into a "tidy2" data frame / tibble with parallel computing
#' ## set up a multisession
#' future::plan("multisession")
#' ## run the function - note that no additional arguments are required
#' bind_tweets(data_path = "data/", user = TRUE, output_format = "tidy2")
#' ## Shut down parallel workers
#' future::plan("sequential")            
#' }
bind_tweets <- function(data_path, user = FALSE, verbose = TRUE, output_format = NA, 
                        vars = c("text", "user", "tweet_metrics", "user_metrics", "hashtags", "ext_urls", "mentions", "annotations", "context_annotations"),
                        quoted_variables = FALSE) {
  if (!is.na(output_format)) {
    flat <- .flat(data_path, output_format = output_format, vars = vars, quoted_variables = quoted_variables)
    if (output_format == "tidy2") {
      flat <- flat %>% dplyr::mutate(dplyr::across(.cols = tidyselect::where(is.list), ~ dplyr::coalesce(., list(NA)))) # set left_join's NULL values to NA for consistency
    }
    return(flat)
  }
  if(user) {
    files <- ls_files(data_path, "^users_")
  } else {
    files <- ls_files(data_path, "^data_")
  }
  if (verbose) {
    pb <- utils::txtProgressBar(min = 0, max = length(files), initial = 0)
  }  
  json.df.all <- data.frame()
  for (i in seq_along(files)) {
    filename <- files[[i]]
    json.df <- jsonlite::read_json(filename, simplifyVector = TRUE)
    if (user) {
      json.df <- json.df$users
    }
    json.df.all <- dplyr::bind_rows(json.df.all, json.df)
    if (verbose) {
      utils::setTxtProgressBar(pb, i)
    }
  }
  .vcat(verbose, "\n")
  return(json.df.all)
}

ls_files <- function(data_path, pattern) {
  ## parse and bind
  files <-
    list.files(
      path = file.path(data_path),
      pattern = pattern,
      recursive = TRUE,
      include.dirs = TRUE,
      full.names = TRUE
    )
  
  if (length(files) < 1) {
    stop(paste0("There are no files matching the pattern `", pattern, "` in the specified directory."), call. = FALSE)
  }
  return(files)
}

#' @param data_file string, a single file path to a JSON file; or a vector of file paths to JSON files of stored tweets data saved as data_*id*.json
#' @export
#' @rdname bind_tweets
#' @importFrom rlang .data
#' @importFrom rlang :=
convert_json <- function(data_file, output_format = "tidy",
                         vars = c("text", "user", "tweet_metrics", "user_metrics", "hashtags", "ext_urls", "mentions", "annotations", "context_annotations"),
                         quoted_variables = F) {
  if (!output_format %in% c("tidy", "raw", "tidy2")) {
    stop("Unknown format.", call. = FALSE)
  }
  tweet_data <- .gen_raw(purrr::map_dfr(data_file, ~jsonlite::read_json(., simplifyVector = TRUE)))
  names(tweet_data) <- paste0("tweet.", names(tweet_data))
  aux_file <- .gen_aux_filename(data_file)
  user_data <- .gen_raw(purrr::map_dfr(aux_file, ~jsonlite::read_json(., simplifyVector = TRUE)$users), pki_name = "author_id")
  names(user_data) <- paste0("user.", names(user_data))
  sourcetweet_data <- list(main = purrr::map_dfr(aux_file, ~jsonlite::read_json(., simplifyVector = TRUE)$tweets))
  names(sourcetweet_data) <- paste0("sourcetweet.", names(sourcetweet_data))
  ## raw
  raw <- c(tweet_data, user_data, sourcetweet_data)
  if (output_format == "raw") {
    return(raw)
  }
  if (output_format == "tidy") {
    tweetmain <- raw[["tweet.main"]]
    usermain <- dplyr::distinct(raw[["user.main"]], .data$author_id, .keep_all = TRUE)  ## there are duplicates
    colnames(usermain) <- paste0("user_", colnames(usermain))
    tweet_metrics <- tibble::tibble(tweet_id = raw$tweet.public_metrics.retweet_count$tweet_id,
                                    retweet_count = raw$tweet.public_metrics.retweet_count$data,
                                    like_count = raw$tweet.public_metrics.like_count$data,
                                    quote_count = raw$tweet.public_metrics.quote_count$data,
                                    impression_count = raw$tweet.public_metrics.impression_count$data)
    user_metrics <- tibble::tibble(author_id = raw$user.public_metrics.tweet_count$author_id,
                                   user_tweet_count = raw$user.public_metrics.tweet_count$data,
                                   user_list_count = raw$user.public_metrics.listed_count$data,
                                   user_followers_count = raw$user.public_metrics.followers_count$data,
                                   user_following_count = raw$user.public_metrics.following_count$data) %>%
      dplyr::distinct(.data$author_id, .keep_all = TRUE)
    res <- tweetmain %>% dplyr::left_join(usermain, by = c("author_id" = "user_author_id")) %>%
      dplyr::left_join(tweet_metrics, by = "tweet_id") %>%
      dplyr::left_join(user_metrics, by = "author_id")
    if (!is.null(raw$tweet.referenced_tweets)) {
      ref <- raw$tweet.referenced_tweets
      colnames(ref) <- c("tweet_id", "sourcetweet_type", "sourcetweet_id")
      ref <- ref %>% dplyr::filter(.data$sourcetweet_type != "replied_to")
      res <- dplyr::left_join(res, ref, by = "tweet_id")
      if (nrow(raw$sourcetweet.main) > 0) {
        source_main <- dplyr::select(raw$sourcetweet.main, .data$id, .data$text, .data$lang, .data$author_id) %>%
          dplyr::distinct(.data$id, .keep_all = TRUE)
        colnames(source_main) <- paste0("sourcetweet_", colnames(source_main))
        res <- res %>% dplyr::left_join(source_main, by = "sourcetweet_id")
      }
    }
    res <- dplyr::relocate(res, .data$tweet_id, .data$user_username, .data$text)
    return(tibble::as_tibble(res))
  }

  if (output_format == "tidy2") {
    res <- raw[["tweet.main"]] %>% dplyr::select(tweet_id, tidyselect::any_of(c("conversation_id", "author_id", "created_at", "source", "in_reply_to_user_id")))
    if ("text" %in% vars) {
      text <- raw[["tweet.main"]] %>% dplyr::select(tweet_id, tidyselect::any_of(c("text", "lang", "possibly_sensitive")))
      res <- res %>% dplyr::left_join(text, by = "tweet_id")
    }
    if ("user" %in% vars) {
      usermain <- dplyr::distinct(raw[["user.main"]], .data$author_id, .keep_all = TRUE)  ## there are duplicates
      colnames(usermain) <- paste0("user_", colnames(usermain))
      res <- res %>% dplyr::left_join(usermain, by = c("author_id" = "user_author_id"))
    }
    if ("tweet_metrics" %in% vars) {
      tweet_metrics <- tibble::tibble(tweet_id = raw$tweet.public_metrics.retweet_count$tweet_id,
                                      retweet_count = raw$tweet.public_metrics.retweet_count$data,
                                      like_count = raw$tweet.public_metrics.like_count$data,
                                      quote_count = raw$tweet.public_metrics.quote_count$data,
                                      impression_count = raw$tweet.public_metrics.impression_count$data) 
      res <- res %>% dplyr::left_join(tweet_metrics, by = "tweet_id")
    }
    if ("user_metrics" %in% vars) {
      user_metrics <- tibble::tibble(author_id = raw$user.public_metrics.tweet_count$author_id,
                                     user_tweet_count = raw$user.public_metrics.tweet_count$data,
                                     user_list_count = raw$user.public_metrics.listed_count$data,
                                     user_followers_count = raw$user.public_metrics.followers_count$data,
                                     user_following_count = raw$user.public_metrics.following_count$data) %>%
        dplyr::distinct(.data$author_id, .keep_all = TRUE)
      res <- res %>% dplyr::left_join(user_metrics, by = "author_id")
    }
    if ("hashtags" %in% vars & !is.null(raw$tweet.entities.hashtags)) {
      hashtags <- raw$tweet.entities.hashtags %>% 
        dplyr::group_by(.data$tweet_id) %>% dplyr::mutate(hashtags = if ("tag" %in% colnames(.)) list(.data$tag) else NA) %>% # used hashtags as list per tweet
        dplyr::ungroup() %>% dplyr::distinct(.data$tweet_id, .keep_all = TRUE) %>%    # drop duplicates created through the dplyr::left_join
        dplyr::select(.data$tweet_id, hashtags)
      res <- dplyr::left_join(res, hashtags, by = "tweet_id") 
    }
    if ("ext_urls" %in% vars & !is.null(raw$tweet.entities.urls)) {
      urls <- raw$tweet.entities.urls  # has a row for every URL
      if ("expanded_url" %in% colnames(urls)) { # if applicable, drop twitter-intern URLs (retweets etc.)
        urls <- dplyr::filter(urls, !stringr::str_detect(.data$expanded_url, pattern = "https://twitter.com/"))}  
      urls <- urls %>% 
        dplyr::group_by(.data$tweet_id) %>% 
        dplyr::mutate(ext_urls = if ("url" %in% colnames(.)) list(.data$url) else NA, # used URLs as list per tweet
                      ext_urls_expanded = if ("expanded_url" %in% colnames(.)) list(.data$expanded_url) else NA,
                      ext_urls_unwound = if ("unwound_url" %in% colnames(.)) list(.data$unwound_url) else NA,
                      ext_urls_title = if ("title" %in% colnames(.)) list(.data$title) else NA,
                      ext_urls_description = if ("description" %in% colnames(.)) list(.data$description) else NA) %>% 
        dplyr::ungroup() %>% dplyr::distinct(.data$tweet_id, .keep_all = TRUE) %>% # drop duplicates created through the dplyr::left_join
        dplyr::select(.data$tweet_id, tidyselect::starts_with("ext_urls"))
      res <- dplyr::left_join(res, urls, by = "tweet_id") 
    }
    if ("annotations" %in% vars & !is.null(raw$tweet.entities.annotations)) {
      annotations <- raw$tweet.entities.annotations %>% # has a row for every hashtag
        dplyr::group_by(.data$tweet_id) %>% dplyr::mutate( # used annotations as list per tweet
          annotation_probability = if ("probability" %in% colnames(.)) list(as.numeric(.data$probability)) else NA, 
          annotation_type = if ("type" %in% colnames(.)) list(.data$type) else NA,
          annotation_entity = if ("normalized_text" %in% colnames(.)) list(.data$normalized_text) else NA) %>% 
        dplyr::ungroup() %>% dplyr::distinct(.data$tweet_id, .keep_all = TRUE) %>%  # drop duplicates created through the dplyr::left_join
        dplyr::select(.data$tweet_id, tidyselect::starts_with("annotation"))
      res <- dplyr::left_join(res, annotations, by = "tweet_id") 
    }
    if ("context_annotations" %in% vars & !is.null(raw$tweet.context_annotations)) {
      context_annotations <- raw$tweet.context_annotations %>% 
        dplyr::group_by(.data$tweet_id) %>% dplyr::mutate( # used annotations as list per tweet
          context.domain.id = if ("domain.id" %in% colnames(.)) list(.data$domain.id) else NA,
          context.domain.name = if ("domain.name" %in% colnames(.)) list(.data$domain.name) else NA,
          context.domain.description = if ("domain.description" %in% colnames(.)) list(.data$domain.description) else NA,
          context.entity.id = if ("entity.id" %in% colnames(.)) list(.data$entity.id) else NA,
          context.entity.name = if ("entity.name" %in% colnames(.)) list(.data$entity.name) else NA,
          context.entity.description =  if("entity.description" %in% colnames(.)) list(.data$entity.description) else NA) %>% 
        dplyr::ungroup() %>% dplyr::distinct(.data$tweet_id, .keep_all = TRUE) %>%  # drop duplicates created through the dplyr::left_join
        dplyr::select(.data$tweet_id, tidyselect::starts_with("context"))
      res <- dplyr::left_join(res, context_annotations, by = "tweet_id")
    }
    if ("mentions" %in% vars & !is.null(raw$tweet.entities.mentions)) { 
      mentions <- raw$tweet.entities.mentions %>% #  a row for every mention
        dplyr::group_by(.data$tweet_id) %>%
        dplyr::mutate(mentions_username = if ("username" %in% colnames(.)) list(as.character(.data$username)) else NA,# mentioned usernames as list per tweet
                      mentions_user_id = if ("id" %in% colnames(.)) list(as.character(.data$id)) else NA) %>% # mentioned users' IDs as list per tweet
        dplyr::ungroup() %>% dplyr::distinct(.data$tweet_id, .keep_all = TRUE) %>%  # drop duplicates created through the dplyr::left_join
        dplyr::select(.data$tweet_id, tidyselect::starts_with("mentions"))
      res <- dplyr::left_join(res, mentions, by = "tweet_id")
    }
    if (!is.null(raw$tweet.referenced_tweets)) {
      ref <- raw$tweet.referenced_tweets
      colnames(ref) <- c("tweet_id", "sourcetweet_type", "sourcetweet_id")
      ref <- ref %>% dplyr::filter(.data$sourcetweet_type != "replied_to") 
      res <- dplyr::left_join(res, ref, by = "tweet_id")
      if (nrow(raw$sourcetweet.main) > 0) {
        if ("text" %in% vars) {
        source_main <- dplyr::select(raw$sourcetweet.main, .data$id, .data$text, .data$lang, .data$author_id) %>%
          dplyr::distinct(.data$id, .keep_all = TRUE)
        } else {
          source_main <- dplyr::select(raw$sourcetweet.main, .data$id, .data$author_id) %>%
            dplyr::distinct(.data$id, .keep_all = TRUE)
        }
        colnames(source_main) <- paste0("sourcetweet_", colnames(source_main))
        res <- res %>% dplyr::left_join(source_main, by = "sourcetweet_id") %>% 
          dplyr::mutate(is_retweet = dplyr::case_when( # clear retweet identifier
            .data$sourcetweet_type == "retweeted" ~ TRUE,
            is.na(.data$sourcetweet_type) ~ FALSE,
            TRUE ~ FALSE
          )) %>% 
          dplyr::mutate(is_quote = dplyr::case_when( # clear quote identifier
            .data$sourcetweet_type == "quoted" ~ TRUE,
            is.na(.data$sourcetweet_type) ~ FALSE,
            TRUE ~ FALSE
          )) %>%  
          dplyr::mutate(is_reply = if ("in_reply_to_user_id" %in% colnames(.)) dplyr::case_when( # clear reply identifier (note that replies can also be e.g. quotes, when tweets are quoted in a thread)
            !is.na(.data$in_reply_to_user_id) ~ TRUE,
            is.na(.data$in_reply_to_user_id) ~ FALSE,
          ) else FALSE) %>%  
          dplyr::distinct(.data$tweet_id, .keep_all = TRUE) # make unique explicitly to prevent errors (e.g. duplicated mentions). Will be made unique anyway
        if ("text" %in% vars) {
          res <- res %>% 
            dplyr::mutate(text = dplyr::case_when(  # full length text for RTs, removes RT marker
              .data$sourcetweet_type == "retweeted" ~ .data$sourcetweet_text,
              is.na(.data$sourcetweet_type) ~ .data$text,
              TRUE ~ .data$text))      
          }
        if (any(c("mentions", "ext_urls", "hashtags", "annotations", "context_annotations") %in% vars)) {
          rt <-        # RT and quote entity information. This is incomplete in the tweet.entities for RTs due to truncation and missing for quotes
            raw$sourcetweet.main %>% 
            dplyr::filter(.data$id %in% raw$tweet.referenced_tweets[raw$tweet.referenced_tweets$type != "replied_to", "id"]$id) %>% # get retweets & quotes only
            dplyr::distinct(.data$id, .keep_all = TRUE) # unique tweets only (requires formatting as data.table to be efficient)
        }
        if ("mentions" %in% vars & !is.null(rt$entities$mentions)){
          if ("mentions" %in% colnames(rt$entities)) rt$entities.mentions <- rt$entities$mentions %>% purrr::map(as.data.frame) # this is necessary because empty data is represented as Named list(), causing tidyr::unnest() (and equivalent functions) to fail due to different data formats
            mentions_rt <-
              rt %>% dplyr::select(.data$id, .data$entities.mentions) %>% tidyr::unnest(.data$entities.mentions, names_sep = "_", keep_empty = T) %>%  # ! requires tidyr v1.1.4+ !
              dplyr::group_by(.data$id) %>% 
              dplyr::mutate(mentions_username_source = if ("entities.mentions_username" %in% colnames(.)) list(as.character(.data$entities.mentions_username)) else NA,# mentioned usernames as list per tweet
                            mentions_user_id_source = if ("entities.mentions_id" %in% colnames(.)) list(as.character(.data$entities.mentions_id)) else NA) %>% # mentioned users' IDs as list per tweet
              dplyr::select(.data$id, tidyselect::starts_with("mentions")) %>% # dplyr::select relevant variables
              dplyr::ungroup() %>% dplyr::distinct(.data$id, .keep_all = TRUE) # drop duplicates introduced by tidyr::unnesting
            res <- dplyr::left_join(res, mentions_rt, by = c("sourcetweet_id" = "id")) 
            res <- res %>% dplyr::rowwise() %>% dplyr::mutate(retweet_source_author_name = ifelse(is_retweet == TRUE & "mentions_username" %in% colnames(.data), dplyr::first(.data$mentions_username), NA)) # preserve original RT authors usernames (currently unavailable for quotes, as their authors are not in the @mentions)
            res <- res %>% dplyr::ungroup() %>% .merge_rt_variables()# get correct entities for RTs (separately for every data set, rather than merge in the end, to account for missing variables)
            if (quoted_variables == T) {
              res <- .add_quote_variables(res) # get quote entities if enabled
            }
            res <- res %>% dplyr::select(!tidyselect::ends_with("_source")) # drop _source variables
          }
        if ("ext_urls" %in% vars & !is.null(rt$entities$urls))  { 
          if ("urls" %in% colnames(rt$entities)) rt$entities.urls <- rt$entities$urls %>% purrr::map(as.data.frame)
          urls_rt <- rt %>% dplyr::select(.data$id, .data$entities.urls) %>% tidyr::unnest(.data$entities.urls, names_sep = "_", keep_empty = T)   # ! requires tidyr v1.1.4+ !
          if ("entities.urls_expanded_url" %in% colnames(urls_rt)) { # if applicable drop twitter-intern URLs (retweets etc.)
            urls_rt <- dplyr::filter(urls_rt, !stringr::str_detect(.data$entities.urls_expanded_url, pattern = "https://twitter.com/"))
          }  
          urls_rt <- urls_rt %>%   
            dplyr::group_by(.data$id) %>% 
            dplyr::mutate(ext_urls_source = if ("entities.urls_url" %in% colnames(.)) list(.data$entities.urls_url) else NA, # used URLs as list per tweet
                          ext_urls_expanded_source = if ("entities.urls_expanded_url" %in% colnames(.)) list(.data$entities.urls_expanded_url) else NA,
                          ext_urls_unwound_source = if ("entities.urls_unwound_url" %in% colnames(.)) list(.data$entities.urls_unwound_url) else NA,
                          ext_urls_title_source = if ("entities.urls_title" %in% colnames(.)) list(.data$entities.urls_title) else NA,
                          ext_urls_description_source = if ("entities.urls_description" %in% colnames(.)) list(.data$entities.urls_description) else NA) %>% 
            dplyr::select(.data$id, tidyselect::starts_with("ext_urls")) %>%  # dplyr::select relevant variables
            dplyr::ungroup() %>% dplyr::distinct(.data$id, .keep_all = TRUE) # drop duplicates introduced by tidyr::unnesting
          res <- dplyr::left_join(res, urls_rt, by = c("sourcetweet_id" = "id"))
          res <- .merge_rt_variables(res) # get correct entities for RTs 
          if (quoted_variables == T) {
            res <- .add_quote_variables(res) # get quote entities if enabled
          }
          res <- res %>% dplyr::select(!tidyselect::ends_with("_source")) # drop _source variables
          }
        if ("hashtags" %in% vars & !is.null(rt$entities$hashtags)) {
          if ("hashtags" %in% colnames(rt$entities)) rt$entities.hashtags <- rt$entities$hashtags %>% purrr::map(as.data.frame) 
          hashtags_rt <-
            rt %>% dplyr::select(.data$id, .data$entities.hashtags) %>% tidyr::unnest(.data$entities.hashtags, names_sep = "_", keep_empty = T) %>%  
            dplyr::group_by(.data$id) %>% 
            dplyr::mutate(hashtags_source = if ("entities.hashtags_tag" %in% colnames(.)) list(.data$entities.hashtags_tag) else NA) %>% # hashtags as list per tweet
            dplyr::select(.data$id, .data$hashtags_source) %>% # dplyr::select relevant variables
            dplyr::ungroup() %>% dplyr::distinct(.data$id, .keep_all = TRUE) # drop duplicates introduced by tidyr::unnesting
          res <- dplyr::left_join(res, hashtags_rt, by = c("sourcetweet_id" = "id"))
          res <- .merge_rt_variables(res) # get correct entities for RTs 
          if (quoted_variables == T) {
            res <- .add_quote_variables(res) # get quote entities if enabled
          }
          res <- res %>% dplyr::select(!tidyselect::ends_with("_source")) # drop _source variables
        }
        if ("annotations" %in% vars & !is.null(rt$entities$annotations)) {
          if ("annotations" %in% colnames(rt$entities)) rt$entities.annotations <- rt$entities$annotations %>% purrr::map(as.data.frame)
          annotations_rt <-
            rt %>% dplyr::select(.data$id, .data$entities.annotations) %>% tidyr::unnest(.data$entities.annotations, names_sep = "_", keep_empty = T) %>%  
            dplyr::group_by(.data$id) %>% 
            dplyr::mutate(annotation_probability_source = if ("entities.annotations_probability" %in% colnames(.)) list(as.numeric(.data$entities.annotations_probability)) else NA, # used annotations as list per tweet
                          annotation_type_source = if ("entities.annotations_type" %in% colnames(.)) list(.data$entities.annotations_type) else NA,
                          annotation_entity_source = if ("entities.annotations_normalized_text" %in% colnames(.)) list(.data$entities.annotations_normalized_text) else NA) %>% 
            dplyr::select(.data$id, tidyselect::starts_with("annotation")) %>% # dplyr::select relevant variables
            dplyr::ungroup() %>% dplyr::distinct(.data$id, .keep_all = TRUE) # drop duplicates introduced by tidyr::unnesting
          res <- dplyr::left_join(res, annotations_rt, by = c("sourcetweet_id" = "id"))
          res <- .merge_rt_variables(res) # get correct entities for RTs 
          if (quoted_variables == T) {
            res <- .add_quote_variables(res) # get quote entities if enabled
          }
          res <- res %>% dplyr::select(!tidyselect::ends_with("_source")) # drop _source variables
        }
        if ("context_annotations" %in% vars & !is.null(rt$context_annotations)) {
          if ("context_annotations" %in% colnames(rt)) rt$context_annotations <- rt$context_annotations %>% purrr::map(as.data.frame)
          context_annotations_rt <- 
            rt %>% dplyr::select(.data$id, .data$context_annotations) %>% tidyr::unnest(.data$context_annotations, names_sep = "_", keep_empty = T) %>% 
            dplyr::group_by(.data$id) %>% dplyr::mutate( # used annotations as list per tweet
              context.domain.id_source = if ("id" %in% (.[["context_annotations_domain"]] %>% colnames(.))) list(.data$context_annotations_domain$id) else NA, 
              context.domain.name_source = if ("name" %in% (.[["context_annotations_domain"]] %>% colnames(.))) list(.data$context_annotations_domain$name) else NA,
              context.domain.description_source = if ("description" %in% (.[["context_annotations_domain"]] %>% colnames(.))) list(.data$context_annotations_domain$description) else NA,
              context.entity.id_source = if ("id" %in% (.[["context_annotations_entity"]] %>% colnames(.))) list(.data$context_annotations_entity$id) else NA,
              context.entity.name_source = if ("name" %in% (.[["context_annotations_entity"]] %>% colnames(.))) list(.data$context_annotations_entity$name) else NA,
              context.entity.description_source = if ("description" %in% (.[["context_annotations_entity"]] %>% colnames(.))) list(.data$context_annotations_entity$description) else NA) %>% 
            dplyr::ungroup() %>% dplyr::distinct(.data$id, .keep_all = TRUE) %>%  # drop duplicates created through the dplyr::left_join
            dplyr::select(.data$id, tidyselect::starts_with("context."))
          res <- dplyr::left_join(res, context_annotations_rt, by = c("sourcetweet_id" = "id"))
          res <- .merge_rt_variables(res) # get correct entities for RTs
          if (quoted_variables == T) {
            res <- .add_quote_variables(res) # get quote entities if enabled
          }
          res <- res %>% dplyr::select(!tidyselect::ends_with("_source")) # drop _source variables
        } 
      }
    }
    res <- dplyr::relocate(res, tidyselect::any_of(c("tweet_id", "user_username", "text")))
    return(tibble::as_tibble(res))
  }
}

.flat <- function(data_path, output_format = "tidy", 
                  vars = c("text", "user", "tweet_metrics", "user_metrics", "hashtags", "ext_urls", "mentions", "annotations", "context_annotations"), 
                  quoted_variables = FALSE) {
  if (!output_format %in% c("tidy", "raw", "tidy2")) {
    stop("Unknown format.", call. = FALSE)
  }
  data_files <- ls_files(data_path, "^data_")
  if (output_format == "raw") {
    return(convert_json(data_files, output_format = "raw"))
  }
  return(furrr::future_map_dfr(data_files, convert_json, output_format = output_format, vars = vars, quoted_variables = quoted_variables))
}

.gen_aux_filename <- function(data_filename) {
  ids <- gsub("[^0-9]+", "" , basename(data_filename))
  return(file.path(dirname(data_filename), paste0("users_", ids, ".json")))
}

.gen_raw <- function(df, pkicol = "id", pki_name = "tweet_id") {
  dplyr::select_if(df, is.list) -> df_complex_col
  dplyr::select_if(df, Negate(is.list)) %>% dplyr::rename(pki = tidyselect::all_of(pkicol)) -> main
  ## df_df_col are data.frame with $ in the column, weird things,
  ## need to be transformed into list-columns with .dfcol_to_list below
  df_complex_col %>% dplyr::select_if(is.data.frame) -> df_df_col
  ## "Normal" list-column
  df_complex_col %>% dplyr::select_if(Negate(is.data.frame)) -> df_list_col
  mother_colnames <- colnames(df_df_col)
  df_df_col_list <- dplyr::bind_cols(purrr::map2_dfc(df_df_col, mother_colnames, .dfcol_to_list), df_list_col)
  all_list <- purrr::map(df_df_col_list, .simple_unnest, pki = main$pki)
  ## after first pass above, some columns are still not in 3NF (e.g. context_annotations)
  item_names <- names(all_list)
  all_list <- purrr::map2(all_list, item_names, .second_pass)
  all_list$main <- dplyr::relocate(main, .data$pki)
  all_list <- purrr::map(all_list, .rename_pki, pki_name = pki_name)
  return(all_list)
}

.rename_pki <- function(item, pki_name = "tweet_id") {
  colnames(item)[colnames(item) == "pki"] <- pki_name
  return(item)
}

.second_pass <- function(x, item_name) {
  ## turing test for "data.frame" columns,something like context_annotations
  if (ncol(dplyr::select_if(x, is.data.frame)) != 0) {
    ca_df_col <- dplyr::select(x, -.data$pki)
    ca_mother_colnames <- colnames(ca_df_col)
    return(dplyr::bind_cols(dplyr::select(x, .data$pki), purrr::map2_dfc(ca_df_col, ca_mother_colnames, .dfcol_to_list)))
  }
  ## if (dplyr::summarise_all(x, ~any(purrr::map_lgl(., is.data.frame))) %>% dplyr::rowwise() %>% any()) {
  ##   ca_df_col <- dplyr::select(x, -pki)
  ##   ca_mother_colnames <- colnames(ca_df_col)
  ##   res <- purrr::map(ca_df_col, .simple_unnest, pki = pki)
  ##   names(res) <- paste0(item_name, ".", names(res))
  ##   return(res)
  ## }
  return(x)
}


.dfcol_to_list <- function(x_df, mother_name) {
  tibble::as_tibble(x_df) -> x_df
  x_df_names <- colnames(x_df)
  colnames(x_df) <- paste0(mother_name, ".", x_df_names)
  return(x_df)
}

.simple_unnest <- function(x, pki) {
  if (class(x) == "list" & any(purrr::map_lgl(x, is.data.frame))) {
    tibble::tibble(pki = pki, data = x) %>% dplyr::filter(purrr::map_lgl(.data$data, ~length(.) != 0)) %>% dplyr::group_by(.data$pki) %>% tidyr::unnest(cols = c(.data$data)) %>% dplyr::ungroup() -> res
  } else {
    res <- tibble::tibble(pki = pki, data = x)
  }
  return(res)
}

.merge_rt_variables <- function(x) {
  variables <- dplyr::select(x, tidyselect::ends_with("_source")) %>% colnames(.) %>% stringr::str_extract(".*(?=_source)")
  if (!purrr::is_empty(variables)) {
      for (i in 1:length(variables)) {
        if (as.character(variables[i]) %in% colnames(x)) {
          x <- x %>% dplyr::mutate(!!as.name(variables[i]) := ifelse(.data$is_retweet == F,   
                                                                     !!as.name(variables[i]),          
                                                                     !!as.name(paste0(variables[i],"_source"))))
        }
        if(!(as.character(variables[i]) %in% colnames(x))) {
          x <- x %>% dplyr::mutate(!!as.name(variables[i]) := ifelse(.data$is_retweet == F,   
                                                                     NA,          
                                                                     !!as.name(paste0(variables[i],"_source"))))
        }
      }
  }  
  return(x)
}

.add_quote_variables <- function(x) {
  variables <- dplyr::select(x, tidyselect::ends_with("_source")) %>% colnames(.) %>% stringr::str_extract(".*(?=_source)")
  if (!purrr::is_empty(variables)) {
    for (i in 1:length(variables)) {
        x <- x %>% dplyr::mutate(!!as.name(paste0(variables[i], "_quoted")) := ifelse(.data$is_quote == T,   
                                                                                      !!as.name(paste0(variables[i],"_source")),          
                                                                                      NA))       
    }
  }  
  return(x)
}


