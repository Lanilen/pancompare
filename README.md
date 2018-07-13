# pancompare
 Scripts to compare SNP calls across different genomes (for a pangenome approach to SNP calling)

 So far, there are scripts only for doing cross-genome comparisons for GBS data. What the code
does is take alignments of TAGS (as they come out of TASSEL, which reduces whole datasets to
distinct tags) against a reference genome, and find "perfect pairs" of tags (which are the ones
that contain the interesting SNPs). These perfect pairs can be found against different genomes,
then a simple comparison will report whether you're finding the same perfect pairs with the
different genomes, or different ones.

 To obtain the list of tags, follow the Tassel 5 workflow:
https://bitbucket.org/tasseladmin/tassel-5-source/wiki/Tassel5GBSv2Pipeline
 
 Stop after running TagExportToFastqPlugin. Use a high value for -c (min. count) so that
you don't get bogged down with sequencing errors and similar nonsense. Sequencing errors
will break perfect pairs and give fake SNPs that, while easy to filter, will break this
approach to comparing tags.

 You can obtain these tags in any other way you may see fit!!
 
 The scripts assume all tags start at the cut site (hence, start at the same spot). This
may not be true if your reference genome is so far away you might get random indels through
the tag alignments that alter the start/end.

 Also, you can skip the tag pairing and use UNEAK, which will by default give perfect pairs
of tags (or any other de novo method to GBS SNP calling that will report these pairs).

Code:

perfect_pairs.pl:
 Usage: perfect_pairs.pl samfile > output.txt

 All this requires is a sam file of tags mapped to a reference genome, and will output a list
 of single-space separated perfect pairs of tags. Run this individually for each alignment to
 a different reference genome you have.
 
compare_lists.pl:
 Usage: compare_lists.pl (unique|intersect) file1 file2 (...) fileN
 
 Depends on List::Compare perl module (cpanm List::Compare).
 
 The script can be run in two ways:

 compare_lists.pl intersect file1 file2 file3 ...
  This will generate a list of lines that appear in all the prepared files
 identically. In the case of GBS tags, these should be 'perfect pair' files
 where tags that map as unique pairs to the same location are placed in the
 same line.

 compare_lists.pl unique file1 file2 file3
  This will generate a comma separated file with one line per alignment, with which lines
 are unique to each of the files (so make sure the files have no commas at all). The first
 element of each line will be the name of the files.
