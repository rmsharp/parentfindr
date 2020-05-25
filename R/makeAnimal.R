#' static class animal{
#'   String id, birthDate, exitDate, sex,  comments;//   allele1 allele2 ...
#'   genotype [] alleles; //x by 2
#'   int invalid=0;
#'   int discrep=0;
#'   int missing=0;
#'   public String discmsg;
#'   Vector<animal> partner;
#'
#'   protected animal copy(){
#'     aclon++;
#'     animal e = new animal();
#'     e.id=id;
#'     if(alleles != null){
#'       e.alleles=new genotype[alleles.length];
#'       for(int x = 0; x < alleles.length; x++)
#'         e.alleles[x]=alleles[x].copy();
#'     }
#'     e.invalid=invalid;
#'     e.discrep=discrep;
#'     e.missing=missing;
#'     e.partner=partner;//needs work
#'     return e;
#'   }
#'   double concordant(){
#'     double nallele=alleles.length;
#'     double callele=nallele-(missing+invalid);
#'     double ncd=callele-(discrep);
#'     double r=ncd /callele;
#'     if("NaN".equals(""+r))
#'       r=0.0;
#'     return r;
#'   }
#'   double available(){
#'     double nallele=alleles.length;
#'     double callele=nallele-(missing+invalid);
#'     double r= callele/nallele;
#'     if("NaN".equals(""+r))
#'       r=0.0;
#'     return r;
#'   }
#'
#'   public animal(String [] input){//refId   birthDate exitDate sex  comments   allele1 allele2 ...
#'     acon2++;
#'     id=input[0];
#'     check(id !=null,"Error null ID in input file");
#'     id=id.trim();
#'
#'     birthDate=input[1];
#'     exitDate=input[2];
#'     sex=input[3];
#'     comments=input[4];
#'
#'     //      int l =input.length-1;
#'     //      check(l>1,"Error need at least two markers for ID " + id);
#'     //      check((l&1)!=1,"Error must have even number of alleles for ID " + id);
#'
#'     //      l=l/2;
#'     alleles=new genotype[input.length-5];
#'
#'     for(int x = 5; x < input.length;x++){
#'
#'       alleles[x-5]=new genotype(input[x].trim(),uhdr[x]); //csv string of alleles
#'     }
#'   }
#'
#'   public animal(){acon++;}
#'
#'
#' }
#'