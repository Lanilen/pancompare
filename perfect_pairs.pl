#!/usr/bin/perl

my $usage = "$0 samfile > output.txt\n";

unless ($#ARGV == 0) {
    die $usage;
}

my %position;

open (READ, $ARGV[0]);
 LOOP: while (<READ>) {
     chomp;
     if (/^\@/) {
	 next LOOP;
     }
     my @x = split;
     my $pos = $x[3];
     if ($x[1] == 4) {
	 next LOOP;
     }
     if ($x[1] == 16) {
	 # It's a reverse read, so we have to translate the CIGAR
	 while ($x[5] =~ m/(\d+)([A-Z])/g) {
	     my $l = $1;
	     my $t = $2;
	     if ($t =~ /[MD]/) {
		 $pos += $l;
	     }
	 }
     }
     $pos--; # This is because the first position is a 1M, so everything
             # would be +1 otherwise
     
     $pos .= "_";
     $pos .= $x[2];
     if (length ($position{$pos}) > 0) {
	 $position{$pos} .= " ";
     }
     $position{$pos} .= $x[0];
#     if ($x[1] == 16) {
#	 $position{$pos} .= "-R";
#     }
}
close READ;

foreach my $n (keys %position) {
    my @x = split (/\s+/, $position{$n});
    if ($#x == 1) {
	# First, check that you're not just matching a read against
	# its reverse complement
	my @checker = @x;
	$checker[0] =~ s/[^ACTGactg]//g;
	$checker[1] =~ s/[^ACTGactg]//g;
	if ($checker[0] eq $checker[1] || $checker[0] eq &revcomp($checker[1])) {
	    # It's the same tag!
	}
	else {
	    my @sorted = sort(@x);
	#print $sorted[0], " ", $sorted[1], "\n";
	    print $position{$n}, "\n";
	}
    }
}

sub revcomp {
    my ($seq) = @_;
    $seq = reverse($seq);
    $seq =~ tr/ACTGactg/TGACtgac/;
    return $seq;
}
