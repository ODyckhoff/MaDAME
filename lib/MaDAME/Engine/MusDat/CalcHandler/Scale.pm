#!/usr/bin/perl

package MaDAME::Engine::MusDat::CalcHandler::Scale;

use strict;
use warnings;

sub getScale {
    my ($key) = @_;
    my $mode = shift;
    my @scale;

    $key =~ /(\d+)(\w+)?/;
    my $keynumber = $1;
    my $minor = $2 ? 1 : 0;
    if ($minor && $mode) {
        @scale = $Mode::Minor::getScale($keynumber, 'min');
    }
    else {
        @scale = $Mode::Major::getScale($keynumber);
    }

    return @scale;
}
