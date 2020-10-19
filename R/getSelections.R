#' Get selections from user
#'
#' Initial implementation is to get selections from a file using key value
#' pairs.
#'
#'public static void main2(String[] args) throws Exception{
#'SwingUtil.init();
#'status.setStatus("Waiting for input");
#'String tst = "";
#'for(int x = 0; x < args.length;x++){
#'  tst=tst+args[x]+"|";
#'}
#'//Util.showmsg("Exclusion Parameters",new Exception(tst),null);
#'//      if(args==null||args.length==0)
#'  //          args=new String[]{"/tmp/GT200909911BF_2-Analysis_FinalReport.txt","/tmp/out.txt","/tmp/pop.txt","/tmp/parm.txt"};
#'  //          args=new String[]{"/tmp/final.txt","/tmp/out.txt","/tmp/pop.txt","/tmp/parm.txt"};
#'  //      args=new String[]{"/tmp/sample.txt","/tmp/out.txt","/tmp/pop.txt","/tmp/parm.txt"};
#'  //          args=new String[]{"/var/progs/tmp/partfinal.txt","/var/progs/tmp/out.txt","/var/progs/tmp/pop.txt","/var/progs/tmp/parm.txt","500","100"};
#'  //      args=new String[]{"/var/tmp/beadout.txt","/var/progs/tmp/out.txt","/var/progs/tmp/pop.txt","/var/progs/tmp/parm.txt","500","100"};
#'  //      args=new String[]{"6","Microsatellites-1.0","../genetics/tstfiles/animalalleles.tsv","../genetics/tstfiles/potentialtrios.tsv",""};
#'
#'  //convert to structure format
#'  //  cvt(args);
#'
#'
#'
#'  final Panel p = new Panel();
#'  p.setLayout(new GridBagLayout());
#'  final HCheckfield MICROSATELLITES= new HCheckfield("Microsatellite based allele file",0,"Override the default SNP-based allele file");
#'  final HFloatfield MAXMISSINGPCT= new HFloatfield("Max missing/unused loci %", 10,0,100,"maximum allowable missing/incomparable data to be considered a match to the offspring.",true);
#'  final HFloatfield MAXDISCREPANTPCT= new HFloatfield("Max discrepant loci %", 2,0,100,"how many alleles must match for the individual to be considered a match.",true);
#'  final HNumberField MINNUMBER= new HNumberField("Min available loci", 90,0,999,"minimum number of loci to be considered a match to the offspring.",true);
#'  final HNumberField MAXDISCREPANT= new HNumberField("Max discrepant loci ", 1,0,100,"how many alleles must match for the individual to be considered a match.",true);
#'  MICROSATELLITES.jc.addActionListener(new ActionListener() {
#'
#'    public void actionPerformed(ActionEvent e) {
#'      if("0".equals(MICROSATELLITES.getvalue()))
#'        MINNUMBER.jc.setText("90");
#'      else
#'        MINNUMBER.jc.setText("13");
#'
#'
#'    }
#'  });
#'  final HCheckfield SIRESFIRST= new HCheckfield("Exclude Sires First",0,"Override the default Dams-first exclusion");
#'
#'
#'  final HTextfield ALLELEFILE= new HTextfield("Animals Allele File", "","Location of animal markers file");
#'  final HTextfield TRIOSFILE= new HTextfield("Potential Trios File", "","Location of the list of offspring and potential dams/sires");
#'  String tm=System.getProperty("allelefile");
#'  if(tm!= null)
#'    ALLELEFILE.jc.setText(tm);
#'
#'  tm=System.getProperty("triofile");
#'  if(tm!= null)
#'    TRIOSFILE.jc.setText(tm);
#'  final HPullDown SELTYPE= new HPullDown("Selection Method",new String[]{"Fewest Discrepant","Most Concordant"}, "Select parent that has the minimum number of discrepancies or the greatest percentage of concordant alleles with the offspring.",true);
#'  final HPullDown DATETYPE= new HPullDown("Input date format",new String[]{"mm/dd/YYYY","YYYYMMDD"}, "mm/dd/YYYY is compatible with excel and etc, YYYYMMDD is the native pedsys format.",true);
#'  JButton b1 = new JButton("Browse...");
#'  b1.addActionListener(new ActionListener() {
#'    public void actionPerformed(ActionEvent e) {
#'      JFileChooser c;
#'      if("".equals(lastdir[0]))
#'        c= new JFileChooser();
#'      else
#'        c=new JFileChooser(lastdir[0]);
#'      // Demonstrate "Save" dialog:
#'          int rVal = c.showSaveDialog(null);
#'          if (rVal == JFileChooser.APPROVE_OPTION) {
#'            TRIOSFILE.jc.setText(c.getSelectedFile().getPath());
#'            lastdir[0]=c.getSelectedFile().getParent();
#'          }
#'    }
#'  });
#'  Dimension d = new Dimension(100,24);
#'  b1.setMaximumSize(d);
#'  b1.setPreferredSize(d);
#'  b1.setMinimumSize(d);
#'  JButton b2 = new JButton("Browse...");
#'  b2.addActionListener(new ActionListener() {
#'
#'    public void actionPerformed(ActionEvent e) {
#'      JFileChooser c;
#'      if("".equals(lastdir[0]))
#'        c= new JFileChooser();
#'      else
#'        c=new JFileChooser(lastdir[0]);
#'      // Demonstrate "Save" dialog:
#'          int rVal = c.showSaveDialog(null);
#'          if (rVal == JFileChooser.APPROVE_OPTION) {
#'            ALLELEFILE.jc.setText(c.getSelectedFile().getPath());
#'            lastdir[0]=c.getSelectedFile().getParent();
#'          }
#'    }
#'  });
#'  b2.setMaximumSize(d);
#'  b2.setPreferredSize(d);
#'  b2.setMinimumSize(d);
#'  Dimension dm = new Dimension(240,24);
#'  TRIOSFILE.jc.sz=dm;
#'  ALLELEFILE.jc.sz=dm;
#'  TRIOSFILE.jc.setsize();
#'  ALLELEFILE.jc.setsize();
#'
#'  MICROSATELLITES.jc.setMinimumSize(new Dimension(240,24));
#'  MICROSATELLITES.jc.setPreferredSize(new Dimension(240,24));
#'  SIRESFIRST.jc.setMinimumSize(new Dimension(240,24));
#'  SIRESFIRST.jc.setPreferredSize(new Dimension(240,24));
#'  //MICROSATELLITES.jl.setMinimumSize(new Dimension(270,24));
#'  //MICROSATELLITES.jl.setPreferredSize(new Dimension(270,24));
#'
#'
#'  MINNUMBER.jc.setMinimumSize(new Dimension(270,24));
#'  MINNUMBER.jc.setPreferredSize(new Dimension(270,24));
#'  MINNUMBER.jl.setMinimumSize(new Dimension(240,24));
#'  MINNUMBER.jl.setPreferredSize(new Dimension(240,24));
#'  MAXDISCREPANT.jc.setMinimumSize(new Dimension(270,24));
#'  MAXDISCREPANT.jc.setPreferredSize(new Dimension(270,24));
#'  MAXDISCREPANT.jl.setMinimumSize(new Dimension(240,24));
#'  MAXDISCREPANT.jl.setPreferredSize(new Dimension(240,24));
#'  MAXMISSINGPCT.jc.setMinimumSize(new Dimension(270,24));
#'  MAXMISSINGPCT.jc.setPreferredSize(new Dimension(270,24));
#'  MAXMISSINGPCT.jl.setMinimumSize(new Dimension(240,24));
#'  MAXMISSINGPCT.jl.setPreferredSize(new Dimension(240,24));
#'  MAXDISCREPANTPCT.jc.setMinimumSize(new Dimension(270,24));
#'  MAXDISCREPANTPCT.jc.setPreferredSize(new Dimension(270,24));
#'  MAXDISCREPANTPCT.jl.setMinimumSize(new Dimension(240,24));
#'  MAXDISCREPANTPCT.jl.setPreferredSize(new Dimension(240,24));
#'  SELTYPE.jc.setMinimumSize(new Dimension(240,24));
#'  SELTYPE.jc.setPreferredSize(new Dimension(240,24));
#'  DATETYPE.jc.setMinimumSize(new Dimension(240,24));
#'  DATETYPE.jc.setPreferredSize(new Dimension(240,24));
#'  SELTYPE.jc.addActionListener(new ActionListener() {
#'    public void actionPerformed(ActionEvent arg0) {
#'      if("Fewest Discrepant".equals(SELTYPE.getvalue())){
#'        p.remove(MAXMISSINGPCT);
#'        p.add(MINNUMBER,slot1);
#'        p.remove(MAXDISCREPANTPCT);
#'        p.add(MAXDISCREPANT,slot2);
#'      }else{
#'        p.remove(MINNUMBER);
#'        p.add(MAXMISSINGPCT,slot1);
#'        p.remove(MAXDISCREPANT);
#'        p.add(MAXDISCREPANTPCT,slot2);
#'      }
#'      p.validate();
#'      p.repaint();
#'    }
#'  });
#'
