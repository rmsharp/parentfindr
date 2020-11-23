#' Get parentfindr configuration
#'
## Copyright(c) 2017-2020 R. Mark Sharp
## This file is part of parentfindr
#' @return{A list of configuration settings used by the application.}
#'
#' Currently this returns the following character strings in a named list.
#' \enumerate{
#'   \item{     minNumber}{getParamDef(tokenList, "minNumber")},
#'   \item{maxDiscrepant}{getParamDef(tokenList, "maxDiscrepant")},
#'   \item{thMissing}{getParamDef(tokenList, "thMissing")},
#'   \item{thDiscrepant}{getParamDef(tokenList, "thDiscrepant")},
#'   \item{microsatellites}{getParamDef(tokenList, "microsatellites")},
#'   \item{siresFirst}{getParamDef(tokenList, "siresFirst")},
#'   \item{selectionTypeFewestDiscrepant}
#'   {getParamDef(tokenList, "selectionTypeFewestDiscrepant")},
#'   \item{nAlleles}{getParamDef(tokenList, "nAlleles")},
#'   \item{dateType}{getParamDef(tokenList, "dateType")},
#'   \item{firstParentType}{getParamDef(tokenList, "firstParentType")},
#'   \item{alleleFile}{getParamDef(tokenList, "alleleFile")},
#'   \item{triosFile}{getParamDef(tokenList, "triosFile")},
#'   \item{sysname }{sysInfo[["nAlleles"]]},
#'   \item{release}{sysInfo[["release"]]},
#'   \item{version }{sysInfo[["version"]]},
#'   \item{nodename}{sysInfo[["nodename"]]},
#'   \item{machine}{sysInfo[["machine"]]},
#'   \item{login}{sysInfo[["login"]]},
#'   \item{user}{sysInfo[["user"]]},
#'   \item{effective_user}{sysInfo[["effective_user"]]},
#'   \item{homeDir}{config[["homeDir"]]},
#'   \item{configFile}{config[["configFile"]])}
#'  }
#'
#' @examples
#' \donttest{
#' library(parentfindr)
#' getParentfindrConfig()
#' }
#' @param expectConfigFile logical parameter when set to \code{FALSE}, no
#' configuration is looked for. Default value is \code{TRUE}.
#' @import stringi
#' @export
getParentfindrConfig <- function(expectConfigFile = TRUE) {
  sysInfo <- Sys.info()
  config <- getParentfindrConfigFileName(sysInfo)

  if (file.exists(config[["configFile"]])) {
    lines <- readLines(config[["configFile"]], skipNul = TRUE)
    tokenList <- getTokenList(lines)
    list(
      minNumber = getParamDef(tokenList, "minNumber"),
      maxDiscrepant = getParamDef(tokenList, "maxDiscrepant"),
      thMissing = getParamDef(tokenList, "thMissing"),
      thDiscrepant = getParamDef(tokenList, "thDiscrepant"),
      microsatellites = getParamDef(tokenList, "microsatellites"),
      selectionTypeFewestDiscrepant =
        getParamDef(tokenList, "selectionTypeFewestDiscrepant"),
      nAlleles = getParamDef(tokenList, "nAlleles"),
      dateType = getParamDef(tokenList, "dateType"),
      firstParentType = getParamDef(tokenList, "firstParentType"),
      alleleFile = getParamDef(tokenList, "alleleFile"),
      triosFile = getParamDef(tokenList, "triosFile"),
      sysname  = sysInfo[["sysname"]],
      release = sysInfo[["release"]],
      version  = sysInfo[["version"]],
      nodename = sysInfo[["nodename"]],
      machine = sysInfo[["machine"]],
      login = sysInfo[["login"]],
      user = sysInfo[["user"]],
      effective_user = sysInfo[["effective_user"]],
      homeDir = config[["homeDir"]],
      configFile = config[["configFile"]])
  } else {
    if (expectConfigFile) {
      warning(paste0("The nprcgenekeepr configuration file is missing.\n",
                     "It is required when the LabKey API is to be used.\n",
                     "The file should be named: ",
                     config[["configFile"]], ".\n"))
    }
    list(minNumber = 4,
         maxDiscrepant = 4,
         thMissing = 4,
         thDiscrepant = 4,
         microsatellites = TRUE,
         selectionTypeFewestDiscrepant = TRUE,
         nAlleles = 0,
         dateType = "YYYYMMDD", # is one of c("YYYYMMDD", "mm/dd/YYYY"),
         firstParentType = "dams", # is one of c("dams", "sires")
         alleleFile = "../inst/testdata/str-animal-alleles_rms.xlsx",
         triosFile = "../inst/testdata/str-potential-trios.txt",
         sysname  = sysInfo[["sysname"]],
         release = sysInfo[["release"]],
         version  = sysInfo[["version"]],
         nodename = sysInfo[["nodename"]],
         machine = sysInfo[["machine"]],
         login = sysInfo[["login"]],
         user = sysInfo[["user"]],
         effective_user = sysInfo[["effective_user"]],
         homeDir = config[["homeDir"]],
         configFile = config[["configFile"]])
  }
}
