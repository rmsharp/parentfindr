#' Create results report for parentfindr
#'
#'
#' Exclusion Parentage Report: Wed May 02 16:33:23 CDT 2012
createParentFindrReport <- function() {
  config <- getParentfindrConfig(TRUE)
  header <- stri_c("Exclusion Parentage Report: ", Sys.time())

  parameters <- stri_c(
    "***Parameters***\\n",
    "Maximum missing/untestable locus percent per individual: ",
    config$thMissing, "\\n",
    "Maximum discrepant/untestable locus percent per individual: ",
    config$maxDiscrepant, "\\n",
    "Input Animals to Marker Allele values file ",
    config$alleleFile,
    "Input Potential Trios file: ",
    config$triosFile,
    "\\n")

  summary <- stri_c(
    "***Summary***\\n",
    7,
    " Offspring in the input file\\n",
    7,
    " resolved to one dam and one sire\\n",
    0,
    " resolved to multiple dams and/or sires\\n",
    0,
    " did not resolve to a valid offspring\\n",
    0,
    " did not resolve to a valid dam\\n",
    0,
    " did not resolve to a valid sire\\n",
    96,
    " Markers provided\\n")
  calls <- stri_c(

  )
  multipleSireAndDams <- stri_c(

  )
  errors <- stri_c(

  )
  definitions <- stri_c(
    "***Definitions***\\n",
    "Calls: the section of the report for trios, where given the current ",
    "threholds and data the offspring resolved to one sire and one dam.\\n",
    "Type: The individual's role in the would-be trio.\\n",
    "ID: the individual's ID as used in the input files.\\n",
    "discrep: the number of discrepancies, where the dam could not match to a ",
    "child allele, or where the sire could not match after evaluating the dam.",
    "\\n",
    "#concord: the number of concordant loci.\\n",
    "%concord: the number of concordant loci as a percentage of the loci that ",
    "were recognizable in both parent and offspring.\\n",
    "missing/missing markers: the number of loci that had one or more ",
    "unrecognizable allele values.\\n",
    "unused: the number of recognizable locus values in the individual that ",
    "had a missing corresponding locus in the offspring.\\n",
    "total: discrep+concord+missing+unused, should equal the number of ",
    "expected markers in the file.\\n")
}