#!/usr/bin/perl

package MaDAME::Engine::MusDat::CalcHandler::KeyFinder;

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


####### REQUIREMENT #######
#
# a) either detect key based on numbers of sharps/flats
#     - problems caused by non black note sharps/flats e.g. E# or Cb
#
# b) or based on TTSTTTS pattern for simple Major key calculation
#     - however, interval data may be needed for relative major/minor calculation
#     - BUT
#         + e.g. C major/A minor - C, Dm, Em, F, G, Am, Bdim / Am, Bdim, C, Dm, Em, F, G
#         + Same thing, different order.
#         + So just present both sets of information? GetHandler will be able to request single key if user wants it.


####### NEW CODE #######
my @notes = @ARGV;
print(join(", ", @notes) . "\n");
#@notes = sort( @notes );

my @possible = ();


for( my $root = 0; $root < 12; $root++ ) {

    my @ttsttts = ( 0, 2, 4, 5, 7, 9, 11 );
    @ttsttts = map { $_ + $root } @ttsttts;
    foreach(@ttsttts) {
        if($_ >= 12) {
            $_ -= 12;
        }
    }
   
    print(join(", ", @ttsttts) . "\n");
 
    my @result = ();

    foreach my $note ( @notes ) {
        if ($note ~~ @ttsttts) {
            push(@result, $note);
        }
    }

    if( scalar( @result ) == scalar( @notes ) ) {
        push( @possible, $root );
    }
}

print( "The possible keys are " . join( ", ", @possible ) . " major and their relative minors\n" );

####### OLD CODE #######
#
# sub obj_get_key { # Detect key based on note objects passed.
#    my @notes = @_; # An array of note objects.
#    foreach $note (@notes) {
#        if $note->is_modified($note) {
#            # It's a sharp or a flat.
#        }
#    }
#}
#
#sub num_get_key { # Detect key based on raw note data (numbers) passed.
#    my @notes = @_; # An array of note numbers.
#    foreach $note (@notes) {
#        
#    }
#}
