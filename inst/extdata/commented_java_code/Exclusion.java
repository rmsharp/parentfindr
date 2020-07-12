
import java.awt.Dimension;
import java.awt.GridBagConstraints;
import java.awt.GridBagLayout;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.io.File;

import javax.swing.JButton;
import javax.swing.JFileChooser;
import javax.swing.JOptionPane;

import org.nhprc.gui.StatusWindow;
import org.nhprc.swing.HCheckfield;
import org.nhprc.swing.HFloatfield;
import org.nhprc.swing.HNumberField;
import org.nhprc.swing.HPullDown;
import org.nhprc.swing.HTextfield;
import org.nhprc.swing.Panel;
import org.nhprc.swing.SwingUtil;
import org.nhprc.util.Exec;
import org.nhprc.util.Util;


public class Exclusion {
    //      args=new String[]{"1","8","Microsatellites-1.0","../genetics/tstfiles/animalalleles.tsv","../genetics/tstfiles/potentialtrios.tsv",""};

//outputs the id and the population then the allels
    static String datadelim="[Data]";
    static String id="Sample ID";
    static String pop="Sample Group";
    static String allel1="Allele1 - Top";
    static String allel2="Allele2 - Top";
    static int _id=-1;
    static int _pop=-1;
    static int _allel1=-1;
    static int _allel2=-1;

    static int precol=2;
    static int maxcol=0;
    static int maxrow=0;
    static String [] lastdir=new String[]{""};
    static StatusWindow status=new StatusWindow("Exclusion 1.03 status", "waiting for input"); 
    
//properties  standalone=
    
    public static void main(String[] args) {
    while(true){
        try{
            main2(args);
    }catch(Exception e){
    //  e.printStackTrace();
        
        JOptionPane.showMessageDialog(null, e.getMessage() + "\nPlease double check the data files and try again", "Error ", JOptionPane.ERROR_MESSAGE);
    }
    }
    }
    static GridBagConstraints slot1;
    static GridBagConstraints slot2;
    
