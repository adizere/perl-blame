package Logger::Delegates::Db::SqlContainer::Sqlite;

use strict;
use warnings;


use base qw( Logger::Delegates::Db::SqlContainer::Base );


# package level SQL statements... this is essentially what forms each Container package

__PACKAGE__->driver_name( 'sqlite' );

# TODO...
__PACKAGE__->statements()->{create}->{logs} = q|

|;


__PACKAGE__->statements()->{create}->{log_entries} = q|

|;


1;
