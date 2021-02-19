# twitterv2r

Repo containing code to loop through usernames/hashtag and collect tweets from Full Archive v2 API endpoint. Uses new pagination_token query params. 

Function taken from [Gist](https://gist.github.com/schochastics/1ff42c0211916d73fc98ba8ad0dcb261#file-get_tweets-r-L14) by [https://github.com/schochastics](https://github.com/schochastics)

- get_user_tweetsv2.R loops through list of users and collects tweets between specified date ranges, avoiding rate limits by sleeping between calls.
- get_hashtag_tweetsv2.R captures tweets for particular hashtag between specified date ranges, avoiding rate limits by sleeping between calls.

Files are stores as .json files in folders "data/" and "includes/," where "data/" contains the main tweet parameters, and "includes/" contains additional user-level information.

For more information on the parameters and fields included in queries to new v2 Endpoint see: [https://developer.twitter.com/en/docs/twitter-api/tweets/search/api-reference/get-tweets-search-all](https://developer.twitter.com/en/docs/twitter-api/tweets/search/api-reference/get-tweets-search-all).

Scripts also include loop to bind all .json files into single data.frame object for saving.
