#!/usr/bin/perl

package MaDAME::Engine::MusDat::CalcHandler::Chord;

use strict;
use warnings;

sub augment {
    $_[2]++;
    return @_;
}

sub diminish {
    $_[1]--;
    $_[2]--;
    return @_;
}

my @notes = (0, 4, 7);
print(join(', ', augment(@notes)) . "\n");
@notes = (0, 4, 7);
print(join(', ', diminish(@notes)) . "\n");
