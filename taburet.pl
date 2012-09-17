#!/usr/bin/env perl

use 5.01;
use strict;
use warnings;

use EV;
use XML::Simple qw(XMLout);
use IO::Socket::INET;
use Taburet;

my $taburet = Taburet->new;

$| = 1;

my $socket = new IO::Socket::INET (
    PeerHost => 'ky6uk.org',
    PeerPort => '5222',
    Proto => 'tcp',
) or die "create socket exception: $!\n";

$socket->send(
    XMLout({
        "stream:stream" => {
            "to"           => "ky6uk.org",
            "xmlns:stream" => "http://etherx.jabber.org/streams"
        }
    }, KeepRoot => 1, XMLDecl => 1)
);

my $watcher = EV::io $socket, EV::READ, sub {
    while ( my $line = <$socket> ) {
        chomp $line;
        $taburet->process_xml($line);
    }
};

EV::run;
