#' Get first parent IDs
#'
#' @param id offspring ID
#' @param firstParentType character vector of length one with one of \emph{dams}
#'                     or \emph{sires}.
#' @param scores list object with a comparison information for all trio
#'               combinations.
#' @export
getFirstParents <- function(id, firstParentType, scores) {
  names(scores[[id]][[firstParentType]])
}