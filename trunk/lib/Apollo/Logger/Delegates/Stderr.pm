package Apollo::Logger::Delegates::Stderr;

use strict;
use warnings;


use base qw( Apollo::Logger::Delegates::Base );


use Carp;


sub to_log {
    my ( $self, $message ) = @_;

    print STDERR $message->to_string(); # almost as simple as for Stdout
}

1;
