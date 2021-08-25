# running two make_query in rapid succession will not trigger HTTP 429

    Code
      academictwitteR:::make_query(url = endpoint_url, params = params, bearer_token = get_bearer())
    Output
      $meta
      $meta$result_count
      [1] 0
      
      

---

    Code
      academictwitteR:::make_query(url = endpoint_url, params = params, bearer_token = get_bearer())
    Output
      $meta
      $meta$result_count
      [1] 0
      
      

