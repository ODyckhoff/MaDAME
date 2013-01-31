#!/usr/bin/perl

package MaDAME::Engine;

use strict;
use warnings;

use MaDAME::Configuration;

our $debug = 0;

sub new {
    my $class = shift;
    my $self = {
        engine => 'MaDAME::Engine::' . shift,
        data   => \@_,
    };

    bless $self, $class;
    
    #if ( $debug ) {
        print "Class name is: $class\n";
        print "Engine required is: $self->{engine}\n";
        print "Data input is: " . join(', ', @{ $self->{data} }) . "\n";
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
