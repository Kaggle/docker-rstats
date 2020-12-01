# This library adds support for User Secrets, which can be added to
# the Notebook by selecting Add-Ons toolbar -> Secrets.
#
# Sample user code:
#
# paste(get_user_secret('r_secret'))

get_user_secret <- function(label) {
    KAGGLE_USER_SECRETS_TOKEN <- Sys.getenv("KAGGLE_USER_SECRETS_TOKEN")
    KAGGLE_BASE_URL <- Sys.getenv("KAGGLE_URL_BASE")
    KAGGLE_IAP_TOKEN <- Sys.getenv("KAGGLE_IAP_TOKEN")
    GET_USER_SECRET_BY_LABEL_ENDPOINT = "/requests/GetUserSecretByLabelRequest"

    if (KAGGLE_USER_SECRETS_TOKEN == '') {
      stop("Expected KAGGLE_USER_SECRETS_TOKEN environment variable to be present.", call. = FALSE)
    }
    request_body <- list(Label = label)
    auth_header <- paste0("Bearer ", KAGGLE_USER_SECRETS_TOKEN)
    if (KAGGLE_IAP_TOKEN != '') {
        iap_auth_header <- paste0("Bearer ", KAGGLE_IAP_TOKEN)
        headers <- add_headers(c("X-Kaggle-Authorization" = auth_header, "Authorization" = iap_auth_header))
    } else {
        headers <- add_headers(c("X-Kaggle-Authorization" = auth_header))
    }
    response <- POST(
      paste0(KAGGLE_BASE_URL, GET_USER_SECRET_BY_LABEL_ENDPOINT),
      headers,
      # Reset the cookies on each request, since the server expects none.
      handle = handle(''),
      body = request_body,
      encode = "json"
    )
    if (http_error(response) || !identical(content(response)$wasSuccessful, TRUE)) {
      err <- paste("Unable to get user secret. Please ensure you have internet enabled. Error: ",
                        paste(content(response, "text", encoding = 'utf-8')))
      stop(err, call. = FALSE)
    }
    response_body <- content(response)
    return(response_body$result$secret)
}
