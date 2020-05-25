#' Implements the Java function \code{meets} in the original code.
#'
#' public static boolean meets(animal e){
#' //  if(e.invalid > thinvalid) return false;
#' //  if(e.discrep > thdiscrepancies) return false;
#' //  if((e.missing+e.invalid)*100.0/e.alleles.length > thmissing)
#'   if(seldiscrepant){
#'     if(e.alleles.length-(e.missing+e.invalid) < minnumber)
#'       return false;
#'
#'     //  if((e.discrep*100.0)/(e.alleles.length-e.missing-e.invalid) > thdiscrepant)
#'       if((e.discrep)> maxdiscrepant)
#'         return false;
#'   }else{
#'     if((e.missing+e.invalid)*100.0/e.alleles.length > thmissing)
#'       return false;
#'
#'     if((e.discrep*100.0)/(e.alleles.length-e.missing-e.invalid) > thdiscrepant)
#'       return false;
#'
#'   }
#'
#' return true;
#' }
#'