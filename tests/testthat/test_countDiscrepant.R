#' Copyright(c) 2020 R. Mark Sharp
#' This file is part of parentfindr
context("countDiscrepantLoci")
library(testthat)
library(stringi)
test_that("43705 correctly counts missing loci data", {
  alleleFile <- system.file("testdata", "snp-animal-alleles.txt",
                            package = "parentfindr")
  # animalAlleleLines <- read.table(file = alleleFile,
  #                                 header = FALSE,
  #                                 colClasses = character(),
  #                                 stringsAsFactors = FALSE)
  offspringId <- "48575"
  potentialDamId <- "43336"
  potentialSireId <- "44709"
  animalAlleleLines <- readLines(con = alleleFile,
                                  warn = FALSE)
  animalAlleles <- getAnimalAlleles(animalAlleleLines,
                                    dateType = "YYYYMMDD")
  kid <- animalAlleles[[offspringId]]
  dam <- animalAlleles[[potentialDamId]]
  sire <- animalAlleles[[potentialSireId]]
  discrepantLoci <- countDiscrepantLoci(dam, kid)
  list(kid = kid$refId, pkLMatch = discrepantLoci$pkMatch$pkLMatch,
       pkRMatch = discrepantLoci$pkMatch$pkRMatch)
  dam$discrepantLoci <- discrepantLoci$discrepantLoci
  ## The current offspring has an NA value in the first locus and thus test
  ## handling NA values. Make sure this test is not lost and it would be better
  ## to make it explicit.
  expect_equal(dam$discrepantLoci, 12)
  expect_equal(countDiscrepantLoci(dam, kid)$discrepantLoci, 12)

})
