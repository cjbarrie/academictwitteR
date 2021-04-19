# academictwitteR

Repo containing code to loop through usernames/hashtags and collect tweets from Full Archive v2 API endpoint for the Academic Research Product Track. Uses new pagination_token query params. Repo now contains skeleton for developing package to contain all functions; for now, main functions are located in folder "R/".

## Installation

You can install the development package with:

``` r
devtools::install_github("cjbarrie/academictwitteR")
```

NOTE: the name of the package has been changed from twittterv2r.

## Demo

Getting tweets of specified users via `get_user_tweets()`. This function captures tweets for a particular user or set of users and collects tweets between specified date ranges, avoiding rate limits by sleeping between calls. A call may look like:

```{r}

bearer_token <- "" # Insert bearer token

users <- c("TwitterDev", "jack")
tweets <- get_user_tweets(users, "2020-01-01T00:00:00Z", "2020-01-05T00:00:00Z", bearer_token, data_path = "data/")

```

Getting tweets of specified string or series of strings via `get_all_tweets()`. This function captures tweets containing a particular string or set of strings between specified date ranges, avoiding rate limits by sleeping between calls. This function can also captures tweets for a particular hashtag or set of hashtags when specified with the # operator. See [here](https://developer.twitter.com/en/docs/twitter-api/tweets/search/integrate/build-a-query) for information on building queries for search tweets.

For a particular series of strings a call may look like:

```{r}

bearer_token <- "" # Insert bearer token

tweets <- get_all_tweets("apples OR oranges", "2020-01-01T00:00:00Z", "2020-01-05T00:00:00Z", bearer_token, data_path = "data/")

```

For a particular series of hashtags a call may look like:

```{r}

bearer_token <- "" # Insert bearer token

tweets <- get_all_tweets("#BLM OR #BlackLivesMatter", "2020-01-01T00:00:00Z", "2020-01-05T00:00:00Z", bearer_token, data_path = "data/")

```

Function originally taken from [Gist](https://gist.github.com/schochastics/1ff42c0211916d73fc98ba8ad0dcb261#file-get_tweets-r-L14) by [https://github.com/schochastics](https://github.com/schochastics).

Files are stores as JSON files in folder "data/" when a `data_path` is specified. Tweet-level data is stored in files beginning "data_"; user-level data is stored in files beginning "user_".

If a filename is supplied, the functions will save the resulting tweet-level information as a RDS file, otherwise results will be returned as a dataframe.

For more information on the parameters and fields included in queries to new v2 Endpoint see: [https://developer.twitter.com/en/docs/twitter-api/tweets/search/api-reference/get-tweets-search-all](https://developer.twitter.com/en/docs/twitter-api/tweets/search/api-reference/get-tweets-search-all).

## Note on User Information

The API call returns both the tweet data and the user information separately, but currently only the former is parsed. Is it possible to obtain other user information such as user handle and display name. These can then be merged with the dataset using the author_id field.

```
bearer_token <- "" # Insert bearer token

users <- c("TwitterDev", "jack")
tweets_df <- get_user_tweets(users, "2020-01-01T00:00:00Z", "2020-01-05T00:00:00Z", bearer_token)

get_user_profile(unique(tweets_df$author_id), bearer_token)
```
