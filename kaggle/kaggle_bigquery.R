# This library adds support for BigQuery (via the bigrquery library), by using
# Kaggle's UserSecrets service to retrieve an OAuth access token for the connected
# credentials attached to the running Kernel.
#
# Sample user code:
#
# project <- "yes-theory-1" # put your project ID here
# sql <- "SELECT year, month, day, weight_pounds FROM [publicdata:samples.natality] LIMIT 5"
# query_exec(sql, project = project)

KAGGLE_USER_SECRETS_TOKEN <- Sys.getenv("KAGGLE_USER_SECRETS_TOKEN")
KAGGLE_BASE_URL <- Sys.getenv("KAGGLE_URL_BASE")
GET_USER_SECRET_ENDPONT = "/requests/GetUserSecretRequest"

# We create a Token2.0 Credential object (from httr library) and use bigrquery's set_access_cred
# to override the interactive authentication (https://github.com/r-dbi/bigrquery/blob/master/R/auth.R).
library(httr)
TokenBigQueryKernel <- R6::R6Class("TokenBigQueryKernel", inherit = Token2.0, list(
  params = list(as_header = TRUE),
  endpoint = oauth_endpoints("google"),
  initialize = function() {
  },
  can_refresh = function() {
    TRUE
  },
  refresh = function() {
    if (KAGGLE_USER_SECRETS_TOKEN == '') {
      stop("Expected KAGGLE_USER_SECRETS_TOKEN environment variable to be present.", call. = FALSE)
    }
    request_body <- list(JWE = KAGGLE_USER_SECRETS_TOKEN, Target = 1)
    response <- POST(paste0(KAGGLE_BASE_URL, GET_USER_SECRET_ENDPONT), body = request_body, encode = "json")
    if (http_error(response) || !identical(content(response)$wasSuccessful, TRUE)) {
      err <- paste("Unable to refresh token. Please ensure you have a connected BigQuery account. Error: ",
                        paste(content(response, "text", encoding = 'utf-8')))
      stop(err, call. = FALSE)
    }
    response_body <- content(response)
    self$credentials$access_token <- response_body$result$secret
    self
  },
  # Never cache
  cache = function(path) self,
  load_from_cache = function() self
))

library(bigrquery)
# A hack to allow users to use bigrquery directly. The "correct" way would be to use:
# `bq_auth(scopes = NULL, token = TokenBigQueryKernel$new())`, but that would force auth immediately,
# which would slow kernels starting and could cause errors on startup.
auth <- getNamespace("bigrquery")$.auth
auth$set_cred(TokenBigQueryKernel$new())
auth$set_auth_active(TRUE)
