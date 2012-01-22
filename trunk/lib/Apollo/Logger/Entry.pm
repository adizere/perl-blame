package Apollo::Logger::Entry;

use strict;
use warnings;


use base qw( Class::Accessor::Grouped );


use Apollo::Logger;
use Apollo::Logger::Levels qw( DEFAULT_LOG_LVL get_level_name );
use Apollo::Utilities qw( datetime_iso8601 );


__PACKAGE__->mk_group_accessors( simple => qw( header timestamp level content ) );


sub new {
    my $class = shift();
    my $args = shift(); # hashref args

    my $self = {};
    bless $self, $class;

    # set the content
    $self->content( $args->{content} || '' );

    # set the level..
    unless ( defined $args->{level} ) {
        $args->{level} = get_level_name( DEFAULT_LOG_LVL );
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
    foreach( qw( header timestamp level ) ) {
        $ret .= '[' . $self->$_() . ']' if ( defined $self->$_() );
    }
    $ret .= $self->content() if ( defined $self->content() );
    $ret .= "\n";
}


sub to_hashref {
    my $self = shift();

    my $ret;
    foreach( qw( header timestamp level content ) ) {
        $ret->{$_} = $self->$_();
    }

    return $ret;
}


1;
