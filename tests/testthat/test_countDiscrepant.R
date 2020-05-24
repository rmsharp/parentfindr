#' Copyright(c) 2020 R. Mark Sharp
#' This file is part of parentfindr
context("countMissing")
library(testthat)
library(stringi)
test_that("countMissing correctly counts missing loci data", {
  alleleFile <- system.file("testdata", "snp-animal-alleles.txt",
                            package = "parentfindr")
  # animalAlleleLines <- read.table(file = alleleFile,
  #                                 header = FALSE,
  #                                 colClasses = character(),
  #                                 stringsAsFactors = FALSE)
  offspringId <- "48575"
  potentialDamId <- "43336"
  animalAlleleLines <- readLines(con = alleleFile,
                                  warn = FALSE)
  animalAlleles <- getAnimalAlleles(animalAlleleLines,
                                    dateType = "YYYYMMDD")
  kid <- animalAlleles[[offspringId]]
  dam <- animalAlleles[[potentialDamId]]
  expect_equal(countDiscrepant(dam, kid)$discrepant, 12)
})
