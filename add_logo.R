# References:
# 1. https://github.com/tonyelhabr/temisc/blob/master/R/add_logo.R


#' Add a logo
#'
#' Add a logo to an RMarkdown file.
#'
#' @details \code{filepath_logo} defaults to the "te" logo (which is stored internally).
#' @param filepath_logo character. Fileapth. Wrapped internally by \code{knitr::image_uri()}.
#' @param img_alt,img_style character. Passed to \code{htmltools::ims()}
#' @export
add_logo <-
  function(filepath_logo = system.file("logo", "te.png", package = "temisc"),
           img_alt = 'logo',
           img_style = 'position:absolute; top:0; right:0; padding:10px;') {
    require_ns("htmltools")
    require_ns("knitr")
    htmltools::img(
      src = knitr::image_uri(filepath_logo),
      alt = img_alt,
      style = img_style
    )
  }