#!/usr/bin/perl

use strict;
use FindBin;                 # locate this script

use lib "$FindBin::Bin";
use common;

# which fields from the input file do you want to output?
my %fields =(
            recordId => 1,
            Title=>1,
            Journal=>1,
            Volume=>1,
            Issue=>1,
            PageRange=>1,
            PublishingStatus=>1,
            Date=>1,
            Publisher=>1,
            URL=>1,
            Refereed=>1,
            OpenAccess=>1,
            Authors=>1,
            dmgKey => 0,
);

my %lov = Get_Lov();

my $file = shift @ARGV;

Process_File_XML($file);

exit(0);


sub Verify_Entry
{
    my %record = @_;

    # verify all fields are accounted for

    foreach my $k (keys %record) {
        if ($record{$k} eq "") {
            die "empty field $k $record{$k}";
        }
        if (not defined($fields{$k})) {
            die "Field not defined [$k]";
        }
                
    }

    $record{Authors} =~ s/,\s*/,\n/g;
    $record{Contributors} = @{[$record{Authors} =~ /(\n)/g]} + 1;

    # verify format of date
    die "$record{Title}: illegal format in date [$record{Date}]" unless $record{Date} =~ /^[0-9]{4}\/[0-9][0-9]?$/;

    # verify published status
    die "$record{Title}:  We don't know this published status [$record{PublishedStatus}]" unless $record{PublishingStatus} =~ /^(Published|Accepted)$/;
    # verify refereed
    Verify_Yes_No($record{Refereed}, "Refereed");
    Verify_Yes_No($record{OpenAccess}, "Open Access");


    return %record;
}


sub Output_Entry
{
    my %record = (@_);
#    foreach my $k (sort keys %record) {
#       print "$k-> $record{$k}\n"
#    }

print <<END;
<section id="9a34d6b273914f18b2273e8de7c48fd6" label="Journal Articles" recordId="$record{recordId}">
<field id="f3fd4878d47c4e83aef6959620ba4870" label="Article Title">
<value type="String">$record{Title}</value>
</field>
<field id="5c04ea4dae464499807d0b40b4cad049" label="Journal">
<value type="String">$record{Journal}</value>
</field>
<field id="0a826c656ff34e579dfcbfb373771260" label="Volume">
<value type="String">$record{Volume}</value>
</field>
<field id="cc1d9e14945b4e8496641dbe22b3448a" label="Issue">
<value type="String">$record{Issue}</value>
</field>
<field id="00ba1799ece344dc8d0779a3f05a4df8" label="Page Range">
<value type="String">$record{PageRange}</value>
</field>
<field id="3b56e4362d6a495aa5d22a1de5914741" label="Publishing Status">
$lov{$record{PublishingStatus}}
</field>
<field id="6fafe258e19e49a7884428cb49d75424" label="Date">
<value format="yyyy/MM" type="YearMonth">$record{Date}</value>
</field>
<field id="4ad593960aba4a21bf154fa8daf37f9f" label="Publisher">
<value type="String">$record{Publisher}</value>
</field>
<field id="4c3bc805ceaa42259f014514fc4905f8" label="Publication Location"/>
<field id="1167905d079c4400ae7a4a76a203a445" label="Description / Contribution Value">
<value type="Bilingual">
</value>
<bilingual>
<french>
</french>
<english>
</english>
</bilingual>
</field>
<field id="478545acac5340c0a73b7e0d2a4bee06" label="URL">
<value type="String">$record{URL}</value>
</field>
<field id="2089ff1a86844b6c9a10fc63469f9a9d" label="Refereed?">
$lov{$record{Refereed}}
</field>
<field id="51b7eaff05444990af823b9d80924f5b" label="Open Access?">
$lov{$record{OpenAccess}}
</field>
<field id="b779cc6478bd4b09b516c6d55e938583" label="Synthesis?"/>
<field id="289c8814fff141d89b12569d49aa2cb3" label="Contribution Role">
<lov id="00000000000000000000000100002102">Co-Author</lov>
</field>
<field id="dc7922dfa04348a3a83c9afb5bbaa24a" label="Number of Contributors">
<value type="Number">$record{Contributors}</value>
</field>
<field id="bc3b428d99384b04bb749311bb804e1d" label="Authors">
<value type="String">$record{Authors}</value>
</field>
<field id="707a6e0ca58341a5a82fb923b2842530" label="Editors">
<value type="String">
</value>
</field>
</section>
END
}
