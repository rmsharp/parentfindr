#' Scores a potential parent to a kid and optionally a previously scored parent.
#'
#' @return A list containing the offspring \code{refId}, the \code{sex} of the
#' potential parent that was scored, the \code{pkMatch} list, which contains
#' offspring's \code{refId} and the two logical vectors of left and right
#' allele comparison results between the potential parent and the offspring,
#' and finally it has the characer vector of text, which fully describes the
#' discrepancies with one discrepancy per element.
#'
#' @param parent A list with the all of the information from the animal allele
#' file representing one potential parent.
#' @param kid A list with the all of the information from the animal allele
#' file representing the potential offspring.
#' @param other A list with the all of the information from the animal allele
#' file representing one potential parent.
#' @export
computeScores <- function(parent, kid, other) {
  parentAlleles <- parent$alleles
  kidAlleles <- kid$alleles
  nAlleles <- length(kid$alleles)

  # ea.kidlmatch=(ea.left ==ka.left || ea.right==ka.left);
  # ea.kidrmatch=(ea.left ==ka.right || ea.right==ka.right);
  # if(!(ea.kidlmatch||ea.kidrmatch)){
  #   sb.append("discrepancy: locus: " + ea.disp + " "+  " OFFSPRING: "+
  #              ka.left+","+ka.right + " " + swp("DAM") + ": "+ ea.left +
  #              "," + ea.right + lf );
  #   e.discrep++;
  # }
  missingLoci <- 0
  invalidLoci <- 0
  discrepantLoci <- 0
  text <- character(0)
  pkLMatch <- pkRMatch <- rep(TRUE, length(parentAlleles))
  if (missing(other)) {
    for (i in seq_along(parentAlleles)) {
      pAllele <- parentAlleles[[i]]
      kAllele <- kidAlleles[[i]]
      if (any(is.na(pAllele)))
        missingLoci <- missingLoci + 1
      else if (any(is.na(kAllele))) {
        invalidLoci <- invalidLoci + 1
      } else {
        pkLMatch[i] <- pAllele[1] == kAllele[1] || pAllele[2] == kAllele[1]
        pkRMatch[i] <- pAllele[1] == kAllele[2] || pAllele[2] == kAllele[2]
        if (!(pkLMatch[i] || pkRMatch[i])) {
          discrepantLoci <- discrepantLoci + 1
          text <- c(text,
                    paste0("discrepancy: locus: ", names(parentAlleles)[i],
                           " OFFSPRING: ",
                           kAllele[1], ", ", kAllele[2],
                           ifelse(parent$sex == "M", "  SIRE: ", "  DAM: "),
                           pAllele[1], ", ", pAllele[2]))
        }
      }
    }
  } else {
    for (i in seq_along(parentAlleles)) {
      pAllele <- parentAlleles[[i]]
      kAllele <- kidAlleles[[i]]
      if (any(is.na(pAllele)))
        missingLoci <- missingLoci + 1
      else if (any(is.na(kAllele))) {
        invalidLoci <- invalidLoci + 1
      } else {
        okLMatch <- other$scores$pkMatch$pkLMatch[i]
        okRMatch <- other$scores$pkMatch$pkRMatch[i]
        if (okLMatch == okRMatch) {
          pkLMatch[i] <- pAllele[1] == kAllele[1] || pAllele[2] == kAllele[1]
          pkRMatch[i] <- pAllele[1] == kAllele[2] || pAllele[2] == kAllele[2]
        } else if (okLMatch) {
          pkLMatch[i] <- FALSE
          pkRMatch[i] <- pAllele[1] == kAllele[2] || pAllele[2] == kAllele[2]
        } else if (okRMatch) {
          pkLMatch[i] <- pAllele[1] == kAllele[1] || pAllele[2] == kAllele[1]
          pkRMatch[i] <- FALSE
        }
        if (!(pkLMatch[i] || pkRMatch[i])) {
          discrepantLoci <- discrepantLoci + 1
          text <- c(text,
                    paste0("discrepancy: locus: ", names(parentAlleles)[i],
                           " OFFSPRING: ",
                           kAllele[1], ", ", kAllele[2],
                           ifelse(parent$sex == "M", "  SIRE: ", "  DAM: "),
                           pAllele[1], ", ", pAllele[2]))
        }
      }
    }
  }
  ## cAlleleNumber <- length(alleles) - (missingLoci + invalidLoci)
  ## percentNonDiscrepant <- (cAlleleNumber - discrepantLoci)/cAlleleNumber
  numLoci <- length(parentAlleles)
  numLociCompared <- numLoci - (missingLoci + invalidLoci)
  fractionNonDiscrepant <- (numLociCompared - discrepantLoci) /
    numLociCompared
  pkMatch <- list(kid = kid$refId, pkLMatch = pkLMatch,
                  pkRMatch = pkRMatch)
  list(refId = kid$refId,
       nAlleles = nAlleles,
       parentSex = parent$sex,
       missingLoci = missingLoci,
       invalidLoci = invalidLoci,
       discrepantLoci = discrepantLoci,
       numLociCompared = numLociCompared,
       fractionNonDiscrepant = fractionNonDiscrepant,
       pkMatch = pkMatch, text = text)
}
