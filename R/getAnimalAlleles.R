#' Tests to see if the potential trios file has the appropriate header.
#'
#' @param alleleFile Character vector of length one having the path of the
#' animal alleles file.
#' @param dateType A character vector of length one used to guide
#' interpretation of date fields. Either "YYYYMMDD" or "mm/dd/YYYY"
#' @importFrom stringi stri_split_charclass
#' @importFrom rmsutilityr get_and_or_list
#' @export
#' @importFrom readxl excel_format
#' @importFrom stringi stri_split_charclass
#' @importFrom rmsutilityr get_and_or_list
#' @export
getAnimalAlleles <- function(alleleFile, dateType) {
  if (file.exists(alleleFile)) {
    if (excel_format(alleleFile) %in% c("xls", "xlsx")) {
      alleles <- getAnimalAllelesDfFromExcel(alleleFile, dateType = dateType)
    } else {
      alleles <- getAnimalAllelesDfFromCsv(alleleFile, dateType = dateType)
    }
  } else {
    stop(paste0("The animal allele file cannot be found. The file name ",
                "provided is '", alleleFile, "'."))
    }

  alleles
}