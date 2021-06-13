#' Bind user information stored as JSON files
#' `r lifecycle::badge("deprecated")
#'
#' @param data_path string, file path to directory of stored tweets data saved as users_*id*.json
#' @param verbose If `FALSE`, messages are suppressed
#' @return a data.frame
#' @keywords internal
#' @export
#'
#' @examples
#' \dontrun{
#' bind_user_jsons("data_path = "data/"")
#' }
bind_user_jsons <- function(data_path, verbose = TRUE) {
  lifecycle::deprecate_soft("0.2.0", "bind_user_jsons()", details = "Please use `bind_tweets(user = TRUE)` instead")
  bind_tweets(data_path = data_path, user = TRUE, verbose = verbose)
}

#' Bind tweets stored as JSON files
#' `r lifecycle::badge("deprecated")
#'
#' @param data_path string, file path to directory of stored tweets data saved as data_*id*.json
#' @param verbose If `FALSE`, messages are suppressed
#' @return a data.frame
#' @keywords internal
#' @export
#'
#' @examples
#' \dontrun{
#' bind_tweet_jsons(data_path = "data/")
#' }
bind_tweet_jsons <- function(data_path, verbose = TRUE) {
  lifecycle::deprecate_soft("0.2.0", "bind_user_jsons()", "bind_tweets()")
  bind_tweets(data_path = data_path, user = FALSE, verbose = verbose)
}

#' Get retweets of user
#' `r lifecycle::badge("deprecated")
#'
#' This function collects retweets of tweets by a user or set of users between specified date ranges.
#' Tweet-level data is stored in a data/ path as a series of JSONs beginning "data_"; User-level data is stored as
#' a series of JSONs beginning "users_". If a filename is supplied, this function will save the result as a RDS file,
#' otherwise it will return the results as a dataframe.
#'
#' @inheritParams get_all_tweets
#' @param users character vector, user handles from which to collect data
#'
#' @return a data frame
#' @keywords internal
#' @export
#'
#' @examples
#' \dontrun{
#' bearer_token <- "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
#' users <- c("cbarrie", "justin_ct_ho")
#' get_retweets_of_user(users, "2020-01-01T00:00:00Z", "2020-04-05T00:00:00Z",
#'                      bearer_token, data_path = "data/")
#' }
get_retweets_of_user <-
  function(users,
           start_tweets,
           end_tweets,
           bearer_token = get_bearer(),
           n = 100,
           file = NULL,
           data_path = NULL,
           bind_tweets = TRUE,
           verbose = TRUE,
           ...) {
    query <- add_query_prefix(users, "retweets_of:")
    lifecycle::deprecate_soft("0.2.0", "get_retweets_of_user()", details =  "Please use `get_all_tweets(retweets_of = users)` instead.")
    get_all_tweets(query = query, start_tweets = start_tweets, end_tweets = end_tweets, bearer_token = bearer_token, n = n, file = file, data_path = data_path, bind_tweets = bind_tweets, verbose = verbose, ...)
  }

#' Get tweets to users
#' `r lifecycle::badge("deprecated")
#' 
#' This function collects tweets between specified date ranges that are
#' in reply to the specified user(s). Tweet-level data is stored in a data/ path as a series of JSONs beginning
#' "data_"; User-level data is stored as a series of JSONs beginning "users_". If a filename is supplied,
#' this function will save the result as a RDS file, otherwise it will return the results as a dataframe.
#'
#' @param users character vector, user handles from which to collect data
#' @inheritParams get_all_tweets
#'
#' @return a data frame
#' @keywords internal
#' @export
#'
#' @examples
#' \dontrun{
#' bearer_token <- "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
#' users <- c("uoessps", "spsgradschool")
#' get_to_tweets(users, "2020-01-01T00:00:00Z", "2020-01-05T00:00:00Z",
#'              bearer_token, data_path = "data/")
#' }
get_to_tweets <-
  function(users,
           start_tweets,
           end_tweets,
           bearer_token = get_bearer(),
           n = 100,
           file = NULL,
           data_path = NULL,
           bind_tweets = TRUE,
           verbose = TRUE,
           ...) {
    query <- add_query_prefix(users, "to:")
    lifecycle::deprecate_soft("0.2.0", "get_to_tweets()", details = "Please use `get_all_tweets(reply_to = users)` instead.")
    get_all_tweets(query = query, start_tweets = start_tweets, end_tweets = end_tweets, bearer_token = bearer_token, n = n, file = file, data_path = data_path, bind_tweets = bind_tweets, verbose = verbose,...)
  }


