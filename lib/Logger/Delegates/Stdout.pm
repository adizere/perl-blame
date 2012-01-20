package Logger::Delegates::Stdout;

use strict;
use warnings;


use base qw( Logger::Delegates::Base );


use Carp;


sub to_log {
    my ( $self, $content ) = @_;

    print $content; # as simple as that
}

1;
