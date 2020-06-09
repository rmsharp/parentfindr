#' Copyright(c) 2020 R. Mark Sharp
#' This file is part of parentfindr
library(testthat)
library(parentfindr)
context("getAnimalAllelesDfFromCsv")

test_that(paste0("getAnimalAllelesDfFromCsv reads SNP-based allele ",
                   "file in CSV format."), {
  animalAllelesDf <-
    getAnimalAllelesDfFromCsv(
      alleleFile = system.file("testdata", "snp-animal-alleles.txt",
                               package = "parentfindr"),
      dateType = "YYYYMMDD")
  expect_equal(length(animalAllelesDf), 31)
  expect_equal(names(animalAllelesDf),
               c("43336", "43575", "44484", "43238", "44709", "43582", "44720",
                 "43705", "44634", "48575", "43545", "44638", "43644", "44662",
                 "43927", "43601", "44540", "44696", "43383", "48858", "48764",
                 "47680", "48741", "48651", "48642", "48851", "43307", "47728",
                 "48955", "47520", "48799"))
  expect_equal(animalAllelesDf$`43336`$sex, "F")
  expect_equal(animalAllelesDf$`43336`$birthDate,
               structure(13997, class = "Date"))
})
test_that(paste0("getAnimalAllelesDfFromCsv reads Microsatellite-based allele ",
                 "file in CSV format."), {
  animalAllelesDf <-
    getAnimalAllelesDfFromCsv(
      alleleFile = system.file("testdata", "str-animal-alleles.txt",
                               package = "parentfindr"),
      dateType = "YYYYMMDD")
  expect_equal(length(animalAllelesDf), 25)
  expect_equal(names(animalAllelesDf),
               c("AN1", "AN2", "AN3", "AN4", "AN5", "AN6", "AN7", "AN8", "AN9",
                 "AN10", "AN11", "AN12", "AN13", "AN14", "AN15", "AN16", "AN17",
                 "AN18", "AN19", "AN20", "AN21", "AN22", "AN23", "AN24", "AN25"
               ))
  expect_equal(animalAllelesDf$`AN5`$sex, "M")
  expect_equal(animalAllelesDf$`AN5`$birthDate,
               structure(NA_real_, class = "Date"))
})
