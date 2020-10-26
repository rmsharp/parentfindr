#' Get offspring with no dams in trios object
#'
#' @param trios List containing a list for each offspring. Each offspring list
#' contains a named character vector of length one (\code{offspring}) containing
#' the offspring ID, a character vector of potential dams (\code{dams}),
#' and a named character vector of potential sires (\code{sires}).
#' @export
getOffspringNoDam <- function(trios) {
  offspringNoDam <- character(0)
  for (trio in trios) {
    if (length(trio$dams) == 0)
      offspringNoDam <- c(offspringNoDam, trio$offspring)
  }
  offspringNoDam
}
