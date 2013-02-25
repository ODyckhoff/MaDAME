#!/usr/bin/perl

package MaDAME::Engine::MusDat::KeyFinder;

use strict;
use warnings;

# use MaDAME::Configuration;

    # number - 0,  1,  2,  3,  4,  5,  6,  7
    # --------------------------------------
    # sharps - 0, F#, C#, G#, D#, A#, E#, B#
    #    key - C,  G,  D,  A,  E,  B, F#, C#
    # --------------------------------------
    #  flats - 0, Bb, Eb, Ab, Db, Gb, Cb, Fb
    #    key - C,  F, Bb, Eb, Ab, Db, Gb, Cb


sub obj_get_key { # Detect key based on note objects passed.
    my @notes = @_; # An array of note objects.
    foreach $note (@notes) {
        if $note->is_modified($note) {
            # It's a sharp or a flat.
        }
    }
}

sub num_get_key { # Detect key based on raw note data (numbers) passed.
    my @notes = @_; # An array of note numbers.
    foreach $note (@notes) {
        
    }
}
