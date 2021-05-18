#' Get tweets in particular language
#'
#' This function collects tweets containing strings or hashtags 
#' between specified date ranges filtering by language. Tweet-level data is stored in a data/ 
#' path as a series of JSONs beginning "data_"; User-level data is stored as a series of 
#' JSONs beginning "users_". If a filename is supplied, this function will 
#' save the result as a RDS file, otherwise it will return the results as a dataframe.
#'
#' @param query string or character vector, search query or queries
#' @param lang, string, a single BCP 47 language identifier e.g. "fr"
#' @param start_tweets string, starting date
#' @param end_tweets  string, ending date
#' @param bearer_token string, bearer token
#' @param file string, name of the resulting RDS file
#' @param data_path string, if supplied, fetched data can be saved to the designated path as jsons
#' @param bind_tweets If `TRUE`, tweets captured are bound into a data.frame for assignment
#' @param verbose If `FALSE`, query progress messages are suppressed
#' @param ... arguments will be passed to `build_query()` function. See `?build_query()` for further information.
#' 
#' @return a data.frame
#' @export
#'
#' @examples
#' \dontrun{
#' bearer_token <- "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
#' get_lang_tweets("bonne", lang= "fr", 
#'                 "2021-01-01T00:00:00Z", "2021-01-01T00:10:00Z", 
#'                 bearer_token, data_path = "data/")
#' }
get_lang_tweets <-
  function(query,
           lang,
           start_tweets,
           end_tweets,
           bearer_token,
           file = NULL,
           data_path = NULL,
           bind_tweets = TRUE,
           verbose = TRUE,
           ...) {
    #stop clause for if user sets no place
    if (missing(lang)) {
      stop("language must be specified for get_lang_tweets() function")
    }
    get_all_tweets(query, start_tweets, end_tweets, bearer_token, lang=lang, ...)
  }
