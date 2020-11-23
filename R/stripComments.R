#' @title Strip off comments
#' @description Takes a character vector containing XML text and removes
#' comments. Lines that contained only comments are also removed.
#'
#' @return Character vector with all XML comments removed.
#' @param stmt character vector containing XML text
#' @importFrom stringi stri_length stri_locate_first_fixed stri_sub
#' @export
stripComments <- function(stmt) {
  stmt <- stmt[stri_length(stmt) > 0]
  cmt <- stri_locate_first_fixed(stmt, "#")[ , 1] - 1
  len <- stri_length(stmt)
  stmt <- stri_sub(stmt, 1, pmin(len, cmt, na.rm = TRUE))
  stmt[stri_length(stmt) > 0]
}
