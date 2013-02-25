#!/usr/bin/perl

package MaDAME::Engine::MusDat;

use strict;
use warnings;

use MaDAME::Log;

use MaDAME::Engine::MusDat::GetHandler;
use MaDAME::Engine::MusDat::CalcHandler;

sub new {
    debug( join( ', ', @{ $_[1] }) );
    my $class = shift;
    my $paramsref = shift;
       my @params = @$paramsref;
       my $request = $params[0];
       my $data = $params[1];

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
    

    # Check for sane request.
    unless ( $request =~ /^(get|calc)_data$/ ) {
        die("Error! Request is '$request'. Should be either 'get_data' or 'calc_data'");
    }
    
    # Guaranteed that $1 won't be undefined at this stage, and that the value will be one that MaDAME expects.
    my $method = $1;

    debug( ( $method =~ /get/ ? 'Getting' : 'Calculating' ) . " data for $data..." );

    startHandler($method, $data);
}

sub startHandler {
    my $handler;

    if ( shift eq 'get' ) { 
        $handler = new MaDAME::Engine::MusDat::GetHandler(@_);
    } else {
        $handler = new MaDAME::Engine::MusDat::CalcHandler(@_);
    }
    
    # $handler->process;
}    
1;
