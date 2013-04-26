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
        $key = keyInfo($key);
    }
    return @keys;
}

sub keyInfo {
    my $key = $_[0];

    my $tmp = $key;
        $key =~ /^(\d+)(har|mel|nat)$/;
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
    return $key;
}

sub chordWithKey {
    my $tmpchord = $_[0];
    debug("tmpchord = $tmpchord");
    my @chord = &MaDAME::Engine::MusDat::CalcHandler::Chord::getChordNotes($tmpchord);
    debug("chord: " . join(', ', @chord));
    my @keys = &MaDAME::Engine::MusDat::CalcHandler::Chord::getKeysByChord(@chord);
    debug('@keys size: ' . scalar(@keys));

    for my $key (@keys) {
        debug("\$key = $key");
        my $tmp = $key;
        $key = {
                name => $tmp,
                progression => [&MaDAME::Engine::MusDat::CalcHandler::Chord::getProgression($tmp)],
        };
    }
    
    return @keys;     
}

sub chordWithNote {
    my $note = $_[0];
    debug("This chord is $note");
    my @chords = &MaDAME::Engine::MusDat::CalcHandler::Chord::getChordsByNote($note);

    return @chords;
}

sub scaleInfo {
    my $key = $_[0];
    my @scale = &MaDAME::Engine::MusDat::CalcHandler::Scale::findScale($key);

    return @scale;
}
# Execute instructions.

# Check output

# Return output suitable for MaDAME::Data to begin conversion to e.g. MusicXML.

1;
