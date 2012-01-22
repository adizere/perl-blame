package Apollo::Logger::Levels;

use strict;
use warnings;

use base qw( Exporter );


use Package::Constants;


my %_levels;

BEGIN {
    # levels definitions
    # 'name' used in log output
    # 'precedence' used in log levels filtering

    %_levels = (
        'DEBUG_LOG_LVL' => {
            name => 'DEBUG',
            precedence => 5,
        },
        'INFORMATION_LOG_LVL' => {
            name => 'INFO',
            precedence => 4,
        },
        'WARNINGS_LOG_LVL' => {
            name => 'WARN',
            precedence => 3,
        },
        'ERRORS_LOG_LVL' => {
            name => 'ERROR',
            precedence => 2,
        },
        'FATALS_LOG_LVL' => {
            name => 'FATAL',
            precedence => 1,
        }
    );

    foreach( keys %_levels ) {
        my $const_name = $_levels{$_}->{name};
        my $const_value = $_;
        my $r = eval "use constant $const_name => '$const_value'";
        if ( $@ ) {
            warn $@;
        }
    }
};

use constant DEFAULT_LOG_LVL => 'INFORMATION_LOG_LVL';


our @EXPORT_OK = ( Package::Constants->list( __PACKAGE__ ), qw( compare_levels get_level_name get_level_precedence ) );


sub compare_levels {
    return unless ( @_ == 2 && defined $_[0] && defined $_[1] );

    my ( $first, $second ) = ( $_levels{$_[0]}->{precedence} || undef, $_levels{$_[1]}->{precedence} || undef );

    return unless ( $first && $second );

    $first > $second ? return 1 : ( $first == $second ? return 0 : return -1  );
}


# to be used when creating Entries - which need to contain the log level name: INFO / DEBUG / etc..
sub get_level_name {
    my $lvl = shift();

    $lvl ? return $_levels{$lvl}->{name} : undef;
}


sub get_level_precedence {
    my $lvl = shift();

    $lvl ? return $_levels{$lvl}->{precedence} : undef;
}


1;
