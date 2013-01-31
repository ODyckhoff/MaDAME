#!/usr/bin/perl

package MaDAME::Engine::MusDat;

use strict;
use warnings;

sub new {
    print join( ', ', @{ $_[1] }) . "\n";
    my $class = shift;
    my $paramsref = shift;
       my @params = @$paramsref;
       my $request = $params[0];
       my $data = $params[1];

    my $self = {
        request => $request, # Should be either 'get_data' or 'calc_data'.
        data    => $data,
    };
    print "$self->{request}\n";
    bless $self, $class;

    return $self;
}

sub init {
    my ( $self ) = shift;

    my $request = $self->{request};
    my $data    = $self->{data};

    print "Hurray, MusDat loaded!\n";
    
    unless ( $request =~ /^(get|calc)_data$/ ) {
        die("Error! Request is '$request'. Should be either 'get_data' or 'calc_data'");
    }
    
    my $method = $1;

    print ( ( $method =~ /get/ ? 'Getting' : 'Calculaing' ) . " data for $data...\n" );
}
1;