#' Get tweets from user
#' `r lifecycle::badge("deprecated")
#'  
#' This function collects tweets of a user or set of users between specified date ranges.
#' Tweet-level data is stored in a data/ path as a series of JSONs beginning "data_"; User-level
#' data is stored as a series of JSONs beginning "users_". If a filename is supplied, this
#' function will save the result as a RDS file, otherwise it will return the results as a dataframe.
#'
#' @param users character vector, user handles from which to collect data
#' @inheritParams get_all_tweets
#'
#' @return a data frame
#' @keywords internal
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
           bearer_token = get_bearer(),
           n = 100,
           file = NULL,
           data_path = NULL,
           bind_tweets = TRUE,
           verbose = TRUE,
           ...) {
    query <- add_query_prefix(users, "from:")
    lifecycle::deprecate_soft("0.2.0", "get_user_tweets()", details = "Please use `get_all_tweets(users = users) instead.`")
    get_all_tweets(query = query, start_tweets = start_tweets, end_tweets = end_tweets, bearer_token = bearer_token, n = n, file = file, data_path = data_path, bind_tweets = bind_tweets, verbose = verbose,...)
  }

#' Get tweets for query containing videos
#' `r lifecycle::badge("deprecated")
#'
#' This function collects tweets containing strings or hashtags between specified date ranges
#' that also contain native Twitter videos, uploaded directly to Twitter. This will not match
#' on videos created with Periscope, or Tweets with links to other video hosting sites. Tweet-level
#' data is stored in a data/ path as a series of JSONs beginning "data_"; User-level data is stored
#' as a series of JSONs beginning "users_". If a filename is supplied, this function will save the
#' result as a RDS file, otherwise it will return the results as a dataframe.
#'
#' @inheritParams get_all_tweets
#' @return a data frame
#' @keywords internal
#' @export
#'
#' @examples
#' \dontrun{
#' bearer_token <- "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
#' get_video_tweets("#BLM", "2020-01-01T00:00:00Z", "2020-01-05T00:00:00Z",
#'                   bearer_token, data_path = "data/")
#' }
get_video_tweets <-
  function(query,
           start_tweets,
           end_tweets,
           bearer_token = get_bearer(),
           n = 100,
           file = NULL,
           data_path = NULL,
           bind_tweets = TRUE,
           verbose = TRUE,
           ...) {
    lifecycle::deprecate_soft("0.2.0", "get_video_tweets()", details = "Please use `get_all_tweets(has_videos = TRUE)` instead.")
    get_all_tweets(query = query, start_tweets = start_tweets, end_tweets = end_tweets, bearer_token = bearer_token, n = n, file = file, data_path = data_path, bind_tweets = bind_tweets, verbose = verbose, has_videos = TRUE,...)
  }

