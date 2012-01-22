use strict;
use warnings;


use Test::More 'no_plan';
use IO::Capture::Stdout;


use Apollo::Logger qw( log add_delegate );
use Apollo::Logger::Delegates::Stdout;


my $delegates_count = 3;

foreach( 1 .. $delegates_count ) {

    my $delegate = Apollo::Logger::Delegates::Stdout->new();
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


# now test the header
foreach( 1 .. $lines_count ) {
    my $capture = IO::Capture::Stdout->new();

    my $header = 'SAMPLE HEADER';

    my $has_header = $_ % 2 ? 1 : 0;
    if ( $has_header ){
        Apollo::Logger->header( $header );
    } else {
        Apollo::Logger->header( undef );
    }

    $capture->start();
    my $to_log = time() . " test " . $_;
    log( $to_log );
    $capture->stop();

    # each delegate outputed a line
    foreach( 1 .. $delegates_count ) {
        # what we captured should be like what we logged
        my $line = $capture->read;
        like ( $line, qr/$to_log/, 'Ok log to STDOUT' );

        # header ON ?
        if ( $has_header ){
            like ( $line, qr/$header/, 'Ok log to STDOUT' );
        } else {
            unlike ( $line, qr/$header/, 'Ok log to STDOUT' );
        }
    }
}
