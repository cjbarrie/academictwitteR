make_query <- function(url, params, bearer_token, max_error = 4, verbose = TRUE) {
  bearer_token <- check_bearer(bearer_token)
  count <- 0
  while (TRUE) {
    if (count >= max_error) {
      stop("Too many errors.")
    }
    pre_time <- Sys.time()
    r <- httr::GET(url, httr::add_headers(Authorization = bearer_token), query = params)
    time_diff <- as.numeric(Sys.time() - pre_time)
    if (time_diff < 1) { ## To prevent #231
      Sys.sleep(1)
    }
    status_code <- httr::status_code(r)
    if (!status_code %in% c(200, 429, 503)) {
      stop(paste("something went wrong. Status code:", httr::status_code(r)))
    }
    if (.check_header_rate_limit(r, verbose = verbose)) {
      count <- count + 1
    }
    if (status_code == 200) {
      break()
    }
    if (status_code == 503) {
      count <- count + 1
      Sys.sleep(count * 5)
    }
    if (status_code == 429) {
      .trigger_sleep(r, verbose = verbose)
      count <- count + 1
    }
  }
  jsonlite::fromJSON(httr::content(r, "text"))
}

get_tweets <- function(params, endpoint_url, page_token_name = "next_token", n, file, bearer_token, data_path, export_query, bind_tweets, verbose) {
  
  # Check file storage conditions
  create_storage_dir(data_path = data_path, export_query = export_query, built_query = params[["query"]], start_tweets = params[["start_time"]], end_tweets = params[["end_time"]], verbose = verbose)
  
  # Start Data Collection Loop
  next_token <- ""
  df.all <- data.frame()
  toknum <- 0
  ntweets <- 0
  while (!is.null(next_token)) {
    df <- make_query(url = endpoint_url, params = params, bearer_token = bearer_token, verbose = verbose)
    if (is.null(data_path)) {
      # if data path is null, generate data.frame object within loop
      df.all <- dplyr::bind_rows(df.all, df$data)
    }
    if (!is.null(data_path) & is.null(file) & !bind_tweets) {
      df_to_json(df, data_path)
    }
    if (!is.null(data_path)) {
      df_to_json(df, data_path)
      df.all <- dplyr::bind_rows(df.all, df$data) #and combine new data with old within function
    }
    next_token <- df$meta$next_token #this is NULL if there are no pages left
    if (!is.null(next_token)) {
      params[[page_token_name]] <- next_token
    }
    toknum <- toknum + 1
    if (is.null(df$data)) {
      n_newtweets <- 0
    } else {
      n_newtweets <- nrow(df$data)
    }
    ntweets <- ntweets + n_newtweets
    .vcat(verbose, "Total pages queried: ", toknum, " (tweets captured this page: ", n_newtweets, ").\n",
          sep = ""
    )
    if (ntweets >= n){ # Check n
      df.all <- df.all[1:n,] # remove extra
      .vcat(verbose, "Total tweets captured now reach", n, ": finishing collection.\n")
      break
    }
    if (is.null(next_token)) {
      .vcat(verbose, "This is the last page for", params[["query"]], ": finishing collection.\n")
      break
    }
  }
  
  if (is.null(data_path) & is.null(file)) {
    return(df.all) # return to data.frame
  }
  if (!is.null(file)) {
    saveRDS(df.all, file = file) # save as RDS
    return(df.all) # return data.frame
  }
  
  if (!is.null(data_path) & bind_tweets) {
    return(df.all) # return data.frame
  }
  
  if (!is.null(data_path) &
      is.null(file) & !bind_tweets) {
    .vcat(verbose, "Data stored as JSONs: use bind_tweets function to bundle into data.frame")
  }
}

check_bearer <- function(bearer_token){
  if(missing(bearer_token)){
    stop("bearer token must be specified.")
  }
  if(substr(bearer_token,1,7)=="Bearer "){
    bearer <- bearer_token
  } else{
    bearer <- paste0("Bearer ",bearer_token)
  }
  return(bearer)
}

check_data_path <- function(data_path, file, bind_tweets, verbose = TRUE){
  #warning re data storage recommendations if no data path set
  if (is.null(data_path)) {
    .vwarn(verbose, "Recommended to specify a data path in order to mitigate data loss when ingesting large amounts of data.")
  }
  #warning re data.frame object and necessity of assignment
  if (is.null(data_path) & is.null(file)) {
    .vwarn(verbose, "Tweets will not be stored as JSONs or as a .rds file and will only be available in local memory if assigned to an object.")
  }
  #stop clause for if user sets bind_tweets to FALSE but sets no data path
  if (is.null(data_path) & !bind_tweets) {
    stop("Argument (bind_tweets = FALSE) only valid when a data_path is specified.")
  }
  #warning re binding of tweets when a data path and file path have been set but bind_tweets is set to FALSE
  if (!is.null(data_path) & !is.null(file) & !bind_tweets) {
    .vwarn(verbose, "Tweets will still be bound in local memory to generate .rds file. Argument (bind_tweets = FALSE) only valid when just a data path has been specified.")
  }
  #warning re data storage and memory limits when setting bind_tweets to TRUE 
  if (!is.null(data_path) & is.null(file) & bind_tweets) {
    .vwarn(verbose, "Tweets will be bound in local memory as well as stored as JSONs.")
  }
}

