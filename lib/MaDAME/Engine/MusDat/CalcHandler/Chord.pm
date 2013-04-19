#!/usr/bin/perl

package MaDAME::Engine::MusDat::CalcHandler::Chord;

use strict;
use warnings;

use MaDAME::Configuration;
use MaDAME::Log qw( debug error );

sub augment {
    $_[2]++;
    return @_;
}

sub diminish {
    $_[2]--;
    return @_;
}

sub dom7 {
    push(@_, 10);
    return @_;
}

sub maj7 {
    push(@_, 11);
    return @_;
}

sub getProgression {


}

sub getChordNotes {
    my ($chord) = @_;

    $chord =~ /^(\d)(.*?)?$/;
    my $key = $1;
    my $mode = $2 || 'maj';

    my @notes = ();

    if($mode =~ /^(maj|dom7|maj7|aug)$/) {
        # Major.pm
    }
    elsif($mode =~ /^(m|mdom7|mmaj7|dim)$/) {
        # Minor.pm
    }
    else {
        # unrecognised mode.
    }

    @notes = augment(@notes)  if $mode eq 'aug';
    @notes = diminish(@notes) if $mode eq 'dim';

    return @notes;
}

sub getChordsByNote {
    my ($note) = @_;
    
    my @chords = (
    # root chords.
        # major chords.
        $note . 'maj', 
        $note . 'dom7',
        $note . 'maj7',
        $note . 'aug',

        # minor chords.
        $note . 'm',
        $note . 'mdom7',
        $note . 'mmaj7',
        $note . 'dim',

    # note as a third
        # major chords.
        ($note - 4) . 'maj',
        ($note - 4) . 'dom7',
        ($note - 4) . 'maj7',
        ($note - 4) . 'aug',

        # minor chords.
        ($note - 3) . 'm',
        ($note - 3) . 'mdom7',
        ($note - 3) . 'mmaj7',
        ($note - 3) . 'dim',

    # note as a fifth
        # major chords.
        ($note - 7) . 'maj',
        ($note - 7) . 'dom7',
        ($note - 7) . 'maj7',
        ($note - 8) . 'aug',

        # minor chords.
        ($note - 7) . 'm',
        ($note - 7) . 'mdom7',
        ($note - 7) . 'mmaj7',
        ($note - 6) . 'dim',

    # note as a dominant 7th
        ($note - 10) . 'dom7',
        ($note - 10) . 'mdom7',

    # note as a major 7th
        ($note - 11) . 'maj7',
        ($note - 11) . 'mmaj7',
    );

    my @fullchords = ();

    foreach my $root (@chords) {
        push(@fullchords, getChordNotes($root));
    }

    return @fullchords;
}

sub getKeysByChord {
    # major    - maj min min maj maj min dim
    # natural  - min dim maj min min maj maj
    # harmonic - min dim aug min maj maj dim
    # melodic  - min min aug maj maj dim dim

    my @chord = @_;
    if( scalar( @chord ) == 3 ) {
        # Could be a maj, min, aug or dim.
           if( $chord[0] == $chord[1] - 4 && $chord[1] == $chord[2] - 3 ) {
            # Major 3rd followed by Minor 3rd. Major Chord.
            debug( "Found major chord (" . join(', ', @chord) . ")." );
        }
        elsif( $chord[0] == $chord[1] - 3 && $chord[1] == $chord[2] - 4 ) {
            # Minor 3rd followed by Major 3rd. Minor Chord.
            debug( "Found minor chord (" . join(', ', @chord) . ")." );
        }
        elsif( $chord[0] == $chord[1] - 4 && $chord[1] == $chord[2] - 4 ) {
            # Two Major 3rd intervals. Augmented Chord.
            debug( "Found augmented chord (" . join(', ', @chord) . ")." );
        }
        elsif( $chord[0] == $chord[1] - 3 && $chord[1] == $chord[2] - 3 ) {
            # Two Minor 3rd intervals. Diminished Chord.
            debug( "Found diminished chord (" . join(', ', @chord) . ")." );
        }
        else {
            # Unknown.
            error( "Unknown chord type for chord (" . join(', ', @chord) . ")." );
        }
    }
    else {
        # Too few or two many notes. Not a valid chord.
        error( ( scalar( @chord ) > 3 ? "Too many notes" : "Too few notes" ) . " in chord (" . join(', ', @chord ) . ")." );
    }

}

my @notes = (1, 4, 7);
getKeysByChord(@notes);
#print(join(', ', augment(@notes)) . "\n");
#@notes = (0, 4, 7);
#print(join(', ', diminish(@notes)) . "\n");
#@notes = (0, 4, 7);
#print(join(', ', dom7(@notes)) . "\n");
#@notes = (0, 4, 7);
#print(join(', ', maj7(@notes)) . "\n");
1;
