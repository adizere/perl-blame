package Logger::Delegates::Db::SqlContainer::Base;

use strict;
use warnings;


use base qw( Class::Accessor::Grouped );


__PACKAGE__->mk_group_accessors( inherited => qw(
        driver_name
        statements
    ) );


# property shared among all subclasses
my $_statements = {
    # for table creation the SQLs reside in their particular subclass
    create => {
        logs => undef,
        log_entries => undef,
    },

    # search & insert queries are the same for all drivers
    select => {
        logs => 'SELECT * FROM logs WHERE name = ?',
    },
    insert => {
        logs => 'INSERT INTO logs ( name ) VALUES (?)',
        log_entries => 'INSERT INTO log_entries ( log_id, header, timestamp, level, content ) VALUES ( ?, ?, ?, ?, ? )',
    },
};

__PACKAGE__->statements( $_statements );



sub new {
    my $class = shift();

    my $self = {};
    bless $self, $class;

    return $self;
}


sub get_statement {
    my ( $self, $operation, $table_name ) = @_;

    return $self->statements()->{$operation}->{$table_name};
}

1;
