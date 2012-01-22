package Apollo::Logger::Delegates::Db::SqlContainer::Mysql;

use strict;
use warnings;


use base qw( Apollo::Logger::Delegates::Db::SqlContainer::Base );


# package level SQL statements... this is essentially what forms each Container package

__PACKAGE__->driver_name( 'mysql' );


__PACKAGE__->statements()->{create}->{logs} = q|
    CREATE TABLE IF NOT EXISTS logs (
        id INTEGER NOT NULL AUTO_INCREMENT,
        name VARCHAR(50) UNIQUE NOT NULL,
        PRIMARY KEY (id)
    );
|;


__PACKAGE__->statements()->{create}->{log_entries} = q|
    CREATE TABLE IF NOT EXISTS log_entries (
        id INTEGER NOT NULL AUTO_INCREMENT,
        log_id INTEGER NOT NULL,
        level VARCHAR(5) NOT NULL,
        content TEXT,
        timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        header VARCHAR(100) DEFAULT NULL,
        PRIMARY KEY (id)
    );
|;


1;
