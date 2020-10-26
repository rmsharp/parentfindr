#' Remove sires with greater than maximum missing loci
#'
#' @param scoresDf dataframe with scores from \emph{scores} object
#' @param thMissing threshold for maximum missing loci
#' @export
removeSiresOverMoxMissing <- function(scoresDf, thMissing) {
  scoresDf[(scoresDf$sireMissingLoci * 100.0 / scoresDf$sireNAlleles) <=
                       thMissing, ]
}