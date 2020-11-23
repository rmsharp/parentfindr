#' Remove rows from scoresDf with dams having below minimum number compared
#' loci
#'
#' @param scoresDf dataframe with scores from \emph{scores} object
#' @param minNumber threshold for minimum compared loci
#' @export
removeDamsBelowMinNumber <- function(scoresDf, minNumber) {
  scoresDf[(scoresDf$damNumLociCompared) < minNumber,  ]
}
