# academictwitteR 

Repo containing code to for R package <tt>academictwitteR</tt> collect tweets from v2 API endpoint for the Academic Research Product Track.

```
To cite package ‘academictwitteR’ in publications use:

  Christopher Barrie and Justin Chun-ting Ho (NA). academictwitteR:
  academictwitteR: a package to access the Twitter Academic Research
  Product Track v2 API endpoint. R package version 0.0.0.9000.
  https://github.com/cjbarrie/academictwitteR

A BibTeX entry for LaTeX users is

  @Manual{,
    title = {academictwitteR: academictwitteR: a package to access the Twitter Academic Research Product Track v2 API endpoint},
    author = {Christopher Barrie and Justin Chun-ting Ho},
    note = {R package version 0.0.0.9000},
    url = {https://github.com/cjbarrie/academictwitteR},
  }
  
```

## Installation

You can install the development package with:

``` r
devtools::install_github("cjbarrie/academictwitteR")
```

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

Note that the "AND" operator is implicit when specifying more than one character string in the query. See [here](https://developer.twitter.com/en/docs/twitter-api/tweets/search/integrate/build-a-query) for information on building queries for search tweets. 

Thus, when searching for all elements of a character string, a call may look like:

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

Users can then use the `bind_tweet_jsons` and `bind_user_jsons` convenience functions to bundle the jsons into a data.frame object for analysis in R as such:

```{r}

tweets <- bind_tweet_jsons(data_path = "data/")

```

```{r}

users <- bind_user_jsons(data_path = "data/")

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
