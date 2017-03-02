
#This script find number of paths from each TF to Pathway genes 

use strict;
use warnings;
use List::MoreUtils qw/ uniq /;
my(@values,%pwhash,%ppwhash,%tfhash,@pwvalues,@tfvalues,%hoa,%scorehash,%layerhash,%hoa2,$score,%hoh,%annohash);


open(IN,"filter_c2_l70sxyn_method1_tab_tf_gene_layer_all_bottomup_top.txt") or die " File not found $!";#Network file
open(pw,"pwlist.txt") or die " File not found $!";#Pathway list
open(Ppw,"positive_pwlist.txt") or die " File not found $!";#positive pathway list
open(tf,"tflist.txt") or die " File not found $!";#positive TF list
open(OUT,">PathsfromTF.txt") or die "file waht not found";#output file
open(ANNO,"p2_annotation.txt") or die "file waht not found";#annotation file

<ANNO>;

	while(<ANNO>){
	s/\r\n?/\n/;  # remove return
	chomp();
	#print "$_\n";
	@values = split('\t', $_);
	$annohash{$values[0]}="$values[1]";
	}
	#---------------------------Create annotation hash---------------

while(<pw>){ # 									 PW list
	s/\r\n?/\n/;  # remove return
	chomp();
	s/\r\n?/\n/;  # remove return
	chomp();
	@pwvalues = split('\t', $_);
	$pwhash{$pwvalues[0]}=$pwvalues[1];
	}
	#-------------------------------------------------------------------------
	while(<Ppw>){ # 							all Positive PW list
	s/\r\n?/\n/;  # remove return
	chomp();
	s/\r\n?/\n/;  # remove return
	chomp();
	my @ppwvalues = split('\t', $_);
	$ppwhash{$ppwvalues[0]}=$ppwvalues[1];
	}
	
#------------------------------------------------------------------------------
while(<tf>){#positive TF list
	s/\r\n?/\n/;  # remove return
	chomp();
	s/\r\n?/\n/;  # remove return
	chomp();
	@tfvalues = split('\t', $_);
	$tfhash{$tfvalues[0]}=$tfvalues[1];
	#$scorehash{$tfvalues[0]}=$pos_TF_score;#IF a Positive TF add a score
	
}
#-----------------------------------------------------------------------------
<IN>;
while(<IN>){#store the pTF and PW to hash with TF as key
	s/\r\n?/\n/;  # remove return
	chomp();
	@values = split('\t', $_);
	
	$layerhash{$values[4]};
	push @{$layerhash{$values[4]}},"$values[1]"; 
	
	$hoa{$values[1]};
	push @{$hoa{$values[1]}},"$values[2]";
}
#--------------------------------------------------------------------------------
my $count=0;
foreach (sort keys %hoa) {#calculate natural score of TFs only for layer1
    my $b=$_;
    if( grep( /^$b$/, @{$layerhash{'layer1'}} ) ){ #do this for only layer1
    $scorehash{$b}= scalar @{$hoa{$b}};
    $count++;
    }

}

#---------------------------------------------------------------------------------
foreach(sort keys %layerhash){
	my $a=$_;
	unless($a eq 'layer1'){
	@{$layerhash{$a}}= uniq @{$layerhash{$a}};# get uniq TFs in each layers except layer 1
	print "$a : @{$layerhash{$a}}\n";
#		
	foreach(@{$layerhash{$a}}){#get the array of TFs in each layer
			
			
			print "\t$_\n";
			foreach(@{$hoa{$_}}){#get the array of TFs which it connects to from bottom
				my $b=$_;
				print "\t\t$b\t$scorehash{$b}\n";
				
				
				$score=$score+$scorehash{$b};#add each of the score of the bottom layer elements connected to this tf from layer above.
				
			}
			$scorehash{$_}=$score;
			$score=0;
		
			}
	}
		
}
#------------------------------------------------------------------------------------------

print  "Layer\tTF\tpaths\tsymbol\n";
 foreach(sort keys %layerhash){#print the layer and score of each TF based on connections.
  	my $kye=$_;
  	
  	@{$layerhash{$_}}= uniq @{$layerhash{$_}};
  	foreach ( @{$layerhash{$_}} ) {
    print  "$kye\t$_\t$scorehash{$_}\t$annohash{$_}\n";
    
}
  	
  }
  #---------------------------------END--------------------------------------------------------
  
	
	



