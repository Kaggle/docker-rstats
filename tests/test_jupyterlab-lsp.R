context("jupyterlab-lsp")

library(httr)

test_that("jupyterlab-lsp is installed", {
	expect_error({
		# Start a jupyterlab server and wait for it to initialize
		system(
			"/usr/local/bin/jupyter server --allow-root --no-browser --port 9999 --notebook-dir /tmp",
			wait=FALSE)
		
		code <- 0
		for (x in 1:5) {
			# Ping LSP endpoint, verify 200 response
			print("ping lsp server...")
			response <- try(GET("http://localhost:9999/lsp/status"))
			if (class(response) == "response")
				code <- status_code(response)

			if (code == 200) {
				break
			}

			Sys.sleep(5)
		}
		expect_equal(code, 200)

		# Kill the server
		pid <- system("ps -ef | grep jupyter | grep 9999 | awk '{print $2}' | head -n 1", intern = TRUE)
		tools::pskill(pid)
	}, NA) # expect no error to be thrown
})
