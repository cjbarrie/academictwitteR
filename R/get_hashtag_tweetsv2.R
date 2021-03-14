#' Get tweets from user
#' 
#' This function loops through list of users and collects tweets between specified date ranges. Tweet-level data is stored in a data/ path as a series of JSONS; User-level data is stored in a includes/ path as a series of JSONS. If a filename is supplied, this function will save the result as a RDS file, otherwise, it will return the results as a dataframe.
#'
#' @param query string, search query, use "+" to separate query terms.
#' @param start_tweets string, starting date
#' @param end_tweets  string, ending date
#' @param bearer_token string, bearer token
#' @param file string, name of the resulting RDS file. Will return a dataframe if not supplied
#' @param data_path string, if supplied, fetched data will be saved to the designated path as jsons
#'
#' @return a data frame
#' @export
#'
#' @examples
#' \dontrun{
#' bearer_token <- "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
#' get_hashtag_tweets("#BLM", "2020-01-01T00:00:00Z", "2020-01-05T00:00:00Z", bearer_token, data_path = "data/")
#' }
get_hashtag_tweets <- function(query, start_tweets, end_tweets, bearer_token, file = NULL, data_path = NULL){
  #create folders for storage
  ifelse(!dir.exists(file.path(data_path)),
         dir.create(file.path(data_path), showWarnings = FALSE),
         warning("Directory already exists. Existing JSON files will be parsed and returned, choose a new path if this is not intended.", call. = FALSE, immediate. = TRUE))

  nextoken <- ""
  df.all <- data.frame()
  
  while (!is.null(nextoken)) {
    df <-
      get_tweets(
        q = query ,
        n = 500,
        start_time = start_tweets,
        end_time = end_tweets,
        token = bearer_token,
        next_token = nextoken
      )
    if(is.null(data_path)){ # if data path is null, combine new data with old data within function
      df.all <- dplyr::bind_rows(df.all, df$data)} 
    else { # if data path is supplied, save to path
        jsonlite::write_json(df$data, paste0(data_path, "data_", df$data$id[nrow(df$data)], ".json"))
        jsonlite::write_json(df$includes,
                             paste0(data_path, "users_", df$data$id[nrow(df$data)], ".json"))
      } 
    
    nextoken <-
      df$meta$next_token #this is NULL if there are no pages left
    cat(query, ": ", "(", nrow(df$data), ") ", "\n", sep = "")
    Sys.sleep(3.1)
    if (is.null(nextoken)) {
      cat("next_token is now NULL for", query, ": finishing collection.")
      break
    }
  }
  
  
  if(is.null(data_path)){ # if data path is null
      if(!is.null(file)){ # and if file name is supplied
        saveRDS(df.all, file = file) # save as RDS
      } else { # if file name is not supplied
        return(df.all) # return to data frame
      }
    } else { # if data path is supplied
      # parse and bind
      files <-
        list.files(
          path = file.path(data_path),
          pattern = "^data_",
          recursive = T,
          include.dirs = T
        )
      files <- paste(data_path, files, sep = "")
      
      pb = utils::txtProgressBar(min = 0,
                                 max = length(files),
                                 initial = 0)
      
      json.df.all <- data.frame()
      for (i in seq_along(files)) {
        filename = files[[i]]
        json.df <- jsonlite::read_json(filename, simplifyVector = TRUE)
        json.df.all <- dplyr::bind_rows(json.df.all, json.df)
        utils::setTxtProgressBar(pb, i)
      }
      
      if(!is.null(file)){ # and if file name is supplied
        saveRDS(json.df.all, file = file) # save as RDS
      } else { # if file name is not supplied
        return(json.df.all) # return to data frame
      }
    }
}
