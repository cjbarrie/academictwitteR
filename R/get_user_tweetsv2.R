#' Get tweets from user
#'
#' This function collects tweets of a user or set of users between specified date ranges. 
#' Tweet-level data is stored in a data/ path as a series of JSONs beginning "data_"; User-level 
#' data is stored as a series of JSONs beginning "users_". If a filename is supplied, this 
#' function will save the result as a RDS file, otherwise it will return the results as a dataframe.
#'
#' @param users character vector, user handles from which to collect data
#' @param start_tweets string, starting date
#' @param end_tweets  string, ending date
#' @param bearer_token string, bearer token
#' @param file string, name of the resulting RDS file
#' @param data_path string, if supplied, fetched data can be saved to the designated path as jsons
#' @param bind_tweets If `TRUE`, tweets captured are bound into a data.frame for assignment
#' @param verbose If `FALSE`, query progress messages are suppressed
#'
#' @return a data frame
#' @export
#'
#' @examples
#' \dontrun{
#' bearer_token <- "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
#' users <- c("uoessps", "spsgradschool")
#' get_user_tweets(users, "2020-01-01T00:00:00Z", "2020-01-05T00:00:00Z", 
#'                 bearer_token, data_path = "data/")
#' }
get_user_tweets <-
  function(users,
           start_tweets,
           end_tweets,
           bearer_token,
           file = NULL,
           data_path = NULL,
           bind_tweets = TRUE,
           verbose = TRUE) {
    #warning re data storage recommendations if no data path set
    if (is.null(data_path)) {
      warning(
        "Recommended to specify a data path in order to mitigate data loss when ingesting large amounts of data.",
        call. = FALSE,
        immediate. = TRUE
      )
    }
    #warning re data.frame object and necessity of assignment
    if (is.null(data_path) & is.null(file)) {
      warning(
        "Tweets will not be stored as JSONs or as a .rds file and will only be available in local memory if assigned to an object.",
        call. = FALSE,
        immediate. = TRUE
      )
    }
    #stop clause for if user sets bind_tweets to FALSE but sets no data path
    if (is.null(data_path) & bind_tweets == F) {
      stop("Argument (bind_tweets = F) only valid when a data_path is specified.")
    }
    #warning re binding of tweets when a data path and file path have been set but bind_tweets is set to FALSE
    if (!is.null(data_path) & !is.null(file) & bind_tweets == F) {
      warning(
        "Tweets will still be bound in local memory to generate .rds file. Argument (bind_tweets = F) only valid when just a data path has been specified.",
        call. = FALSE,
        immediate. = TRUE
      )
    }
    #warning re data storage and memory limits when setting bind_tweets to TRUE
    if (!is.null(data_path) & is.null(file) & bind_tweets == T) {
      warning(
        "Tweets will be bound in local memory as well as stored as JSONs.",
        call. = FALSE,
        immediate. = TRUE
      )
    }
    #create folders for storage
    ifelse(!dir.exists(file.path(data_path)),
           dir.create(file.path(data_path), showWarnings = FALSE),
           warning(
             "Directory already exists. Existing JSON files may be parsed and returned, choose a new path if this is not intended.",
             call. = FALSE,
             immediate. = TRUE
           ))
    
    nextoken <- ""
    i <- 1
    df.all <- data.frame()
    toknum <- 0
    ntweets <- 0
    
    while (!is.null(nextoken)) {
      query <- paste0('from:', users[[i]])
      userhandle <- users[[i]]
      df <-
        get_tweets(
          q = query ,
          n = 500,
          start_time = start_tweets,
          end_time = end_tweets,
          token = bearer_token,
          next_token = nextoken
        )
      if (is.null(data_path)) {
        # if data path is null, generate data.frame object within loop
        df.all <- dplyr::bind_rows(df.all, df$data)
      }
      if (!is.null(data_path) & is.null(file) & bind_tweets == F) {
        # if only data path is supplied and bind_tweets is set to FALSE, generate only JSON files in data path folder
        jsonlite::write_json(df$data,
                             paste0(data_path, "data_", df$data$id[nrow(df$data)], ".json"))
        jsonlite::write_json(df$includes,
                             paste0(data_path, "users_", df$data$id[nrow(df$data)], ".json"))
      }
      if (!is.null(data_path)) {
        # if data path is supplied and file name given, generate data.frame object within loop and JSONs
        jsonlite::write_json(df$data,
                             paste0(data_path, "data_", df$data$id[nrow(df$data)], ".json"))
        jsonlite::write_json(df$includes,
                             paste0(data_path, "users_", df$data$id[nrow(df$data)], ".json"))
        df.all <-
          dplyr::bind_rows(df.all, df$data) #and combine new data with old within function
      }
      
      nextoken <-
        df$meta$next_token #this is NULL if there are no pages left
      if (verbose) {
        toknum <- toknum + 1
        ntweets <- ntweets + nrow(df$data)
        cat(
          "query: <",
          query,
          ">: ",
          "(tweets captured this page: ",
          nrow(df$data),
          "). Total pages queried: ",
          toknum,
          ". Total tweets ingested: ",
          ntweets,
          ". \n",
          sep = ""
        )
      }
      Sys.sleep(3.1)
      if (is.null(nextoken)) {
        if (verbose) {
          cat("next_token is now NULL for",
              userhandle,
              " moving to next account \n")
        }
        nextoken <- ""
        i = i + 1
        if (i > length(users)) {
          cat("No more accounts to capture")
          break
        }
      }
    }
    
    if (is.null(data_path) & is.null(file)) {
      return(df.all) # return to data.frame
    }
    if (!is.null(file)) {
      saveRDS(df.all, file = paste0(file, ".rds")) # save as RDS
      return(df.all) # return data.frame
    }
    if (!is.null(data_path) &
        is.null(file) & bind_tweets == F) {
      cat("Data stored as JSONs: use bind_tweets_json function to bundle into data.frame")
    }
  }