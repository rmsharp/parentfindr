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
  animalAlleleLines <- readLines(con = alleleFile,
                                  warn = FALSE)
  animalAlleles <- getAnimalAlleles(animalAlleleLines,
                                    dateType = "YYYYMMDD")[[1]]
  alleles <- animalAlleles$alleles

  expect_equal(countMissing(alleles), 1)
})
