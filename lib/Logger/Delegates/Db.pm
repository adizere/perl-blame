package Logger::Delegates::Db;

use strict;
use warnings;


use base qw( Logger::Delegates::Base );


use Carp;


sub _init {
    my ( $self, $args ) = @_;

    # args check
    $self->_check_args( $args );
}


sub to_log {
    my ( $self, $content ) = @_;
}


sub _check_args {
    my ( $self, $args ) = @_;

    #unless 
}

1;
