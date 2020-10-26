#' Remove dams with greater than maximum missing loci
#'
#' @param scoresDf dataframe with scores from \emph{scores} object
#' @param thMissing threshold for maximum missing loci
#' @export
removeDamsOverMaxMissing <- function(scoresDf, thMissing) {
  scoresDf[(scoresDf$damMissingLoci * 100.0 / scoresDf$damNAlleles) <=
                       thMissing, ]
}
