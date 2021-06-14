# academictwitteR <img src="man/figures/academictwitteRhex.png" width="160px" align="right" />

<!-- badges: start -->
[![v2](https://img.shields.io/endpoint?url=https%3A%2F%2Ftwbadges.glitch.me%2Fbadges%2Fv2)](https://developer.twitter.com/en/docs/twitter-api)
[![DOI](https://joss.theoj.org/papers/10.21105/joss.03272/status.svg)](https://doi.org/10.21105/joss.03272) 
[![](https://www.r-pkg.org/badges/version/academictwitteR)](https://cran.r-project.org/package=academictwitteR)
![Downloads](https://cranlogs.r-pkg.org/badges/academictwitteR)
[![](http://cranlogs.r-pkg.org/badges/grand-total/academictwitteR)](https://cran.r-project.org/package=academictwitteR)
[![Codecov test coverage](https://codecov.io/gh/cjbarrie/academictwitteR/branch/master/graph/badge.svg)](https://codecov.io/gh/cjbarrie/academictwitteR?branch=master)
<!-- badges: end -->


[![Twitter](https://img.shields.io/twitter/url/https/twitter.com/cbarrie.svg?style=social&label=Follow%20%40cbarrie)](https://twitter.com/cbarrie)
[![Twitter](https://img.shields.io/twitter/url/https/twitter.com/justin_ct_ho.svg?style=social&label=Follow%20%40justin_ct_ho)](https://twitter.com/justin_ct_ho)

Repo containing code to for R package <tt>academictwitteR</tt> to collect tweets from v2 API endpoint for the Academic Research Product Track.


To cite package ‘academictwitteR’ in publications use:

  - Barrie, Christopher and Ho, Justin Chun-ting. (2021). academictwitteR: an R package to access the Twitter Academic Research Product Track v2 API endpoint. *Journal of Open Source Software*, 6(62), 3272, https://doi.org/10.21105/joss.03272

A BibTeX entry for LaTeX users is:

```
@article{BarrieHo2021,
  doi = {10.21105/joss.03272},
  url = {https://doi.org/10.21105/joss.03272},
  year = {2021},
  publisher = {The Open Journal},
  volume = {6},
  number = {62},
  pages = {1-2},
  author = {Christopher Barrie and Justin Chun-ting Ho},
  title = {academictwitteR: an R package to access the Twitter Academic Research Product Track v2 API endpoint},
  journal = {Journal of Open Source Software}
}

  
```

## Installation

You can install the package with:
``` r
install.packages("academictwitteR")
```

Alternatively, you can install the development version with:
``` r
devtools::install_github("cjbarrie/academictwitteR", build_vignettes = TRUE)
```


Get started by reading `vignette("academictwitteR-intro")`.

The <tt>academictwitteR</tt> package has been designed with the efficient storage of data in mind. Queries to the API include arguments to specify whether tweets be stored as a .rds file using the `file` argument or as separate JSON files for tweet- and user-level information separately with argument `data_path`.

Tweets are returned as a data.frame object and, when a `file` argument has been included, will also be saved as a .rds file.

## Demo

Getting tweets of specified users via `get_user_tweets()`. This function captures tweets for a particular user or set of users and collects tweets between specified date ranges, avoiding rate limits by sleeping between calls. A call may look like:

```{r}

bearer_token <- "" # Insert bearer token

users <- c("TwitterDev", "jack")
tweets <-
  get_user_tweets(users,
                  "2010-01-01T00:00:00Z",
                  "2020-01-01T00:00:00Z",
                  bearer_token)

```

Getting tweets of specified string or series of strings via `get_all_tweets()`. This function captures tweets containing a particular string or set of strings between specified date ranges, avoiding rate limits by sleeping between calls. 

This function can also capture tweets for a particular hashtag or set of hashtags when specified with the # operator.

For a particular set of strings a call may look like:

```{r}

bearer_token <- "" # Insert bearer token

tweets <-
  get_all_tweets("apples OR oranges",
                 "2020-01-01T00:00:00Z",
                 "2020-01-05T00:00:00Z",
                 bearer_token)

```

For a particular set of hashtags a call may look like:

```{r}

bearer_token <- "" # Insert bearer token

tweets <-
  get_all_tweets(
    "#BLM OR #BlackLivesMatter",
    "2020-01-01T00:00:00Z",
    "2020-01-05T00:00:00Z",
    bearer_token
  )

```

Alternatively, we can specify a character vector comprising several elements. For example, we if we wanted to search multiple hashtags, we could specify a query as follows:

```{r}

bearer_token <- "" # Insert bearer token

htagquery <- c("#BLM", "#BlackLivesMatter", "#GeorgeFloyd")

tweets <-
  get_all_tweets(
    htagquery,
    "2020-01-01T00:00:00Z",
    "2020-01-05T00:00:00Z",
    bearer_token
  )

```

, which will achieve the same thing as typing out `OR` between our strings.  


Note that the "AND" operator is implicit when specifying more than one character string in the query. See [here](https://developer.twitter.com/en/docs/twitter-api/tweets/search/integrate/build-a-query) for information on building queries for search tweets. Thus, when searching for all elements of a character string, a call may look like:

```{r}

bearer_token <- "" # Insert bearer token

tweets <-
  get_all_tweets("apples oranges",
                 "2020-01-01T00:00:00Z",
                 "2020-01-05T00:00:00Z",
                 bearer_token)

```

, which will capture tweets containing *both* the words "apples" and "oranges." The same logic applies for hashtag queries.

## Note on data storage

Files are stores as JSON files in specified directory when a `data_path` is specified. Tweet-level data is stored in files beginning "data_"; user-level data is stored in files beginning "users_".

If a filename is supplied, the functions will save the resulting tweet-level information as a .rds file.

Functions always return a data.frame object unless a `data_path` is specified and `bind_tweets` is set to `FALSE`. When collecting large amounts of data, we recommend using the `data_path` option with `bind_tweets = FALSE`. This mitigates potential data loss in case the query is interrupted. 

An example of such a query would be:

```{r}

bearer_token <- "" # Insert bearer token

tweets <-
  get_all_tweets(
    "#BLM OR #BlackLivesMatter",
    "2014-01-01T00:00:00Z",
    "2020-01-01T00:00:00Z",
    bearer_token,
    data_path = "data/",
    bind_tweets = FALSE
  )

```

, which would collect all tweets containing the hashtags "#BLM" or "BlackLivesMatter" over a six-year period. 

Users can then use the `bind_tweets` convenience function to bundle the jsons into a data.frame object for analysis in R as such:

```{r}
tweets <- bind_tweets(data_path = "data/")
users <- bind_tweets(data_path = "data/", user = TRUE)
```

## Arguments

`get_all_tweets()` accepts a range of arguments, which can be combined to generate a more precise query.

| Arguments   |     Description      |
|----------|:-------------:|
|query | Search query or queries e.g. "cat"
|exclude | Tweets containing the keyword(s) will be excluded "grumpy" e.g.
|is_retweet | If `TRUE`, only retweets will be returned; if `FALSE`, retweets will not be returned, only tweets will be returned; if `NULL`, both retweets and tweets will be returned.
|is_reply | If `TRUE`, only reply tweets will be returned
|is_quote | If `TRUE`, only quote tweets will be returned
|is_verified |If `TRUE`, only tweets whose authors are verified by Twitter will be returned
|place | Name of place e.g. "London"
|country | Name of country as ISO alpha-2 code e.g. "GB"
|point_radius | A vector of two point coordinates latitude, longitude, and point radius distance (in miles)
|bbox | A vector of four bounding box coordinates from west longitude to north latitude
|geo_query | If `TRUE` user will be prompted to enter relevant information for bounding box or point radius geo buffers
|remove_promoted | If `TRUE`, tweets created for promotion only on ads.twitter.com are removed
|has_hashtags | If `TRUE`, only tweets containing hashtags will be returned
|has_cashtags | If `TRUE`, only tweets containing cashtags will be returned
|has_links | If `TRUE`, only tweets containing links and media will be returned
|has_mentions |If `TRUE`, only tweets containing mentions will be returned
|has_media |If `TRUE`, only tweets containing a recognized media object, such as a photo, GIF, or video, as determined by Twitter will be returned
|has_images |If `TRUE`, only tweets containing a recognized URL to an image will be returned
|has_videos |If `TRUE`, only tweets containing contain native Twitter videos, uploaded directly to Twitter will be returned
|has_geo |If `TRUE`, only tweets containing Tweet-specific geolocation data provided by the Twitter user will be returned
|lang | A single BCP 47 language identifier e.g. "fr"

An example would be:
```{r}
bearer_token <- "" # Insert bearer token

tweets <-
  get_all_tweets(
    query = "cat",
    exclude = "grumpy",
    "2020-01-01T00:00:00Z",
    "2020-01-02T00:00:00Z",
    bearer_token,
    has_images = TRUE,
    has_hashtags = TRUE,
    country = "GB",
    lang = "en"
  )
```
The above query will fetch all tweets that contain the word "cat" but not "grumpy", posted on 1 January 2020 in the UK, have an image attachment, include at least one hashtag, and are written in English.

## Interruption and Continuation

The package offers two functions to deal with interruption and continue previous data collection session. If you have set a data_path and export_query was set to "TRUE" during the original collection, you can use `resume_collection()` to resume a previous interrupted collection session. An example would be:
```{r}
bearer_token <- ""
resume_collection(data_path = "data", bearer_token)
```

If a previous data collection session is completed, you can use `update_collection()` to continue data collection with a new end date. This function is particularly useful for getting data for ongoing events. An example would be:
```{r}
bearer_token <- ""
update_collection(data_path = "data", "2020-05-10T00:00:00Z", bearer_token)
```

## Note on v2 Twitter API

For more information on the parameters and fields available from the v2 Twitter API endpoint see: [https://developer.twitter.com/en/docs/twitter-api/tweets/search/api-reference/get-tweets-search-all](https://developer.twitter.com/en/docs/twitter-api/tweets/search/api-reference/get-tweets-search-all).

## Note on User Information

The API call returns both the tweet data and the user information separately, but currently only the former is parsed. It is possible to obtain other user information such as user handle and display name. These can then be merged with the dataset using the author_id field.

```

bearer_token <- "" # Insert bearer token

users <- c("TwitterDev", "jack")
tweets_df <-
  get_user_tweets(users,
                  "2020-01-01T00:00:00Z",
                  "2020-01-05T00:00:00Z",
                  bearer_token)

users_df <-
  get_user_profile(unique(tweets_df$author_id), bearer_token)
  
```


## Acknowledgements

Function originally taken from [Gist](https://gist.github.com/schochastics/1ff42c0211916d73fc98ba8ad0dcb261#file-get_tweets-r-L14) by [https://github.com/schochastics](https://github.com/schochastics).


## Code of Conduct

Please note that the academictwitteR project is released with a [Contributor Code of Conduct](https://contributor-covenant.org/version/2/0/CODE_OF_CONDUCT.html). By contributing to this project, you agree to abide by its terms.
