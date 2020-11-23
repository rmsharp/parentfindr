library(rmsutilityr)
library(stringi)
## final HTextfield ALLELEFILE= new HTextfield("Animals Allele File", "","Location of animal markers file");
## final HTextfield TRIOSFILE= new HTextfield("Potential Trios File", "","Location of the list of offspring and potential dams/sires");
alleleFile <- "inst/testdata/snp-animal-alleles.xlsx"
triosFile <- "inst/testdata/snp-potential-trios.xlsx"
alleleFile <- "inst/testdata/snp-animal-alleles.txt"
triosFile <- "inst/testdata/snp-potential-trios.txt"
alleleFile <- "inst/testdata/str-animal-alleles.txt"
triosFile <- "inst/testdata/str-potential-trios.txt"
alleleFile <- "inst/testdata/str-animal-alleles.xlsx"
triosFile <- "inst/testdata/str-potential-trios.txt"
alleleFile <- "inst/testdata/str-animal-alleles_rms.xlsx"
triosFile <- "inst/testdata/str-potential-trios.txt"

## final HPullDown SELTYPE= new HPullDown("Selection Method",new String[]{"Fewest Discrepant","Most Concordant"}, "Select parent that has the minimum number of discrepancies or the greatest percentage of concordant alleles with the offspring.",true);
## final HPullDown DATETYPE= new HPullDown("Input date format",new String[]{"mm/dd/YYYY","YYYYMMDD"}, "mm/dd/YYYY is compatible with excel and etc, YYYYMMDD is the native pedsys format.",true);
## I have been reading through the code and have a question regarding how missing loci (alleles) and invalid loci (alleles) are calculated.
##
## Only the left of the left and right pairs of the locus geneotypes are used for scoring, which makes me assume that if the left one is missing, both are missing. Is that correct?
##
##   A parent’s locus is counted as missing if it does not have a value in the left allele even if this locus is missing for the offspring.
##
## A parent’s locus is counted as invalid if it does have a value in the left allele but the offspring does not have a value in the left allele.
##
## This allows the calculation of denominator for the percent non-discrepant alleles.
## cAlleleNumber <- length(alleles) - (missingLoci + invalidLoci)
## percentNonDiscrepant <- (cAlleleNumber - discrepantLoci)/cAlleleNumber
##  This converts "a", "c", "g", "t" to 1, 2, 3, 4 respectively if the allele
##  string is !microsatelite && !nok which means the microsatellite
##   genotype did not used integers.
##  public genotype(String alleles, String desc){//csv string of alleles
##     gcon2++;
##     disp=desc;
##     String [] t = spltucasetrim(alleles,",");
##     String aleft="-1";
##     String aright="-1";
##     if(t.length==2){
##       aleft=t[0];
##       aright=t[1];
##     }
##     //      N/A
##     boolean nok=false;
##     int al=0;
##     int ar=0;
##     try{
##       left=Integer.parseInt(aleft);
##       right=Integer.parseInt(aright);
##       nok=true;
##     }catch(NumberFormatException e){
##       left=-1;right=-1;
##     }
##     if(!microsatellites&&!nok){
##       left=a2i(aleft);
##       right=a2i(aright);
##     }
##     if(left<0 || right<0){//both invalid if one invalid
##       left=-1;
##       right=-1;
##     }
##
## }
##
minNumber <- -1
maxDiscrepant <- -1
thMissing <- -1
htDiscrepant <- -1
dateType <- "YYYYMMDD"
microSatellites <- FALSE
siresFirst <- TRUE
skipDate <- FALSE
selectionType <- "Fewest Discrepant"
if (selectionType == "Fewest Discrepant")
  selectionTypeFewestDiscrepant <- TRUE

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

#size <- as.matrix(NA, nrow = 270, ncol = 24, rownames.force = NA)
# args <- list(maxDiscrepant,
#              minNumber,
#              percentDiscrepant,
#              percentMissing,
#              siresFirst,
#              microSatellites,
#              animalAllelefile,
#              potentialTriosFile,
#              outFile,
#              callFile,
#              selType,
#              dateType)
#
# exclusionParentage <- function(maxDiscrepant,
#                                minNumber,
#                                percentDiscrepant,
#                                percentMissing,
#                                siresFirst,
#                                microSatellites,
#                                animalAllelefile = alleleFile,
#                                potentialTriosFile = triosFile,
#                                outFile,
#                                callFile,
#                                selType,
#                                dateType) {
  minNumber <- 4
  maxDiscrepant <- 4
  thMissing <- 4
  thDiscrepant <- 4
  microsatellites <- TRUE
  siresFirst <- FALSE
  selectionTypeFewestDiscrepant <- TRUE
  nAlleles <- 0

##  animalAlleleLines <- readLines(con = alleleFile, warn = FALSE)
##  potentialTriosLines <- readLines(con = triosFile, warn = FALSE)
##  if (!isValidTrioHeader(potentialTriosLines[1]))
##    stop("Potential Trios File has invalid headers. Should have ",
##         get_and_or_list(getTriosFileHeaders()), ".")
##
##  if (!isValidAnimalAlleleHeader(animalAllelesLines[1]))
##      stop("Animal allele file has invalid headers. First three headers should ",
##      "be ", get_and_or_list(getPotentialAlleleFileHeaders()), ".")

  trios <- getTrios(triosFile)
  animalAlleles <- getAnimalAlleles(alleleFile, dateType)
  ## allScores[["48575"]][["43307"]][["43383"]]
  ##trios <- list("48575" = list(offspring = "48575", dams = "43307",
  ##                             sires = "43383"))
  ##trios <- list("48851" = list(offspring = "48575", dams = "43601",
  ##                             sires = "43383"))
scores <- getScores(trios, animalAlleles)
