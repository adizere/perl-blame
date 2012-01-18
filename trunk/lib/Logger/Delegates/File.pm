package Logger::Delegates::File;

use strict;
use warnings;


use base qw( Logger::Delegates::Base );


our $fh;


sub _init {
    my $file = '/tmp/log';
    if ( ( -e $file ) && ( ! -w $file ) ) {
        die "Cannot access (write to) $file for log outputing.\n";
    }
    open( $fh, ">>", $file );
}


sub to_log {
    my ( $self, $content ) = @_;

    unless ( $fh ) {
        warn "No file selected for output.\n";
        return;
    }

    print $fh $content;
}

1;
