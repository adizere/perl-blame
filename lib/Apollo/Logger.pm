package Apollo::Logger;

use strict;
use warnings;


use base qw( Class::Accessor::Grouped Exporter Apollo::Base );


use Apollo::Logger::Delegates::File;
use Apollo::Logger::Levels qw( DEFAULT_LOG_LVL compare_levels get_level_name );

use Carp;


# package members
__PACKAGE__->mk_group_accessors( inherited => qw( level ) );
__PACKAGE__->level( DEFAULT_LOG_LVL );


my @_delegates = ();


our @EXPORT_OK = qw( log add_delegate );



sub log {
    my ( $level, $message_string ) = @_;

    unless( @_delegates && scalar( @_delegates ) > 0 ) {
        croak "No delegates selected. Can't log.";
        return;
    }

    # called only with 1 parameter - the message;
    unless ( $message_string ) {
        $message_string = $level;
        $level = __PACKAGE__->level(); # assume the intended level is the default one..
    }

    # make sure the logging level isn't higher than that of this message
    return if ( $level ne __PACKAGE__->level() || compare_levels( $level, __PACKAGE__->level() ) == -1 );

    require Apollo::Logger::Entry;
    _log_message( Apollo::Logger::Entry->new({
        content => $message_string,
        level => get_level_name( $level ),
    }));

    return 1;
}


sub _log_message {
    my $message = shift();

    return unless @_delegates;

    foreach( @_delegates ) {
        $_->to_log( $message );
    }
}


sub add_delegate {
    my ( $class, $delegate ) = @_;

    unless ( $delegate && $class && ( ref ( $class) ne __PACKAGE__ ) ) {
        $delegate = $class;
    }

    unless ( $delegate && $delegate->isa( 'Apollo::Logger::Delegates::Base' ) ) {
        croak "$delegate: Not a valid delegate.";
        return;
    }

    push @_delegates, $delegate;
}


1;
