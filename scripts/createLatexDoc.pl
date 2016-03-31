#!/usr/bin/perl


use strict;

my $type = $ARGV[0];
my $refs = $ARGV[1];
my $papers = $ARGV[2];

die "$0 <C|J> refsFile papersFile" unless ($type eq "C" or $type eq "J") and $refs ne "" and $papers ne "";


my %refs;
my %invRefs;

my %papers;

Load_Refs($refs);

foreach my $k (keys %refs) {
#    print "[$refs{$k}] $k\n"
}

Do_Papers($papers);


foreach my $k (sort keys %papers){
    print "\\item $k \\cite{", $papers{$k}, "}\n";
}



sub Load_Refs
{
    my ($filename) = @_;

    open(IN, "<$filename") or die "Unable to open [$filename]";


    while (<IN>) {
        chomp;
        next unless $_ =~ /^$type/;
        my @f = split(/;/);
        my $index = sprintf("%03d",substr($f[0], 1));
        $refs{$f[1]} = $index;
        $invRefs{$index} = $f[1];
    }
    close IN;

}


sub Do_Papers
{
    my ($filename) = @_;

    open(IN, "<$filename") or die "Unable to open [$filename]";

    my %record;

    while (<IN>) {
        chomp;
        if ($_ eq "") {
            Process_Record(%record);
            %record = ();
            next;
        }
        my @f = split(/=/);
        $record{$f[0]} = $f[1];
        #    print "$f[0]=> $f[1]\n";
    }
    Process_Record(%record);

    close IN;

}

sub Process_Record
{
    my (%record) = @_;

    return if scalar(%record) < 2;


    my $ti = $record{Title};
    $ti =~ s/ - / /g;

    $ti =~ s/\..*$/\./;
    if (not ($ti =~ /\.$/)) {
        $ti .= ".";
    }
#    print "$refs{$ti} => $record{Title}\n";
    $papers{$refs{$ti}} = $record{dmgKey};
    if (not defined($refs{$ti})) {
        die "record does not contain title [$record{dmgKey}];[$record{Title}]";
    }

}
