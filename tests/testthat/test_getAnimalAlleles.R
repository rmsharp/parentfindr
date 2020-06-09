#' Copyright(c) 2020 R. Mark Sharp
#' This file is part of parentfindr
library(testthat)
context("getAnimalAlleles")
library(parentfindr)
library(stringi)
test_that("getAnimalAlleles correctly extracts data CSV file", {
  alleleFile <- system.file("testdata", "snp-animal-alleles.txt",
                            package = "parentfindr")
  animalAlleles <- getAnimalAlleles(alleleFile, dateType = "YYYYMMDD")
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
test_that("getAnimalAlleles correctly extracts data from Excel file", {
  alleleFile <- system.file("testdata", "snp-animal-alleles.xlsx",
                            package = "parentfindr")
  animalAlleles <- getAnimalAlleles(alleleFile, dateType = "YYYYMMDD")
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
test_that(
  paste0("getAnimalAlleles provides informative error messages and ",
         "stop when a path to a non-existent file is provided."), {
  alleleFile <- system.file("testdata", "snp-animal-alleles.csv",
                            package = "parentfindr")
  expect_error(getAnimalAlleles(alleleFile, dateType = "YYYYMMDD"),
               paste0("The animal allele file cannot be found. ",
                      "The file name provided is"))
                 })
