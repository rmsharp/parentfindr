#' Tests to see if the potential trios file has the appropriate header.
#'
#' @param lines Character vector of length one plus the number of animals where
#' the additional line is the header
#' @importFrom stringi stri_split_charclass
#' @importFrom rmsutilityr get_and_or_list
#' @export
getTrios <- function(lines) {
  headerLine <- lines[[1]]
  headers <- stri_split_charclass(headerLine, "\\p{WHITE_SPACE}")[[1]]
  if (!isValidTrioHeader(headerLine)) {
    found <- headers[seq_along(getTriosFileHeaders())]
    stop(paste0("Invalid header values found in animal trio file. Found ",
         get_and_or_list(found), " while looking for ",
         get_and_or_list(getTriosFileHeaders()), "."))
  }
  lines <- lines[-1]
  trios <- list()
  for (i in seq_along(lines)) {
    trios[[i]] <- makeTriosRow(lines[i])
  }
  names(trios) <- vapply(trios, function(trio) {
    trio$offspring}, character(1))

  trios
}