package Logger::Delegates::Stderr;

use strict;
use warnings;


use base qw( Logger::Delegates::Base );


use Carp;


sub to_log {
    my ( $self, $content ) = @_;

    print STDERR $content; # almost as simple as for Stdout
}

1;
