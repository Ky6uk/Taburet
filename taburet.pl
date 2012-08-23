#!/usr/bin/env perl

use strict;
use warnings;
use 5.01;

use EV;
use IO::Socket::INET;
use XML::Simple;
use Data::Dumper;
use Module::Pluggable search_path => ['Plugin'];

foreach my $plugin ( plugins ) {
    eval { require $plugin };
}

exit 0;

# flush after every write
$| = 1;

my $socket = new IO::Socket::INET (
    PeerHost => 'ky6uk.org',
    PeerPort => '5222',
    Proto => 'tcp',
) or die "create socket exception: $!\n";

&send_auth();

my $watcher = EV::io $socket, EV::READ, sub {
    while ( my $line = <$socket> ) {
        debug("socket readable");

        chomp $line;
        dispatch( XMLin($line, KeepRoot => 1, ForceArray => 1) );
    }
};

# отправка авторизации
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

# диспетчер ответов сервера
sub dispatch {
    my ($data) = @_;
    debug("dispatching");

    print Dumper $data;
}

# простой вывод debug-строк
sub debug {
    say "DEBUG: " . join(", ", @_);
}

EV::run;