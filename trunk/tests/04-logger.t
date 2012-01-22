use strict;
use warnings;


use Test::More 'no_plan';
use Test::Exception;
use Test::File;


# log_levels comprises: DEBUG, INFO, WARN, ERROR, FATAL
use_ok( 'Apollo::Logger', qw( log add_delegate  )  );

can_ok( 'Apollo::Logger', 'log' );
can_ok( 'Apollo::Logger', 'add_delegate' );
can_ok( 'Apollo::Logger', 'level' );

use Apollo::Logger qw( log );
use Apollo::Logger::Levels qw( INFO WARN DEBUG ERROR FATAL );

foreach ( ( DEBUG, INFO, WARN, ERROR, FATAL ) ) {
    Apollo::Logger->level( $_ );
    is( Apollo::Logger->level(), $_, "OK level update for $_." );
}

# put the level to the lowest level now..
Apollo::Logger->level( DEBUG );


# test levels without any delegate
foreach my $outer_level ( ( DEBUG, INFO, WARN, ERROR, FATAL ) ) {
    foreach my $inner_level ( ( DEBUG, INFO, WARN, ERROR, FATAL ) ) {
        my $status;
        dies_ok { $status = log( $inner_level, "Outer: [$outer_level], Inner: [$inner_level]" ); } 'Apollo::Logger should die when no delegates defined.';
        is ( $status, undef, 'No delegate defined means nothing logged.' );
    }
}


# add the File delegate and test it
use_ok( 'Apollo::Logger::Delegates::File', qw( new ) );
use Apollo::Logger::Delegates::File;

my $file_name = '/tmp/_' . time() . $$ . "_blame_test.log";
my $delegate = Apollo::Logger::Delegates::File->new( $file_name );

file_exists_ok ( $file_name );
file_empty_ok ( $file_name );
file_readable_ok( $file_name );

add_delegate( $delegate );
dies_ok { add_delegate( 'abc' ) } 'Should not be able to add an invalid delegate.';

my $count = 0;
my $status = log( 'Test' );
$count++;
unless ( $status ) {
    fail ( "Error logging - status returned: $status\n" );
}

file_not_empty_ok( $file_name );
file_line_count_is( $file_name, $count );


foreach( 1..10 ) {
    log( 'Test' );
    $count++;
    file_line_count_is( $file_name, $count );
}

# cleanup
unlink $file_name;
