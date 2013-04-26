#!/usr/bin/perl

package MaDAME;

use strict;
use warnings;

use MaDAME::Log;

our $madame;

our $engine  = shift;
our @request = @ARGV;
debug('@request contains: ' . join(', ', @request));

use MaDAME::Engine;
$madame = new MaDAME::Engine($engine, \@request);

my $data = $madame->initEngine();

print(join(', ', @{%{@{$data}[0]}->{scale}} ) . "\n");
