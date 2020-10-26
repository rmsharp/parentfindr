#' Make first parent data.frame object for dams or sires portion of the score
#' object
#'
#' @param id offspring ID
#' @param firstParentType character vector of length one with one of \emph{dams}
#'                     or \emph{sires}.
#' @param columnNames character vector of columns to include from \code{scores}
#' in dataframe
#' @param firstParents character vector of parent IDs of gender firstParentType
#' @param scores list object with a comparison information for all trio
#'               combinations.
#' @importFrom stringi stri_c
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
  parentCol <- ifelse(firstParentType == "dams", "dam", "sire")
  columnNames <- stri_c(parentCol, capitalizeFirstLetter(columnNames))
  names(firstParentDf) <- c("offspring",
                            parentCol,
                            columnNames)
  firstParentDf
}
