#' Make first parent data.frame object for dams or sires portion of the score
#' object
#'
#' @param id progeny ID
#' @param firstParentType character vector of length one with one of \emph{dams}
#'                     or \emph{sires}.
#' @param columnNames character vector of columns to include from \code{scores}
#' in dataframe
#' @param firstParents character vector of parent IDs of gender firstParentType
#' @param scores list object with a comparison information for all trio
#'               combinations.
#' @export
makeFirstParentDf <- function(id, firstParentType, columnNames, firstParents,
                              scores) {
  firstParentDf <- data.frame()
  for (firstParent in firstParents) {
    firstParentDf <-
      rbind(firstParentDf,
            data.frame(
              id,
              firstParent,
              getFirstParentScores(id, firstParent, firstParentType,
                                   columnNames, scores),
              stringsAsFactors = FALSE))
  }

  names(firstParentDf) <- c("progeny",
                            ifelse(firstParentType == "dams", "dam", "sire"),
                            columnNames)
  firstParentDf
}
