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
    my $engine = &$sub( $data ) ; #die ( "Error: Incorrect Data Type '$1'.\n" );

    return $engine;
}

sub get {
    print "Getting: $_[0]\n";

    use MaDAME::Engine::MusDat::Get;
    my $engine = new MaDAME::Engine::MusDat::Get ( $_[0] );

    return $engine;
}

sub calc {
    print "Calculating with: $_[0]\n";

    use MaDAME::Engine::MusDat::Calc;
    my $engine = new MaDAME::Engine::MusDat::Calc ( $_[0] );

    return $engine;
}
1;
