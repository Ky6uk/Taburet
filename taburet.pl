#!/usr/bin/env perl

use strict;
use warnings;
use 5.01;

use EV;
use IO::Socket::INET;
use XML::Simple;
use Data::Dumper;

# flush after every write
$| = 1;

my $connection_state = 0;

my $socket = new IO::Socket::INET (
    PeerHost => 'ky6uk.org',
    PeerPort => '5222',
    Proto => 'tcp',
) or die "create socket exception: $!\n";

&send_auth() unless $connection_state;

my $watcher = EV::io $socket, EV::READ, sub {
    while ( my $line = <$socket> ) {
        debug("socket readable");

        chomp $line;
        dispatch( XMLin($line, KeepRoot => 1, ForceArray => 1) );
    }
};

sub send_auth {
    my $xml = XMLout({
        "stream:stream" => {
            "to"           => "ky6uk.org",
            "xmlns"        => "jabber:client",
            "xmlns:stream" => "http://etherx.jabber.org/streams",
            "version"      => "1.0"
        }
    }, KeepRoot => 1, XMLDecl => 1);

    debug("send xml to socket");
    $socket->send($xml);
}

sub dispatch {
    my ($data) = @_;
    debug("dispatching");

    print Dumper $data;
}

sub debug {
    say "DEBUG: " . join(", ", @_);
}

EV::run;