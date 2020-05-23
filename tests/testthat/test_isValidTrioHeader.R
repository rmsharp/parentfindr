#' Copyright(c) 2020 R. Mark Sharp
#' This file is part of parentfindr
context("isValidTrioHeader")
library(testthat)
test_that("isValidTrioHeader returns FALSE for bad headers", {
  expect_equal(getPotentialTriosFileHeaders(),
               c("OFFSPRING", "DAMS", "SIRES"))
})
