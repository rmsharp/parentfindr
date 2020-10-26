---
title: "Parent Exclusion"
author: "R. Mark Sharp"
date: "October 21, 2020"
output: 
   - rmarkdown::pdf_document
   - rmarkdown::latex_document
   - rmarkdown::html_vignette
   - rmarkdown::word_document
vignette: >
  %\VignetteEngine{knitr::knitr}
  %\VignetteIndexEntry{Parent Exclusion}
  %\usepackage[UTF-8]{inputenc}
---



## Input of Allele File and Trios File

Define allele and trios file names.


```r
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
```

## Data Format and Questions

I have been reading through the code and have a question regarding how missing 
loci (alleles) and invalid loci (alleles) are calculated.
Only the left of the left and right pairs of the locus geneotypes are used for 
scoring, which makes me assume that if the left one is missing, 
both are missing. Is that correct?
A parent's locus is counted as __missing__ if it does not have a value in the 
left allele even if this locus is missing for the offspring.
A parent's locus is counted as __invalid__ if it does have a value in the left 
allele but the offspring does not have a value in the left allele.
This allows the calculation of the denominator for the percent non-discrepant 
alleles.

## Definitions

Calls
 : the section of the report for trios, where given the current threholds and 
   data the offspring resolved to one sire and one dam.

Type
 : The individual's role in the would-be trio.
  
ID
 : the individual's ID as used in the input files.
 
discrep
 : the number of discrepancies, where the dam could not match to a child allele,
   or where the sire could not match after evaluating the dam.
 
concord
 : the number of concordant loci as a percentage of the loci that were 
   recognizable in both parent and offspring.

missing/missing markers
 : the number of loci that had one or more unrecognizable allele values.
 
unused
 : the number of recognizable locus values in the individual that had a missing
   corresponding locus in the offspring.
   
total
 : discrep+concord+missing+unused, should equal the number of expected markers 
 in the file.
    

## Hard Coded Test Data


```r
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
```




```r
trios <- getTrios(triosFile)
animalAlleles <- getAnimalAlleles(alleleFile, dateType)
```


```r
scores <- getScores(trios, animalAlleles)
scoresDf <- makeScoresDf(scores, firstParentType)
```

Remove offspring greater than maxium percent missing
(100 * invalid loci / number of alleles). 
The figure wording on the consortium's site is wrong. 
It has "offspring below max % missing threshold" while the code
has offspring below or equal to max % missing threshold.


```r
offspringToRemove <- getOffspringOverMoxMissing(scoresDf, thMissing)
scoresDf <- excludeOffspring(offspringToRemove, scoresDf)
```

Remove offspring without at least one dam and at least one sire.


```r
offspringToRemove <- getOffspringNoDam(trios)
scoresDf <- excludeOffspring(offspringToRemove, scoresDf)

offspringToRemove <- getOffspringNoSire(trios)
scoresDf <- excludeOffspring(offspringToRemove, scoresDf)
```

Remove dams above the maximum % missing or unused threshold.


```r
scoresDf  <- removeDamsOverMaxMissing(scoresDf, thMissing)
```

Remove dams above maximum percent discrepancy threshold.


```r
scoresDf <- removeDamsOverMaxDiscrepant(scoresDf, thDiscrepant)
```

Remove sires above the maximum percent missing or unused threshold.


```r
scoresDf <- removeSiresOverMoxMissing(scoresDf, thMissing)
```

Remove sires above maximum percent discrepancy threshold.



```r
scoresDf <- removeSiresOverMoxDiscrepant(scoresDf, thDiscrepant)
```
