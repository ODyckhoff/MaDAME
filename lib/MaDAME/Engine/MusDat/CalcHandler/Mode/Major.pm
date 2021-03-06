#!/usr/bin/perl

package MaDAME::Engine::MusDat::CalcHandler::Mode::Major;

use strict;
use warnings;

our %key = (nat => {
                          scale => [0, 2, 4, 5, 7, 9, 11],
                          chord => [0, 4, 7],
                          progression => ['0', '2min', '4min', '5', '7', '9min', '11dim'],
                      },
           rel => 9,
          );

sub getKeyProg {
    my $keynumber = $_[0];
    my @progression = @{ $key{nat}{'progression'} };
    foreach my $chord ( @progression ) {
        $chord =~ s/^(\d+)/$1 + $keynumber/e;
    }
   
    return @progression;
}

sub getRelative {
    return $_[0] + $key{rel};
}

sub getScale {
    my ($keynumber) = @_;
    if($keynumber =~ /\D/) {
        error( "Invalid Mode for Major key" );
    }
    my @scale = @{ $key{nat}{scale} };
    my @fullscale = (@scale, $scale[0] + 12, reverse(@scale));
    # print(join(', ', @fullscale) . "\n");

    #adjust to key
    @fullscale = map { $_ + $keynumber } @fullscale;

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
