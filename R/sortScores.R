#' Sorts the \code{scores} object
#'
#' @return A sorted \code{scores} object
#'
#' The \code{scores} object can contain the scores of a single potential parent
#' a potential mates or scores of multiple potential parents and their
#' potential mates.
#'
#' @param scores A list object that can contain the scores of a single potential
#' parent a potential mates or scores of multiple potential parents and their
#' potential mates.
#' @export
sortScores <- function(scores) {
  discrepancyScores <- list()
  for (i in seq_along(scores$dams)) {
    sDiscrepancyScores <- list()
    for (j in seq_along(scores$dams[[i]]$sires)) {
      sDiscrepancyScores[[scores$dams[[i]]$sires[[j]]$refId]] <-
        scores$dams[[i]]$sires[[j]]$fractionNonDiscrepant
    }
    discrepancyScores[[names(scores$dams)[[i]]]] <-
      list(refId = scores$dams[[i]]$refId,
           sex = scores$dams[[i]]$parentSex,
           fractionNonDiscrepant = scores$dams[[i]]$fractionNonDiscrepant,
           sDiscrepancyScores = sDiscrepancyScores)

  }
  discrepancyScores
}
