#!/usr/bin/perl

package MaDAME::Engine::MusDat::CalcHandler::Chord;

use strict;
use warnings;

use MaDAME::Configuration;
use MaDAME::Log qw( debug error );
use MaDAME::Engine::MusDat::CalcHandler::Mode::Minor;
use MaDAME::Engine::MusDat::CalcHandler::Mode::Major;

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
    my $key = $_[0];
    debug("key = $key");
    my @progression = ();

    if    ($key =~ s/nat//) {
        @progression = &MaDAME::Engine::MusDat::CalcHandler::Mode::Minor::getKeyProg($key, $&);
    }
    elsif ($key =~ s/har//) {
        @progression = &MaDAME::Engine::MusDat::CalcHandler::Mode::Minor::getKeyProg($key, $&);
    }
    elsif ($key =~ s/mel//) {
        @progression = &MaDAME::Engine::MusDat::CalcHandler::Mode::Minor::getKeyProg($key, $&);
    }
    else {
        # Probably major
        @progression = &MaDAME::Engine::MusDat::CalcHandler::Mode::Major::getKeyProg($key) 
            unless ( $key =~ /\D/ && error( "'$key' is not a valid key.") ) ;
    }

    for my $chord ( @progression ) {
        # replace each root note in the progression with its chord.
        debug("Your chord is $chord");
        $chord = [ getChordNotes( $chord ) ];
    }

    return @progression;
}

sub getChordNotes {
    my ($chord) = @_;
    debug("testing $chord");

    $chord =~ /^(\d+)(\w+?)?$/;
    my $key = $1;
    my $mode = $2 || 'maj';

    my @notes = ();

    if($mode =~ /^(maj|dom7|maj7|aug)$/) {
        @notes = &MaDAME::Engine::MusDat::CalcHandler::Mode::Major::getChord($key);
    }
    elsif($mode =~ /^(min|mdom7|mmaj7|dim|nat|har|mel|m)$/) {
        @notes = &MaDAME::Engine::MusDat::CalcHandler::Mode::Minor::getChord($key);
    }
    else {
        # unrecognised mode.
    }

    @notes = augment(@notes)  if $mode eq 'aug' ;
    @notes = diminish(@notes) if $mode eq 'dim' ;
    @notes = dom7(@notes)     if $mode eq 'dom7';
    @notes = maj7(@notes)     if $mode eq 'maj7';

    return @notes;
}

sub getChordsByNote {
    my ($note) = @_;
    debug("the note is $note"); 
    my @chords = (
    # root chords.
        # major chords.
        $note, 
        $note . 'dom7',
        $note . 'maj7',
        $note . 'aug',

        # minor chords.
        $note . 'min',
        $note . 'mdom7',
        $note . 'mmaj7',
        $note . 'dim',

    # note as a third
        # major chords.
        (($note - 4) < 0 ? (($note - 4) + 12) : $note - 4),
        (($note - 4) < 0 ? (($note - 4) + 12) : $note - 4) . 'dom7',
        (($note - 4) < 0 ? (($note - 4) + 12) : $note - 4) . 'maj7',
        (($note - 4) < 0 ? (($note - 4) + 12) : $note - 4) . 'aug',

        # minor chords.
        (($note - 3) < 0 ? (($note - 3) + 12) : $note - 3) . 'min',
        (($note - 3) < 0 ? (($note - 3) + 12) : $note - 3) . 'mdom7',
        (($note - 3) < 0 ? (($note - 3) + 12) : $note - 3) . 'mmaj7',
        (($note - 3) < 0 ? (($note - 3) + 12) : $note - 3) . 'dim',

    # note as a fifth
        # major chords.
        (($note - 7) < 0 ? (($note - 7) + 12) : $note - 7),
        (($note - 7) < 0 ? (($note - 7) + 12) : $note - 7) . 'dom7',
        (($note - 7) < 0 ? (($note - 7) + 12) : $note - 7) . 'maj7',
        (($note - 8) < 0 ? (($note - 8) + 12) : $note - 8) . 'aug',

        # minor chords.
        (($note - 7) < 0 ? (($note - 7) + 12) : $note - 7) . 'min',
        (($note - 7) < 0 ? (($note - 7) + 12) : $note - 7) . 'mdom7',
        (($note - 7) < 0 ? (($note - 7) + 12) : $note - 7) . 'mmaj7',
        (($note - 6) < 0 ? (($note - 6) + 12) : $note - 6) . 'dim',

    # note as a dominant 7th
        (($note - 10) < 0 ? (($note - 10) + 12) : $note - 10) . 'dom7',
        (($note - 10) < 0 ? (($note - 10) + 12) : $note - 10) . 'mdom7',

    # note as a major 7th
        (($note - 11) < 0 ? (($note - 11) + 12) : $note - 11) . 'maj7',
        (($note - 11) < 0 ? (($note - 11) + 12) : $note - 11) . 'mmaj7',
    );

    my @fullchords = ();

    foreach my $root (@chords) {
        push(@fullchords, [getChordNotes($root)]);
    }

    return @fullchords;
}

