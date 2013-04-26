#!/usr/bin/perl

package MaDAME::Engine::MusDat::CalcHandler::KeyFinder;

use strict;
use warnings;

use MaDAME::Configuration;
use MaDAME::Log;

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
sub getKey {
    my @notes = @_;
    my @possible = ();

    for( my $root = 0; $root < 12; $root++ ) {
        my @major = ( 0, 2, 4, 5, 7, 9, 11 );
        my @harmo = ( 0, 2, 3, 5, 7, 8, 11 );
        my @melod = ( 0, 2, 3, 5, 7, 9, 11 );

        @major = map { $_ + $root } @major;
        @harmo = map { $_ + $root } @harmo;
        @melod = map { $_ + $root } @melod;
        
        for(my $i = 0; $i < scalar( @major ); $i++) {
            if( $major[$i] >= 12 ) {
                $major[$i] -= 12;
            }
            if( $harmo[$i] >= 12 ) {
                $harmo[$i] -= 12;
            }
            if( $melod[$i] >= 12 ) {
                $melod[$i] -= 12;
            }
        }
       
        my @majresult = ();
        my @harresult = ();
        my @melresult = ();
    
        foreach my $note ( @notes ) {

            if( $note ~~ @major ) {
                push( @majresult, $note );
            }
            if( $note ~~ @harmo ) {
                push( @harresult, $note );
            }
            if( $note ~~ @melod ) {
                push( @melresult, $note );
            }
        }
         
        if( scalar( @majresult ) == scalar( @notes ) ) {
            push( @possible, $root );
        }
        if( scalar( @harresult ) == scalar( @notes ) ) {
            push( @possible, $root . 'har' );
        }
        if( scalar( @melresult ) == scalar( @notes ) ) {
            push( @possible, $root . 'mel' );
        }
    }
    
    if(@possible) {
        debug( "The possible keys are " . join( ", ", @possible ) . " major and their relative minors\n" );
        return @possible;
    }
    else {
        debug( "There are no possible keys for the given notes.\n" );
        return ();
    }
}
1;

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