#' Get tweets within radius buffer
#' `r lifecycle::badge("deprecated")
#'
#' This function collects tweets containing strings or hashtags
#' between specified date ranges filtering by radius buffer. Tweet-level data is stored in a data/
#' path as a series of JSONs beginning "data_"; User-level data is stored as a series of
#' JSONs beginning "users_". If a filename is supplied, this function will
#' save the result as a RDS file, otherwise it will return the results as a data.frame.
#' Note: radius must be less than 25mi.
#'
#' @param radius numeric, a vector of two point coordinates latitude, longitude, and point radius distance (in miles)
#' @inheritParams get_all_tweets
#' @return a data.frame
#' @keywords internal
#' @export
#'
#' @examples
#' \dontrun{
#' bearer_token <- "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
#' tweets <- get_radius_tweets("happy", radius = c(-0.131969125179604,51.50847878040284, 25),
#'                            start_tweets = "2021-01-01T00:00:00Z",
#'                            end_tweets = "2021-01-01T10:00:00Z",
#'                            bearer_token = bearer_token, data_path = "data/")
#' }
get_radius_tweets <-
  function(query,
           radius,
           start_tweets,
           end_tweets,
           bearer_token = get_bearer(),
           n = 100,
           file = NULL,
           data_path = NULL,
           bind_tweets = TRUE,
           verbose = TRUE,
           ...) {
    #stop clause for if user sets no place
    if (missing(radius)) {
      stop("radius must be specified for get_radius_tweets() function")
    }
    lifecycle::deprecate_soft("0.2.0", "get_radius_tweets()", details = "Please use `get_all_tweets(point_radius = radius)` instead.")
    get_all_tweets(query = query, start_tweets = start_tweets, end_tweets = end_tweets, bearer_token = bearer_token, n = n, file = file, data_path = data_path, bind_tweets = bind_tweets, verbose = verbose, point_radius = radius, ...)
  }

#' Get tweets within bounding box
#' `r lifecycle::badge("deprecated")
#'
#' This function collects tweets containing strings or hashtags
#' between specified date ranges filtering by bounding box. Tweet-level data is stored in a data/
#' path as a series of JSONs beginning "data_"; User-level data is stored as a series of
#' JSONs beginning "users_". If a filename is supplied, this function will
#' save the result as a RDS file, otherwise it will return the results as a dataframe.
#' Note: width and height of the bounding box must be less than 25mi.
#'
#' @param bbox numeric, a vector of four bounding box coordinates from west longitude to north latitude
#' @inheritParams get_all_tweets
#' @return a data.frame
#' @keywords internal
#' @export
#'
#' @examples
#' \dontrun{
#' bearer_token <- "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
#' tweets <- get_bbox_tweets("happy", bbox= c(-0.222473,51.442453,0.072784,51.568534),
#'                            "2021-01-01T00:00:00Z", "2021-02-01T10:00:00Z",
#'                            bearer_token, data_path = "data/")
#' }
get_bbox_tweets <-
  function(query,
           bbox,
           start_tweets,
           end_tweets,
           bearer_token = get_bearer(),
           n = 100,
           file = NULL,
           data_path = NULL,
           bind_tweets = TRUE,
           verbose = TRUE,
           ...) {
    #stop clause for if user sets no place
    if (missing(bbox)) {
      stop("bbox coordinates must be specified for get_bbox_tweets() function")
    }
    lifecycle::deprecate_soft("0.2.0", "get_bbox_tweets()", details = "Please use `get_all_tweets(bbox = bbox)` instead.")
    get_all_tweets(query = query, start_tweets = start_tweets, end_tweets = end_tweets, bearer_token = bearer_token, n = n, file = file, data_path = data_path, bind_tweets = bind_tweets, verbose = verbose, bbox = bbox, ...)
  }

