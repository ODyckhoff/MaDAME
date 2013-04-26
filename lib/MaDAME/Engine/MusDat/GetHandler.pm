#!/usr/bin/perl

package MaDAME::Engine::MusDat::GetHandler;

use strict;
use warnings;

use MaDAME::Configuration;
use MaDAME::Log;
use MaDAME::Engine::MusDat::CalcHandler::KeyFinder;
use MaDAME::Engine::MusDat::CalcHandler::Scale;
use MaDAME::Engine::MusDat::CalcHandler::Mode::Major;
use MaDAME::Engine::MusDat::CalcHandler::Mode::Minor;
use MaDAME::Engine::MusDat::CalcHandler::Chord;

sub new {
    my $class = shift;
    my $self = {
        request => shift,
           data => shift,
    };
    bless $self, $class;
    
    return $self;
}

# Validate Data.

# Get instructions for data processing.
sub getData {
    my ( $self ) = shift;
    my @reqdata = @{ $self->{data} };
    my $request = $self->{request};
    
    my $data;

    if($request eq 'KeyFinder') {
         my @tmpdata = keyFinder(@reqdata);
         $data = \@tmpdata;
    }
    elsif($request eq 'Key') {
         my @tmpdata = keyInfo(@reqdata);
         $data = \@tmpdata;
    }
    elsif($request eq 'Chord') {
        my @tmpdata = chordWithKey(@reqdata);
        $data = \@tmpdata;
    }
    elsif($request eq 'Note') {
        my @tmpdata = chordWithNote(@reqdata);
        $data = \@tmpdata;
    }
    elsif($request eq 'Scale') {
        my @tmpdata = scaleInfo(@reqdata);
        $data = \@tmpdata;
    }
    else {
        error('Invalid Request');
    }

    return $data;
}

sub keyFinder {
    my @notes = @_;
    my @keys = &MaDAME::Engine::MusDat::CalcHandler::KeyFinder::getKey(@notes);
       
    for my $key (@keys) {
        my $tmp = $key;
        $key =~ /^(\d+)(har|mel)$/;
        my $mode = $2 || '';
        my $note = $1;

        my $rel;
        if($mode) {
            debug("note is $note");
            $rel = &MaDAME::Engine::MusDat::CalcHandler::Mode::Minor::getRelative($note);
        }
        else {
            $rel = &MaDAME::Engine::MusDat::CalcHandler::Mode::Major::getRelative($note);
        }
        $key = {
                   name          => $tmp,
                   relative      => $rel,
		   scale         => [&MaDAME::Engine::MusDat::CalcHandler::Scale::findScale($tmp)],
                   chord         => [&MaDAME::Engine::MusDat::CalcHandler::Chord::getChordNotes($tmp)],
                   progression   => [&MaDAME::Engine::MusDat::CalcHandler::Chord::getProgression($tmp)],
                   
        };     
        debug("scale in key $tmp is " .  join(', ', @{ $key->{scale} }) );
        debug("chord for key $tmp is " . join(', ', @{ $key->{chord} }) );
        my $progression;
        foreach(@{$key->{progression}}) {
            debug("chord in sequence is " . join(', ', @{ $_ }));
        }
    }
    return @keys;
}

sub keyInfo {

}

sub chordWithKey {

}

sub chordWithNote {

}

sub scaleInfo {

}
# Execute instructions.

# Check output

# Return output suitable for MaDAME::Data to begin conversion to e.g. MusicXML.

1;
