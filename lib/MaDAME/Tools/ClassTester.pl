#!/usr/bin/perl

package MaDAME::Tools::ClassTester;

use strict;
use warnings;

push ( @INC, '../..' );

my $class = shift || 'MaDAME';
my $methodWant = shift || 'init';
my $debugMode = shift || 0;

my @params = @ARGV;
print join( ', ', @params ) . "\n";

( my $requirement = $class . '.pm' ) =~ s{::}{/}g;
require $requirement;

my $debugref = $class . '::debug';
my $debug = \$debugref;
   $$debug = 1 if $debugMode;

my $object = $class->new ( @params );
$object->$methodWant;
