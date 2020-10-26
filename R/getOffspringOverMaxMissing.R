#' Get offspring with greater than maximum missing loci
#'
#' @param scoresDf dataframe with scores from \emph{scores} object
#' @param thMissing threshold for maximum missing loci
#' @export
getOffspringOverMoxMissing <- function(scoresDf, thMissing) {
  scoresDf$offspring[(scoresDf$invalidLoci * 100.0 / scoresDf$nAlleles) >
                       thMissing]
}