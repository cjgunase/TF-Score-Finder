use strict;
use warnings;
use List::MoreUtils qw/ uniq /;
my(@values,%pwhash,%ppwhash,%tfhash,@pwvalues,@tfvalues,%hoa,%scorehash,%layerhash,%hoa2,$score,%annohash);

my $pos_TF_score=1; #If itself is a positive TF give a score
my $pwscore =1;# IF connects to a pw gene give a score
my $ppwscore=1; # if connects to a positive pw gene give a score
my $pTFscore=1; #if connects toa positive TF give a score


open(IN,"filter_c2_l70sxyn_method1_tab_tf_gene_layer_all_bottomup_top.txt") or die " File not found $!";
open(pw,"pwlist.txt") or die " File not found $!";
open(Ppw,"positive_pwlist.txt") or die " File not found $!";
open(tf,"tflist.txt") or die " File not found $!";
open(OUT,">TF_Score.txt") or die "file waht not found";
open(ANNO,"p2_annotation.txt") or die "file waht not found";
<ANNO>;
while(<ANNO>){
	s/\r\n?/\n/;  # remove return
	chomp();
	#print "$_\n";
	@values = split('\t', $_);
	$annohash{$values[0]}="$_";
	}

while(<pw>){ # 									 PW list
	s/\r\n?/\n/;  # remove return
	chomp();
	s/\r\n?/\n/;  # remove return
	chomp();
	@pwvalues = split('\t', $_);
	$pwhash{$pwvalues[0]}=$pwvalues[1];
	}
	
	while(<Ppw>){ # 							all Positive PW list
	s/\r\n?/\n/;  # remove return
	chomp();
	s/\r\n?/\n/;  # remove return
	chomp();
	my @ppwvalues = split('\t', $_);
	$ppwhash{$ppwvalues[0]}=$ppwvalues[1];
	}
	

while(<tf>){#positive TF list
	s/\r\n?/\n/;  # remove return
	chomp();
	s/\r\n?/\n/;  # remove return
	chomp();
	@tfvalues = split('\t', $_);
	$tfhash{$tfvalues[0]}=$tfvalues[1];
	$scorehash{$tfvalues[0]}=$pos_TF_score;#IF a Positive TF add a score
	
}

<IN>;
while(<IN>){#store the pTF and PW to hash with TF as key
	s/\r\n?/\n/;  # remove return
	chomp();
	@values = split('\t', $_);
	
	$hoa{$values[1]};
	push @{$hoa{$values[1]}},"$values[2]";
	
	$layerhash{$values[4]};
		push @{$layerhash{$values[4]}},"$values[1]";
	
	}
	
	
	foreach (sort keys %hoa) {#calculate natural score
    print "$_ : @{$hoa{$_}}\n";
    
    $score=0;
    unless(exists($pwhash{$_})||exists($ppwhash{$_})){
    	if(exists($tfhash{$_})){
    		$score=$score+1;}
    }
    
    
    foreach(@{$hoa{$_}}){
    	
    	if(exists($pwhash{$_})){$score=$score+$pwscore;} #check if connects to pathway gens
    	if(exists($ppwhash{$_})){$score=$score+$ppwscore;} #check if connects to pathway gens
    	if(exists($tfhash{$_})){$score=$score+$pTFscore;} #check if connects to positive TFs
    	
    	unless(exists($pwhash{$_})||exists($ppwhash{$_})||exists($tfhash{$_})){
    		$score++;
    	}
    	
    	
    	
    } 
    print "$_ Score:= $score\n";
    if(exists($scorehash{$_})){#if a positive TF it already have a score add to that score
    $scorehash{$_}=$scorehash{$_}+$score;
    }else{
    	$scorehash{$_}=$score;
    }
    
  }
  
  #--more connections to PW or TF
  
#  foreach (sort keys %hoa) {#calculate update  score of TFs
#   my $a=$_;
#    foreach(@{$hoa{$_}}){#POPTR_0001s02340.1 : POPTR_0003s17980.1 POPTR_0003s18720.1 POPTR_0005s11950.1 POPTR_0006s03180.1 POPTR_0013s15380.2
#    	
#    	    	
#    	   unless(exists($pwhash{$_})||exists($ppwhash{$_})){ 	
#    	if($scorehash{$_} > 0){ $scorehash{$a}=$scorehash{$a}+1; }
#    	
#    	   }
#    	
#    } 
#    
#   # $scorehash{$_}=$score2;
#    
#    
#  }
  
  
  
  
  
  #---
  print  "Layer\tTF\tScore\ttranscript_name\tcommon\tFBG_ID\tTAIR10_hit_symbol\tTAIR10_hit_define\tTAIR10_hit_name\tType\tTF\tTreeTFDB_PACid\tXy_specific\tXylem\tPholem\tLeaf\tShoot\tprotoplast
\n";
  foreach(sort keys %layerhash){
  	my $kye=$_;
  	
  	@{$layerhash{$_}}= uniq @{$layerhash{$_}};
  	foreach ( @{$layerhash{$_}} ) {
    print "$kye\t$_\t$scorehash{$_}\t$annohash{$_}\n";
    
}
  	
  }
  
  
  
 
  
  
	
	
	
	








