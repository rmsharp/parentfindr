/*
 check offspring, print out mismatches if > 1, if > threshold then error and go to next offspring

if no dams listed then error, if dam with no sires then error

check each dam for > thresholds and then for 1 or more sires

print dam,sire,sire,dam2,sire,sire for allre dams meeting criteria with at least one sire meeting

if discrepancies
  warning allele discrepancies found

if more than one dam or dam with more than one sire
  warning multiple dams/sires meet criteria

else if no dams meet criteria
  error no dams meet criteria, print first dam if available

else if no sires meet criteria
  error no sires meet criteria, print first dam and first sire

 */


import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileReader;
import java.io.PrintStream;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Collections;
import java.util.Comparator;
import java.util.Date;
import java.util.HashMap;
import java.util.Vector;

import com.csvreader.CsvReader;
public class ExclusionParentage {
static int LEFT=0;
static int RIGHT=1;
static String [] mhead;
static String [] chead;
public  static SimpleDateFormat datefmt=new SimpleDateFormat("yyyy-MM-dd");

//static int thinvalid = 4;
//static int thdiscrepancies = 4;
static int minnumber = 4;
static int maxdiscrepant = 4;
static double thmissing = 4;
static double thdiscrepant = 4;
static boolean microsatellites = true;
static boolean siresfirst = false;
static int nloci=0;
/** RMS substituted outOneDamOneSire for out1d1s
 * outOneDamOneSireFilename for out1d1sfn
 * outMultiDamMultiSire for outmdms
 * outMultiDamMultiSireFilename for outmdmsfn
 */
static PrintStream resultsReport;
static PrintStream outcalls;
static PrintStream outOneDamOneSire;
static File outOneDamOneSireFilename;
static PrintStream outMultiDamMultiSire;
static File outMultiDamMultiSireFilename;
public static int datetype; //0=mm/dd/YY
//static PrintStream outnodata;
//static File outnodatafn;
static PrintStream outerr;
static File outerrfn;
static String lf=System.getProperty("line.separator");
//static String lf="\n";
/** RMS substituted selectionTypeFewestDiscrepant for seldiscrepant
 */
static boolean selectionTypeFewestDiscrepant=true;

static int nalleles=0;

public static void main(String[] args) throws Exception {
    long ts1=System.currentTimeMillis();
    //System.in.read();

    System.out.println("start, press any key");
   // System.in.read();
    if(args.length==0) {
//      args=new String[]{"percentdiscrepant=2","percentmissing=8","animalallelefile=../genetics/tstfiles/animalallelescnprc1.tsv","potentialtriosfile=../genetics/tstfiles/potentialtrioscnprc1.tsv",""};
//      args=new String[]{"percentdiscrepant=100","percentmissing=100","animalallelefile=/Users/dave/Documents/Loni_Genotype.txt","potentialtriosfile=/Users/dave/Documents/Loni_Trio.txt",""};
        //chg to maxdiscrepant 1, minnumber 13.90
//      args=new String[]{"seltype=Fewest Discrepant","maxdiscrepant=1","minnumber=90","animalallelefile=/tmp/alleles1.txt","potentialtriosfile=/tmp/trios1.txt","outfile=/tmp/r","callfile=/tmp/c"};
    //System.out.println("seltype=Fewest Discrepant","maxdiscrepant=1","minnumber=90","animalallelefile=/var/data/parentage/SNP-alleles-input-file.txt","potentialtriosfile=/var/data/parentage/t.txt","outfile=/tmp/r","callfile=/tmp/c"};
    System.exit(1);
    }
//    args=new String[]{"seltype=Fewest Discrepant","maxdiscrepant=1","minnumber=90","animalallelefile=/var/data/parentage/SNP-alleles-input-file.txt","potentialtriosfile=/var/data/parentage/SNP-potential-trios.txt","outfile=/tmp/r","callfile=/tmp/c"};
    //args=new String[]{"seltype=Fewest Discrepant","maxdiscrepant=1","minnumber=90","animalallelefile=/var/data/parentage/a.txt","potentialtriosfile=/var/data/parentage/SNP-potential-trios.txt","outfile=/tmp/r","callfile=/tmp/c"};
//  args=new String[]{"percentdiscrepant=2","percentmissing=10","animalallelefile=/Users/dave/Documents/Loni_Genotype.txt","potentialtriosfile=/Users/dave/Documents/Loni_Trio.txt",""};
//  args=new String[]{"percentdiscrepant=2","percentmissing=8","animalallelefile=/Users/dave/Documents/Loni_Genotype.txt","potentialtriosfile=/Users/dave/Documents/Loni_Trio.txt",""};
    //System.out.println("starting "+args + " @" + System.currentTimeMillis());
    commandline(args);
    System.out.println(System.currentTimeMillis()-ts1);
   // System.in.read();

    System.out.println("gclon: \t" + gclon);
    System.out.println("gcon: \t" + gcon);
    System.out.println("gcon2: \t" + gcon2);
    System.out.println("aclon: \t" + aclon);
    System.out.println("acon: \t" + acon);
    System.out.println("acon2: \t" + acon2);

    return;
}
/**
 * return "" or the found value
 * Used to parse arguments from the command line using key = value pair
 * structures
 */
static String parse(String [] args,String key){
    String r = "";
    String k = key + "=";
    for(int x = 0;x<args.length;x++){
        if(args[x].startsWith(k)){
            r=args[x];
            r=r.substring(k.length(),r.length());
        }
    }
    return r;
}
static String [] validtriohdrs = {"OFFSPRING","DAMS","SIRES"};
/** RMS
 * Checks for valid trio headers by comparing the header vector to the defined
 * vector `validtriohdrs`
 * Duplicated with isValidTrioHeader() and getTriosFileHeaders()
 */
static boolean validtriohdr(String h){
    for(int x =0;x<validtriohdrs.length;x++)
        if(h.equals(validtriohdrs[x]))
                return true;
    return false;
}
/** RMS
 * rep() sends a string to stdout with elapse time to the milliseconds attached
 */
static long stm;
static void rep(String s){
    long t=System.currentTimeMillis();
    System.out.println(s + " " + (t-stm));
    stm=t;
}
/** RMS
 * This is all command line processing, which will be added later
 * It is a good place to discover common settings and their use.
 */
public static void commandline(String[] args) throws Exception {
    stm=System.currentTimeMillis();
    animal kid;
    Vector<animal> males;
    Vector<animal> dams;
//  args=new String[]{"10","../genetics/tstfiles/animalalleles.tsv","../genetics/tstfiles/potentialtrios.tsv",""};
//      args=new String[]{"4","1","2","SNPS-1.0","../genetics/tstfiles/animalallelescnprc1.tsv","../genetics/tstfiles/potentialtrioscnprc1.tsv",""};
//missing, invalidated, minsum, filesversion, animals2markers, potentialtrios

/** RMS substituted animalMarkerAlleleFile for ms
 * substituted potentialTriosFile for pt
*/
    String animalMarkerAlleleFile = parse(args, "animalallelefile");
    String potentialTriosFile = parse(args, "potentialtriosfile");

    String tmp = parse(args, "seltype");
    selectionTypeFewestDiscrepant=tmp.equals("Fewest Discrepant");
    tmp = parse(args, "minnumber");
    minnumber=Integer.parseInt(tmp.equals("")?"-1":tmp);
    tmp = parse(args, "maxdiscrepant");
    maxdiscrepant=Integer.parseInt(tmp.equals("")?"-1":tmp);
    tmp = parse(args, "percentmissing");
    thmissing=Double.parseDouble(tmp.equals("")?"-1":tmp);
    tmp = parse(args, "percentdiscrepant");
    thdiscrepant=Double.parseDouble(tmp.equals("")?"-1":tmp);

    tmp = parse(args, "microsatellites");
    microsatellites=tmp.equals("1")?true:false;
    tmp = parse(args, "siresfirst");
    siresfirst=tmp.equals("1")?true:false;

    tmp = parse(args, "skipdate");
    boolean skipdate=tmp.equals("1")?true:false;

    tmp = parse(args, "datetype");
    datetype=tmp.equals("YYYYMMDD")?1:0;


/** RMS substituted reportFile for rp
 * substituted resultsReport for out
*/
    String reportFile= parse(args, "outfile");
    if("".equals(reportFile))
        resultsReport=System.out;
    else
        resultsReport=new PrintStream(reportFile);

    String cls= parse(args, "callfile");

    if("".equals(cls))
        outcalls=System.err;
    else
        outcalls=new PrintStream(cls);
    outcalls.append("EGO\tBIRTH\tEXIT\tSEX\t"+swp("SIRE")+"\t"+swp("DAM")+lf);



    outOneDamOneSireFilename=File.createTempFile("calls", ".tsv");
    outOneDamOneSireFilename.deleteOnExit();
    outOneDamOneSire=new PrintStream(outOneDamOneSireFilename);

    outMultiDamMultiSireFilename=File.createTempFile("multicalls", ".tsv");
    outMultiDamMultiSireFilename.deleteOnExit();
    outMultiDamMultiSire=new PrintStream(outMultiDamMultiSireFilename);

//  outnodatafn=File.createTempFile("nodata", ".tsv");
//  outnodatafn.deleteOnExit();
//  outnodata=new PrintStream(outnodatafn);


    outerrfn=File.createTempFile("errorcalls", ".tsv");
    outerrfn.deleteOnExit();
    outerr=new PrintStream(outerrfn);
    //Exclusion Using Fewest Discrepant
//  Exclusion Using Most Concordant
    String dt = "";
    if(!skipdate)
        dt = ""+ new Date();
    String styp=selectionTypeFewestDiscrepant?"Fewest Discrepant":"Most Concordant";

    resultsReport.println("Exclusion Parentage Report Using "+styp+": " + dt);
    resultsReport.println("***Parameters*** ");
    if(selectionTypeFewestDiscrepant){
        resultsReport.println("Minimum number of testable locus percent per individual: " + minnumber);
        resultsReport.println("Maximum discrepant locus percent per individual: " + maxdiscrepant);
    }else{
        resultsReport.println("Maximum missing/untestable locus percent per individual: " + thmissing);
        resultsReport.println("Maximum discrepant/untestable locus percent per individual: " + thdiscrepant);
    }
//  resultsReport.println("Input Files format version " + fv);
    resultsReport.println("Input Animals to Marker Allele values file " + animalMarkerAlleleFile);
    resultsReport.println("Input Potential Trios file " + potentialTriosFile);
    resultsReport.println();

//  String potentialTriosFile = "../genetics/tstfiles/potentialtrios.tsv";
//  String animalMarkerAlleleFile="../genetics/tstfiles/microsatellites.tsv";
    //resultsReport="../genetics/tstfiles/parentagereporttst.csv";
    rep("parsing done");
    // RMS changing `in` to `potentialTriosReader` CsvReader in = new CsvReader(potentialTriosFile,'\t');
    CsvReader potentialTriosReader = new CsvReader(potentialTriosFile,'\t');
    boolean d = potentialTriosReader.readHeaders();
    if(!d) throw new Exception("Could not read header from " + potentialTriosFile);
    String [] inh = potentialTriosReader.getHeaders();
    int hc=0;
    for(int x = 0; x <inh.length;x++){
        inh[x]=inh[x].toUpperCase();
        if(validtriohdr(inh[x]))
            hc++;
    }
    if(hc != 3)
        throw new Exception("File: " + potentialTriosFile + " does not have the required headers for a potential trios file: OFFSPRING, DAMS, SIRES");
    potentialTriosReader.setHeaders(inh);
    //offspring       dams    sires


//  d=in.readRecord();
    int row=0;
    int calledoffspring=0;
    int multiparentoffspring=0;
    int ninvalid=0;
    int nwithinnovaliddam=0;
    int nwithinnovalidsire=0;

    String tof="";
    String tdm="";
    String tsr="";
    firsts=new HashMap<String,String[]>();
    rep("validations done ");
    kidread:    while(d=potentialTriosReader.readRecord()){
        row++;
        String of=potentialTriosReader.get("OFFSPRING").trim().toUpperCase();
        System.out.println(""+row+" "+of);
        tof=of;
        String dm=potentialTriosReader.get("DAMS").trim().toUpperCase();
        String sr=potentialTriosReader.get("SIRES").trim().toUpperCase();
        if(siresfirst){//swap sires for dams on input
            String tm=dm;
            dm=sr;
            sr=tm;
        }

        if("".equals(of)){
            outerr.println("ERROR NO OFFSPRING SPECIFIED IN ROW " + row + " IN FILE " + potentialTriosFile);
            outerr.println();
            ninvalid++;
            continue kidread;
        }
        if("".equals(dm)){
            outerr.println("ERROR NO "+swp("DAM")+"(S) SPECIFIED IN ROW " + row + " IN FILE " + potentialTriosFile);
            outerr.println();
            nwithinnovaliddam++;
            continue kidread;
        }
        if("".equals(sr)){
            outerr.println("ERROR NO "+swp("SIRE")+"(S) SPECIFIED IN ROW " + row + " IN FILE " + potentialTriosFile);
            outerr.println();
            nwithinnovalidsire++;
            continue kidread;
        }

        kid=new animal(getFirst(of, animalMarkerAlleleFile,"N/A,N/A"));
        countinvalidalleles(kid);

        if(selectionTypeFewestDiscrepant){
//      if((kid.invalid*100.0/kid.alleles.length) > thmissing){
            if((kid.alleles.length-kid.invalid) < minnumber){
                outerr.println("ERROR OFFSPRING " + kid.id + " HAS ONLY " + (kid.alleles.length-kid.invalid) + " MARKERS AVAILABLE, BELOW THRESHOLD OF " + minnumber);
                outerr.println();
                ninvalid++;
                continue kidread;
            }
        }else{
            if((kid.invalid*100.0/kid.alleles.length) > thmissing){
                outerr.println("ERROR OFFSPRING " + kid.id + " MISSING " + kid.invalid + " MARKERS, ABOVE MISSING THRESHOLD OF " + thmissing);
                outerr.println();
                ninvalid++;
                continue kidread;
            }
        }

        String [] dms=spltucasetrim(dm,",");
        String [] sirs=spltucasetrim(sr,",");

//load the males allele data
        males = new Vector();
        for(int x = 0; x < sirs.length;x++){
            animal e = new animal(getFirst(sirs[x], animalMarkerAlleleFile,"N/A,N/A"));
            males.add(e);
        }

        // TODO make dam/sire generic so can swap for harems
        //store copies of each sire with each dam so they can be sorted/mutated independantly
        dams= new Vector();
        for(int x = 0; x < dms.length;x++){
            animal dam=new animal(getFirst(dms[x], animalMarkerAlleleFile,"N/A,N/A"));

            dam.discmsg=computescores(dam,kid);
            dam.partner=new Vector();
            for(int m = 0; m < males.size();m++){
                animal si=(animal)males.get(m).copy();
                si.discmsg=computescores(si,kid,dam);
                dam.partner.add(si);
            }
            Collections.sort(dam.partner, concordcp);
            dams.add(dam);
        }
        Collections.sort(dams, concordcp);

/*at this point all dams are scored and sorted, and sires
apply thresholds and see if there is anything left.
*/
        StringBuffer sb = new StringBuffer();
        sb.append("OFFSPRING " + kid.id + ": ");

            sb.append("  "+ kid.invalid+" missing marker(s) ");
        sb.append(lf);

//count the dams that meet criteria
        int dammeet=0;
        for(int x=0;x<dams.size();x++)
            if(meets(dams.get(x))){
                tdm=dams.get(x).id;
                dammeet++;
            }

        if(dammeet==0){
            sb.append("ERROR NO "+swp("DAM")+"S MEET CRITERIA, FIRST CLOSEST "+swp("DAM")+""+lf);
            sb.append(hdrs);
            sb.append(scores(" "+swp("DAM")+"",dams.get(0)));
            sb.append(lf);
            outerr.append(sb.toString());
            nwithinnovaliddam++;
            continue kidread;
        }

        int multi=0;

        //count the sires that meet criteria
        int siremeet=0;
        //int disc=0;
        int inv=0;
        for(int x=0;x<dams.size();x++){
            int nsire=0;
            animal d1 = dams.get(x);
            if(meets(d1)){
//              if(d1.discrep>0)
    //              disc++;
                if(d1.invalid>0)
                    inv++;
                for(int m=0;m<d1.partner.size();m++){
                    animal s1=d1.partner.get(m);
                    if(meets(s1)){
                        siremeet++;
                        tsr=s1.id;
                        if(nalleles==0)
                            nalleles=s1.alleles.length;
                //      if(s1.discrep>0)
                    //      disc++;
                        if(s1.invalid>0)
                            inv++;
                    }
                }
            }
        }
        if(siremeet==0){
            sb.append("ERROR NO "+swp("SIRE")+"S MEET CRITERIA, FIRST CLOSEST "+swp("DAM")+" AND "+swp("SIRE")+":"+lf);
            sb.append(hdrs);
            sb.append(scores(" "+swp("DAM")+"",dams.get(0)));
            sb.append(scores("  "+swp("SIRE"),dams.get(0).partner.get(0)));
            sb.append(lf);
            outerr.append(sb.toString());
            nwithinnovalidsire++;
            continue kidread;
        }
        multi+=siremeet;
        if(siremeet>1){
        //  sb.append("WARNING MULTIPLE SIRES/DAMS MEET CRITERIA"+lf);
            multiparentoffspring++;
        //  multi=true;
        }else
            calledoffspring++;

//      if(disc>0)
        //  sb.append("WARNING ALLELE DISCREPENCIES FOUND"+lf);
        if(inv>0)
            sb.append("WARNING MISSING/INVALID ALLELE VALUES FOUND"+lf);

        String pdcall="";
        sb.append(hdrs);
        //dump out the dams and sires that meet
        int didx=0;
        for(int x=0;x<dams.size();x++){
            int nsire=0;
            animal d1 = dams.get(x);
            if(meets(d1)){
                boolean dp=false;
                int sidx=0;
                for(int m=0;m<d1.partner.size();m++){
                    animal s1=d1.partner.get(m);
                    if(meets(s1)){
                        if(!dp){
                            didx++;
                            sb.append(scores(" "+swp("DAM")+""+didx,d1));
                        //  if(!"".equals(d1.discmsg))
                            //  sb.append(lf);
                            sb.append(d1.discmsg);
                            pdcall=kid.id+"\t"+kid.birthDate+"\t"+kid.exitDate+"\t"+kid.sex+"\t"+s1.id + "\t" + d1.id+lf;
                            dp=true;
                        }
                        sidx++;
                        sb.append(scores("  "+swp("SIRE")+sidx,s1));
                    //  if(!"".equals(s1.discmsg))
                        //  sb.append(lf);
                        sb.append(s1.discmsg);
                    }
                }
            }
        }
        sb.append(lf);

        if(multi>1)
            outMultiDamMultiSire.append(sb.toString());
        else{//for calls report to pedsys
//          outcalls.append(tof+"\t"+kid.birthDate+"\t"+kid.exitDate+"\t"+kid.sex+"\t"+tsr + "\t" + tdm+lf);
            outcalls.append(pdcall);
            outOneDamOneSire.append(sb.toString());
        }
    }
    rep("main loop done ");

    resultsReport.println("***Summary***");
    resultsReport.println(row + " Offspring in the input file");
    resultsReport.println(calledoffspring + " resolved to one dam and one sire");
    resultsReport.println(multiparentoffspring + " resolved to multiple dams and/or sires");
    resultsReport.println(ninvalid + " did not resolve to a valid offspring");
    resultsReport.println(nwithinnovaliddam + " did not resolve to a valid "+swp("DAM").toLowerCase());
    resultsReport.println(nwithinnovalidsire + " did not resolve to a valid "+swp("SIRE").toLowerCase());
    resultsReport.println(nalleles + " Markers provided");
    resultsReport.println();

    outOneDamOneSire.flush();
    outOneDamOneSire.close();
    outMultiDamMultiSire.flush();
    outMultiDamMultiSire.close();
    outerr.flush();
    outerr.close();
    outcalls.flush();
    outcalls.close();
//  outnodata.flush();
//  outnodata.close();

    resultsReport.println("***Calls*** ");
    byte [] buf = new byte [32767];
    FileInputStream fi=new FileInputStream(outOneDamOneSireFilename);
    int c = fi.read(buf);
    while(c != -1){
        resultsReport.write(buf, 0, c);
        c = fi.read(buf);
    }
    fi.close();
    resultsReport.println();

    resultsReport.println("***Multiple Sires/Dams*** ");
    fi=new FileInputStream(outMultiDamMultiSireFilename);
    c = fi.read(buf);
    while(c != -1){
        resultsReport.write(buf, 0, c);
        c = fi.read(buf);
    }
    fi.close();
    resultsReport.println();

    resultsReport.println("***Errors*** ");
    fi=new FileInputStream(outerrfn);
    c = fi.read(buf);
    while(c != -1){
        resultsReport.write(buf, 0, c);
        c = fi.read(buf);
    }
    fi.close();
    resultsReport.println();

/*  resultsReport.println("***Animals with no match to genetic data file*** ");
//  fi=new FileInputStream(outnodatafn);
    c = fi.read(buf);
    while(c != -1){
        resultsReport.write(buf, 0, c);
        c = fi.read(buf);
    }
    fi.close();
    resultsReport.println(); */


String definitions="***Definitions***"+lf+
"Calls: the section of the report for trios, where given the current threholds and data the offspring resolved to one sire and one dam."+lf+
"Type: The individual's role in the would-be trio."+lf+
"ID: the individual's ID as used in the input files."+lf+
"discrep: the number of discrepancies, where the dam could not match to a child allele, or where the sire could not match after evaluating the dam."+lf+
"#concord: the number of concordant loci."+lf+
"%concord: the number of concordant loci as a percentage of the loci that were recognizable in both parent and offspring."+lf+
"missing/missing markers: the number of loci that had one or more unrecognizable allele values."+lf+
"unused: the number of recognizable locus values in the individual that had a missing corresponding locus in the offspring."+lf+
"total: discrep+concord+missing+unused, should equal the number of expected markers in the file.";

    resultsReport.println(definitions);
    resultsReport.println();



    resultsReport.flush();
    resultsReport.close();
//  args=new String[]{animalMarkerAlleleFile,"tstfiles/colonydata.tsv","tstfiles/parentagereporttst.csv"};
//  System.out.println(args[0]+","+args[1]+","+args[2]);
}

static String swp(String rel){
    if(siresfirst){
        if ("DAM".equals(rel))
            return "SIRE";
        else
            return "DAM";
    }else
        return rel;
}
public static boolean meets(animal e){
//  if(e.invalid > thinvalid) return false;
//  if(e.discrep > thdiscrepancies) return false;
//  if((e.missing+e.invalid)*100.0/e.alleles.length > thmissing)
    if(selectionTypeFewestDiscrepant){
        if(e.alleles.length-(e.missing+e.invalid) < minnumber)
            return false;

//  if((e.discrep*100.0)/(e.alleles.length-e.missing-e.invalid) > thdiscrepant)
        if((e.discrep)> maxdiscrepant)
            return false;
    }else{
        if((e.missing+e.invalid)*100.0/e.alleles.length > thmissing)
            return false;

        if((e.discrep*100.0)/(e.alleles.length-e.missing-e.invalid) > thdiscrepant)
            return false;

    }

    return true;
}



static boolean knownhdr(String h){
    String[] knownhdrs={"REFID","SEX","BIRTHDATE","EXITDATE","COMMENTS"};
    for(int x = 0; x < knownhdrs.length;x++){
        if(knownhdrs[x].equals(h))
            return true;
    }
    return false;
}

/** convert date to pedsys format
 */

public static String getDate(String d) throws Exception{
    d=d.trim();
    if("".equals(d))
        return "";
    else if(datetype==0){//mm/dd/YYYY
        String []  t = d.split("/");
        if(t.length != 3)
             t = d.split("-");
        if(t.length != 3)
            throw new Exception("Could not parse date " + d);
        if(t[2].length() == 2){
            int i = Integer.parseInt(t[2]);
            String c = ""+Calendar.getInstance().get(Calendar.YEAR);
            int y =Integer.parseInt(c.substring(2));
            if(i>y)
                return "19"+t[2]+t[0]+t[1];
            else
                return "20"+t[2]+t[0]+t[1];
        }else if (t[2].length() == 4){
            return t[2]+t[0]+t[1];
        }else throw new Exception("Could not parse date " + d);

    }else if(datetype==1){//YYYYMMDD
        return d;
    }else{
        throw new Exception("Invalid date type " + datetype);
    }


}
public static String [] uhdr = null;
static int gf=0;
static HashMap<String, String []> firsts;
//refId   birthDate exitDate sex  comments  allele1 allele2 ...
public static String [] getFirst(String str, String msfile, String dflt) throws Exception{
    String [] fs = firsts.get(str+"|"+msfile);
    if(fs==null){
    //System.out.println("" + (++gf) + " " + str + "|" + msfile);
    CsvReader r = new CsvReader(msfile);
    r.setDelimiter('\t');
    r.readHeaders();
    if(uhdr==null){
        uhdr = r.getHeaders();
        int kh=0;
        for(int x = 0; x < uhdr.length;x++){
            uhdr[x]=uhdr[x].toUpperCase();
            if(knownhdr(uhdr[x]))
                kh++;
        }
        if(kh <4){
            throw new Exception("File: " + msfile + " does not have the required headers for an allele file: REFID, SEX, BIRTHDATE, EXITDATE");
        }
    }
    r.setHeaders(uhdr); //convert reader headers to upper case
    int alc=0;
    for(int x = 0; x < uhdr.length;x++)
        if(!knownhdr(uhdr[x]))
            alc++;
    boolean go=r.readRecord();
    while(go){
        String id=r.get("REFID");
        if(id.equalsIgnoreCase(str)){
            Vector <String> fnd=new Vector<String>();
            fnd.add(id);
            fnd.add(getDate(r.get("BIRTHDATE")));
            fnd.add(getDate(r.get("EXITDATE")));
            fnd.add(r.get("SEX"));
            fnd.add(r.get("COMMENTS"));
            for(int x = 0;x<uhdr.length;x++){
                String h = uhdr[x];
                if(!knownhdr(h)){ //add everything that is not known as an allele
                    fnd.add(r.get(h));
                }
            }
            String [] rv =fnd.toArray(new String [0]);
            r.close();
            fs=rv;
              firsts.put(str+"|"+msfile, fs);
            return rv;
        }
        go=r.readRecord();
    }
    String [] rv=new String[alc+5];
    for(int x = 0; x < rv.length;x++)
        rv[x]=dflt;
    rv[0]=str;
    rv[1]="";
    rv[2]="";
    rv[3]="U";
    rv[4]="";
    fs=rv;
    firsts.put(str+"|"+msfile, fs);
    }
    return fs;
}

//return the first row that starts with str
public static String [] getFirst2(String str, String msfile, String dflt) throws Exception{
    String r = "";
    BufferedReader br=new BufferedReader(new FileReader(msfile));
    r=br.readLine();
    String f=null;
    r=r.toUpperCase();
    String [] rc=spltucasetrim(r,"\t");
    int c = rc.length-1;
    while (r != null){
        r=r.toUpperCase().trim();
        if(r.startsWith(str))
            return spltucasetrim(r,"\t");
        r=br.readLine();
    }

//  outnodata.append(str + "\t"+lf);
    rc[0]=str;
    for(int x = 1;x<rc.length;x++)
        rc[x]=dflt;

    return rc;
}


static Comparator<animal> concordcp = new Comparator<ExclusionParentage.animal>() {
    public int compare(animal o1, animal o2) {
        if(selectionTypeFewestDiscrepant){
            Integer a1=o1.alleles.length-(o1.missing + o1.invalid);
            Integer a2=o2.alleles.length-(o2.missing + o2.invalid);
            int ac=a2.compareTo(a1);

            Integer d1=o1.discrep;
            Integer d2=o2.discrep;
            int dc=d1.compareTo(d2);

            if(dc==0)
                return ac;
            else
                return dc;
        }else{
            double c1= o1.concordant() * o1.available();
//          if("NaN".equals(""+c1))
//              c1=0.0;
            double c2= o2.concordant() * o2.available();
//          if("NaN".equals(""+c2))
//              c2=0.0;

            return Double.compare(c2, c1);
        }
    }
};

//score an entry to a kid and a previously scored parent
static String computescores(animal e, animal kid, animal other){
    StringBuffer sb = new StringBuffer();
    e.missing=0;
    e.invalid=0;
    e.discrep=0;
    for(int x = 0; x < e.alleles.length;x++){
           genotype ka=kid.alleles[x];
           genotype ea=e.alleles[x];
           genotype oa=other.alleles[x];
           if(ea.left==-1)
               e.missing++;
           else if(ka.left==-1)
               e.invalid++;
           else{
               if(oa.kidlmatch==oa.kidrmatch){//two hits or none
                   ea.kidlmatch=(ea.left ==ka.left || ea.right==ka.left);
                   ea.kidrmatch=(ea.left ==ka.right || ea.right==ka.right);
               }else if(oa.kidlmatch){
                   ea.kidlmatch=false;
                   ea.kidrmatch=(ea.left ==ka.right || ea.right==ka.right);
               }else if(oa.kidrmatch){
                   ea.kidrmatch=false;
                   ea.kidlmatch=(ea.left ==ka.left || ea.right==ka.left);
               }
               if(!(ea.kidlmatch||ea.kidrmatch)){
                   sb.append("discrepancy: locus: " + ea.disp + " OFFSPRING: "+ ka.left+","+ka.right + " " + swp("DAM") +  ": "+oa.left + "," + oa.right + " " + swp("SIRE") + ": "+ea.left + "," + ea.right  + lf );
                   e.discrep++;
               }
           }
    }
    String r = sb.toString();
//  if(!r.equals("")) System.out.println(r);
    return r;
}

//score an entry to a kid and a previously scored parent
static String computescores(animal e, animal kid){
    e.missing=0;
    e.invalid=0;
    e.discrep=0;
    StringBuffer sb = new StringBuffer();
    for(int x = 0; x < e.alleles.length;x++){
           genotype ka=kid.alleles[x];
           genotype ea=e.alleles[x];
           if(ea.left==-1)
               e.missing++;
           else if(ka.left==-1)
               e.invalid++;
           else{
               ea.kidlmatch=(ea.left ==ka.left || ea.right==ka.left);
               ea.kidrmatch=(ea.left ==ka.right || ea.right==ka.right);
               if(!(ea.kidlmatch||ea.kidrmatch)){
                   sb.append("discrepancy: locus: " + ea.disp + " "+  " OFFSPRING: "+ ka.left+","+ka.right + " " + swp("DAM") + ": "+ea.left + "," + ea.right + lf );
                   e.discrep++;
               }
           }
    }
    String r = sb.toString();
//  if(!r.equals(""))
    //  System.out.println(r);
    return r;

}


//score the kid
static void countinvalidalleles(animal e){
    int invalid=0;
    int tinvalid;
    for(int x = 0; x < e.alleles.length;x++){
        tinvalid=0;
        if(e.alleles[x].left == -1)
                tinvalid++;
        invalid+=tinvalid;
    }
    e.invalid=invalid;
}



static int a2i(String a){
    int r = -1;
    if(a.equalsIgnoreCase("a"))
        r=1;
    else if(a.equalsIgnoreCase("c"))
        r=2;
    else if(a.equalsIgnoreCase("g"))
        r=3;
    else if(a.equalsIgnoreCase("t"))
        r=4;
    return r;
}

static String hdrs="Type\tID\tdiscrep\t%concrd\t#concrd\tmissing\tunused\ttotal"+lf;


static String scores(String pre,animal e){
    double nallele=e.alleles.length;
    double callele=nallele-(e.missing+e.invalid);
    double ncd=callele-(e.discrep);
    int cdc=e.alleles.length-(e.missing+e.discrep+e.invalid);
//  double scr=
    return pre+"\t"+e.id+"\t"+e.discrep+"\t%"+fmtdbl(ncd * 100.0/callele) + "\t"+cdc+"\t"+e.missing+"\t"+e.invalid +"\t"+(e.missing+e.discrep+e.invalid+cdc) +lf;

}



static String fmtdbl(double dbl){
    if("NaN".equals(""+dbl))

        dbl=0.0;
    int sz=6;
    String t=""+dbl;
    if(t.length()>sz)
        t=t.substring(0,sz);
    else if(t.length() <sz){
        String z = "";
        int c = sz-t.length();
        for(int x = 0; x<c;x++)
            z=z+"0";
        t=t+z;
    }




    return t;
}

static void check(boolean v, String msg){
    if (!v){
        System.err.println(msg);
        System.exit(1);
    }
}

static void usage(){
    System.err.println("java Parentage microsatellites.tsv colonydata.tsv parentagereport.csv"+lf+
            "microsatellites format: header row, each row is ID then allel pairs tab seperated"+lf+
            "colonydata format: header row, each row is ID, DateOfBirth(yyyy-mm-dd), Sex(M/F)  tab seperated");
    System.exit(1);
}
static long gclon=0;
static long gcon=0;
static long gcon2=0;
static long aclon=0;
static long acon=0;
static long acon2=0;

static class genotype{
    int left=-1;
    int right=-1;
    String disp="";


