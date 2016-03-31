#!/usr/bin/perl

######################################################################

my %lov = (
           "Published" => "<lov id=\"00000000000000000000000100001704\">Published</lov>",
           "Accepted" =>  "<lov id=\"00000000000000000000000100001702\">Accepted</lov>",
           "Yes"  => "<lov id=\"00000000000000000000000000000400\">Yes</lov>",
           "No"  => "<lov id=\"00000000000000000000000000000401\">No</lov>",
           "Paper" => '<lov id="00000000000000000000000100007000">Paper</lov>',
          );

sub Get_Lov {
    return %lov;
}

sub Read_Entry {
    my %record;
    while (<>) {
        if (not $_ =~ /^([^=]+)=(.+)$/) {
            next if /^#/;
            if (/^\s*$/) {
                return %record;    
            } else {
                die "Illegal line [$_] in input";
            }
        }
        $record{$1} = $2;
    }
    return %record;
}

sub Read_Entry {
    my %record;
    while (<IN>) {
        next if /^#/;
        if (not $_ =~ /^([^=]+)=(.+)$/) {
            return %record;
        }
        $record{$1} = $2;
    }
    return %record;
}

sub Verify_Yes_No {
    my ($val, $field) =@_;
    if ($val eq "Yes" or $val eq "No") {
        return;
    }
    die "Illegal yes/no answer in field [$field] value [$val]";
    
}


sub Process_File {
    
    my ($file) = @_;
    
    die "Usage $0 <filename>\n\n" if (not -f $file);
    
    open(IN, $file) or die "Unable to open input file [$file]";
    
    print <<END;
<?xml version="1.0" encoding="UTF-8"?>
<generic-cv:generic-cv xmlns:generic-cv="http://www.cihr-irsc.gc.ca/generic-cv/1.0.0" lang="en" dateTimeGenerated="2015-07-20 23:16:49">
<section id="047ec63e32fe450e943cb678339e8102" label="Contributions">
<section id="46e8f57e67db48b29d84dda77cf0ef51" label="Publications">
END
    
    
    my $count = 0;
    my %entry;
    while (%entry = Read_Entry()) {
        %entry = Verify_Entry(%entry);
        Output_Entry(%entry);
        $count++;
    }
    
    print <<END;
</section>
</section>
</generic-cv:generic-cv>
END
    
    print STDERR "Created $count records\n";
    close IN;
}

1;
