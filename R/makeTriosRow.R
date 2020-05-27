#' Translates raw rows of an animal trios file to a named list object
#'
#' @return A list suitable for row in an animal trios list.
#'
#' @param record A record from the trios dataframe object.
#'
#' @importFrom stringi stri_split_charclass stri_split_fixed
#' @export
makeTriosRow <- function(record) {
  offspring <- record$offspring
  dams <- stri_split_fixed(record$dams, ",")[[1]]
  sires <- stri_split_fixed(record$sires, ",")[[1]]

  triosRow <- list(
    offspring = offspring,
    dams = dams,
    sires = sires
  )
  triosRow
}