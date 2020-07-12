#' Creates a dataframe with a set of potential parents with one row for each
#' offspring from CSV file.
#'
#' @return A dataframe with one row for each offspring where the potential dams
#' and sires are the second and third column respectively. The \code{dam} and
#' \code{sire} columns contain the animal IDs in a single character string
#' separated as they were in the original file.
#'
#' @param triosFile Character vector of length one having the path of the
#' trios file.
#' @importFrom stringi stri_split_charclass
#' @importFrom rmsutilityr get_and_or_list
#' @export
getTriosDfFromCsv <- function(triosFile) {
  lines <- readLines(con = triosFile, warn = FALSE)
  headerLine <- lines[[1]]
  headers <- stri_split_charclass(headerLine, "\\p{WHITE_SPACE}")[[1]]
  if (!isValidTrioHeader(headerLine)) {
    found <- headers[seq_along(getTriosFileHeaders())]
    stop(paste0("Invalid header values found in animal trio file. Found ",
                get_and_or_list(found), " while looking for ",
                get_and_or_list(getTriosFileHeaders()), "."))
  }
  lines <- lines[-1]
  triosDf <- data.frame()
  for (line in lines) {
    line <- stri_split_charclass(line, "\\p{WHITE_SPACE}")[[1]]
    trioRow <- data.frame(line[1], line[2], line[3])
    triosDf <- rbind(triosDf, trioRow)
  }
  names(triosDf) <- headers
  triosDf
}