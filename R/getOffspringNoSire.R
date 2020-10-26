#' Get offspring with no dams in trios object
#'
#' @param trios List containing a list for each offspring. Each offspring list
#' contains a named character vector of length one (\code{offspring}) containing
#' the offspring ID, a character vector of potential dams (\code{dams}),
#' and a named character vector of potential sires (\code{sires}).
#' @export
getOffspringNoSire <- function(trios) {
  offspringNoSire <- character(0)
  for (trio in trios) {
    if (length(trio$sires) == 0)
      offspringNoSire <- c(offspringNoSire, trio$offspring)
  }
  offspringNoSire
}