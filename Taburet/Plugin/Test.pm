package Taburet::Plugin::Stream;

use Data::Dumper;

Taburet->add_trigger(
    "stream:stream" => sub {
        print Dumper \@_;
    }
);

1;
