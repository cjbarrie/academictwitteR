convert_3nf <- function(tweets) {
  dplyr::select_if(tweets, is.list) -> tweets_complex_col
  dplyr::select_if(tweets, Negate(is.list)) %>% dplyr::rename(tweet_id = "id") -> tweets_clean
  tweets_complex_col %>% dplyr::select_if(is.data.frame) -> tweets_df_col
  tweets_complex_col %>% dplyr::select_if(Negate(is.data.frame)) -> tweets_list_col
  mother_colnames <- colnames(tweets_df_col)
  tweets_df_col_list <- dplyr::bind_cols(purrr::map2_dfc(tweets_df_col, mother_colnames, .dfcol_to_list), tweets_list_col)
  all_list <- purrr::map(tweets_df_col_list, .simple_unnest, tweet_id = tweets_clean$tweet_id)
  ## context_annotations are troublesome
  if (!is.null(all_list$context_annotations)) {
    ca_df_col <- dplyr::select(all_list$context_annotations, -tweet_id)
    ca_mother_colnames <- colnames(ca_df_col)
    all_list$context_annotations <- dplyr::bind_cols(dplyr::select(all_list$context_annotations, tweet_id), purrr::map2_dfc(ca_df_col, ca_mother_colnames, .dfcol_to_list))
  }
  all_list$main <- dplyr::relocate(tweets_clean, tweet_id, author_id, text, .before = source) 
  return(all_list)
}

.dfcol_to_list <- function(x_df, mother_name, grandmother_name = NA) {
  tibble::as_tibble(x_df) -> x_df
  x_df_names <- colnames(x_df)
  colnames(x_df) <- paste0(mother_name, ".", x_df_names)
  if (!is.na(grandmother_name)) {
    colnames(x_df) <- paste0(grandmother_name, ".", colnames(x_df))
  }
  return(x_df)
}

.simple_unnest <- function(x, tweet_id) {
  if (class(x) == "list" & any(purrr::map_lgl(x, is.data.frame))) {
    tibble::tibble(tweet_id = tweet_id, data = x) %>% dplyr::group_by(tweet_id) %>% tidyr::unnest(cols = c(data)) %>% dplyr::select(-data) %>% dplyr::ungroup() -> res
  } else {
    res <- tibble::tibble(tweet_id = tweet_id, data = x)
  }
  return(res)
}
