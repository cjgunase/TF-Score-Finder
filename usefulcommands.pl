use strict;
use warnings;

open(LAY,"temp.txt") or die "temp File not found $!";

s/\r\n?/\n/;  # remove return
	chomp();
	
	#split by tabs
	@values = split('\t', $_);