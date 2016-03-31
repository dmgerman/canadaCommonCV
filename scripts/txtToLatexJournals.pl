#!/usr/bin/perl

use strict;
use FindBin;                 # locate this script

use lib "$FindBin::Bin";
use common;

my %fields =(
            recordId => 0,
            Title=>1,
            Journal=>1,
            Volume=>1,
            Issue=>1,
            PageRange=>0,
            PublishingStatus=>0,
            Date=>1,
            Publisher=>0,
            URL=>0,
            Refereed=>0,
            OpenAccess=>0,
            Authors=>1,
            dmgKey => 1,
);



my $file = shift @ARGV;
Process_File_Latex($file);
exit(0);

sub Verify_Entry
{
    my %record = @_;

    # verify all fields are accounted for

    foreach my $k (keys %fields) {
        if ($fields{$k} == 1) {
            die "$record{recordId} :$record{Title}: => Field [$k] is required" unless defined($record{$k});
        }
    }
    
    return %record;
}



sub Output_Entry
{
    my (%record) = @_;
    
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
    print "\@article{$record{dmgKey},\n";
    print ${indent}, "author = \{$record{Authors}\},\n";
    print ${indent}, "journal = \{$record{Journal}\},\n";
    print ${indent}, "title = \{$record{Title}\},\n";
    print ${indent}, "year = \{$year\},\n";
    print ${indent}, "month = \{$months[$month]\},\n";
    print ${indent}, "volume = \{$record{Volume}\},\n";
    print ${indent}, "number = \{$record{Issue}\},\n";
    print ${indent}, "doi = \{$record{DOI}\},\n" if $record{DOI} ne "";
    print "}\n\n";
}
