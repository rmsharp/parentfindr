#' Captitalize first letter of each word in a character string
#'
#' @return character string with first character of each word capitalized and
#' remaining characters either left alone or are forced to lower case.
#'
#' In many cases the user will want to use \code{tools::toTitleCase} instead.
#'
#' @examples
#' library(stringi, quietly = TRUE)
#' capitalizeFirstLetter(words = c("a", "vector of words",
#'                                  "TO BE CAPITALIZED."))
#' capitalizeFirstLetter(words = c("a", "vector of words",
#'                                  "TO BE CAPITALIZED."), lower = TRUE)
#' @param words character string with one or more words in each element.
#' @param lower logical indicating whether remaining characters will be
#' forced to lower case.
#'
#' @importFrom stringi stri_split stri_c
#' @export
capitalizeFirstLetter <- function(words = "", lower = FALSE) {
  if (lower)
    words <- tolower(words)
  new <- sapply(words, function(word) {
    word <- unlist(stri_split(as.character(word[[1]]), fixed = " "))
    substring(word, 1, 1) <- toupper(substring(word, 1, 1))
    substring(word, 2) <- substring(word, 2)
    word <- stri_c(word, collapse = " ")
    word
  })
  names(new) <- NULL
  new
}
