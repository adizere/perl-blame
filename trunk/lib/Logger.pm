package Logger;

use strict;
use warnings;


use base qw( Class::Accessor::Grouped Exporter );


use Readonly;
use Logger::Delegates::File;


__PACKAGE__->mk_group_accessors( inherited => qw( level ) );

my %levels;
BEGIN {
    # levels definitions
    %levels = (
        'debug_lvl' => {
            name => 'DEBUG',
            precedence => 5,
        },
        'information_lvl' => {
            name => 'INFO',
            precedence => 4,
        },
        'warning_lvl' => {
            name => 'WARN',
            precedence => 3,
        },
        'error_lvl' => {
            name => 'ERROR',
            precedence => 2,
        },
        'fatal_error_lvl' => {
            name => 'FATAL',
            precedence => 1,
        }
    );
};

# levels will be exported into constants for ease of use
use constant {
    DEBUG => 'debug_lvl',
    INFO => 'information_lvl',
    WARN => 'warning_lvl',
    ERROR => 'error_lvl',
    FATAL => 'fatal_error_lvl',
};


# default logging level; also used in Logger::Message
my $_DEFAULT_LEVEL = 'information_lvl';
our $DEFAULT_LEVEL_NAME = $levels{$_DEFAULT_LEVEL}->{name};
our $DEFAULT_LEVEL_PRECEDENCE = $levels{$_DEFAULT_LEVEL}->{precedence};


__PACKAGE__->level( $_DEFAULT_LEVEL );


my @delegates = (
    Logger::Delegates::File->new(),
);


our @EXPORT_OK = qw( log DEBUG INFO WARN ERROR FATAL );
our %EXPORT_TAGS = (
    'log_levels' => [ qw( DEBUG INFO WARN ERROR FATAL ) ],
);


sub log {
    my ( $level, $message_string ) = @_;

    # called only with 1 parameter - the message;
    unless ( $message_string ) {
        $message_string = $level;
        $level = $_DEFAULT_LEVEL; # assume the intended level is the default one..
    }

    # make sure the logging level isn't higher than that of this message
    return unless $levels{$level}->{precedence} le $levels{__PACKAGE__->level()}->{precedence};

    require Logger::Message;
    _log_message( Logger::Message->new({
        content => $message_string,
        level => $levels{$level}->{name},
    }));

    return 1;
}


sub _log_message {
    my $message = shift();

    return unless @delegates;

    foreach( @delegates ) {
        $_->to_log( $message->to_string() );
    }
}


sub add_delegate {
    my ( $class, $delegate ) = @_;

    return unless ( $delegate );

    push @delegates, $delegate;
}


1;
