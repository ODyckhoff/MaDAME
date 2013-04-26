#!/usr/bin/perl

package MaDAME::Engine::MusDat::CalcHandler::Mode::Minor;

use strict;
use warnings;

use MaDAME::Configuration;
use MaDAME::Log;

our %key = (nat  => {
                          scale => [0, 2, 3, 5, 7, 8, 10],
                          chord => [0, 3, 7],
                          progression => ['0min', '2dim', '3', '5min', '7min', '8', '10'],
                        },
            har => {
                          progression => ['0min', '2dim', '3aug', '5min', '7', '8', '11dim'],
                        },
            mel  => {
                          progression => ['0min', '2min', '3aug', '5', '7', '9dim', '11dim'],
                        },
            rel => 3,
          );

sub getKeyProg {
    my ($keynumber, $mode) = @_;
    my @progression = @{ $key{$mode}{'progression'} };
    foreach my $chord ( @progression ) {
        $chord =~ s/^(\d+)/$1 + $keynumber/e;
    }

    return @progression;
}

sub getRelative {
    debug(join(', ', @_));
    return ( $_[0] + $key{rel} );
}

sub getScale {
    my ($keynumber, $mode) = @_;
    my @scale = @{ $key{nat}{scale} };
    my @fullscale = (@scale, $scale[0] + 12, reverse(@scale));
    print(join(', ', @fullscale) . "\n");

    #adjust to key
    @fullscale = map { $_ + $keynumber } @fullscale;

    #adjust to mode
    if($mode eq 'har') {
        $fullscale[6]++;
        $fullscale[8]++;
    }
    elsif($mode eq 'mel') {
        $fullscale[5]++;
        $fullscale[6]++;
    }
    else {
        unless($mode eq 'nat') {
            error( "Invalid Minor Mode" );
        }
    }
    
    return @fullscale;   
}

sub getChord {
    my ($root) = @_;
    if($root =~ /\D/) {
        error("Invalid note number provided");
    }
    my @chord = map { $_ + $root } @{ $key{nat}{chord} };

    return @chord;
}
1;
