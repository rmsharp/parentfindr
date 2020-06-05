#' Extract animal allele data from the Excel formatted animal allele file.
#'
#' @param alleleFile Character vector of length one having the path of the
#' animal alleles file.
#' @param dateType A character vector of length one used to guide
#' interpretation of date fields. Either "YYYYMMDD" or "mm/dd/YYYY"
#' @importFrom lubridate ymd mdy
#' @importFrom stringi stri_split_charclass
#' @importFrom rmsutilityr get_and_or_list
#' @export
getAnimalAllelesDfFromExcel <- function(alleleFile, dateType) {
  animalAllelesDf <- as.data.frame(read_excel(path = alleleFile, na = "N/A"))
  headers <- colnames(animalAllelesDf)
  found <- headers[seq_along(getAnimalAlleleFileHeaders())]
  ## Need to add ability to have either sires before or after dams
  if (!all(getAnimalAlleleFileHeaders() == found)) {
    stop(paste0("Invalid header values found in animal allele file (",
                alleleFile, "). Found ",
                get_and_or_list(found), " while looking for ",
                get_and_or_list(getAnimalAlleleFileHeaders()), "."))
  }
  alleleNames <- headers[
    (length(getAnimalAlleleFileHeaders()) + 1):length(headers)]

  alleles <- list()
  for (i in seq_len(nrow(animalAllelesDf))) {
    line = animalAllelesDf[i, ]
    refId <- as.character(line$refId)
    sex <- toupper(line$sex)
    if (dateType == "YYYYMMDD") {
      birthDate <- ymd(line$birthDate)
      exitDate <- ymd(line$exitDate)
    } else if (dateType == "mm/dd/YYYY") {
      birthDate <- mdy(line$birthDate)
      exitDate <- mdy(line$exitDate)
    }
    comments <- line$comments
    tokens <- line[!is.element(names(line),
                               c("refId", "sex", "birthDate", "exitDate",
                                 "comments")) ]
    alleles[[i]] <- list(
      refId = refId,
      sex = sex,
      birthDate = birthDate,
      exitDate = exitDate,
      comments = comments,
      alleles = parseAlleles(tokens = tokens, alleleNames = alleleNames)
    )
  }
  names(alleles) <- vapply(alleles, function(allele) {
    allele$refId}, character(1))

  alleles

}

