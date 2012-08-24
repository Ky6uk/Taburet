package Taburet;

use strict;
use warnings;

use XML::Simple;
use Class::Trigger;
use Data::Dumper;
use Module::Pluggable require => 1;

# require plugins
__PACKAGE__->plugins;

# create and return new object of this package
sub new {
    my ($class) = @_;
    my $self = {};

    bless $self, $class;

    return $self;
}

sub process_xml {
    my ($self, $xml) = @_;

    my $result = XMLin($xml, KeepRoot => 1, ForceArray => 1);

    print Dumper $result;
}

1;