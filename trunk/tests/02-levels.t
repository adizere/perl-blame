use strict;
use warnings;


use Test::More 'no_plan';

use_ok( 'Apollo::Logger::Levels', qw( DEFAULT_LOG_LVL DEBUG INFO WARN ERROR FATAL compare_levels ) );


use Apollo::Logger::Levels qw( DEFAULT_LOG_LVL DEBUG INFO WARN ERROR FATAL compare_levels get_level_precedence );

fail( 'Default log level not defined' ) unless ( defined DEFAULT_LOG_LVL );


# tests the functions compare_levels and get_level_precedence
foreach my $outer ( ( DEBUG, INFO, WARN, ERROR, FATAL ) ) {
    foreach my $inner ( ( DEBUG, INFO, WARN, ERROR, FATAL ) ) {
        my $out = compare_levels( $outer, $inner );

        my $outer_prec = get_level_precedence( $outer );
        my $inner_prec = get_level_precedence( $inner );

        if ( $outer_prec > $inner_prec ) {
            is( $out, 1, 'Level comparing: bigger ok' );
        } elsif ( $outer_prec == $inner_prec ) {
            is( $out, 0, 'Level comparing: equal ok' );
        } else {
            is( $out, -1, 'Level comparing: smaller ok' );
        }
    }
}
