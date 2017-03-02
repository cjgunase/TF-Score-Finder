use strict;
#use warnings;
use List::MoreUtils qw/ uniq /;
my(@values,%pwhash,%ppwhash,%tfhash,@pwvalues,@tfvalues,%hoa,%scorehash,%layerhash,%hoa2,$score,%annohash,%layer1hash);
#------------------------------------Define scores for PW,poistive PW,PositiveTF------------------------------default given 1
my $pos_TF_score=1; #If itself is a positive TF give a score
my $pwscore =1;# IF connects to a pw gene give a score
my $ppwscore=1; # if connects to a positive pw gene give a score
my $pTFscore=1; #if connects toa positive TF give a score
my $regTF=1; # if not a Positive TF, Not connected to PW or Positive PW give a score

#---------------------------------------------------------------------------------------------------------------------------
open(IN,"filter_c2_l70sxyn_method1_tab_tf_gene_layer_all_bottomup_top.txt") or die " File not found $!";
open(pw,"pwlist.txt") or die " File not found $!";
open(Ppw,"positive_pwlist.txt") or die " File not found $!";
open(tf,"tflist.txt") or die " File not found $!";
open(OUT,">TF_Score.txt") or die "file waht not found";
open(ANNO,"p2_annotation.txt") or die "file waht not found";
#-----------------------------------------------------------------read annotation-------------------------
<ANNO>;
while(<ANNO>){
	s/\r\n?/\n/;  # remove return
	chomp();
	#print "$_\n";
	@values = split('\t', $_);
	$annohash{$values[0]}="$_";
	}
#-----------------------------------------------------------------REad Pathway list-------------------------
while(<pw>){ # 									
	s/\r\n?/\n/;  # remove return
	chomp();
	s/\r\n?/\n/;  # remove return
	chomp();
	@pwvalues = split('\t', $_);
	$pwhash{$pwvalues[0]}=$pwvalues[1];
	}
#-----------------------------------------------------------------REad positive Pathway list-------------------------	
	while(<Ppw>){ # 							
	s/\r\n?/\n/;  # remove return
	chomp();
	s/\r\n?/\n/;  # remove return
	chomp();
	my @ppwvalues = split('\t', $_);
	$ppwhash{$ppwvalues[0]}=$ppwvalues[1];
	}
	
#-----------------------------------------------------------------REad positive TF list-------------------------
while(<tf>){#positive TF list
	s/\r\n?/\n/;  # remove return
	chomp();
	s/\r\n?/\n/;  # remove return
	chomp();
	@tfvalues = split('\t', $_);
	$tfhash{$tfvalues[0]}=$tfvalues[1];
	$scorehash{$tfvalues[0]}=$pos_TF_score;#IF a Positive TF add a score
	
}
#-----------------------------------------------------------------REad Network file and put in to a hash of array for Each TF and its connections-------------------------
<IN>;
while(<IN>){#store the pTF and PW to hash with TF as key
	s/\r\n?/\n/;  # remove return
	chomp();
	@values = split('\t', $_);
	
	$hoa{$values[1]};
	push @{$hoa{$values[1]}},"$values[2]";
	
	$layerhash{$values[4]};
		push @{$layerhash{$values[4]}},"$values[1]";
	
	if($values[4] eq "layer1"){
		$layer1hash{$values[1]}="";}

			}
	
#-------------------------------------------------------Find what each TF is connected to and put to a hash of array TF  : Cennected PW or TF-----------------------	

	foreach (sort keys %hoa) {
    print "$_ : @{$hoa{$_}}\n";
#-----------------------------------------------------add a score to each TF if connected a positive TF in Upper Layer------------    
    $score=0;
    my $triger=0;
    unless(exists($layer1hash{$_})){#unless exist in layer1
    	if(exists($tfhash{$_})){
    		
    		$triger=1;
    	}
    		
    }
   
#---------------------------------------------------------Add scores if connected to PW, Postive PW, Positive TF, or regular TF-------------------------------------------------------    
    
    foreach(@{$hoa{$_}}){
    	if($triger == 1){$scorehash{$_}=$scorehash{$_}+$pTFscore;}
    	$triger =0;
    	if(exists($pwhash{$_})){$score=$score+$pwscore;} #check if connects to pathway gens
    	
    	if(exists($ppwhash{$_})){$score=$score+$ppwscore;} #check if connects to pos pathway gens
    	
    	if(exists($tfhash{$_})){$score=$score+$pTFscore;} #check if connects to positive TFs
    	
    	
    	unless(exists($pwhash{$_})||exists($ppwhash{$_})||exists($tfhash{$_})){
    							$score=$score+$regTF;#check if conneted to a regular TF
    							
    	}
    	   	
    	}
    	
    	
    	
    	
    	
  #---------------------------------------------------------adding scores together and put in to hash of TF:Score hash-----------------------------------------------------  	
    	
    	 
    
    if(exists($scorehash{$_})){#if a positive TF it already have a score add to that score
    $scorehash{$_}=$scorehash{$_}+$score;
    }else{
    	$scorehash{$_}=$score;
    }
    #---------------------------------------------------------------Score added-------------------------------------------------------
  }
  

  
  
  
  
  
# ---------------------------------Print OUT with annotation and score of each TF---------------------------------------------------------

  print OUT "Layer\tTF\tScore\ttranscript_name\tcommon\tFBG_ID\tTAIR10_hit_symbol\tTAIR10_hit_define\tTAIR10_hit_name\tType\tTF\tTreeTFDB_PACid\tXy_specific\tXylem\tPholem\tLeaf\tShoot\tprotoplast
";
  foreach(sort keys %layerhash){
  	my $kye=$_;
  	
  	@{$layerhash{$_}}= uniq @{$layerhash{$_}};
  	foreach ( @{$layerhash{$_}} ) {
    print OUT "$kye\t$_\t$scorehash{$_}\t$annohash{$_}\n";
    
}
  	
  }
  
  
  
 
  
  
	
	
	
	