    public static void main2(String[] args) throws Exception{
        SwingUtil.init();
        status.setStatus("Waiting for input");
        String tst = "";
        for(int x = 0; x < args.length;x++){
            tst=tst+args[x]+"|";
        }
        //Util.showmsg("Exclusion Parameters",new Exception(tst),null);
//      if(args==null||args.length==0)
//          args=new String[]{"/tmp/GT200909911BF_2-Analysis_FinalReport.txt","/tmp/out.txt","/tmp/pop.txt","/tmp/parm.txt"};
//          args=new String[]{"/tmp/final.txt","/tmp/out.txt","/tmp/pop.txt","/tmp/parm.txt"};
//      args=new String[]{"/tmp/sample.txt","/tmp/out.txt","/tmp/pop.txt","/tmp/parm.txt"};
//          args=new String[]{"/var/progs/tmp/partfinal.txt","/var/progs/tmp/out.txt","/var/progs/tmp/pop.txt","/var/progs/tmp/parm.txt","500","100"};
//      args=new String[]{"/var/tmp/beadout.txt","/var/progs/tmp/out.txt","/var/progs/tmp/pop.txt","/var/progs/tmp/parm.txt","500","100"};
//      args=new String[]{"6","Microsatellites-1.0","../genetics/tstfiles/animalalleles.tsv","../genetics/tstfiles/potentialtrios.tsv",""};
        
        //convert to structure format
    //  cvt(args);
        


        final Panel p = new Panel();
        p.setLayout(new GridBagLayout());
        final HCheckfield MICROSATELLITES= new HCheckfield("Microsatellite based allele file",0,"Override the default SNP-based allele file");
        final HFloatfield MAXMISSINGPCT= new HFloatfield("Max missing/unused loci %", 10,0,100,"maximum allowable missing/incomparable data to be considered a match to the offspring.",true);
        final HFloatfield MAXDISCREPANTPCT= new HFloatfield("Max discrepant loci %", 2,0,100,"how many alleles must match for the individual to be considered a match.",true);
        final HNumberField MINNUMBER= new HNumberField("Min available loci", 90,0,999,"minimum number of loci to be considered a match to the offspring.",true);
        final HNumberField MAXDISCREPANT= new HNumberField("Max discrepant loci ", 1,0,100,"how many alleles must match for the individual to be considered a match.",true);
        MICROSATELLITES.jc.addActionListener(new ActionListener() {
            
            public void actionPerformed(ActionEvent e) {
                if("0".equals(MICROSATELLITES.getvalue()))
                    MINNUMBER.jc.setText("90");
                else
                    MINNUMBER.jc.setText("13");
                    
                
            }
        });
        final HCheckfield SIRESFIRST= new HCheckfield("Exclude Sires First",0,"Override the default Dams-first exclusion");

        
        final HTextfield ALLELEFILE= new HTextfield("Animals Allele File", "","Location of animal markers file");       
        final HTextfield TRIOSFILE= new HTextfield("Potential Trios File", "","Location of the list of offspring and potential dams/sires");
        String tm=System.getProperty("allelefile");
        if(tm!= null)
            ALLELEFILE.jc.setText(tm);
        
        tm=System.getProperty("triofile");
        if(tm!= null)
            TRIOSFILE.jc.setText(tm);
        final HPullDown SELTYPE= new HPullDown("Selection Method",new String[]{"Fewest Discrepant","Most Concordant"}, "Select parent that has the minimum number of discrepancies or the greatest percentage of concordant alleles with the offspring.",true);
        final HPullDown DATETYPE= new HPullDown("Input date format",new String[]{"mm/dd/YYYY","YYYYMMDD"}, "mm/dd/YYYY is compatible with excel and etc, YYYYMMDD is the native pedsys format.",true);
        JButton b1 = new JButton("Browse...");
        b1.addActionListener(new ActionListener() {
            public void actionPerformed(ActionEvent e) {
                  JFileChooser c;
                  if("".equals(lastdir[0]))
                      c= new JFileChooser();
                  else
                      c=new JFileChooser(lastdir[0]);
                  // Demonstrate "Save" dialog:
                  int rVal = c.showSaveDialog(null);
                  if (rVal == JFileChooser.APPROVE_OPTION) {
                    TRIOSFILE.jc.setText(c.getSelectedFile().getPath());
                    lastdir[0]=c.getSelectedFile().getParent();
                  }
            }
        });
        Dimension d = new Dimension(100,24);
        b1.setMaximumSize(d);
        b1.setPreferredSize(d);
        b1.setMinimumSize(d);
        JButton b2 = new JButton("Browse...");
        b2.addActionListener(new ActionListener() {
            
            public void actionPerformed(ActionEvent e) {
                  JFileChooser c;
                  if("".equals(lastdir[0]))
                      c= new JFileChooser();
                  else
                      c=new JFileChooser(lastdir[0]);
                  // Demonstrate "Save" dialog:
                  int rVal = c.showSaveDialog(null);
                  if (rVal == JFileChooser.APPROVE_OPTION) {
                      ALLELEFILE.jc.setText(c.getSelectedFile().getPath());
                        lastdir[0]=c.getSelectedFile().getParent();
                  }
            }
        });
        b2.setMaximumSize(d);
        b2.setPreferredSize(d);
        b2.setMinimumSize(d);
        Dimension dm = new Dimension(240,24);
        TRIOSFILE.jc.sz=dm;
        ALLELEFILE.jc.sz=dm;
        TRIOSFILE.jc.setsize();
        ALLELEFILE.jc.setsize();

        MICROSATELLITES.jc.setMinimumSize(new Dimension(240,24));
        MICROSATELLITES.jc.setPreferredSize(new Dimension(240,24));
        SIRESFIRST.jc.setMinimumSize(new Dimension(240,24));
        SIRESFIRST.jc.setPreferredSize(new Dimension(240,24));
        //MICROSATELLITES.jl.setMinimumSize(new Dimension(270,24));
        //MICROSATELLITES.jl.setPreferredSize(new Dimension(270,24));
        
        
        MINNUMBER.jc.setMinimumSize(new Dimension(270,24));
        MINNUMBER.jc.setPreferredSize(new Dimension(270,24));
        MINNUMBER.jl.setMinimumSize(new Dimension(240,24));
        MINNUMBER.jl.setPreferredSize(new Dimension(240,24));
        MAXDISCREPANT.jc.setMinimumSize(new Dimension(270,24));
        MAXDISCREPANT.jc.setPreferredSize(new Dimension(270,24));
        MAXDISCREPANT.jl.setMinimumSize(new Dimension(240,24));
        MAXDISCREPANT.jl.setPreferredSize(new Dimension(240,24));
        MAXMISSINGPCT.jc.setMinimumSize(new Dimension(270,24));
        MAXMISSINGPCT.jc.setPreferredSize(new Dimension(270,24));
        MAXMISSINGPCT.jl.setMinimumSize(new Dimension(240,24));
        MAXMISSINGPCT.jl.setPreferredSize(new Dimension(240,24));
        MAXDISCREPANTPCT.jc.setMinimumSize(new Dimension(270,24));
        MAXDISCREPANTPCT.jc.setPreferredSize(new Dimension(270,24));
        MAXDISCREPANTPCT.jl.setMinimumSize(new Dimension(240,24));
        MAXDISCREPANTPCT.jl.setPreferredSize(new Dimension(240,24));
        SELTYPE.jc.setMinimumSize(new Dimension(240,24));
        SELTYPE.jc.setPreferredSize(new Dimension(240,24));
        DATETYPE.jc.setMinimumSize(new Dimension(240,24));
        DATETYPE.jc.setPreferredSize(new Dimension(240,24));
        SELTYPE.jc.addActionListener(new ActionListener() {
            public void actionPerformed(ActionEvent arg0) {
                if("Fewest Discrepant".equals(SELTYPE.getvalue())){
                    p.remove(MAXMISSINGPCT);
                    p.add(MINNUMBER,slot1);
                    p.remove(MAXDISCREPANTPCT);
                    p.add(MAXDISCREPANT,slot2);
                }else{
                    p.remove(MINNUMBER);
                    p.add(MAXMISSINGPCT,slot1);
                    p.remove(MAXDISCREPANT);
                    p.add(MAXDISCREPANTPCT,slot2);
                }
                p.validate();
                p.repaint();
            }
        });
        
        
        GridBagConstraints c = new GridBagConstraints();
        c.anchor=GridBagConstraints.WEST;
        
        GridBagConstraints g = (GridBagConstraints)c.clone();
        p.add(MICROSATELLITES,g);
        int y = 0;
        g = (GridBagConstraints)c.clone();
        g.gridy=++y;
        p.add(ALLELEFILE,g);
        
        g = (GridBagConstraints)c.clone();
        g.gridx=1;
        g.gridy=y;
        p.add(b2,g);

        g = (GridBagConstraints)c.clone();
        g.gridy=++y;
        p.add(TRIOSFILE,g);
        
        g = (GridBagConstraints)g.clone();
        g.gridx=1;
        g.gridy=y;
        p.add(b1,g);
        
        g = (GridBagConstraints)c.clone();
        g.gridy=++y;
        p.add(SIRESFIRST,g);

        g = (GridBagConstraints)c.clone();
        g.gridy=++y;
        g.anchor=GridBagConstraints.EAST;
        p.add(SELTYPE,g);

//      g = (GridBagConstraints)c.clone();
//      g.gridy=++y;
//      g.anchor=GridBagConstraints.EAST;
//      p.add(MAXMISSINGPCT,g);
        
//      g = (GridBagConstraints)c.clone();
//      g.gridy=++y;
//      g.anchor=GridBagConstraints.EAST;
//      p.add(MAXDISCREPANTPCT,g);
        
        g = (GridBagConstraints)c.clone();
        g.gridy=++y;
        g.anchor=GridBagConstraints.EAST;
        slot1=g;
        p.add(MINNUMBER,g);

        g = (GridBagConstraints)c.clone();
        g.gridy=++y;
        g.anchor=GridBagConstraints.EAST;
        slot2=g;
        p.add(MAXDISCREPANT,g);

        g = (GridBagConstraints)c.clone();
        g.gridy=++y;
        g.anchor=GridBagConstraints.EAST;
        p.add(DATETYPE,g);
        
        int i = Util.showmsgframe("Exclusion Parameters",640,310,p,null);
        if(i!=JOptionPane.OK_OPTION){
//          System.out.println("User cancel request");
            System.exit(0);
        }

        String outf=parse(args, "report","");

        if("".equals(outf))
            outf=File.createTempFile("out", ".txt").getCanonicalPath();
        
        String callf=parse(args, "calls","");
        
        if("".equals(callf))
            callf=File.createTempFile("calls", ".txt").getCanonicalPath();
        
//      args=new String[]{"percentdiscrepant="+MAXDISCREPANTPCT.getvalue(),
//          "percentmissing="+MAXMISSINGPCT.getvalue(),
        
        args=new String[]{"maxdiscrepant="+MAXDISCREPANT.getvalue(),
            "minnumber="+MINNUMBER.getvalue(),
            "percentdiscrepant="+MAXDISCREPANTPCT.getvalue(),
            "percentmissing="+MAXMISSINGPCT.getvalue(),         
            "siresfirst="+SIRESFIRST.getvalue(),
            "microsatellites="+MICROSATELLITES.getvalue(),
            "animalallelefile="+ALLELEFILE.getvalue(),
            "potentialtriosfile="+TRIOSFILE.getvalue(),
            "outfile="+outf,
            "callfile="+callf,
            "seltype="+SELTYPE.getvalue(),
            "datetype="+DATETYPE.getvalue()
        };
        
        ExclusionParentage.uhdr=null;
        ExclusionParentage.nalleles=0;
        ExclusionParentage.datetype=0;
        status.setStatus("Processing files");
        status.setWaiting(true);
        ExclusionParentage.main(args);
        status.setWaiting(false);
        status.setStatus("Displaying results");
        Exec.main(new String[] {outf});
        Exec.main(new String[] {callf});
        
        

//      System.exit(0);
    }
    
    /*
-d drawparams
-K K
-M NUMPOPS
-N NUMINDS
-p input file (population q's)
-i input file (individual q's)
-a input file (labels atop figure)
-b input file (labels below figure)
-c input file (cluster permutation)
-o output file
 */
    static String parse(String [] args,String key, String dflt){
        String s = parse(args, key);
        if(s==null)
            return dflt;
        return s;
        
    }
    static String parse(String [] args,String key){
        String r = null;
        String k = key + "=";
        for(int x = 0;x<args.length;x++){
            if(args[x].startsWith(k)){
                r=args[x];
                r=r.substring(k.length(),r.length());
            }
        }
        return r;
    }
}
