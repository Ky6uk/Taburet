package Taburet;

use strict;
use warnings;

use XML::Simple qw(:strict);
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

# обработчик XML
sub process_xml {
    my ($self, $xml) = @_;
    my $result = XMLin($xml, KeepRoot => 1, ForceArray => 0, KeyAttr => []);
    print Dumper $result;

    while ( my ($key, $value) = each %$result ) {
        print "call_trigger: $key\n";
        $self->call_trigger($key, $value);
    }
}

1;