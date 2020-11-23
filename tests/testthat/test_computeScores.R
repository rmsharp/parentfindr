#' Copyright(c) 2017-2020 R. Mark Sharp
#' This file is part of parentfindr
context("computeScores")
library(testthat)
trios <- parentfindr::snpTrios
animalAlleles <- parentfindr::snpAnimalAlleles

kidId <- names(trios)[1]
kid <- animalAlleles[[kidId]]
damIds <- trios[[kidId]]$dams
damId <- damIds[1]
dam <- animalAlleles[[damId]]
sireIds <- trios[[kidId]]$sires
sireId <- sireIds[1]
sire <- animalAlleles[[sireId]]
parent <- dam

snpScores <- computeScores(parent, kid)
test_that("computeScores computes dam's SNP scores correctly", {
  expect_equal(snpScores$refId,"48575")
  expect_equal(snpScores$nAlleles, 96)
  expect_equal(snpScores$parentSex, "F")
  expect_equal(snpScores$missingLoci, 1)
  expect_equal(snpScores$discrepantLoci, 12)
  expect_equal(snpScores$text[[1]],
               "discrepancy: locus: PAX32123 OFFSPRING: 3, 3  DAM: 1, 1")
})
scores <- list()
scores[["dams"]][[damId]] <- snpScores
dam[["scores"]] <- snpScores

snpScores <- computeScores(sire, kid, dam)
test_that("computeScores computes sires's SNP scores correctly", {
  expect_equal(snpScores$refId,"48575")
  expect_equal(snpScores$nAlleles, 96)
  expect_equal(snpScores$parentSex, "M")
  expect_equal(snpScores$missingLoci, 1)
  expect_equal(snpScores$discrepantLoci, 10)
  expect_equal(snpScores$text[[1]],
               "discrepancy: locus: DRD13129 OFFSPRING: 4, 4  SIRE: 1, 1")
})