create_data_dir <- function(data_path, verbose = TRUE){
  #create folders for storage
  if (dir.exists(file.path(data_path))) {
    .vwarn(verbose, "Directory already exists. Existing JSON files may be parsed and returned, choose a new path if this is not intended.")
    invisible(data_path)
  }
  dir.create(file.path(data_path), showWarnings = FALSE)
  invisible(data_path)  
}

df_to_json <- function(df, data_path){
  # check input
  # if data path is supplied and file name given, generate data.frame object within loop and JSONs
  jsonlite::write_json(df$data,
                       file.path(data_path, paste0("data_", df$data$id[nrow(df$data)], ".json")))
  jsonlite::write_json(df$includes,
                       file.path(data_path, paste0("users_", df$data$id[nrow(df$data)], ".json")))
}

create_storage_dir <- function(data_path, export_query, built_query, start_tweets, end_tweets, verbose){
  if (!is.null(data_path)){
    create_data_dir(data_path, verbose)
    if (isTRUE(export_query)){ # Note export_query is called only if data path is supplied
      # Writing query to file (for resuming)
      filecon <- file(file.path(data_path, "query"))
      writeLines(c(built_query,start_tweets,end_tweets), filecon)
      close(filecon)
    }
  }
}


.gen_random_dir <- function() {
  file.path(tempdir(), paste0(sample(letters, 20), collapse = ""))
}

.vcat <- function(bool, ...) {
  if (bool) {
    cat(...)
  }
}

.vwarn <- function(bool, ...) {
  if (bool) {
    warning(..., call. = FALSE)
  }
}

.check_reset <- function(r, tzone = "") {
  lubridate::with_tz(lubridate::as_datetime(as.numeric(httr::headers(r)$`x-rate-limit-reset`), tz = tzone), tzone)
}

.trigger_sleep <- function(r, verbose = TRUE, really_sleep = TRUE, ref_time = Sys.time(), tzone = "") {
  reset_time <- .check_reset(r, tzone = tzone)
  ## add 1s as buffer
  sleep_period <- ceiling(as.numeric(reset_time - ref_time, units = "secs")) + 1
  if (sleep_period < 0) {
    ## issue #213
    .vcat(verbose, "Rate limit reached. Cannot estimate adaptive sleep time. Sleeping for 900 seconds. \n")
    sleep_period <- 900
  } else {
    .vcat(verbose, "Rate limit reached. Rate limit will reset at", as.character(reset_time) ,"\nSleeping for", sleep_period ,"seconds. \n")
  }
  if (verbose) {
    pb <- utils::txtProgressBar(min = 0, max = sleep_period, initial = 0)
    for (i in seq_len(sleep_period)) {
      utils::setTxtProgressBar(pb, i)
      if (really_sleep) {
        Sys.sleep(1)
      }
    }
  } else {
    if (really_sleep) {
      Sys.sleep(sleep_period)
    }
  }
  invisible(r)
}

.process_qparam <- function(param, param_str,query) {
  if(!is.null(param)){
    if(isTRUE(param)) {
      query <- paste(query, param_str)
    } else if(param == FALSE) {
      query <- paste(query, paste0("-", param_str))
    }
  }
  return(query)
}

add_query_prefix <- function(x, prefix){
  q <- paste0(prefix, x)
  q <- paste(q, collapse = " OR ")
  q <- paste0("(",q,")")
  return(q)
}

add_context_annotations <- function(params, verbose){
  if(params[["max_results"]] > 100){
    params[["max_results"]] <- 100
    .vcat(verbose, "page_n is limited to 100 due to the restriction imposed by Twitter API\n")
  }
  params[["tweet.fields"]] <- "attachments,author_id,context_annotations,conversation_id,created_at,entities,geo,id,in_reply_to_user_id,lang,public_metrics,possibly_sensitive,referenced_tweets,source,text,withheld"
  params
}


## prophylatic solution to #192
.check_header_rate_limit <- function(r, verbose) {
  if (is.null(httr::headers(r)$`x-rate-limit-remaining`)) {
    return(FALSE)
  }
  if (httr::headers(r)$`x-rate-limit-remaining` == "1") {
    .vwarn(verbose, paste("x-rate-limit-remaining=1. Resets at", .check_reset(r)))
    return(TRUE)
  } else {
    return(FALSE)
  }
}
