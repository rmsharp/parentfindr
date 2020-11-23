## ----setup, include=FALSE-----------------------------------------------------
knitr::opts_chunk$set(echo = TRUE)
library(parentfindr)
library(rmsutilityr)
library(stringi)
library(xtable)


## ----define-allele-and-trio-filenames-----------------------------------------
alleleFile <- "../inst/testdata/snp-animal-alleles.xlsx"
triosFile <- "../inst/testdata/snp-potential-trios.xlsx"
#alleleFile <- "inst/testdata/snp-animal-alleles.txt"
#triosFile <- "inst/testdata/snp-potential-trios.txt"
#alleleFile <- "inst/testdata/str-animal-alleles.txt"
#triosFile <- "inst/testdata/str-potential-trios.txt"
#alleleFile <- "inst/testdata/str-animal-alleles.xlsx"
#triosFile <- "inst/testdata/str-potential-trios.txt"
#alleleFile <- "../inst/testdata/str-animal-alleles_rms.xlsx"
#triosFile <- "../inst/testdata/str-potential-trios.txt"


## ----set-up-test-data---------------------------------------------------------
  parentfindrParms <- list(
    minNumber = 4,
    maxDiscrepant = 4,
    thMissing = 4,
    thDiscrepant = 4,
    microsatellites = TRUE,
    selectionTypeFewestDiscrepant = TRUE, # Not used yet
    dateType = "YYYYMMDD", # is one of c("YYYYMMDD", "mm/dd/YYYY")
    firstParentType = "dams", # is one of c("dames", "sires")
    alleleFile = alleleFile,
    triosFile = triosFile)
  
  parentfindrParms <- getParentfindrConfig(TRUE)
  

## ----read-in-example-data, echo=TRUE------------------------------------------
trios <- getTrios(parentfindrParms$triosFile)
animalAlleles <- getAnimalAlleles(parentfindrParms$alleleFile,
                                  parentfindrParms$dateType)


## ----calculate-scores---------------------------------------------------------
scores <- getScores(trios, animalAlleles)
scoresDf <- makeScoresDf(scores, parentfindrParms$firstParentType)


## ----remove-offspring-maxMissing----------------------------------------------
offspringToRemove <- getOffspringOverMoxMissing(scoresDf, 
                                                 parentfindrParms$thMissing)
scoresDf <- excludeOffspring(offspringToRemove, scoresDf)


## ----remove-offspring-no-dam--------------------------------------------------
offspringToRemove <- getOffspringNoDam(trios)
scoresDf <- excludeOffspring(offspringToRemove, scoresDf)

offspringToRemove <- getOffspringNoSire(trios)
scoresDf <- excludeOffspring(offspringToRemove, scoresDf)


## ----remove-dams-maxMissing-maxUnused-----------------------------------------
scoresDf  <- removeDamsOverMaxMissing(scoresDf, parentfindrParms$thMissing)


## ----create-descriptive-text-for-removals-------------------------------------
if (parentfindrParms$selectionTypeFewestDiscrepant) {
  damRemovalText <- stri_c(
    "The selection type is 'Fewest Discrepant'. Thus,
    'removeDamsOverMaxDiscrepant()' will be called in the code block below.\n",
    "\nThis will remove dams with more than ", 
    parentfindrParms$thDiscrepant, " percent discrepant loci.")
  sireRemovalText <- stri_c(
    "The selection type is 'Fewest Discrepant'. Thus,
    'removeSiresOverMaxDiscrepant()' will be called in the code block below.\n",
    "\nThis will remove sires with more than ", 
    parentfindrParms$thDiscrepant, " percent discrepant loci.")
} else {
  damRemovalText <- stri_c(
    "The selection type is 'Most Concordant'. Thus,
    'removeDamsBelowMinNumber()' will be called in the code block below.\n",
    "\nThis will remove dams with less than ", 
    parentfindrParms$minNumber, " percent concordent loci.")
  sireRemovalText <- stri_c(
    "The selection type is 'Most Concordant'. Thus,
    'removeSiresBelowMinNumber()' will be called in the code block below.\n",
    "\nThis will remove sires with less than ", 
    parentfindrParms$minNumber, " percent concordent loci.")
}

## ----remove-dams--------------------------------------------------------------
if (parentfindrParms$selectionTypeFewestDiscrepant) {
  scoresDf <- removeDamsOverMaxDiscrepant(scoresDf,
                                          parentfindrParms$thDiscrepant)
} else {
  scoresDf <- removeDamsBelowMinNumber(scoresDf,
                                       parentfindrParms$minNumber)
}



## ----remove-sires-------------------------------------------------------------
scoresDf <- removeSiresOverMoxMissing(scoresDf, parentfindrParms$thMissing)
if (parentfindrParms$selectionTypeFewestDiscrepant) {
  scoresDf <- removeSiresOverMoxMissing(scoresDf,
                                        parentfindrParms$thDiscrepant)
} else {
  scoresDf <- removeSiresBelowMinNumber(scoresDf,
                                        parentfindrParms$minNumber)
}



## ----print-scoresDf, include = TRUE, results = 'asis'-------------------------
xtable(scoresDf)


