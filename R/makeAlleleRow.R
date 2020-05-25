#' Translates raw rows of an animal allele file to a data.frame row
#'
#' @return A vector suitable for row in an animal allele data.frame.
#'
#' @param line A line from the animal allele file.
#' @param alleleNames A character vector of the header values for the alleles.
#' These correspond to the allele names.
#' @param dateType A character vector of length one used to guide
#' interpretation of date fields. Either "YYYYMMDD" or "mm/dd/YYYY"
#' @importFrom stringi stri_split_charclass stri_split_fixed
#' @importFrom lubridate ymd mdy
#' @export
makeAlleleRow <- function(line, alleleNames, dateType) {
  tokens <- stri_split_charclass(line, "\\p{WHITE_SPACE}")[[1]]
  refId <- tokens[1]
  sex <- toupper(tokens[2])
  if (dateType == "YYYYMMDD") {
    birthDate <- ymd(tokens[3])
    exitDate <- ymd(tokens[4])
  } else if (dateType == "mm/dd/YYYY") {
    birthDate <- mdy(tokens[3])
    exitDate <- mdy(tokens[4])
  }
  comments <- tokens[5]
  tokens <- tokens[6:length(tokens)]
  len <- length(tokens)
  alleles <- list()
  for (i in seq_len(len)) {
    alleles[[i]] <- stri_split_fixed(tokens[i], ",")[[1]]
    alleles[[i]][alleles[[i]] == "N/A"] <- NA
  }
  names(alleles) <- alleleNames
  alleleRow <- list(
    refId = refId,
    sex = sex,
    birthDate = birthDate,
    exitDate = exitDate,
    comments = comments,
    alleles = alleles
  )
  alleleRow
}