#!/usr/bin/perl

# note.pl - contains subroutines for individual note calculations.

use strict;
use warnings;

use Getopt::Long;

our(@note_array, @white, @black, $result, $note_no, $octave);
# $result = GetOptions ("length=i" => \$note_no);
$note_no = shift;

@note_array = (['A', 'Gss', 'Bbb'], ['As', 'Bb'], ['B', 'Ass'], ['C', 'Dbb'], ['Cs', 'Db'], ['D', 'Css', 'Ebb'], ['Ds', 'Eb'], ['E', 'Dss'], ['F', 'Gbb'], ['Fs', 'Gb'], ['G', 'Fss', 'Abb'], ['Gs', 'Ab']);

#                   A     A#/Bb     B       C     C#/Db     D     D#/Eb     E       F     F#/Gb     G     G#/Ab
# --------------------------------------------------------------------------------------------------------------
# | Black Notes |       |   1   |       |       |   4   |       |   6   |       |       |   9   |       |  11  |
# |-------------+-------+-------+-------+-------+-------+-------+-------+-------+-------+-------+-------+------|
# | White Notes |   0   |       |   2   |   3   |       |   5   |       |   7   |   8   |       |   10  |      |
# --------------------------------------------------------------------------------------------------------------
#                   A     A#/Bb     B       C     C#/Db     D     D#/Eb     E       F     F#/Gb     G     G#/Ab

@black = (1, 4, 6, 9, 11);
@white = (0, 2, 3, 5, 7, 8, 10);

sub note_res {
    # Resolve note number to a note and an octave. Octave 0 is defined as being the octave that contains Concert A (440 Hz frequency).
    $octave = 0;
    
    while ($note_no >= 12) {
        # Will skip loop and proceed to second loop if $note_no is less than 12
        
        $note_no -= 12;
        $octave++;
    }

    while ($note_no < 0) {
        
        $note_no += 12;
        $octave--;
    }

    return($note_no, $octave);
}

my @info = note_res();
print 'The note is either ' . join(', ', @{$note_array[$info[0]]}) . ' and may be found in octave ' . $octave . "\n";
