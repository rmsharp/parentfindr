#' Get the names in a named sublist nested at any depth within the list
#' provided.
#'
#' @return A character vector of names found.
#'
#' @param x The list to be searched
#' @param nodeName The node name within the list for which the names are sought
#' @export
getSublist <- function(x, nodeName) {

  if (is.element(nodeName, names(x))) {
    return(x)
  } else {
    for (subX in names(x)) {
      getSublist(x[[subX]], nodeName)
    }
  }
}
