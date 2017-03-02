use strict;
use warnings;
open(FILE,"scoreUPDATED.txt") or die "file waht not found";
open(ANNO,"p2_annotation.txt") or die "file waht not found";
my(%annohash,@values);
<ANNO>;

while(<ANNO>){
	s/\r\n?/\n/;  # remove return
	chomp();
	#print "$_\n";
	@values = split('\t', $_);
	$annohash{$values[0]}="$values[1]";
	}
	
	while(<FILE>){
		s/\r\n?/\n/;  # remove return
		chomp();
		
		my @values2 = split('\t', $_);
		
		print "$_\t$annohash{$values2[1]}\n";
	}
	
	
	
	#------------------------
	  #--more connections to PW or TF-----------------------omitted----------
  
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


#-------------

#    unless(exists($pwhash{$_})||exists($ppwhash{$_})){
#    	if(exists($tfhash{$_})){
#    		$score=$score+$pos_TF_score;}
#    }
	
	
	
	