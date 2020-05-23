library(rmsutilityr)
library(stringi)
## final HTextfield ALLELEFILE= new HTextfield("Animals Allele File", "","Location of animal markers file");
## final HTextfield TRIOSFILE= new HTextfield("Potential Trios File", "","Location of the list of offspring and potential dams/sires");
alleleFile <- "inst/testdata/snp-animal-alleles.txt"
triosFile <- "inst/testdata/snp-potential-trios.txt"

## final HPullDown SELTYPE= new HPullDown("Selection Method",new String[]{"Fewest Discrepant","Most Concordant"}, "Select parent that has the minimum number of discrepancies or the greatest percentage of concordant alleles with the offspring.",true);
## final HPullDown DATETYPE= new HPullDown("Input date format",new String[]{"mm/dd/YYYY","YYYYMMDD"}, "mm/dd/YYYY is compatible with excel and etc, YYYYMMDD is the native pedsys format.",true);

setType <- "Fewest Discrepant"
dateType <- "YYYYMMDD"

## String[]{"maxdiscrepant="+MAXDISCREPANT.getvalue(),
## "minnumber="+MINNUMBER.getvalue(),
## "percentdiscrepant="+MAXDISCREPANTPCT.getvalue(),
## "percentmissing="+MAXMISSINGPCT.getvalue(),
## "siresfirst="+SIRESFIRST.getvalue(),
## "microsatellites="+MICROSATELLITES.getvalue(),
## "animalallelefile="+ALLELEFILE.getvalue(),
## "potentialTriosFile="+TRIOSFILE.getvalue(),
## "outfile="+outf,
## "callfile="+callf,
## "seltype="+SELTYPE.getvalue(),
## "datetype="+DATETYPE.getvalue()
## };

size <- as.matrix(NA, nrow = 270, ncol = 24, rownames.force = NA)
args <- list(maxDiscrepant,
             minNumber,
             percentDiscrepant,
             percentMissing,
             siresFirst,
             microSatellites,
             animalAllelefile,
             potentialTriosFile,
             outFile,
             callFile,
             selType,
             dateType)

exclusionParentage <- function(maxDiscrepant,
                               minNumber,
                               percentDiscrepant,
                               percentMissing,
                               siresFirst,
                               microSatellites,
                               animalAllelefile = alleleFile,
                               potentialTriosFile = triosFile,
                               outFile,
                               callFile,
                               selType,
                               dateType) {
  minNumber <- 4
  maxDiscrepant <- 4
  thMissing <- 4
  thDiscrepant <- 4
  microsatellites <- TRUE
  siresFirst <- FALSE
  selDiscrepant <- TRUE
  nAlleles <- 0

  animalAllele <- readLines(con = animalAllelefile, warn = FALSE)
  potentialTrios <- readLines(con = potentialTriosFile, warn = FALSE)
  if (!isValidTrioHeader(potentialTrios[1]))
    stop("Potential Trios File has invalid headers. Should have ",
         get_and_or_list(getPotentialTriosFileHeaders()), ".")

  if (!isValidAnimalAlleleHeader[1]) {
      stop("Animal allele ile has invalid headers. First three headers should ",
      "be ", get_and_or_list(getPotentialAlleleFileHeaders()), ".")

  }
}