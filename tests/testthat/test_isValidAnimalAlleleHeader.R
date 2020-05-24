#' Copyright(c) 2020 R. Mark Sharp
#' This file is part of parentfindr
context("isValidAnimalAlleleHeader")
library(testthat)
test_that("isValidAnimalAlleleHeader returns FALSE for bad headers", {
  expect_equal(toupper(getAnimalAlleleFileHeaders()),
               toupper(c("refId", "sex", "birthDate", "exitDate", "comments")))
})
