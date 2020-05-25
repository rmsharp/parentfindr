#' Collect all the scores for possible parents for an offspring.
#'
#' @description This takes a single offspring and a list of potential dams and
#' a list of potential dams and calculates the number of loci with
#' alleles \code{missingLoci} for each sire and dam, the number of
#' \code{invalidLoci}
#' loci for the offspring. Note: \code{invalidLoci} loci for the offspring are
#' defined the same as \code{missingLoci} loci for potential parents; they are
#' loci with no observed alleles.
#'
#' @param kidId Character vector with the \code{refId} of the offspring.
#' @param damIds Character vector of \code{refId} values corresponding to
#' possible dams for the offspring.
#' @param sireIds Character vector of \code{refId} values corresponding to
#' possible sires for the offspring.
#' @param animalAlleles List with all allele information for all animals.
#' @export
collectTrioScores <- function(kidId, damIds, sireIds, animalAlleles) {
  kid <- animalAlleles[[kidId]]
  scores <- list()
  for (damId in damIds) {
    dam <- animalAlleles[[damId]]
    scores[[damId]] <- computeScores(dam, kid)
    dam[["scores"]] <- scores[[damId]]
    for (sireId in sireIds) {
      sire <- animalAlleles[[sireId]]
      scores[[damId]][[sireId]] <- computeScores(sire, kid, dam)
    }
    scores[[damId]] <- sortScores(scores[[damId]])
  }

  scores <- sortScores(scores)
  scores
}