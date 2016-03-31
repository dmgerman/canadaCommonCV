#!/usr/bin/perl

use strict;

my %record;

while (<>) {
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


sub Process_Record
{
    my (%record) = @_;
    
    foreach my $k (keys (%record)) {
        $record{$k} =~ s@%@\\%@g;
    }


    # year and month
    my ($year, $month) = split('/',$record{Date});



    my @months = ('Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sept', 'Oct', 'Nov', 'Dec');

    # clean authors

    $record{Authors} =~ s/\.$//; # last . if exists
    $record{Authors} =~ s/<b>//g;
    $record{Authors} =~ s/\*//g;
    $record{Authors} =~ s@</b>@@g;
    $record{Authors} =~ s@, @ and @g; # comma becomes an and
    

    my $indent = "    ";
    print "\@InProceedings{$record{dmgKey},\n";
    print ${indent}, "author = \{$record{Authors}\},\n";
    print ${indent}, "booktitle = \{$record{PublishedIn}\},\n";
    print ${indent}, "title = \{$record{Title}\},\n";
    print ${indent}, "year = \{$year\},\n";
    print ${indent}, "month = \{$months[$month]\},\n";
    print ${indent}, "pages = \{$record{PageRange}\},\n" if $record{PageRange} ne "";
    print ${indent}, "doi = \{$record{URL}\},\n" if $record{URL} ne "";
    print ${indent}, "dmgnote = \{$record{Note}\},\n" if $record{Note} ne "";
    
    print "}\n";
}
