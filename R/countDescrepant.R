#' Counts the number of loci with missing data
#'
#' @return An integer value equal to the number of loci missing data
#' @param parent A list with the all of the information from the animal allele
#' file representing one potential parent.
#' @param kid A list with the all of the information from the animal allele
#' file representing the potential offspring.
#' @param other A list with the all of the information from the animal allele
#' file representing one potential parent.
#' @export
countDiscrepant <- function(parent, kid, other) {
  parentAlleles <- parent$alleles
  kidAlleles <- kid$alleles
  # ea.kidlmatch=(ea.left ==ka.left || ea.right==ka.left);
  # ea.kidrmatch=(ea.left ==ka.right || ea.right==ka.right);
  # if(!(ea.kidlmatch||ea.kidrmatch)){
  #   sb.append("discrepancy: locus: " + ea.disp + " "+  " OFFSPRING: "+
  #              ka.left+","+ka.right + " " + swp("DAM") + ": "+ ea.left +
  #              "," + ea.right + lf );
  #   e.discrep++;
  # }
  discrepant <- 0
  text <- character(0)
  if (missing(other)) {
    for (i in seq_along(parentAlleles)) {
      pAllele <- parentAlleles[[i]]
      kAllele <- kidAlleles[[i]]
      pkLMatch <- pAllele[1] == kAllele[1] || pAllele[2] == kAllele[1]
      pkRMatch <- pAllele[1] == kAllele[2] || pAllele[2] == kAllele[2]
      if (!(pkLMatch | pkRMatch)) {
        discrepant <- discrepant + 1
        text <- c(text,
                  paste0("discrepancy: locus: ", names(parentAlleles), " OFFSPRING: ",
                         kAllele[1], ", ", kAllele[2],
                         ifelse(parent$sex == "M", "  SIRE: ", "  DAM: "),
                         pAllele[1], ", ", pAllele[2]))
      }
    }
  } else {
    for (i in seq_along(parentAlleles)) {
      pAllele <- parentAlleles[[i]]
      kAllele <- kidAlleles[[i]]
      oAllele <- otherAlleles[[i]]
      pkLMatch <- pAllele[1] == kAllele[1] || pAllele[2] == kAllele[1]
      pkRMatch <- pAllele[1] == kAllele[2] || pAllele[2] == kAllele[2]
      if (!(pkLMatch | pkRMatch)) {
        discrepant <- discrepant + 1
        text <- c(text,
                  paste0("discrepancy: locus: ", names(parentAlleles), " OFFSPRING: ",
                         kAllele[1], ", ", kAllele[2],
                         ifelse(parent$sex == "M", "  SIRE: ", "  DAM: "),
                         pAllele[1], ", ", pAllele[2]))
      }
    }
  }

  list(discrepant = discrepant, text = text)
}
# //score an entry to a kid and a previously scored parent
# static String computescores(animal e, animal kid, animal other){
#   StringBuffer sb = new StringBuffer();
#   e.missing=0;
#   e.invalid=0;
#   e.discrep=0;
#   for(int x = 0; x < e.alleles.length;x++){
#     genotype ka=kid.alleles[x];
#     genotype ea=e.alleles[x];
#     genotype oa=other.alleles[x];
#     if(ea.left==-1)
#       e.missing++;
#     else if(ka.left==-1)
#       e.invalid++;
#     else{
#       if(oa.kidlmatch==oa.kidrmatch){//two hits or none
#         ea.kidlmatch=(ea.left ==ka.left || ea.right==ka.left);
#         ea.kidrmatch=(ea.left ==ka.right || ea.right==ka.right);
#       }else if(oa.kidlmatch){
#         ea.kidlmatch=false;
#         ea.kidrmatch=(ea.left ==ka.right || ea.right==ka.right);
#       }else if(oa.kidrmatch){
#         ea.kidrmatch=false;
#         ea.kidlmatch=(ea.left ==ka.left || ea.right==ka.left);
#       }
#       if(!(ea.kidlmatch||ea.kidrmatch)){
#         sb.append("discrepancy: locus: " + ea.disp + " OFFSPRING: "+ ka.left+","+ka.right + " " + swp("DAM") +  ": "+oa.left + "," + oa.right + " " + swp("SIRE") + ": "+ea.left + "," + ea.right  + lf );
#         e.discrep++;
#       }
#     }
#   }
#   String r = sb.toString();
#   //  if(!r.equals("")) System.out.println(r);
#   return r;
# }
