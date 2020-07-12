#' Detect file type of trios file and routes its parsing.
#'
#' The trios files are made up of sets of potential parents in one row for each
#' offspring from CSV file.
#'
#' @param triosFile Character vector of length one having the path of the
#' trios file.
#' @importFrom readxl excel_format
#' @importFrom stringi stri_split_charclass
#' @importFrom rmsutilityr get_and_or_list
#' @export
getTrios <- function(triosFile) {
  if (excel_format(triosFile) %in% c("xls", "xlsx")) {
    triosDf <- getTriosDfFromExcel(triosFile)
  } else {
    triosDf <- getTriosDfFromCsv(triosFile)
  }
  trios <- list()
  for (i in seq_len(nrow(triosDf))) {
    trios[[i]] <- makeTriosRow(triosDf[i, ])
  }
  names(trios) <- vapply(trios, function(trio) {trio$offspring}, character(1))

  trios
}