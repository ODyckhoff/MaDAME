#!/usr/bin/perl

package MaDAME::Engine::MusDat;

use strict;
use warnings;

use MaDAME::Log;

use MaDAME::Engine::MusDat::GetHandler;
use MaDAME::Engine::MusDat::CalcHandler;

sub new {
    #debug( join( ', ', @{ $_[1] }) );
    my $class = shift;
    my $paramsref = shift;
       my @params = @$paramsref;
       my $request = shift(@params);
       my $data = \@params;
    my $self = {
        request => $request, # Should be either 'get_data' or 'calc_data'.
        data    => $data,
    };
    debug( $self->{request} );
    bless $self, $class;

    return $self;
}

sub init {
    my ( $self ) = shift;

    my $request = $self->{request};
    my $data    = $self->{data};

    debug( "Hurray, MusDat loaded!" );

    my $handler;
       $handler = new MaDAME::Engine::MusDat::GetHandler($request, $data);
    
    $data = $handler->getData();

    return $data;
}
1;
