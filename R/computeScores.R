#' Scores and entry potential parent to a kid and optionally a previously
#' scored parent
#'
#' @param parent A list with the all of the information from the animal allele
#' file representing one potential parent.
#' @param kid A list with the all of the information from the animal allele
#' file representing the potential offspring.
#' @param other A list with the all of the information from the animal allele
#' file representing one potential parent.
#' @importFrom stringi stri_split_charclass
#' @export
computescores <- function(parent, kid, other) {
  missing = countMissing(parent$alleles)
  invalid = countMissing(kid$alleles)
  if (missing(other)) {
      discrepant <- countDiscrepant(parent, kid)
  } else {
    discrepant <- countDiscrepant(parent, kid, other)
  }
  list(
    missing = missing,
    invalid = invalid,
    discrepant = discrepant
  )
}
