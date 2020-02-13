# This library adds support for User Secrets, which can be added to
# the Notebook by selecting Add-Ons toolbar -> Secrets.
#
# Sample user code:
#
# paste(get_user_secret('r_secret'))

get_user_secret <- function(label) {
    KAGGLE_USER_SECRETS_TOKEN <- Sys.getenv("KAGGLE_USER_SECRETS_TOKEN")
    KAGGLE_BASE_URL <- Sys.getenv("KAGGLE_URL_BASE")
    GET_USER_SECRET_BY_LABEL_ENDPONT = "/requests/GetUserSecretByLabelRequest"

    if (KAGGLE_USER_SECRETS_TOKEN == '') {
      stop("Expected KAGGLE_USER_SECRETS_TOKEN environment variable to be present.", call. = FALSE)
    }
    request_body <- list(JWE = KAGGLE_USER_SECRETS_TOKEN, Label = label)
    response <- POST(paste0(KAGGLE_BASE_URL, GET_USER_SECRET_BY_LABEL_ENDPONT), body = request_body, encode = "json")
    if (http_error(response) || !identical(content(response)$wasSuccessful, TRUE)) {
      err <- paste("Unable to get user secret. Please ensure you have internet enabled. Error: ",
                        paste(content(response, "text", encoding = 'utf-8')))
      stop(err, call. = FALSE)
    }
    response_body <- content(response)
    return(response_body$result$secret)
}