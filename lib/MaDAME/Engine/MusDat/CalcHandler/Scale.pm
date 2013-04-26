#!/usr/bin/perl

package MaDAME::Engine::MusDat::CalcHandler::Scale;

use strict;
use warnings;

use MaDAME::Configuration;
use MaDAME::Log;
use MaDAME::Engine::MusDat::CalcHandler::Mode::Minor;
use MaDAME::Engine::MusDat::CalcHandler::Mode::Major;

sub findScale {
    my ($key) = @_;
    my @scale;

    $key =~ /(\d+)(\w+)?/;
    my $keynumber = $1;
    my $minor = $2 ? $2 : 'nat';
    if ($minor) {
        @scale = &MaDAME::Engine::MusDat::CalcHandler::Mode::Minor::getScale($keynumber, $minor);
    }
    else {
        @scale = &MaDAME::Engine::MusDat::CalcHandler::Mode::Major::getScale($keynumber);
    }
    debug( "scale is: " . join(', ', @scale));
    return @scale;
}
1;
