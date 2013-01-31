#!/usr/bin/perl

package MaDAME::Configuration;

use strict;
use warnings;

use Exporter;
my @ISA = qw( Exporter );
my @EXPORT = qw( %cfg );

our %cfg;

use Cwd 'abs_path';
my $path = abs_path($0);
chomp $path;
print "$path\n";

$path =~ s{(?<!MaDAME)(.+?)MaDAME.*}{$1MaDAME};

my $directory = $path . '/config/';
opendir (DIR, $directory) or die $!;

while (my $file = readdir(DIR)) {
    next if ( $file =~ /^\.\.?$/ );
    print "$file\n";
    if(do $directory . $file) {
        print "  hurray\n";
    } else {
        print "$!\n";
    }
}

closedir(DIR);

1;
