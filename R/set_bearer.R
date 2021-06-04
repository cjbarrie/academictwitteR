#' Manage your bearer token
#'
#' These two functions manage your bearer token. It is in general not safe to 1) hardcode your bearer token in your R script or 2) have your bearer token in your command history. \code{set_bearer} saves your bearer token as an RDS file. \code{get_bearer} returns your bearer token, if it has been preset.
#' @param bearer_token string, your bearer token
#' @param path string, path to store your bearer token. Default to .academictwitteR_token at your user directory
#' @return nothing. Your bearer token is stored
#' @export
set_bearer <- function(bearer_token = NULL, path = "~/.academictwitteR_token") {
  full_path <- base::path.expand(path)
  if (is.null(bearer_token)) {
    cat("Please paste your bearer token here: ")
    if (is.null(getOption("academictwitteR.connection"))) {
      options("academictwitteR.connection" = stdin())
    }
    bearer_token <- readLines(con = getOption("academictwitteR.connection"), n = 1)
  }
  if (!file.exists(full_path)) {
    file.create(full_path)
  }
  base::Sys.chmod(full_path, "0600")
  writeLines(bearer_token, full_path)
  invisible(full_path)
}

#' @export
#' @rdname set_bearer
get_bearer <- function(path = "~/.academictwitteR_token") {
  full_path <- base::path.expand(path)
  if (base::file.exists(full_path)) {
    return(readLines(full_path))
  }
  stop("Please set up your bearer token with set_bearer() or supply your bearer token in every call.", call. = FALSE)
}
