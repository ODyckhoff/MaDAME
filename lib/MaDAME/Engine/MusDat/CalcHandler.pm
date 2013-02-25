#!/usr/bin/perl

package MaDAME::Engine::MusDat::CalcHandler;

use strict;
use warnings;

use MaDAME::Configuration;

sub new {
    my $class = shift;
    my $self = {
        data => shift,
    };
    bless $self, $class;
    
    return $self;
}
1;
