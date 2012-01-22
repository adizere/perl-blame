package Logger::Delegates::Stdout;

use strict;
use warnings;


use base qw( Logger::Delegates::Base );


use Carp;


sub to_log {
    my ( $self, $message ) = @_;

    print $message->to_string(); # as simple as that
}

1;
