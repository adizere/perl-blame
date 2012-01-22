package Apollo::Utilities;

use strict;
use warnings;

use base qw( Exporter Apollo::Base );

use POSIX qw( strftime );


our @EXPORT_OK = qw( datetime_iso8601 );


sub datetime_iso8601 {
    # the "T" and "Z" are added after date and time, respectively
    return strftime("%Y-%m-%dT%H:%M:%SZ", gmtime());
}


1;
