#!/usr/bin/env perl

use 5.01;
use strict;
use warnings;

use EV;
use XML::Simple;
use Data::Dumper;
use IO::Socket::INET;

use Taburet;

my $taburet = Taburet->new;

# flush after every write
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
        debug("socket readable");
        chomp $line;

        $taburet->process_xml($line);
    }
};

# простой вывод debug-строк
sub debug {
    say "DEBUG: " . join(", ", @_);
}

EV::run;
