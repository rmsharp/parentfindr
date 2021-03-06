% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/getParentfindrConfig.R
\name{getParentfindrConfig}
\alias{getParentfindrConfig}
\title{Get parentfindr configuration}
\usage{
getParentfindrConfig(expectConfigFile = TRUE)
}
\arguments{
\item{expectConfigFile}{logical parameter when set to \code{FALSE}, no
configuration is looked for. Default value is \code{TRUE}.}
}
\value{
{A list of configuration settings used by the application.}

Currently this returns the following character strings in a named list.
\enumerate{
\item{     minNumber}{getParamDef(tokenList, "minNumber")},
\item{maxDiscrepant}{getParamDef(tokenList, "maxDiscrepant")},
\item{thMissing}{getParamDef(tokenList, "thMissing")},
\item{thDiscrepant}{getParamDef(tokenList, "thDiscrepant")},
\item{microsatellites}{getParamDef(tokenList, "microsatellites")},
\item{siresFirst}{getParamDef(tokenList, "siresFirst")},
\item{selectionTypeFewestDiscrepant}
{getParamDef(tokenList, "selectionTypeFewestDiscrepant")},
\item{nAlleles}{getParamDef(tokenList, "nAlleles")},
\item{dateType}{getParamDef(tokenList, "dateType")},
\item{firstParentType}{getParamDef(tokenList, "firstParentType")},
\item{alleleFile}{getParamDef(tokenList, "alleleFile")},
\item{triosFile}{getParamDef(tokenList, "triosFile")},
\item{sysname }{sysInfo[\link{"nAlleles"}]},
\item{release}{sysInfo[\link{"release"}]},
\item{version }{sysInfo[\link{"version"}]},
\item{nodename}{sysInfo[\link{"nodename"}]},
\item{machine}{sysInfo[\link{"machine"}]},
\item{login}{sysInfo[\link{"login"}]},
\item{user}{sysInfo[\link{"user"}]},
\item{effective_user}{sysInfo[\link{"effective_user"}]},
\item{homeDir}{config[\link{"homeDir"}]},
\item{configFile}{config[\link{"configFile"}])}
}
}
\description{
Get parentfindr configuration
}
\examples{
\donttest{
library(parentfindr)
getParentfindrConfig()
}
}
