#' Get first parent scores from scores object
#'
#' @param id offspring ID
#' @param firstParent first parent ID
#' @param firstParentType character vector of length one with one of \emph{dams}
#'                     or \emph{sires}.
#' @param columnNames character vector of columns to include from \code{scores}
#' in dataframe
#' @param scores list object with a comparison information for all trio
#'               combinations.
#' @export
getFirstParentScores <- function(id, firstParent, firstParentType,
                                  columnNames, scores) {
  scores[[id]][[firstParentType]][[firstParent]][columnNames]
}