sub getKeysByChord {
    # major    - maj min min maj maj min dim
    # natural  - min dim maj min min maj maj
    # harmonic - min dim aug min maj maj dim
    # melodic  - min min aug maj maj dim dim

    my @chord = @_;
    debug("\@chord = " . join(', ', @chord));
    my @positions = ();
    my @keys = ();

    if( scalar( @chord ) == 3 ) {
        # Could be a maj, min, aug or dim.
           if( $chord[0] == $chord[1] - 4 && $chord[1] == $chord[2] - 3 ) {
            # Major 3rd followed by Minor 3rd. Major Chord.
            debug( "Found major chord (" . join(', ', @chord) . ")." );

            push( @positions, ([0, 3, 4], [2, 5, 6], [4, 5], [3, 4]) );
        }
        elsif( $chord[0] == $chord[1] - 3 && $chord[1] == $chord[2] - 4 ) {
            # Minor 3rd followed by Major 3rd. Minor Chord.
            debug( "Found minor chord (" . join(', ', @chord) . ")." );

            push( @positions, ([1, 2, 5], [0, 3, 4], [0, 3], [0, 1]) );
        }
        elsif( $chord[0] == $chord[1] - 4 && $chord[1] == $chord[2] - 4 ) {
            # Two Major 3rd intervals. Augmented Chord.
            debug( "Found augmented chord (" . join(', ', @chord) . ")." );

            push( @positions, ([], [], [2], [2]) );
        }
        elsif( $chord[0] == $chord[1] - 3 && $chord[1] == $chord[2] - 3 ) {
            # Two Minor 3rd intervals. Diminished Chord.
            debug( "Found diminished chord (" . join(', ', @chord) . ")." );

            push( @positions, ([6], [1], [1, 6], [5, 6]) );
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

    # Loop through all chord positions.
    for(my $i = 0; $i < 4; $i++) {
        next unless $positions[$i]; # chord type does not appear, move on.
        
        foreach my $position ( @{ $positions[$i] } ) {
            # Subract the root note of the chord by the number of the position to get the key
            
            my $key  = $chord[0] - $position;
            $key += 12    if ( $key < 0 );
            $key .= 'min' if ( $i  == 1 );
            $key .= 'har' if ( $i  == 2 );
            $key .= 'mel' if ( $i  == 3 );

            push( @keys, $key );
        }
    }

    return @keys;

}

#my @notes = (1, 4, 7);
#getKeysByChord(@notes);
#print(join(', ', augment(@notes)) . "\n");
#@notes = (0, 4, 7);
#print(join(', ', diminish(@notes)) . "\n");
#@notes = (0, 4, 7);
#print(join(', ', dom7(@notes)) . "\n");
#@notes = (0, 4, 7);
#print(join(', ', maj7(@notes)) . "\n");
1;
