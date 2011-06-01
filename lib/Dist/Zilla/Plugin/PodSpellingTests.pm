use 5.008;
use strict;
use warnings;

package Dist::Zilla::Plugin::PodSpellingTests;
BEGIN {
  $Dist::Zilla::Plugin::PodSpellingTests::VERSION = '1.111520';
}

# ABSTRACT: Release tests for POD spelling
use Moose;
extends 'Dist::Zilla::Plugin::InlineFiles';
with 'Dist::Zilla::Role::TextTemplate';
sub mvp_multivalue_args { qw( stopwords ) }
has wordlist => (
    is      => 'ro',
    isa     => 'Str',
    default => 'Pod::Wordlist::hanekomu',    # default to original
);
has spell_cmd => (
    is      => 'ro',
    isa     => 'Str',
    default => '',                           # default to original
);
has stopwords => (
    is      => 'ro',
    isa     => 'ArrayRef[Str]',
    default => sub { [] },                   # default to original
);
around add_file => sub {
    my ($orig, $self, $file) = @_;
    my ($set_spell_cmd, $add_stopwords, $stopwords);
    if ($self->spell_cmd) {
        $set_spell_cmd = sprintf "set_spell_cmd('%s');", $self->spell_cmd;
    }

    # automatically add author names to stopwords
    for (@{ $self->zilla->authors }) {
        local $_ = $_;    # we don't want to modify $_ in-place
        s/<.*?>//g;
        push @{ $self->stopwords }, /(\w{2,})/g;
    }
    if (@{ $self->stopwords } > 0) {
        $add_stopwords = 'add_stopwords(<DATA>);';
        $stopwords = join "\n", '__DATA__', @{ $self->stopwords };
    }
    $self->$orig(
        Dist::Zilla::File::InMemory->new(
            {   name    => $file->name,
                content => $self->fill_in_string(
                    $file->content,
                    {   wordlist      => \$self->wordlist,
                        set_spell_cmd => \$set_spell_cmd,
                        add_stopwords => \$add_stopwords,
                        stopwords     => \$stopwords,
                    },
                ),
            }
        ),
    );
};
__PACKAGE__->meta->make_immutable;
no Moose;
1;



=pod

=for stopwords wordlist

=for test_synopsis 1;
__END__

=head1 NAME

Dist::Zilla::Plugin::PodSpellingTests - Release tests for POD spelling

=head1 VERSION

version 1.111520

=head1 SYNOPSIS

In C<dist.ini>:

    [PodSpellingTests]

or:

    [PodSpellingTests]
    wordlist = Pod::Wordlist
    spell_cmd = aspell list
    stopwords = CPAN
    stopwords = github
    stopwords = stopwords
    stopwords = wordlist

or, if you wanted to use my plugin bundle but just override this plugin's
configuration:

    [@Filter]
    -bundle = @MARCEL
    -remove = PodSpellingTests

    [PodSpellingTests]
    wordlist = Pod::Wordlist
    spell_cmd = aspell list
    stopwords = CPAN
    stopwords = github
    stopwords = stopwords
    stopwords = wordlist

=head1 DESCRIPTION

This is an extension of L<Dist::Zilla::Plugin::InlineFiles>, providing
the following file:

  xt/release/pod-spell.t - a standard Test::Spelling test

=head1 METHODS

=head2 wordlist

The module name of a word list you wish to use that works with
L<Test::Spelling>.

Defaults to L<Pod::Wordlist::hanekomu>.

=head2 spell_cmd

If C<spell_cmd> is set then C<set_spell_cmd( your_spell_command );> is
added to the test file to allow for custom spell check programs.

Defaults to nothing.

=head2 stopwords

If stopwords is set then C<add_stopwords( E<lt>DATAE<gt> )> is added
to the test file and the words are added after the C<__DATA__>
section.

C<stopwords> can appear multiple times, one word per line.

Normally no stopwords are added by default, but author names appearing in
C<dist.ini> are automatically added as stopwords so you don't have to add them
manually just because they might appear in the C<AUTHORS> section of the
generated POD document.

=for Pod::Coverage mvp_multivalue_args

=head1 INSTALLATION

See perlmodinstall for information and options on installing Perl modules.

=head1 BUGS AND LIMITATIONS

No bugs have been reported.

Please report any bugs or feature requests through the web interface at
L<http://rt.cpan.org/Public/Dist/Display.html?Name=Dist-Zilla-Plugin-PodSpellingTests>.

=head1 AVAILABILITY

The latest version of this module is available from the Comprehensive Perl
Archive Network (CPAN). Visit L<http://www.perl.com/CPAN/> to find a CPAN
site near you, or see L<http://search.cpan.org/dist/Dist-Zilla-Plugin-PodSpellingTests/>.

The development version lives at L<http://github.com/hanekomu/Dist-Zilla-Plugin-PodSpellingTests>
and may be cloned from L<git://github.com/hanekomu/Dist-Zilla-Plugin-PodSpellingTests.git>.
Instead of sending patches, please fork this project using the standard
git and github infrastructure.

=head1 AUTHORS

=over 4

=item *

Marcel Gruenauer <marcel@cpan.org>

=item *

Harley Pig <harleypig@gmail.com>

=back

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2010 by Marcel Gruenauer.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut


__DATA__
___[ xt/release/pod-spell.t ]___
#!perl

use Test::More;

eval "use {{ $wordlist }}";
plan skip_all => "{{ $wordlist }} required for testing POD spelling"
  if $@;

eval "use Test::Spelling 0.12";
plan skip_all => "Test::Spelling 0.12 required for testing POD spelling"
  if $@;

{{ $set_spell_cmd }}
{{ $add_stopwords }}
all_pod_files_spelling_ok('lib');
{{ $stopwords }}

