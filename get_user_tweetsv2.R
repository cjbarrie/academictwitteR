library(httr)
library(tidyverse)
library(jsonlite)

#create folders for storage
ifelse(!dir.exists(file.path("data/")),
       dir.create(file.path("data/"), showWarnings = FALSE),
       FALSE)
ifelse(!dir.exists(file.path("includes/")),
       dir.create(file.path("includes/"), showWarnings = FALSE),
       FALSE)

#store bearer token for Academic product track v2
bearer_token = "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"

#get tweets v2 functions
source("funs/get_tweets.R")

##get handles
users <- c("user1", "user2", "user3")

#get tweets
start_tweets = "2017-01-01T00:00:00Z"
end_tweets = "2020-01-01T00:00:00Z"
nextoken <- ""
i <- 1

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
  jsonlite::write_json(df$data,
                       paste0("data/", "data_", userhandle, df$data$id[nrow(df$data)], ".json"))
  jsonlite::write_json(df$includes,
                       paste0("includes/", "includes_", userhandle, df$data$id[nrow(df$data)], ".json"))
  nextoken <-
    df$meta$next_token #this is NULL if there are no pages left
  cat(query, ": ", "(", nrow(df$data), ") ", "\n", sep = "")
  Sys.sleep(3.1) #sleep between calls to avoid rate limiting
  if (is.null(nextoken)) {
    cat("next_token is now NULL for",
        userhandle,
        " moving to next account \n")
    nextoken <- ""
    i = i + 1
    if (i > length(users)) {
      cat("No more accounts to capture")
      break
    }
  }
}

#parse and bind
files <-
  list.files(
    path = file.path("data/"),
    recursive = T,
    include.dirs = T
  )
files <- paste("data/", files, sep = "")

pb = txtProgressBar(min = 0,
                    max = length(files),
                    initial = 0)

df.all <- data.frame()
for (i in seq_along(files)) {
  filename = files[[i]]
  df <- read_json(filename, simplifyVector = TRUE)
  df.all <- bind_rows(df.all, df)
  setTxtProgressBar(pb, i)
}

saveRDS(df.all, file = "USERTWEETSv2.rds")
