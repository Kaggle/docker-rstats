context("languageserver")

test_that("languageserver responds to commands", {
    expect_error({
        result <- system(
            "R -e 'languageserver::run()'",
            input="Content-Length: 38\n\n{ \"id\": \"123\", \"method\": \"shutdown\" }\n",
            intern=TRUE)

        found_response <- FALSE
        for (line in result) {
            if (grepl("\"id\":\"123\"", line, fixed=TRUE) & grepl("\"result\":[]", line, fixed=TRUE)) {
                found_response <- TRUE
            }
        }

        expect_true(found_response)
	}, NA) # expect no error to be thrown
})