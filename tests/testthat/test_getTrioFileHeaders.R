#' Copyright(c) 2020 R. Mark Sharp
#' This file is part of parentfindr
context("getTriosFileHeaders")
library(testthat)
test_that("getTriosFileHeaders returns the correct vector", {
  expect_equal(getTriosFileHeaders(),
               c("OFFSPRING", "DAMS", "SIRES"))
})
