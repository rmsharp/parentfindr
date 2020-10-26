## ----setup, include=FALSE-----------------------------------------------------
knitr::opts_chunk$set(echo = TRUE)
library(parentfindr)
library(rmsutilityr)


## ----define-allele-and-trio-filenames-----------------------------------------
alleleFile <- "../inst/testdata/snp-animal-alleles.xlsx"
triosFile <- "../inst/testdata/snp-potential-trios.xlsx"
#alleleFile <- "inst/testdata/snp-animal-alleles.txt"
#triosFile <- "inst/testdata/snp-potential-trios.txt"
#alleleFile <- "inst/testdata/str-animal-alleles.txt"
#triosFile <- "inst/testdata/str-potential-trios.txt"
#alleleFile <- "inst/testdata/str-animal-alleles.xlsx"
#triosFile <- "inst/testdata/str-potential-trios.txt"
alleleFile <- "../inst/testdata/str-animal-alleles_rms.xlsx"
triosFile <- "../inst/testdata/str-potential-trios.txt"


## ----set-up-test-data---------------------------------------------------------
  minNumber <- 4
  maxDiscrepant <- 4
  thMissing <- 4
  thDiscrepant <- 4
  microsatellites <- TRUE
  siresFirst <- FALSE
  selDiscrepant <- TRUE
  nAlleles <- 0
  dateType = "YYYYMMDD" # is one of c("YYYYMMDD", "mm/dd/YYYY")
  firstParentType <- "dams" # is one of c("dames", "sires")


## ----read-in-example-data, echo=TRUE------------------------------------------
trios <- getTrios(triosFile)
animalAlleles <- getAnimalAlleles(alleleFile, dateType)


## ----calculate-scores---------------------------------------------------------
scores <- getScores(trios, animalAlleles)
scoresDf <- makeScoresDf(scores, firstParentType)


## ----remove-offspring-maxMissing----------------------------------------------
offspringToRemove <- getOffspringOverMoxMissing(scoresDf, thMissing)
scoresDf <- excludeOffspring(offspringToRemove, scoresDf)


## ----remove-offspring-no-dam--------------------------------------------------
offspringToRemove <- getOffspringNoDam(trios)
scoresDf <- excludeOffspring(offspringToRemove, scoresDf)

offspringToRemove <- getOffspringNoSire(trios)
scoresDf <- excludeOffspring(offspringToRemove, scoresDf)


## ----remove-dams-maxMissing-maxUnused-----------------------------------------
scoresDf  <- removeDamsOverMaxMissing(scoresDf, thMissing)


## ----remove-dam-maxDiscrepant-------------------------------------------------
scoresDf <- removeDamsOverMaxDiscrepant(scoresDf, thDiscrepant)



## ----remove-sires-maxMissing-maxUnused----------------------------------------
scoresDf <- removeSiresOverMoxMissing(scoresDf, thMissing)


## ----remove-sires-maxDiscrepant-----------------------------------------------
scoresDf <- removeSiresOverMoxDiscrepant(scoresDf, thDiscrepant)