#' Get tweets for query containing mentions of another user
#' `r lifecycle::badge("deprecated")
#'
#' This function collects tweets containing strings or
#' hashtags between specified date ranges that also contain mentions of another Twitter user. Tweet-level data
#' is stored in a data/ path as a series of JSONs beginning "data_"; User-level data is stored as a series of
#' JSONs beginning "users_". If a filename is supplied, this function will save the result as a RDS file, otherwise,
#' it will return the results as a dataframe.
#'
#' @inheritParams get_all_tweets
#' @return a data frame
#' @keywords internal
#' @export
#'
#' @examples
#' \dontrun{
#' bearer_token <- "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
#' get_mentions_tweets("#nowplaying", "2020-01-01T00:00:00Z", "2020-01-05T00:00:00Z",
#'                     bearer_token, data_path = "data/")
#' }
get_mentions_tweets <-
  function(query,
           start_tweets,
           end_tweets,
           bearer_token = get_bearer(),
           n = 100,
           file = NULL,
           data_path = NULL,
           bind_tweets = TRUE,
           verbose = TRUE,
           ...) {
    lifecycle::deprecate_soft("0.2.0", "get_mentions_tweets()", details = "Please use `get_all_tweets(has_mentions = TRUE)` instead.")
    get_all_tweets(query = query, start_tweets = start_tweets, end_tweets = end_tweets, bearer_token = bearer_token, n = n, file = file, data_path = data_path, bind_tweets = bind_tweets, verbose = verbose, has_mentions = TRUE, ...)
  }

#' Get tweets in particular language
#' `r lifecycle::badge("deprecated")
#'
#' This function collects tweets containing strings or hashtags
#' between specified date ranges filtering by language. Tweet-level data is stored in a data/
#' path as a series of JSONs beginning "data_"; User-level data is stored as a series of
#' JSONs beginning "users_". If a filename is supplied, this function will
#' save the result as a RDS file, otherwise it will return the results as a dataframe.
#'
#' @param lang, string, a single BCP 47 language identifier e.g. "fr"
#' @inheritParams get_all_tweets
#' @return a data.frame
#' @keywords internal
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
           bearer_token = get_bearer(),
           n = 100,
           file = NULL,
           data_path = NULL,
           bind_tweets = TRUE,
           verbose = TRUE,
           ...) {
    #stop clause for if user sets no place
    if (missing(lang)) {
      stop("language must be specified for get_lang_tweets() function")
    }
    lifecycle::deprecate_soft("0.2.0", "get_lang_tweets()", details = "Please use `get_all_tweets(lang = lang)` instead.")
    get_all_tweets(query = query, start_tweets = start_tweets, end_tweets = end_tweets, bearer_token = bearer_token, n = n, file = file, data_path = data_path, bind_tweets = bind_tweets, verbose = verbose, lang = lang, ...)
  }

#' Get tweets with country parameter
#' `r lifecycle::badge("deprecated")
#'
#' This function collects tweets containing strings or hashtags
#' between specified date ranges filtering by country. Tweet-level data is stored in a data/
#' path as a series of JSONs beginning "data_"; User-level data is stored as a series of
#' JSONs beginning "users_". If a filename is supplied, this function will
#' save the result as a RDS file, otherwise it will return the results as a data.frame.
#'
#' @param country, string, name of country as ISO alpha-2 code e.g. "GB"
#' @inheritParams get_all_tweets
#' @return a data.frame
#' @keywords internal
#' @export
#'
#' @examples
#' \dontrun{
#' bearer_token <- "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
#' get_country_tweets("happy", country = "GB",
#'                    "2021-01-01T00:00:00Z", "2021-01-01T00:10:00Z",
#'                    bearer_token, data_path = "data/")
#' }
get_country_tweets <-
  function(query,
           country,
           start_tweets,
           end_tweets,
           bearer_token = get_bearer(),
           n = 100,
           file = NULL,
           data_path = NULL,
           bind_tweets = TRUE,
           verbose = TRUE,
           ...) {
    #stop clause for if user sets no place
    if (missing(country)) {
      stop("country must be specified for get_country_tweets() function")
    }
    lifecycle::deprecate_soft("0.2.0", "get_country_tweets()", details = "Please use `get_all_tweets(country = country)` instead.")
    get_all_tweets(query = query, start_tweets = start_tweets, end_tweets = end_tweets, bearer_token = bearer_token, n = n, file = file, data_path = data_path, bind_tweets = bind_tweets, verbose = verbose, country = country, ...)
  }

