package Logger::Delegates::File;

use strict;
use warnings;


use base qw( Logger::Delegates::Base );


use Carp;

our $fh;


sub _init {
    my ( $self, $file ) = @_;

    croak "No output file provided." unless ( $file && length( $file ) > 0 );

    if ( ( -e $file ) && ( ! -w $file ) ) {
        croak "Cannot access (write to) $file for log outputing.\n";
    }
    open( $fh, ">>", $file ) || croak "Cannot log to '$file': $!.";
}


sub to_log {
    my ( $self, $content ) = @_;

    unless ( $fh ) {
        warn "No file selected for output.\n";
        return;
    }

    syswrite $fh, $content;
}

1;
