package Taburet::Plugin::Test;

Taburet->add_trigger(
    "dir.add" => sub {
        my ($class, $dirs) = @_;
        push @$dirs, qw(e f);
    }
);

sub new {
    my ($class) = @_;
    my $self = {};

    bless $self, $class;

    return $self;
}

1;
