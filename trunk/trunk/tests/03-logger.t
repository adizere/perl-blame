use strict;
use warnings;


use Test::More 'no_plan';


# log_levels comprises: DEBUG, INFO, WARN, ERROR, FATAL
use_ok( 'Logger', qw( log :log_levels  )  );

can_ok( 'Logger', 'log' );

use Logger qw( log :log_levels );

can_ok( 'Logger', 'level' );


# test levels
foreach my $outer_level ( ( DEBUG, INFO, WARN, ERROR, FATAL ) ) {
    Logger->level( $outer_level );
    is( Logger->level(), $outer_level, "OK level update for $outer_level" );

    foreach my $inner_level ( ( DEBUG, INFO, WARN, ERROR, FATAL ) ) {
        # should only return 1 when successfull
        my $status = log( $inner_level, "Outer: [$outer_level], Inner: [$inner_level]" );
    }
}
