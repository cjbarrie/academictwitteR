#' Get tweets from full archive search
#'
#' This function collects tweets containing strings or hashtags 
#' between specified date ranges. Tweet-level data is stored in a data/ path as a series of JSONs beginning "data_"; 
#' User-level data is stored as a series of JSONs beginning "users_". If a filename is supplied, this function will 
#' save the result as a RDS file, otherwise it will return the results as a dataframe. 
#'
#' @param query string or character vector, search query or queries
#' @param start_tweets string, starting date
#' @param end_tweets  string, ending date
#' @param bearer_token string, bearer token
#' @param file string, name of the resulting RDS file
#' @param data_path string, if supplied, fetched data can be saved to the designated path as jsons
#' @param export_query If `TRUE`, queries are exported to data_path
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
#' get_all_tweets("BLM", "2020-01-01T00:00:00Z", "2020-01-05T00:00:00Z", 
#'                bearer_token, data_path = "data/")
#' }
get_all_tweets <-
  function(query,
           start_tweets,
           end_tweets,
           bearer_token,
           file = NULL,
           data_path = NULL,
           export_query = TRUE,
           bind_tweets = TRUE,
           verbose = TRUE, 
           ...) {
    
    # Check if path ending with "/"
    if (!is.null(data_path)){
      if(substr(data_path, nchar(data_path), nchar(data_path)) != "/"){
        data_path <- paste0(data_path,"/")
        }
    }
    
    # Check file storage conditions
    check_data_path(data_path, file, bind_tweets)

    # Build query
    built_query <- build_query(query, ...)
        
    # Create storage direction
    if (!is.null(data_path)){
      create_data_dir(data_path)
      if (isTRUE(export_query)){ # Note export_query is called only if data path is supplied
        # Writing query to file (for resuming)
        filecon <- file(paste0(data_path,"query"))
        writeLines(c(built_query,start_tweets,end_tweets), filecon)
        close(filecon)
      }
    }
    
    # Fetch data
    return(fetch_data(built_query, data_path, file, bind_tweets, start_tweets, end_tweets, bearer_token, verbose))
  }
