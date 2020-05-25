#' Copyright(c) 2020 R. Mark Sharp
#' This file is part of parentfindr
context("getAnimalAlleles")
library(testthat)
library(stringi)
test_that("getAnimalAlleles correctly extracts data", {
  alleleFile <- system.file("testdata", "snp-animal-alleles.txt",
                            package = "parentfindr")
  # animalAlleleLines <- read.table(file = alleleFile,
  #                                 header = FALSE,
  #                                 colClasses = character(),
  #                                 stringsAsFactors = FALSE)
  animalAlleleLines <- readLines(con = alleleFile,
                                  warn = FALSE)
  animalAlleles <- getAnimalAlleles(animalAlleleLines, dateType = "YYYYMMDD")
  expect_equal(animalAlleles[[1]]$refId, "43336")
  expect_equal(animalAlleles[[31]][["refId"]], "48799")
  expect_equal(length(animalAlleles), 31)
  expect_true(all(is.na(animalAlleles[[1]]$alleles[["AGTR11303"]])))
  expect_equal(animalAlleles[[1]]$alleles[["AK53266"]], c("1", "1"))
  expect_equal(animalAlleles[[3]]$alleles[["AKAP33344"]],
                c("1", "1"))
  expect_equal(animalAlleles[[31]]$alleles[["X98874013.14.D8YOWMI02JQVIE"]],
               c("1", "1"))
  expect_equal(animalAlleles[[1]]$birthDate, as.Date("2008-04-28"))
})
