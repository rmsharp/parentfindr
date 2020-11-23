#' getParentfindrConfigFileName returns the configuration file name appropriate
#' for the system.
## Copyright(c) 2017-2020 R. Mark Sharp
## This file is part of nprcgenekeepr
#'
#' @return Character vector with expected configuration file
#'
#' @param sysInfo object returned by Sys.info()
#' @examples
#' \donttest{
#' library(parentfindr)
#' sysInfo <- Sys.info()
#' config <- getParentfindrConfigFileName(sysInfo)
#' }
#' @importFrom stringi stri_detect_fixed
#' @export
getParentfindrConfigFileName <- function(sysInfo) {
  if (stri_detect_fixed(toupper(sysInfo[["sysname"]]), "WIND")) {
    homeDir <- paste0(gsub('\\\\', '/', Sys.getenv("HOME")), "/")
    configFile <- paste0(homeDir, "parentfindr_config")
  } else {
    homeDir <- paste0("~/")
    configFile <- paste0(homeDir, "parentfindr_config")
  }
  c(homeDir = homeDir, configFile = configFile)
}
