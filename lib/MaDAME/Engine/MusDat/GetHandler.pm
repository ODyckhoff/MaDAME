#!/usr/bin/perl

package MaDAME::Engine::MusDat::GetHandler;

use strict;
use warnings;

use MaDAME::Configuration;

sub new {
    my $class = shift;
    my $self = {
        data => shift,
    };
    bless $self, $class;
    
    return $self;
}

# Validate Data.

# Get instructions for data processing.

# Execute instructions.

# Check output

# Return output suitable for MaDAME::Data to begin conversion to e.g. MusicXML.

1;
