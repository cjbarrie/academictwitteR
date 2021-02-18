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

#get tweets
start_tweets = "2010-12-01T00:00:00Z"
end_tweets = "2012-01-01T00:00:00Z"
nextoken <- ""
query <- "#hashtag"

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
  jsonlite::write_json(df$data, paste0("data/", "data_", df$data$id[nrow(df$data)], ".json"))
  jsonlite::write_json(df$includes,
                       paste0("includes/", "includes_", df$data$id[nrow(df$data)], ".json"))
  nextoken <-
    df$meta$next_token #this is NULL if there are no pages left
  cat(query, ": ", "(", nrow(df$data), ") ", "\n", sep = "")
  Sys.sleep(3.1)
  if (is.null(nextoken)) {
    cat("next_token is now NULL for", query, ": finishing collection.")
    break
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

saveRDS(df.all, file = "HTAGTWEETSv2.rds")
