#!/usr/bin/perl

package MaDAME;

use strict;
use warnings;

use MaDAME::Log;
#use MaDAME::Data;
use MaDAME::Engine;

use Data::Dumper;

our $madame;

our $engine  = shift;
our @request = @ARGV;
debug('@request contains: ' . join(', ', @request));

$madame = new MaDAME::Engine($engine, \@request);

my $data = $madame->initEngine();

print Dumper($data);

#my $json = &MaDAME::Data::toJSON($data);

#debug("json string? $json");
