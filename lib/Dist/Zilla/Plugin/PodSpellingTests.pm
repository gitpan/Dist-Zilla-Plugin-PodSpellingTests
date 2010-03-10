use 5.008;
use strict;
use warnings;

package Dist::Zilla::Plugin::PodSpellingTests;
our $VERSION = '1.100690';
# ABSTRACT: release tests for POD spelling
use Moose;
use Pod::Wordlist::hanekomu;
use Test::Spelling;
extends 'Dist::Zilla::Plugin::InlineFiles';

__PACKAGE__->meta->make_immutable;
no Moose;
1;




=pod

=head1 NAME

Dist::Zilla::Plugin::PodSpellingTests - release tests for POD spelling

=head1 VERSION

version 1.100690

=head1 SYNOPSIS

In C<dist.ini>:

    [PodSpellingTests]

=head1 DESCRIPTION

This is an extension of L<Dist::Zilla::Plugin::InlineFiles>, providing the
following files

  xt/release/pod-spell.t - a standard Test::Spelling test

=head1 INSTALLATION

See perlmodinstall for information and options on installing Perl modules.

=head1 AUTHOR

  Marcel Gruenauer <marcel@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2010 by Marcel Gruenauer.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut


__DATA__
___[ xt/release/pod-spell.t ]___
#!perl

use Test::More;

eval "use Pod::Wordlist::hanekomu";
plan skip_all => "Pod::Wordlist:hanekomu required for testing POD spelling"
  if $@;

eval "use Test::Spelling";
plan skip_all => "Test::Spelling required for testing POD spelling"
  if $@;

all_pod_files_spelling_ok('lib');

