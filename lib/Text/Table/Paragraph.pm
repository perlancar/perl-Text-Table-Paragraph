package Text::Table::Paragraph;

# DATE
# VERSION

#IFUNBUILT
use strict;
use warnings;
#END IFUNBUILT

sub table {
    require Text::Wrap;

    my %args = @_;
    my $rows = $args{rows} or die "Must provide rows!";

    my $opt_wrap = $args{wrap} // $ENV{TEXT_TABLE_PARAGRAPH_WRAP} // 1;

    my $columns;
    my $data_idx_start;
    if ($args{header_row}) {
        $columns = $rows->[0];
        $data_idx_start = 1;
    } else {
        $columns = [map {"column$_"} 0..$#{$rows->[0]}];
        $data_idx_start = 0;
    }

    local $Text::Wrap::colums = $args{wrap_width} //
        $ENV{TEXT_TABLE_PARAGRAPH_WRAP_WIDTH} // 72;

    my @output;

    for my $i ($data_idx_start .. $#$rows) {
        my $row = $rows->[$i];
        for my $j (0..$#{$columns}) {
            last if $j > $#{$row};
            my $column = $columns->[$j];
            my $val = $row->[$j];
            if ($opt_wrap) {
                $val = Text::Wrap::wrap("", "  ", $val);
            }
            $val =~ s/\R+\z//;
            push @output, "$column: $val\n";
	}
        push @output, "\n";
    }

    return join("", @output);
}

1;
#ABSTRACT: Format table data as paragraphs of rows

=for Pod::Coverage ^(max)$

=head1 SYNOPSIS

 use Text::Table::Paragraph;

 my $rows = [
     # header row
     ['name', 'summary', 'description'],
     # rows
     ['foo', 'bandung', 'a long description .... .... .... .... .... .... .... .... .... .... .... .... .... .... .... .... .... ....'],
     ['bar', 'jakarta', 'another long description .... .... .... .... .... .... .... .... .... .... .... .... .... .... ....'],
     ['baz', 'palangkaraya', 'yet another long description .... .... .... .... .... .... .... .... .... .... .... .... .... .... .... .... .... .... .... .... .... .... ....'],
 ];
 print Text::Table::Paragraph::table(rows => $rows, header_row => 1);


=head1 DESCRIPTION

This module provides a single function, C<table>, which formats a
two-dimensional array of data as paragraphs. Each paragraph shows a row of data
and columns are shown as C<name: value> lines. Long values by default are
wrapped and shown indented in the subsequent lines.

The example shown in the SYNOPSIS generates the following table:

 name: foo
 summary: bandung
 description: a long description .... .... .... .... .... .... .... .... ....
   .... .... .... .... .... .... .... .... ....

 name: bar
 summary: jakarta
 description: another long description .... .... .... .... .... .... .... ....
   .... .... .... .... .... .... ....

 name: baz
 summary: palangkaraya
 description: yet another long description .... .... .... .... .... .... ....
   .... .... .... .... .... .... .... .... .... .... .... .... .... .... ....
   ....

=head1 FUNCTIONS

=head2 table(%params) => str


=head2 OPTIONS

The C<table> function understands these arguments, which are passed as a hash.

=over

=item * rows (aoaos)

Takes an array reference which should contain one or more rows of data, where
each row is an array reference.

=item * header_row (bool)

If given a true value, the first row in the data will be interpreted as a header
row that contains column names. Otherwise, columns will be named: C<column1>,
C<column2>, and so on.

=item * wrap (bool, default 1)

Whether to wrap long values.

=item * wrap_width (int, default 72)

=back


=head1 ENVIRONMENT

=head2 TEXT_TABLE_PARAGRAPH_WRAP => bool

Set default for C<wrap> option.

=head2 TEXT_TABLE_PARAGRAPH_WRAP_WIDTH => int

Set default for C<wrap_width> option.

=head1 SEE ALSO

This module is currently basically L<Text::Table::Tiny> 0.03 modified to output
paragraphs instead of its original 2D text table format.

C<Text::Table::*>, L<Text::Table::Any>

See also L<Bencher::Scenario::TextTableModules>.

=cut
