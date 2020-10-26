#' Remove rows from scoresDf with sires having greater than maximum discrepant
#' loci
#'
#' @param scoresDf dataframe with scores from \emph{scores} object
#' @param thDiscrepant threshold for maximum missing loci
#' @export
removeSiresOverMoxDiscrepant <- function(scoresDf, thDiscrepant) {
  scoresDf[(scoresDf$sireDiscrepantLoci * 100.0 / scoresDf$sireNAlleles) <=
                  thDiscrepant, ]
}