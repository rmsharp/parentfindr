#' Translates raw rows of an animal allele file to a data.frame row
#'
#' @return A vector suitable for row in an animal allele data.frame.
#'
#' @param tokens A line from the animal allele file.
#' @param alleleNames A character vector of the header values for the alleles.
#' These correspond to the allele names.
#' @importFrom stringi stri_split_charclass stri_split_fixed
#' @export
parseAlleles <- function(tokens, alleleNames) {
  len <- length(tokens)
  alleles <- list()
  for (i in seq_len(len)) {
    alleles[[i]] <- stri_split_fixed(tokens[i], ",")[[1]]
    alleles[[i]][alleles[[i]] == "N/A"] <- NA
  }
  names(alleles) <- alleleNames
  alleles
}