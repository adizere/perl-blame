package Apollo::Logger::Delegates::File;

use strict;
use warnings;


use base qw( Apollo::Logger::Delegates::Base );


use Carp;


sub _init {
    my ( $self, $file ) = @_;

    croak "No output file provided." unless ( $file && length( $file ) > 0 );

    if ( ( -e $file ) && ( ! -w $file ) ) {
        croak "Cannot access (write to) $file for log outputing.\n";
    }

    my $fh;
    open( $fh, ">>", $file ) || croak "Cannot log to '$file': $!.";

    $self->{_out} = $fh;
}


sub to_log {
    my ( $self, $message ) = @_;

    unless ( exists $self->{_out} && $self->{_out} ) {
        warn "No file selected for output.\n";
        return;
    }

    syswrite $self->{_out}, $message->to_string();
}

1;
