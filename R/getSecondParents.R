#' Get second parent IDs
#'
#' @param id offspring ID
#' @param firstParent first parent ID
#' @param firstParentType character vector of length one with one of \emph{dams}
#'                     or \emph{sires}.
#' @param scores list object with a comparison information for all trio
#'               combinations.
#' @export
getSecondParents <- function(id, firstParent, firstParentType, scores) {
  secondParentType <- ifelse(firstParentType == "dams", "sires", "dams")
  names(scores[[id]][[
    firstParentType]][[firstParent]][[secondParentType]])
}