    boolean kidlmatch;
    boolean kidrmatch;



    protected genotype copy(){
        gclon++;
        genotype a = new genotype();
        a.left=left;
        a.right=right;
        a.disp=disp;
        a.kidlmatch=kidlmatch;
        a.kidrmatch=kidrmatch;
        return a;
    }
    public genotype(){gcon++;}
    public genotype(String alleles, String desc){//csv string of alleles
        gcon2++;
        disp=desc;
        String [] t = spltucasetrim(alleles,",");
        String aleft="-1";
        String aright="-1";
        if(t.length==2){
            aleft=t[0];
            aright=t[1];
        }
//      N/A
        boolean nok=false;
        int al=0;
        int ar=0;
        try{
            left=Integer.parseInt(aleft);
            right=Integer.parseInt(aright);
            nok=true;
        }catch(NumberFormatException e){
            left=-1;right=-1;
        }
        if(!microsatellites&&!nok){
            left=a2i(aleft);
            right=a2i(aright);
        }
        if(left<0 || right<0){//both invalid if one invalid
            left=-1;
            right=-1;
        }

    }

}
static class animal{
    String id, birthDate, exitDate, sex,  comments;//   allele1 allele2 ...
    genotype [] alleles; //x by 2
    int invalid=0;
    int discrep=0;
    int missing=0;
    public String discmsg;
    Vector<animal> partner;

