options(repos = list(CRAN = "http://cran.rstudio.com/"))

options(device = function() png(width = 900))

# Suppressing package startup messages in package loads
# WART: this appears dangerous and is likely the source of
#       future tough-to-debug bugs
#  (removing this for now as it caused issues with the gbm package)
# env <- as.environment('package:base') 
# unlockBinding('library', env) 
# library.warn <- library
# utils::assignInNamespace('library', function(
#   package, help, pos = 2, lib.loc = NULL, character.only = FALSE,
#   logical.return = FALSE, warn.conflicts = TRUE, quietly = FALSE,
#   verbose = getOption("verbose")) {
#   if (!character.only) {
#     package <- as.character(substitute(package))
#   }

#   suppressPackageStartupMessages(library.warn(
#     package, help, pos, lib.loc, character.only = TRUE,
#     logical.return, warn.conflicts, quietly, verbose))
# }, ns="base")
# lockBinding('library', env) 

# Needed to make plots in rendered iR notebooks display correctly
options(jupyter.plot_mimetypes = "image/png")
