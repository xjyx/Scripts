#!/usr/bin/perl

use FindBin qw ($Bin);
use Getopt::Long;


GetOptions(\%opt,"list:s","fasta:s","output:s","help:s");

my $help=<<USAGE;
Get fasta sequences for ids in a list file
perl getidseq.pl -l id -f RAP3.fa -o nohit.fa > log  

USAGE

if (exists $opt{help} or !-f $opt{fasta}){
   print $help;
   exit;
}


### store id into hash %id
my %id;
open IN, "$opt{list}" or die "$!";
while(<IN>){
    chomp $_;
    next if ($_ eq "");
    $id{$_}=1;    
}
close IN;


### read fasta file and output fasta if id is found in list file
$/=">";
open IN,"$opt{fasta}" or die "$!";
open OUT, ">$opt{output}" or die "$!";
while (<IN>){
    next if (length $_ < 2);
    my @unit=split("\n",$_);
    my $temp=shift @unit;
    my @temp1=split(" ",$temp,2);
    my $head=$temp1[0];
    my $anno=$temp1[1];
    #print "$temp\n";
    #my @temp2=split /"\|",$temp/;
    #my $head1=$temp2[0];
    #$head1=~s/|//g;
    #print "$head1\n";
    my $seq=join("\n",@unit);
    $seq=~s/\>//g;
    if (exists $id{$head}){
      print OUT ">$head $temp1[1]\n$seq";
    }
    #elsif(exists $id{$head1}){
    #  print OUT ">$head1\n$seq";
    #}
    
 
}
close OUT;
close IN;
$/="\n";


