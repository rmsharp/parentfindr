#' Copyright(c) 2020 R. Mark Sharp
#' This file is part of parentfindr
library(testthat)
library(parentfindr)
context("getAnimalAllelesDfFromExcel")

test_that("getAnimalAllelesDfFromExcel reads Excel files.", {
  animalAllelesDf <-
    getAnimalAllelesDfFromExcel(
      alleleFile = system.file("testdata", "snp-animal-alleles.xlsx",
                               package = "parentfindr"),
      dateType = "YYYYMMDD")
  expect_equal(length(animalAllelesDf), 31)
  expect_equal(names(animalAllelesDf),
               c("43336", "43575", "44484", "43238", "44709", "43582", "44720",
                  "43705", "44634", "48575", "43545", "44638", "43644", "44662",
                  "43927", "43601", "44540", "44696", "43383", "48858", "48764",
                  "47680", "48741", "48651", "48642", "48851", "43307", "47728",
                  "48955", "47520", "48799"))
  expect_equal(animalAllelesDf$`43336`$birthDate,
               structure(13997, class = "Date"))
})
