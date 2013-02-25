#!/usr/bin/perl

package MaDAME::Engine;

use strict;
use warnings;

use MaDAME::Configuration;
use MaDAME::Log;

our ( %cfg );

sub new {
    my $class = shift;
    my $self = {
        engine => 'MaDAME::Engine::' . shift,
        data   => \@_,
    };

    bless $self, $class;
    
    #if ( $debug ) {
        debug( "Class name is: $class" );
        debug( "Engine required is: $self->{engine}" );
        debug( "Data input is: " . join(', ', @{ $self->{data} }) );
        #print "$cfg{MusDat}{Modes}{Major}{ignore}\n";
    #}
    return $self;
}

sub initEngine {
    my ( $self ) = shift;
    
    (my $requirement = $self->{engine} . '.pm') =~ s{::}{/}g;
    require $requirement;
    
    my $engine = $self->{engine}->new ( $self->{data} );
    $engine->init;
}
1;