#' Get tweets with place parameter
#' `r lifecycle::badge("deprecated")
#'
#' This function collects tweets containing strings or hashtags
#' between specified date ranges filtering by place. Tweet-level data is stored in a data/
#' path as a series of JSONs beginning "data_"; User-level data is stored as a series of
#' JSONs beginning "users_". If a filename is supplied, this function will
#' save the result as a RDS file, otherwise, it will return the results as a data.frame.
#'
#' @param place, string, name of place e.g. "new york city"
#' @inheritParams get_all_tweets
#' @return a data.frame
#' @keywords internal
#' @export
#'
#' @examples
#' \dontrun{
#' bearer_token <- "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
#' get_place_tweets("happy", place = "London",
#'                  "2021-01-01T00:00:00Z", "2021-01-01T00:10:00Z",
#'                  bearer_token, data_path = "data/")
#' }
get_place_tweets <-
  function(query,
           place,
           start_tweets,
           end_tweets,
           bearer_token = get_bearer(),
           n = 100,
           file = NULL,
           data_path = NULL,
           bind_tweets = TRUE,
           verbose = TRUE,
           ...) {
    #stop clause for if user sets no place
    if (missing(place)) {
      stop("place must be specified for get_place_tweets() function")
    }
    lifecycle::deprecate_soft("0.2.0", "get_place_tweets()", details = "Please use `get_all_tweets(place = place)` instead.")
    get_all_tweets(query = query, start_tweets = start_tweets, end_tweets = end_tweets, bearer_token = bearer_token, n = n, file = file, data_path = data_path, bind_tweets = bind_tweets, verbose = verbose, place = place, ...)
  }

#' Get tweets containing images
#' `r lifecycle::badge("deprecated")
#'
#' This function collects tweets containing strings or
#' hashtags between specified date ranges that also contain (a recognized URL to) an image. Tweet-level data
#' is stored in a data/ path as a series of JSONs beginning "data_"; User-level data is stored as a series
#' of JSONs beginning "users_". If a filename is supplied, this function will save the result as a RDS file,
#' otherwise it will return the results as a dataframe.
#'
#' @inheritParams get_all_tweets
#' @return a data.frame
#' @keywords internal
#' @export
#'
#' @examples
#' \dontrun{
#' bearer_token <- "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
#' get_image_tweets("#BLM", "2020-01-01T00:00:00Z", "2020-01-05T00:00:00Z",
#'                  bearer_token, data_path = "data/")
#' }
get_image_tweets <-
  function(query,
           start_tweets,
           end_tweets,
           bearer_token = get_bearer(),
           n = 100,
           file = NULL,
           data_path = NULL,
           bind_tweets = TRUE,
           verbose = TRUE,
           ...) {
    lifecycle::deprecate_soft("0.2.0", "get_image_tweets()", details = "Please use `get_all_tweets(has_images = TRUE)` instead.")
    get_all_tweets(query = query, start_tweets = start_tweets, end_tweets = end_tweets, bearer_token = bearer_token, n = n, file = file, data_path = data_path, bind_tweets = bind_tweets, verbose = verbose, has_images = TRUE,...)
  }

#' Get tweets for query containing media
#' `r lifecycle::badge("deprecated")
#'
#' This function collects tweets containing the strings or hashtags between specified date ranges
#' that also contain a media object, such as a photo, GIF, or video, as determined by Twitter. Tweet-level
#' data is stored in a data/ path as a series of JSONs beginning "data_"; User-level data is stored as a
#' series of JSONs beginning "users_". If a filename is supplied, this function will save the result
#' as a RDS file, otherwise it will return the results as a dataframe.
#'
#' @inheritParams get_all_tweets
#' @return a data.frame
#' @keywords internal
#' @export
#'
#' @examples
#' \dontrun{
#' bearer_token <- "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
#' get_media_tweets("#BLM", "2020-01-01T00:00:00Z", "2020-01-05T00:00:00Z",
#'                  bearer_token, data_path = "data/")
#' }
get_media_tweets <-
  function(query,
           start_tweets,
           end_tweets,
           bearer_token = get_bearer(),
           n = 100,
           file = NULL,
           data_path = NULL,
           bind_tweets = TRUE,
           verbose = TRUE,
           ...) {
    lifecycle::deprecate_soft("0.2.0", "get_media_tweets()", details = "Please use `get_all_tweets(has_media = TRUE)` instead.")
    get_all_tweets(query = query, start_tweets = start_tweets, end_tweets = end_tweets, bearer_token = bearer_token, n = n, file = file, data_path = data_path, bind_tweets = bind_tweets, verbose = verbose, has_media = TRUE,...)
  }


