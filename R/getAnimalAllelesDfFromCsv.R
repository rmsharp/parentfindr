#' Extract animal allele data from the animal allele file.
#'
#' @param alleleFile Character vector of length one having the path of the
#' animal alleles file.
#' @param dateType A character vector of length one used to guide
#' interpretation of date fields. Either "YYYYMMDD" or "mm/dd/YYYY"
#' @importFrom lubridate ymd mdy
#' @importFrom stringi stri_split_charclass stri_trim_both
#' @importFrom rmsutilityr get_and_or_list
#' @export
getAnimalAllelesDfFromCsv <- function(alleleFile, dateType) {
  lines <- readLines(con = alleleFile, warn = FALSE)
  headerLine <- lines[[1]]
  headers <-
    stri_split_charclass(headerLine, "\\p{WHITE_SPACE}")[[1]]
  ## Need to add ability to have either sires before or after dams
  if (!isValidAnimalAlleleHeader(headerLine)) {
    found <- headers[getAnimalAlleleFileHeaders()]
    stop(
      paste0(
        "Invalid header values found in animal allele file. Found ",
        get_and_or_list(found),
        " while looking for ",
        get_and_or_list(getAnimalAlleleFileHeaders()),
        "."
      )
    )
  }
  lines <- lines[-1]
  alleleNames <-
    headers[(length(getAnimalAlleleFileHeaders()) + 1):length(headers)]

  alleles <- list()
  for (i in seq_along(lines)) {
    tokens <- stri_split_charclass(lines[[i]], "\\p{WHITE_SPACE}")[[1]]
    tokens <- stri_trim_both(tokens)
    tokens <- ifelse(tokens == "", NA, tokens)
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
    allele$refId
    }, character(1))

  alleles
}
