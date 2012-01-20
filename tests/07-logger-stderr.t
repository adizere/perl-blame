use strict;
use warnings;


use Test::More 'no_plan';
use IO::Capture::Stderr;


use Logger qw( log add_delegate );
use Logger::Delegates::Stderr;


my $delegates_count = 5;

foreach( 1 .. $delegates_count ) {

    my $delegate = Logger::Delegates::Stderr->new();
    isnt ( $delegate, undef, 'Ok Stderr delegate creation' );
    add_delegate( $delegate );
}


my $lines_count = 5;
# in each file log 5 lines.. that should be enough..

foreach( 1 .. $lines_count ) {
    my $capture = IO::Capture::Stderr->new();

    $capture->start();
    my $to_log = time() . " testing logger for STDERR " . $_;
    log( $to_log );
    $capture->stop();

    # each delegate outputed a line
    foreach( 1 .. $delegates_count ) {
        # what we captured should be like what we logged
        my $line = $capture->read;
        like ( $line, qr/$to_log/, 'Ok log to STDERR' );
    }
}
