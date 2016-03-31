#!/usr/bin/perl

use strict;
use FindBin;                 # locate this script

use lib "$FindBin::Bin";
use common;

my %fields = (
              recordId => 1,
              Type=>1,
              Title=>1,
              Conference=>1,
              Country=>1,
              City=>1,
              Date=>1,
              DateConf => 1,
              PublishedIn=>0,
              PageRange=>0,
              PublishingStatus=>1,
              Publisher=>1,
              DOI=>0,
              Refereed=>1,
              Authors=>1,
              Region => 0,
              Note => 0,
              dmgKey => 0,
             );

my %subregion = (
                 "Ontario" => "Canada",
                 "British Columbia" => "Canada",
                 "Quebec" => "Canada",
                 "California" => "United States",
                 "Virginia" => "United States",
                 "Nevada" => "United States",
                 "Hawaii" => "United States",
                 "New Mexico" => "United States",
                 );

my %countries = (
                 "Belgium" => 1,
                 "Canada" => 1,
                 "Costa Rica" => 1,
                 "Estonia" => 1,
                 "France" => 1,
                 "Germany" => 1,
                 "India" => 1,
                 "Italy" => 1,
                 "Mexico" => 1,
                 "Portugal" => 1,
                 "South Africa" => 1,
                 "Spain" => 1,
                 "Sweden" => 1,
                 "Switzerland" => 1,
                 "United Kingdom" => 1,
                 "United States" => 1,
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
            die "$record{Title}: empty field $k $record{$k}";
        }
        if (not defined($fields{$k})) {
            die "$record{Title}: Field not defined [$k]" ;
        } 
    }
    foreach my $k (keys %fields) {
        if ($fields{$k} == 1) {
            die "$record{recordId} :$record{Title}: => Field [$k] is required" unless defined($record{$k});
        }
                
    }
    die "$record{Title}:  publishedIn tool long [$record{PublishedIn}]" unless length($record{PublishedIn}) < 100;

    
    $record{Authors} =~ s/,\s*/,\n/g;
    $record{Contributors} = @{[$record{Authors} =~ /(\n)/g]} + 1;

    # verify format of date
    die "$record{Title}:  illegal format in date [$record{Date}]" unless $record{Date} =~ /^[0-9]{4}\/[0-9][0-9]?$/;
    die "$record{Title}:illegal format in date [$record{DateConf}]" unless $record{DateConf} =~ /^[0-9]{4}\-[0-9][0-9]?\-[0-9][0-9]?$/;

    # verify published status
    die "$record{Title}: We don't know this published status [$record{PublishingStatus}]" unless $record{PublishingStatus} =~ /^(Published|Accepted)$/;
    
    die "$record{Title}: We don't know this country [$record{Country}]" unless defined($countries{$record{Country}});
    $record{CountryOut} = '<linkedWith label="Country" value="' . $record{Country} . '" refOrLovId="00000000000000000000000000002000"/>';

    if ($record{Country} =~ /^(Canada|United States)$/) {
        die "This country [$record{Country}] requires a region " if not defined($record{Region});
    }

    # region
    if (defined ($record{Region})) {
        die "illegal region $record{Region} for country $record{Country}" unless $subregion{$record{Region}} eq $record{Country};
        $record{subregionOut} = '<linkedWith label="Subdivision" value="' . $record{Region} . '" refOrLovId="00000000000000000000000000100000"/>';
    } else {
        $record{subregionOut} = '<linkedWith label="Subdivision" value="Not Required" refOrLovId="00000000000000000000000000100000"/>';
    }
    

    die "We don't know this type [$record{Type}]" unless defined($lov{$record{Type}});
    
    # verify refereed
    Verify_Yes_No($record{Refereed}, "Refereed");


    return %record;
}

sub Output_Entry
{
    my %record = (@_);
#    foreach my $k (sort keys %record) {
#       print "$k-> $record{$k}\n"
#    }

print <<END;
<section id="4b9f909503cd4c8aa8d826c87d6d874d" label="Conference Publications" recordId="$record{recordId}">
<field id="81ef87c09ded47ae8880b8d79e83406f" label="Conference Publication Type">
$lov{$record{Type}}
</field>
<field id="8e6ee535c95e42ec866b777c7472bafb" label="Publication Title">
<value type="String">$record{Title}</value>
</field>
<field id="b3c8a60c053a405597b92899d95765a3" label="Conference Name">
<value type="String">$record{Conference}</value>
</field>
<field id="5813833859a64bb58ee55e4f55aff29b" label="Conference Location">
<refTable refValueId="c7d3a87e7a604727934e58a525586fbf" label="Country-Subdivision">
$record{CountryOut}
$record{subregionOut}
</refTable>
</field>
<field id="c2efd9725588489b8df73467c5597c32" label="City">
<value type="String">$record{City}</value>
</field>
<field id="99b57db653a841ccbd5f8e52079745c0" label="Conference Date">
<value format="yyyy-MM-dd" type="Date">$record{DateConf}</value>
</field>
<field id="1a1b39e861054ee59d270e66271a4ead" label="Published In">
<value type="String">$record{PublishedIn}</value>
</field>
<field id="684ccb1fcdd7421f89b304ff5c40579d" label="Page Range">
<value type="String">$record{PageRange}</value>
</field>
<field id="080301b1f1c0464bba7fcfa1fa8fe182" label="Publishing Status">
$lov{$record{PublishingStatus}}
</field>
<field id="0318d139f3e0479083188ff8319a97b2" label="Date">
<value format="yyyy/MM" type="YearMonth">$record{Date}</value>
</field>
<field id="0c357193a93f4137a87394401ac81958" label="Publisher">
<value type="String">$record{Publisher}</value>
</field>
<field id="a6e901e5f0cf48a3a7d674bf1e6fcd7f" label="Description / Contribution Value">
<value type="Bilingual">
</value>
<bilingual>
<french>
</french>
<english>$record{Note}
</english>
</bilingual>
</field>
<field id="61690b466fb748d99ed29b340c0ee60b" label="URL">
<value type="String">http://dx.doi.org/10.1007/978-3-319-17837-0_14</value>
</field>
<field id="560a2ce08e14497ba575af760eb12ba9" label="Refereed?">
$lov{$record{Refereed}}
</field>
<field id="06295e65f66b4c6aa286d08bd9fac59b" label="Invited?">
<lov id="00000000000000000000000000000401">No</lov>
</field>
<field id="b101f8f057db434ba4fdee3a86c387cc" label="Contribution Role">
<lov id="00000000000000000000000100002102">Co-Author</lov>
</field>
<field id="1a66ad40654a45c9a0119b19d7cf20a6" label="Number of Contributors">
<value type="Number">$record{Contributors}</value>
</field>
<field id="3cc54d9bb92d421da46548979048396f" label="Authors">
<value type="String">$record{Authors}</value>
</field>
<field id="018e656a0f824b1f91a6a2cb33ac61dd" label="Editors">
<value type="String">
</value>
</field>
</section>
END
}
