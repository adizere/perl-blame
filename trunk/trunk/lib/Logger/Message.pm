package Logger::Message;

use strict;
use warnings;


use base qw( Class::Accessor::Grouped );


use Logger;
use Utilities qw( datetime_iso8601 );


__PACKAGE__->mk_group_accessors( simple => qw( level content timestamp header ) );


# log level: INFO (imported from Logger)
my $DEFAULT_LEVEL = $Logger::DEFAULT_LEVEL_NAME;



sub new {
    my $class = shift();
    my $args = shift(); # hashref args

    my $self = {};
    bless $self, $class;

    # set the content
    $self->content( $args->{content} || '' );

    # set the level..
    unless ( defined $args->{level} ) {
        $args->{level} = $DEFAULT_LEVEL;
    }
    $self->level( $args->{level} );

    # timestamp
    $self->timestamp( datetime_iso8601() );

    $self->header( undef );

    return $self;
}


sub to_string {
    my $self = shift();

    my $ret;
    foreach( qw( header timestamp level content ) ) {
        $ret .= '[' . $self->$_() . ']' if ( defined $self->$_() );
    }
    $ret .= "\n";
}


1;
