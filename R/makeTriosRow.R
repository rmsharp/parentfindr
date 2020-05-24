#' Translates raw rows of an animal trios file to a named list object
#'
#' @return A list suitable for row in an animal trios list.
#'
#' @param line A line from the animal trios file.
#'
#' @importFrom stringi stri_split_charclass
#' @export
makeTriosRow <- function(line) {
  trios <- stri_split_charclass(line, "\\p{WHITE_SPACE}")[[1]]
  offspring <- trios[1]
  dams <- stri_split_fixed(trios[2], ",")[[1]]
  sires <- stri_split_fixed(trios[3], ",")[[1]]

  triosRow <- list(
    offspring = offspring,
    dams = dams,
    sires = sires
  )
  triosRow
}