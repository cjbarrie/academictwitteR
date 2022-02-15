# academictwitteR 0.3.1
* Added support for hydrating tweet ids (`hydrate_tweets`) [#260 Thanks Tim König]
* Added error capturing mechanism [#264 Thanks Tim König]
* Fixed a bug of `get_retweeted_by` [#287 Thanks Thomas Davidson]
* Various bug fixes [#273, #263, #267]

# academictwitteR 0.3.0
* Added support for batch compliance
* Added functions `get_user_id`, `get_retweeted_by`, and `convert_json`.
* Added parameter `exact_phrase` for `build_query` (also for the downstream function `get_all_tweets`).

# academictwitteR 0.2.1
* Fixed error 400 when fetching tweets with the context annotation field

# academictwitteR 0.2.0

* Support Likes lookup, followers, following, liked tweets, and liking user endpoints
* A function to counts tweets by query string: `count_all_tweets`
* Added the `n` argument
* Autosleep when hitting rate limit
* `bind_tweets` allows transforming the collected tweets to various formats, e.g. tidy data frame
* `set_bearer` and `get_bearer` for managing the bearer token
* Many wrappers to `get_all_tweets` are deprecated
* Bug fixes and efficiency improvements

# academictwitteR 0.1.0
* Initial CRAN version.
