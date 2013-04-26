#!/usr/bin/perl

package MaDAME::Data;

use strict;
use warnings;

use MaDAME::Configuration;
use MaDAME::Log;

#use JSON;

sub toJSON {
    my ($data) = @_;
    my $json;
    #$json = encode_json $data;

    return $json;
}

sub fromJSON {
    my ($json) = @_;
    my $data;
    #$data = decode_json $json;

    return $data;
}
1;
