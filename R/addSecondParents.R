#' Make first parent data.frame object for dams or sires portion of the score
#' object
#'
#' @param id progeny ID
#' @param secondParentType character vector of length one with one of \emph{dams}
#'                     or \emph{sires}.
#' @param columnNames character vector of columns to include from \code{scores}
#' in dataframe
#' @param firstParents character vector of parent IDs of gender firstParentType
#' @param scores list object with a comparison information for all trio
#'               combinations.
#' @export
addSecondParents <- function(id, firstParentDf, secondParentType,
                             columnNames, scores) {
  firstParentType <- ifelse(secondParentType == "dams", "sires", "dams")
  firstParentCol <- ifelse(firstParentType == "dams", "dam", "sire")
  firstParentIdCol <- ifelse(secondParentType == "dams", "sire", "dam")
  secondParentIdCol <- ifelse(secondParentType == "dams", "dam", "sire")
  combinedDf <- data.frame()
  for (firstParent in firstParentDf[[firstParentIdCol]]) {
    dFRow <- data.frame(firstParentDf[
      firstParentDf[[firstParentCol]] == firstParent, ],
      stringsAsFactors = FALSE)
    for (secondParent in getSecondParents(id, firstParent, firstParentType,
                                            scores) ) {
      combinedDf <-
        rbind(combinedDf,
              cbind(dFRow,
                    getSecondParentScores(id, firstParent, secondParent,
                                          firstParentType, columnNames,
                                          scores)))
    }
  }
  names(combinedDf) <- c("progeny", firstParentIdCol, columnNames,
                         secondParentIdCol, columnNames)
  combinedDf
}