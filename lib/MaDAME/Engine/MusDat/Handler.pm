#!/usr/bin/perl

package MaDAME::Engine::MusDat::Handler;

use strict;
use warnings;

use MaDAME::Configuration;

sub new {
    my $class = shift;
    my $self = {
        method => shift,
        data => shift,
    };

    bless $self, $class;

    return $self;
}

sub process {
    my $self = shift;

    my $method = $self->{method};
    print "Handler: $method\n";
    my $data = $self->{data};

    use MaDAME::Engine::MusDat::PreProcessor;
    my $pp = new MaDAME::Engine::MusDat::PreProcessor ( $method, $data );
       
    my $engine = $pp->sort_type;

    print "Handler: $engine->{data}\n";
}
1;
