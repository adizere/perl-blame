package Logger::Delegates::Db::Handle;

use strict;
use warnings;


use Carp;

# class only used internally from Logger::Delegates::Db
# please don't try using it directly..


sub new {
    my $class = shift();

    my $self = {
        _handle => undef,
    };

    bless $self, $class;
    return $self;
}


sub set_handle {
    my ( $self, $handle ) = @_;

    $self->{_handle} = $handle;

    $self->test_connection();
}


sub test_connection {
    my $self = shift();

    # todo..
}


sub from_params {
    my ( $self, $params ) = @_;

    # todo..
}