    protected animal copy(){
        aclon++;
        animal e = new animal();
        e.id=id;
        if(alleles != null){
            e.alleles=new genotype[alleles.length];
            for(int x = 0; x < alleles.length; x++)
                e.alleles[x]=alleles[x].copy();
        }
        e.invalid=invalid;
        e.discrep=discrep;
        e.missing=missing;
        e.partner=partner;//needs work
        return e;
    }
    double concordant(){
        double nallele=alleles.length;
        double callele=nallele-(missing+invalid);
        double ncd=callele-(discrep);
        double r=ncd /callele;
        if("NaN".equals(""+r))
            r=0.0;
        return r;
    }
    double available(){
        double nallele=alleles.length;
        double callele=nallele-(missing+invalid);
        double r= callele/nallele;
        if("NaN".equals(""+r))
            r=0.0;
        return r;
    }

    public animal(String [] input){//refId   birthDate exitDate sex  comments   allele1 allele2 ...
        acon2++;
        id=input[0];
        check(id !=null,"Error null ID in input file");
        id=id.trim();

        birthDate=input[1];
        exitDate=input[2];
        sex=input[3];
        comments=input[4];

//      int l =input.length-1;
//      check(l>1,"Error need at least two markers for ID " + id);
//      check((l&1)!=1,"Error must have even number of alleles for ID " + id);

//      l=l/2;
        alleles=new genotype[input.length-5];

        for(int x = 5; x < input.length;x++){

            alleles[x-5]=new genotype(input[x].trim(),uhdr[x]); //csv string of alleles
        }
    }

    public animal(){acon++;}


}
public static String [] spltucasetrim(String str, String regex){
    str=str.toUpperCase();
    str=str.replace('"',' ');
    String [] r = str.split(regex);
    for(int x =0;x<r.length;x++)
        r[x]=r[x].trim();
    return r;
}
}
