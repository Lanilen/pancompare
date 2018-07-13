#!/usr/bin/perl

use strict;
use List::Compare;

my $usage = "Usage: $0 (unique|intersect) file1 file2 (...) fileN\n
 The script can be run in two ways:

 $0 intersect file1 file2 file3 ...
 This will generate a list of lines that appear in all the prepared files
identically. In the case of GBS tags, these should be 'perfect pair' files
where tags that map as unique pairs to the same location are placed in the
same line.

 $0 unique file1 file2 file3
 This will generate a comma separated file with a table indicating which lines
are unique to each of the files (so make sure the files have no commas at all).
Headers will be the name of the files.
";

if ($#ARGV < 2) {
    die $usage;
}

if ($ARGV[0] ne "unique" && $ARGV[0] ne "intersect") {
    die $usage;
}

my @lists;

foreach my $n (1..$#ARGV) {
    open (READ, $ARGV[$n]);
    my @lines;
    while (<READ>) {
	chomp;
	unless (/^\#/) {
	    push (@lines, $_);
	}
    }
    close READ;
    push (@lists, \@lines);
}

#my $lc = List::Compare->new(@lists);

# Okay, so we have to make a loop to be able to find all the intersects.
# Why? Because of how List::Compare works. It has a comparison that will
# give all the unique elements of the FIRST array, and another that will
# give all the unique elements of THE REST OF THE ARRAYS. So, we gotta loop

my @uniques;
my @intersect;
my $intersection_empty = 1;

for my $n (0..$#lists) {
    my $lc = List::Compare->new(@lists);
    my @uni;
    push (@uni, $ARGV[$n+1]);
    push (@uni, $lc->get_unique());
    push (@uniques, join(',', @uni));
    if ($intersection_empty) {
	@intersect = $lc->get_intersection();
    }
    push (@lists, (shift @lists)); #Rotate AFTER adding the ouytput to @uniques
}

if ($ARGV[0] eq "unique") {
    foreach my $i (@uniques) {
	print $i, "\n";
    }
}

elsif ($ARGV[0] eq "intersect") {
    foreach my $i (@intersect) {
	print $i, "\n";
    }
}
