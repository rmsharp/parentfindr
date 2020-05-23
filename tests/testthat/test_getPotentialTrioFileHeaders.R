#' Copyright(c) 2020 R. Mark Sharp
#' This file is part of parentfindr
context("getPotentialTriosFileHeaders")
library(testthat)
test_that("getPotentialTriosFileHeaders returns the correct vector", {
  expect_equal(getPotentialTriosFileHeaders(),
               c("OFFSPRING", "DAMS", "SIRES"))
})
