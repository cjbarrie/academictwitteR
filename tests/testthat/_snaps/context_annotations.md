# visual output

    Code
      capture_warnings(x <- get_all_tweets(query = "#commtwitter", start_tweets = "2021-06-01T00:00:00Z",
        end_tweets = "2021-06-05T00:00:00Z", context_annotations = FALSE, verbose = TRUE))
    Output
      query:  #commtwitter 
      Total pages queried: 1 (tweets captured this page: 5).
      This is the last page for #commtwitter : finishing collection.
      [1] "Recommended to specify a data path in order to mitigate data loss when ingesting large amounts of data."                  
      [2] "Tweets will not be stored as JSONs or as a .rds file and will only be available in local memory if assigned to an object."
    Code
      capture_warnings(y <- get_all_tweets(query = "#commtwitter", start_tweets = "2021-06-01T00:00:00Z",
        end_tweets = "2021-06-05T00:00:00Z", context_annotations = TRUE, verbose = TRUE))
    Output
      page_n is limited to 100 due to the restriction imposed by Twitter API
      query:  #commtwitter 
      Total pages queried: 1 (tweets captured this page: 5).
      This is the last page for #commtwitter : finishing collection.
      [1] "Recommended to specify a data path in order to mitigate data loss when ingesting large amounts of data."                  
      [2] "Tweets will not be stored as JSONs or as a .rds file and will only be available in local memory if assigned to an object."
    Code
      capture_warnings(z <- get_all_tweets(query = "#commtwitter", start_tweets = "2021-06-01T00:00:00Z",
        end_tweets = "2021-06-05T00:00:00Z", context_annotations = TRUE, page_n = 99,
        verbose = TRUE))
    Output
      query:  #commtwitter 
      Total pages queried: 1 (tweets captured this page: 5).
      This is the last page for #commtwitter : finishing collection.
      [1] "Recommended to specify a data path in order to mitigate data loss when ingesting large amounts of data."                  
      [2] "Tweets will not be stored as JSONs or as a .rds file and will only be available in local memory if assigned to an object."
    Code
      capture_warnings(x1 <- get_all_tweets(query = "#commtwitter", start_tweets = "2021-06-01T00:00:00Z",
        end_tweets = "2021-06-05T00:00:00Z", context_annotations = FALSE, verbose = FALSE))
    Output
      character(0)
    Code
      capture_warnings(y1 <- get_all_tweets(query = "#commtwitter", start_tweets = "2021-06-01T00:00:00Z",
        end_tweets = "2021-06-05T00:00:00Z", context_annotations = TRUE, verbose = FALSE))
    Output
      character(0)
    Code
      capture_warnings(z1 <- get_all_tweets(query = "#commtwitter", start_tweets = "2021-06-01T00:00:00Z",
        end_tweets = "2021-06-05T00:00:00Z", context_annotations = TRUE, page_n = 99,
        verbose = FALSE))
    Output
      character(0)

