add_query_prefix <- function(x, prefix){
  q <- paste0(prefix, x)
  q <- paste(q, collapse = " OR ")
  q <- paste0("(",q,")")
  return(q)
}
