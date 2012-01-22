package Apollo::Logger::Delegates::Db;

use strict;
use warnings;


use base qw( Apollo::Logger::Delegates::Base Exporter );


use Apollo::Logger::Delegates::Db::Handle;

use Carp;


use constant {
    DBLOG_HANDLER_INIT => 1,
    DBLOG_PARAMS_INIT => 2,
};


our @EXPORT_OK = qw( DBLOG_PARAMS_INIT DBLOG_HANDLER_INIT );


# inspired from Fault::Delegate::DB
sub _init {
    my ( $self, $args ) = @_;

    # args check
    $self->_check_args( $args );

    # self members
    $self->{_db_handle} = Apollo::Logger::Delegates::Db::Handle->new();

    $self->{_db_handle}->set_log_name( $args->{log_name} );

    if ( $args->{init_type} eq DBLOG_HANDLER_INIT ) {
        $self->{_db_handle}->set_handle( $args->{handle} );

    } elsif ( $args->{init_type} eq DBLOG_PARAMS_INIT ) {
        # from_params() will initialize the handle directly from the $args->{host}, $args->{user}, etc..
        $self->{_db_handle}->from_params( $args );
    }
}


sub to_log {
    my ( $self, $message ) = @_;

    $self->{_db_handle}->insert_log_entry( $message );
}


=head2 _check_args

Checks the arguments provided at object creation - as an HASHREF

=cut
sub _check_args {
    my ( $self, $args ) = @_;

    unless ( defined $args && ref( $args ) eq 'HASH' ) {
        croak "Invalid object initialization - arguments must be an HASHREF.";
    }
    foreach my $key ( qw( log_name init_type ) ) {
        unless ( exists $args->{$key} && defined $args->{$key} ) {
            croak "Invalid obj. initialization - need the '$key'.";
        }
    }

    if ( $args->{init_type} eq DBLOG_HANDLER_INIT ) {
        # logger initialized with an handler, check that it is a valid
        # todo: how to validate a DBI handle

    } elsif ( $args->{init_type} eq DBLOG_PARAMS_INIT ) {
        # logger initialized with the data source parameters, not yet implemented either
        foreach( qw( username password host port database driver_name ) ) {
            unless ( exists $args->{$_} && defined $args->{$_} ) {
                croak "Invalid obj. initialization - need the '$_'.";
            }
        }

    } else {
        croak "Initialization failed - Init method not valid.";
    }

}

1;
