#!/usr/bin/perl

package MaDAME::Data::Objects::Note;

# note.pl - contains subroutines for individual note calculations.

use strict;
use warnings;

# use MaDAME::Configuration;

our ( @note_array, @white, @black, %durations, %modifiers );

@note_array = (['A', 'Gss', 'Bbb'], ['As', 'Bb'], ['B', 'Ass', 'Cb'], ['C', 'Bs', 'Dbb'], ['Cs', 'Db'], ['D', 'Css', 'Ebb'], ['Ds', 'Eb'], ['E', 'Dss', 'Fb'], ['F', 'Es', 'Gbb'], ['Fs', 'Gb'], ['G', 'Fss', 'Abb'], ['Gs', 'Ab']);

#                   A     A#/Bb     B       C     C#/Db     D     D#/Eb     E       F     F#/Gb     G     G#/Ab
# --------------------------------------------------------------------------------------------------------------
# | Black Notes |       |   1   |       |       |   4   |       |   6   |       |       |   9   |       |  11  |
# |-------------+-------+-------+-------+-------+-------+-------+-------+-------+-------+-------+-------+------|
# | White Notes |   0   |       |   2   |   3   |       |   5   |       |   7   |   8   |       |   10  |      |
# --------------------------------------------------------------------------------------------------------------
#                   A     A#/Bb     B       C     C#/Db     D     D#/Eb     E       F     F#/Gb     G     G#/Ab

@black = (1, 4, 6, 9, 11); # Black notes only have 2 names.
@white = (0, 2, 3, 5, 7, 8, 10); # White notes have 3 names.

%durations = (
      0 => 'breve',
      1 => 'semibreve',
      2 => 'minim',
      4 => 'crotchet',
      8 => 'quaver',
     16 => 'semiquaver',
     32 => 'demisemiquaver',
     64 => 'hemidemisemiquaver',
    128 => 'quasihemidemisemiquaver',
);

%modifiers = (
     's' => "\x{266F}",  # Sharp
    'ss' => "\x{1D12A}", # Double Sharp
     'b' => "\x{266D}",  # Flat
    'bb' => "\x{1D12B}", # Double Flat
     'n' => "\x{266E}",  # Natural
);
   

sub new {
    my $class = shift;
    my $self = {
        note      => shift,
        octave    => shift,
        duration  => shift,
        modifiers => shift,
    };
    bless $self, $class;

    return $self;
}

sub note_res {
    # Resolve note number to a note and an octave. Octave 0 is defined as being the octave that contains Concert A (440 Hz frequency).

    my $self = shift;

    my $octave = 0;
    my $note_no = $self->{note};
    
    while ($note_no >= 12) {
        # Will skip loop and proceed to second loop if $note_no is less than 12
        
        $note_no -= 12;
        $octave++;
    }

    while ($note_no < 0) {
        
        $note_no += 12;
        $octave--;
    }
    
    # Update object attributes.
    $self->{octave} = $octave;
    $self->{note}   = $note_no;

    return($note_no, $octave);
}

sub get_note {
    # Will be used when notes are retrieved for data processing.
    
    my $self = shift;
    
    # Loop through hash checking that all attributes are defined.
    for my $key ( sort keys %{ $self } ) {
        if ( ! $self->{$key} ) { 
            # Throw a Malformed Note Exception; attribute isn't defined.
            print "Malformed Note Exception\n\t'$key' is not defined.\n"
                unless $key eq 'parsed';
        }
    }
    
    $self->{parsed} = parse_note($self);
    print $self->{parsed} if $self->{parsed};
}

sub parse_note {
    my $self = shift;

    my $note      = $note_array[$self->{note}]->[0];
    my $octave    = $self->{octave};
    my $duration  = $self->{duration};
    my $type      = $durations{ $self->{duration} };
    my $mods      = $self->{modifiers};
    
    while ( $mods =~ s/\.// ) {
        $duration = (1/$duration)*1.5;
        $type = 'dotted-' . $type;
    }

    $mods =~ s/(ss|s|bb|b|n)/$modifiers{ $1 }/g;
    die "Error: malformed modifiers in '$self->{modifiers}'.\n"
        if $mods =~ /\w/; # If there's anything left, something is wrong.
    
    return "The note is: $note$mods $type in octave $octave, and will last for $duration beats.\n";
}

# my @info = note_res();
# print 'The note is either ' . join(', ', @{$note_array[$info[0]]}) . ' and may be found in octave ' . $octave . "\n";
