#!/usr/bin/perl

use strict;
use FindBin;                 # locate this script

use lib "$FindBin::Bin";
use common;

my %fields = (
              recordId => 0,
              Type=>0,
              Title=>1,
              Conference=>0,
              Country=>0,
              City=>0,
              Date=>1,
              DateConf => 0,
              PublishedIn=>1,
              PageRange=>0, # output if present
              PublishingStatus=>0,
              Publisher=>0,
              DOI=>0, # output if present
              Refereed=>0,
              Authors=>1,
              Region => 0,
              Note => 0, # output if present
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


sub Output_Entry {
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
    print ${indent}, "doi = \{$record{DOI}\},\n" if $record{DOI} ne "";
    print ${indent}, "dmgnote = \{$record{Note}\},\n" if $record{Note} ne "";
    
    print "}\n\n";
}
