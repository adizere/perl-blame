use strict;
use warnings;


use Test::More 'no_plan';
use IO::Capture::Stdout;


use Logger qw( log add_delegate );
use Logger::Delegates::Stdout;


my $delegates_count = 3;

foreach( 1 .. $delegates_count ) {

    my $delegate = Logger::Delegates::Stdout->new();
    isnt ( $delegate, undef, 'Ok Stdout delegate creation' );
    add_delegate( $delegate );
}


my $lines_count = 3;
# in each file log 3 lines.. that should be enough..

foreach( 1 .. $lines_count ) {
    my $capture = IO::Capture::Stdout->new();

    $capture->start();
    my $to_log = time() . " test " . $_;
    log( $to_log );
    $capture->stop();

    # each delegate outputed a line
    foreach( 1 .. $delegates_count ) {
        # what we captured should be like what we logged
        my $line = $capture->read;
        like ( $line, qr/$to_log/, 'Ok log to STDOUT' );
    }
}
