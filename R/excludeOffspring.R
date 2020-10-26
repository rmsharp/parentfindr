#' Exclude offspring by ID.
#'
#' Removes offspring from \code{scoresDf} that are listed in \code{offspring}.
#'
#' @param offspring character vector with list of offspring IDs
#' @param scoresDf dataframe from scores object
#' @export
excludeOffspring <- function(offspring, scoresDf) {
  scoresDf[!is.element(scoresDf$offspring, offspring), ]
}
