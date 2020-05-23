#' Tests to see if the potential trios file has the appropriate header.
#'
#' @param headerLine Character vector of length one having the first line of
#' the file containing the list of potential trios.
#' @importFrom stringi stri_split_charclass
#' @export
isValidTrioHeader <- function(headerLine = headerLine) {
  headers <- toupper(stri_split_charclass(headerLine, "\\p{WHITE_SPACE}")[[1]])
  all(headers == getPotentialTriosFileHeaders())
}