#' Get second parent score from scores object
#'
#' @param id progeny ID
#' @param firstParent first parent ID
#' @param secondParent second parent ID
#' @param firstParentType character vector of length one with one of \emph{dams}
#'                     or \emph{sires}.
#' @param columnNames character vector of columns to include from \code{scores}
#' in dataframe
#' @param scores list object with a comparison information for all trio
#'               combinations.
#' @export
getSecondParentScores <- function(id, firstParent, secondParent,
                                  firstParentType, columnNames, scores) {
  secondParentType <- ifelse(firstParentType == "dams", "sires", "dams")
  secondParentIdCol <- ifelse(firstParentType == "dams", "sire", "dam")
  parentScores <-
    c(secondParent, scores[[id]][[firstParentType]][[firstParent]][[
      secondParentType]][[secondParent]][columnNames])
  names(parentScores) <- c(secondParentIdCol, columnNames)
  parentScores
}
