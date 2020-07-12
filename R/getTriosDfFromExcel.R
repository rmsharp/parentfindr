#' Creates a dataframe with a set of potential parents for in on row for each
#' offspring from an Excel file.
#'
#' @return A dataframe with one row for each offspring where the potential dams
#' and sires are the second and third column respectively. The \code{dam} and
#' \code{sire} columns contain the animal IDs in a single character string
#' separated as they were in the original file.
#'
#' @param triosFile Character vector of length one having the path of the
#' trios file.
#' @importFrom readxl excel_format
#' @importFrom stringi stri_split_charclass
#' @importFrom rmsutilityr get_and_or_list
#' @export
getTriosDfFromExcel <- function(triosFile) {
  trioDf <- as.data.frame(read_excel(path = triosFile, na = "N/A"))
  headers <- colnames(trioDf)
  if (all(toupper(headers) != toupper(getTriosFileHeaders())))
    stop(
      paste0(
        "Invalid header values found in animal trio file. Found ",
        get_and_or_list(headers),
        " while looking for ",
        get_and_or_list(getTriosFileHeaders()),
        "."
      )
    )
  trioDf
}
