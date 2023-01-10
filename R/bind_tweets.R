#' Bind information stored as JSON files
#'
#' This function binds information stored as JSON files. The experimental function `convert_json` converts individual JSON files into either "raw" or "tidy" format. 
#' 
#' By default, `bind_tweets` binds into a data frame containing tweets (from data_*id*.json files). 
#' 
#' If users is TRUE, it binds into a data frame containing user information (from users_*id*.json). 
#' 
#' For the "tidy" format, parallel processing with furrr is supported. In order to enable parallel processing, workers need to be set manually through [future::plan()]. See examples
#'
#' @param data_path string, file path to directory of stored tweets data saved as data_*id*.json and users_*id*.json
#' @param user If `FALSE`, this function binds JSON files into a data frame containing tweets; data frame containing user information otherwise. Ignore if `output_format` is not NA
#' @param verbose If `FALSE`, messages are suppressed
#' @param output_format
#' `r lifecycle::badge("experimental")` string, if it is not NA, this function return an unprocessed data.frame containing either tweets or user information. Currently, this function supports the following format(s)
#' \itemize{
#'    \item{"raw"}{List of data frames; Note: not all data frames are in Boyce-Codd 3rd Normal Form}
#'    \item{"tidy"}{Tidy format; all essential columns are available}
#' }
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
#' # bind json files in the directory "data" into a "tidy" data frame / tibble with parallel computing
#' ## set up a multisession
#' future::plan("multisession")
#' ## run the function - note that no additional arguments are required
#' bind_tweets(data_path = "data/", user = TRUE, output_format = "tidy")
#' ## Shut down parallel workers
#' future::plan("sequential")
#' }
#' 
bind_tweets <- function(data_path, user = FALSE, verbose = TRUE, output_format = NA) {
  if (!is.na(output_format)) {
    return(.flat(data_path, output_format = output_format))
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
convert_json <- function(data_file, output_format = "tidy") {
  if (!output_format %in% c("tidy", "raw")) {
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
}

.gen_aux_filename <- function(data_filename) {
  ids <- gsub("[^0-9]+", "" , basename(data_filename))
  return(file.path(dirname(data_filename), paste0("users_", ids, ".json")))
}

.flat <- function(data_path, output_format = "tidy") {
  if (!output_format %in% c("tidy", "raw")) {
    stop("Unknown format.", call. = FALSE)
  }
  data_files <- ls_files(data_path, "^data_")
  if (output_format == "raw") {
    return(convert_json(data_files, output_format = "raw"))
  }
  return(furrr::future_map_dfr(data_files, convert_json, output_format = output_format))
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
