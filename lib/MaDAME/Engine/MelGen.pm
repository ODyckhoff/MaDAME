#!/usr/bin/perl

package MaDAME::Engine::MelGen;

use strict;
use warnings;

sub new {
    my $class = shift;
    my $self = {
        request => shift, # Should be either 'get_data' or 'calc_data'.
        data    => \@_,
    };
    bless $self, $class;

    return $self;
}

sub init {
    print "Hurray, MelGen loaded!\n";
}
1;
