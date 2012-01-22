package Logger::Delegates::Db::Handle;

use strict;
use warnings;


use DBI;
use Carp;


# class only used internally from Logger::Delegates::Db
# please don't try using it directly..
sub new {
    my $class = shift();

    my $self = {
        _handle => undef,
        _log_name => undef,
        _log_id => undef,
    };

    bless $self, $class;
    return $self;
}


sub set_log_name {
    my ( $self, $log_name ) = @_;

    $self->{_log_name} = $log_name;
}


sub from_params {
    my ( $self, $params ) = @_;

    # connect to the DB
    my $ds = "dbi:" . $params->{driver_name} . ":database=" .
        $params->{database} . ";host=" . $params->{host} . ";port=" . $params->{port};
    my $handle = DBI->connect( $ds, $params->{username}, $params->{password} ) or die $DBI::errstr;

    $self->set_handle( $handle );
}


sub set_handle {
    my ( $self, $handle ) = @_;

    $self->{_handle} = $handle;

    # now that we have the loader we can finally do some operations on the DB
    $self->_test_connection();
}


sub insert_log_entry {
    my ( $self, $entry ) = @_;

    my $sth = $self->{_handle}->prepare(
        $self->{_sql_container}->get_statement( 'insert', 'log_entries' )
    );

    $sth->bind_param( 1, $self->{_log_id} );
    my $bind_counter = 2;

    # careful, the order is important..
    foreach ( qw( header timestamp level content ) ) {
        $sth->bind_param( $bind_counter++, $entry->$_() || '' );
    }
    $sth->execute or die $sth->errstr;
}


sub _fetch_container {
    my ( $self, $driver_name ) = @_;

    croak "Need the driver name." unless ( $driver_name );

    my $loader_class = 'Logger::Delegates::Db::SqlContainer::' . ucfirst( lc( $driver_name ) );

    eval "require $loader_class";
    if ( $@ ) {
        croak "Unable to require the Loader class for '$driver_name': '$loader_class'; $@.";
    }

    $self->{_sql_container} = $loader_class->new();
}


sub _test_connection {
    my $self = shift();

    # make sure we have a loader
    # each driver has a particular Loader, containing driver dependent data for: mysql, postgres, sqlite, etc..
    $self->{_sql_container} ||  $self->_fetch_container( $self->{_handle}->{Driver}{Name} );

    # tables should exist..
    $self->_tables_ok();

    $self->_log_name_ok();
}


# tables should be created of they don't already exist
sub _tables_ok {
    my $self = shift();

    foreach( qw( logs log_entries ) ){
        $self->{_handle}->do(
            $self->{_sql_container}->get_statement( 'create', $_ )
        );
    }
}


sub _log_name_ok {
    my $self = shift();

    my $log_session = $self->_get_log_by_name();

    unless ( defined $log_session ) {
        # create the row..
        my $sth = $self->{_handle}->prepare(
            $self->{_sql_container}->get_statement( 'insert', 'logs' )
        );
        $sth->bind_param( 1, $self->{_log_name} );
        $sth->execute or die $sth->errstr;

        $log_session = $self->_get_log_by_name();
    }
    $self->{_log_id} = $log_session->{id};
}


sub _get_log_by_name {
    my $self = shift();

    my $sth = $self->{_handle}->prepare(
                $self->{_sql_container}->get_statement( 'select', 'logs' )
            );
    $sth->bind_param( 1, $self->{_log_name} );
    $sth->execute or die $sth->errstr;

    return $sth->fetchrow_hashref();
}

1;
