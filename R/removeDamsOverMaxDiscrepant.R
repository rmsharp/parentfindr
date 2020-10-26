#' Remove rows from scoresDf with dams having greater than maximum discrepant
#' loci
#'
#' @param scoresDf dataframe with scores from \emph{scores} object
#' @param thDiscrepant threshold for maximum missing loci
#' @export
removeDamsOverMaxDiscrepant <- function(scoresDf, thDiscrepant) {
  scoresDf[(scoresDf$damDiscrepantLoci * 100.0 / scoresDf$damNAlleles) <=
                 thDiscrepant,  ]
}