#' Get tweets containing URL
#' `r lifecycle::badge("deprecated")
#' 
#' This function collects tweets containing a given url between specified date ranges.
#' Tweet-level data is stored in a data/ path as a series of JSONs beginning "data_"; User-level data is stored as a series of
#' JSONs beginning "users_". If a filename is supplied, this function will save the result as a RDS file, otherwise
#' it will return the results as a dataframe.
#'
#' @param query string, url
#' @inheritParams get_all_tweets
#' @return a data.frame
#' @keywords internal
#' @export
#'
#' @examples
#' \dontrun{
#' bearer_token <- "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
#' tweets <- get_url_tweets("https://www.theguardian.com/",
#' "2020-01-01T00:00:00Z", "2020-04-04T00:00:00Z", bearer_token, data_path = "data/")
#' }
get_url_tweets <-
  function(query,
           start_tweets,
           end_tweets,
           bearer_token = get_bearer(),
           n = 100,
           file = NULL,
           data_path = NULL,
           bind_tweets = TRUE,
           verbose = TRUE,
           ...) {
    query <- add_query_prefix(query, "url:")
    lifecycle::deprecate_soft("0.2.0", "get_url_tweets()", details = "Please use `get_all_tweets(url = url)` instead.")
    get_all_tweets(query = query, start_tweets = start_tweets, end_tweets = end_tweets, bearer_token = bearer_token, n = n, file = file, data_path = data_path, bind_tweets = bind_tweets, verbose = verbose,...)
  }

#' Get tweets for query containing geo information
#' `r lifecycle::badge("deprecated")
#' 
#' This function collects tweets containing strings or 
#' hashtags between specified date ranges that also contain Tweet-specific geolocation data provided by the 
#' Twitter user. This can be either a location in the form of a Twitter place, with the corresponding display 
#' name, geo polygon, and other fields, or in rare cases, a geo lat-long coordinate. Note: Operators matching 
#' on place (Tweet geo) will only include matches from original tweets. Tweet-level data is stored in a data/ 
#' path as a series of JSONs beginning "data_"; User-level data is stored as a series of JSONs beginning "users_". 
#' If a filename is supplied, this function will save the result as a RDS file, otherwise it will return the results as a dataframe.
#'
#' @inheritParams get_all_tweets
#' @return a data.frame
#' @keywords internal
#' @export
#'
#' @examples
#' \dontrun{
#' bearer_token <- "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
#' get_geo_tweets("protest", "2020-01-01T00:00:00Z", "2020-01-05T00:00:00Z", 
#'                bearer_token, data_path = "data/")
#' }
get_geo_tweets <-
  function(query,
           start_tweets,
           end_tweets,
           bearer_token = get_bearer(),
           n = 100,
           file = NULL,
           data_path = NULL,
           bind_tweets = TRUE,
           verbose = TRUE,
           ...) {
    query <- paste0('has:geo ', query)
    lifecycle::deprecate_soft("0.2.0", "get_geo_tweets()", details = "Please use `get_all_tweets(has:geo = TRUE)` instead.")
    get_all_tweets(query = query, start_tweets = start_tweets, end_tweets = end_tweets, bearer_token = bearer_token, n = n, file = file, data_path = data_path, bind_tweets = bind_tweets, verbose = verbose,...)
  }
