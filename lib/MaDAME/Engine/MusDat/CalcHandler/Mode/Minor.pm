#!/usr/bin/perl

#package MaDAME::Engine::MusDat::CalcHandler::Mode::Major;

use strict;
use warnings;

our %key = (natural  => {
                          scale => [0, 2, 3, 5, 7, 8, 10],
                          chord => [0, 3, 7],
                          progression => ['0min', '2dim', '3', '5min', '7min', '8', '10'],
                        },
            harmonic => {
                          progression => ['0min', '2dim', '3aug', '5min', '7', '8', '11dim'],
                        },
            melodic  => {
                          progression => ['0min', '2min', '3aug', '5', '7', '9dim', '11dim'],
                        },
            relative => 3,
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
    return $_[0] + $key{relative};
}

sub getScale {
    my ($keynumber, $mode) = @_;
    my @scale = @{ $key{natural}{scale} };
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
    my @chord = map { $_ + $root } @{ $key{natural}{chord} };

    return @chord;
}

print(join(', ', getScale(2, 'nat')) . "\n");

# print join(", ", getProgression(3)) . "\n";
