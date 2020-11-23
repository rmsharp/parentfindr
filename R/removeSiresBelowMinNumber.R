#' Remove rows from scoresDf with sires having below minimum number compared
#' loci
#'
#' @param scoresDf dataframe with scores from \emph{scores} object
#' @param minNumber threshold for minimum compared loci
#' @export
removeSiresBelowMinNumber <- function(scoresDf, minNumber) {
  scoresDf[(scoresDf$sireNumLociCompared) < minNumber,  ]
}
