#' Make data.frame object from scores object
#'
#' @return A data.frame object containing the following columns
#'
#' \enumerate{
#' \item{\code{refId}} {The ID of the offspring}
#' \item{\code{damSex}} {The sex of the potential dam, which should always
#' be "F".}
#' \item{\code{damId}} {The ID of the potential dam}
#' \item{\code{damMissingLoci}} {The number of missing loci, which are the loci
#' without genotypes in the parent.}
#' \item{\code{damInvalidLoci}} {The number of invalid loci, which are the loci
#' missing in the offspring but present in the parent.}
#' \item{\code{damDiscrepantLoci}} {The number of discrepant loci, the
#' non-matching loci
#' in the parent in offspring where both have genotypes.}
#' \item{\code{damNumOfLociCompared}} {The number of loci compared}
#' \item{\code{damFractionNonDiscrepant}} {The fraction of non-discrepant loci,
#'   which is
#'   the ratio of (\code{numOfLociCompared} - \code{discrepantLoci}) /
#'   \code{numOfLociCompared}.}
#'   \item{\code{sire}} {A sire from the list of potential sires nested within
#'   the current
#'   dam of the list of dams nested inside the current offspring.}
#' \item{\code{sireSex}} {Sex of the sire, which should always be "M"}
#' \item{\code{sireMissingLoci}} {The number of missing loci, which are the
#'     loci
#'     without genotypes in the parent.}
#' \item{\code{sireInvalidLoci}} {The number of invalid loci, which are the
#'     loci missing
#'     in the offspring but present in the parent.}
#' \item{\code{sireDiscrepantLoci}} {The number of discrepant loci, the
#'     non-matching loci
#'     in the parent in offspring where both have genotypes.}
#' \item{\code{sireNumOfLociCompared}} {The number of loci compared}
#' \item{\code{sireFractionNonDiscrepant}} {The fraction of non-discrepant
#'     loci, which is
#'     the ratio of (\code{sireNumOfLociCompared} - \code{sireDiscrepantLoci}) /
#'     \code{sireNumOfLociCompared}.}
#' }
#' @param scores list object with a comparison information for all trio
#'               combinations.
#' @param firstParentType character vector of length one with one of \emph{dams}
#'                     or \emph{sires}.
#' @export
makeScoresDf <- function(scores, firstParentType) {
  secondParentType <- ifelse(firstParentType == "dams", "sires", "dams")
  columnNames <- c("nAlleles", "parentSex", "missingLoci", "invalidLoci",
                   "discrepantLoci",
                    "numOfLociCompared", "fractionNonDiscrepant")
  ids <- names(scores)
  combinedDf <- data.frame()
  for (id in ids) {
    if (names(scores[[id]]) != firstParentType)
      stop(paste0("scores object does not have '", firstParentType, "' at ",
                  "names(scores[[id]] where id == ", id, ". Has '",
                  names(scores[[id]]), "' instead."))
    firstParents <- names(scores[[id]][[firstParentType]])
    firstParentDf <-
      makeFirstParentDf(id, firstParentType, columnNames, firstParents, scores)
    combinedDf <- rbind(
      combinedDf,
      addSecondParents(id, firstParentDf, secondParentType,
                                   columnNames, scores))
  }
  combinedDf
}
