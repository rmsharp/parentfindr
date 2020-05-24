#' Tests to see if the potential trios file has the appropriate header.
#'
#' @param lines Character vector of length one plus the number of animals where
#' the additional line is the header
#' @param dateType A character vector of length one used to guide
#' interpretation of date fields. Either "YYYYMMDD" or "mm/dd/YYYY"
#' @importFrom stringi stri_split_charclass
#' @importFrom rmsutilityr get_and_or_list
#' @export
getAnimalAlleles <- function(lines, dateType) {
  headerLine <- lines[[1]]
  headers <- stri_split_charclass(headerLine, "\\p{WHITE_SPACE}")[[1]]
  ## Need to add ability to have either sires before or after dams
  if (!isValidAnimalAlleleHeader(headerLine)) {
    found <- headers[getAnimalAlleleFileHeaders()]
    stop(paste0("Invalid header values found in animal allele file. Found ",
         get_and_or_list(found), " while looking for ",
         get_and_or_list(getAnimalAlleleFileHeaders()), "."))
  }
  lines <- lines[-1]
  alleleNames <- headers[
    (length(getAnimalAlleleFileHeaders()) + 1):length(headers)]

  alleles <- list(length(lines))
  for (i in seq_along(lines)) {
    alleles[[i]] <- makeAlleleRow(line = lines[i],
                                  alleleNames = alleleNames,
                                  dateType = dateType)
  }
  names(alleles) <- vapply(alleles, function(allele) {
    allele$refId}, character(1))

  alleles
}