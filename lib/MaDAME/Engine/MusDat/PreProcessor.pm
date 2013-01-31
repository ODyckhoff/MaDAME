#!/usr/bin/perl

package MaDAME::Engine::MusDat::PreProcessor;

use strict;
use warnings;

use MaDAME::Configuration;

sub new {
    my $class = shift;
    my $self = {
        type   => shift,
        data   => shift,
       #params => \@_,
    };

    print "PreProcessor: $self->{type}\n";

    bless $self, $class;

    return $self;
}

sub sort_type {
    my $self = shift;

    my $type = $self->{type};
    print "PreProcessor::sort_type: $type\n";
    my $data = $self->{data};

    my $subref = $type;
    my $sub    = \&$subref;
    &$sub( $data ) ; #die ( "Error: Incorrect Data Type '$1'.\n" );
}

sub get {
    print "Getting: $_[0]\n";

}

sub calc {
    print "Calculating with: $_[0]\n";

}
1;
