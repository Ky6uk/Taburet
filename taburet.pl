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
        chomp $line;
        print Dumper $line;
        my $data = XMLin($line, KeepRoot => 1, ForceArray => 1);
        print Dumper XMLout($data, KeepRoot => 1);
    }
};

sub send_auth {
    $socket->send("test\n");
}

EV::run;