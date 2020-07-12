#' Counts the number of loci with missing data
#'
#' @return An integer value equal to the number of loci missing data
#' @param alleles List of alleles with character vector of haplotype values.
#' @export
countMissingLoci <- function(alleles) {
  sum(vapply(alleles, function(locus) {
    ifelse(any(is.na(locus)), 1L, 0L)},
    integer(1)))
}