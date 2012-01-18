use strict;
use warnings;


use Test::More 'no_plan';
use Test::Exception;
use Test::File;


# log_levels comprises: DEBUG, INFO, WARN, ERROR, FATAL
use_ok( 'Logger', qw( log add_delegate :log_levels  )  );

can_ok( 'Logger', 'log' );
can_ok( 'Logger', 'add_delegate' );
can_ok( 'Logger', 'level' );

use Logger qw( log :log_levels );


foreach ( ( DEBUG, INFO, WARN, ERROR, FATAL ) ) {
    Logger->level( $_ );
    is( Logger->level(), $_, "OK level update for $_." );
}

# put the level to the lowest level now..
Logger->level( DEBUG );


# test levels without any delegate
foreach my $outer_level ( ( DEBUG, INFO, WARN, ERROR, FATAL ) ) {
    foreach my $inner_level ( ( DEBUG, INFO, WARN, ERROR, FATAL ) ) {
        my $status;
        dies_ok { $status = log( $inner_level, "Outer: [$outer_level], Inner: [$inner_level]" ); } 'Logger should die when no delegates defined.';
        is ( $status, undef, 'No delegate defined means nothing logged.' );
    }
}


# add the File delegate and test it
use_ok( 'Logger::Delegates::File', qw( new ) );
use Logger::Delegates::File;

my $file_name = '/tmp/_' . time() . $$ . "_blame_test.log";
my $delegate = Logger::Delegates::File->new( $file_name );

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

unlink $file_name;
