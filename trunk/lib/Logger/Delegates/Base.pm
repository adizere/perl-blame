package Logger::Delegates::Base;

use strict;
use warnings;


sub new {
    my $class = shift();

    my $self = {};
    bless $self, $class;

    $self->_init( @_ );

    return $self;
}


sub _init {
    return;
}


sub to_log {
    my $self = shift();

    warn ref( $self ) . ": No to_log() method defined.\n";
}


1;
