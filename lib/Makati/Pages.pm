package Makati::Pages;

use strict;
use warnings;

use Carp;
use File::Spec;
use Text::MultiMarkdown;

sub new {
    my ( $class, %args ) = @_;
    my $self = {
        dir => $args{dir},
        ext => $args{ext} || '.md',
    };
    bless $self => $class;
    $self->_check_dir;
    return $self;
}

sub _check_dir {
    my $self = shift;
    my $dir  = $self->{dir};
    croak "why no dir" unless -d $dir and -x $dir;
}

sub fetch_and_render {
    my ( $self, $page ) = @_;

    croak "why no args" unless $page;

    my $f = join '' => $page, $self->{ext};
    my $p = File::Spec->catfile( $self->{dir}, $f );
    croak "why no page" unless -f $p and -r $p;

    open my $page_fh, '<', $p
        or die "Could not open $page, lel: $!";
    my $f = join '' => <$page_fh>;
    close $page_fh or die "Could not close $page! $!";

    my $m = Text::MultiMarkdown->new( empty_element_suffix => '>' );
    return $m->markdown($f);
}

1;
__END__

=head1 NAME

Makati::Pages - model class for makati.pm.org static pages

=head1 SYNOPSIS

   use Makati::Pages;
   my $pages = Makati::Pages->new( dir => '/some/where/over/the/rain/bow' );

   # render page from Markdown source
   print $pages->fetch('hello.md');

=head1 DESCRIPTION

Just a simple model class for fetching and rendering pages.

=head1 AUTHOR

Zak B. Elep, E<lt>zakame@cpan.org<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2013 by Zak B. Elep

This program is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.8.2 or,
at your option, any later version of Perl 5 you may have available.

=head1 BUGS

None reported... yet.

=cut
