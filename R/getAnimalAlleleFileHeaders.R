#' Gets character vector of the approved file headers before loci list for a
#' animal allele file.
#'
#' @export
getAnimalAlleleFileHeaders <- function() {
  c("refId","sex","birthDate", "exitDate", "comments")
}