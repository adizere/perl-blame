use strict;
use warnings;


use Test::More 'no_plan';
use Test::File;


use Apollo::Logger qw( log add_delegate );
use Apollo::Logger::Delegates::File;


my $delegates_count = 10;

my @delegates_out_files = ();
foreach( 1 .. $delegates_count ) {
    my $file = '/tmp/_' . time() . $$ . "_blame_test_$_.log";
    push @delegates_out_files, $file;

    my $delegate = Apollo::Logger::Delegates::File->new( $file );
    add_delegate( $delegate );

    file_exists_ok ( $file );
    file_empty_ok ( $file );
    file_readable_ok( $file );
}

my $lines_count = 2;
# in each file log 5 lines.. that should be enough..

foreach( 1 .. $lines_count ) {
    log( 'Test' );
}

foreach my $file ( @delegates_out_files ) {
    file_line_count_is( $file, $lines_count );
}

unlink @delegates_out_files;
