
use strict;
use warnings;

 BEGIN { require 5.008; } 

use ExtUtils::MakeMaker 6.11;



my %WriteMakefileArgs = (
                       'test' => {
                                   'TESTS' => 't/*.t'
                                 },
                       'NAME' => 'Dist::Zilla::Plugin::PodSpellingTests',
                       'DISTNAME' => 'Dist-Zilla-Plugin-PodSpellingTests',
                       'CONFIGURE_REQUIRES' => {
                                                 'ExtUtils::MakeMaker' => '6.11'
                                               },
                       'AUTHOR' => 'Marcel Gruenauer <marcel@cpan.org>',
                       'BUILD_REQUIRES' => {},
                       'ABSTRACT' => 'release tests for POD spelling',
                       'EXE_FILES' => [],
                       'VERSION' => '1.100690',
                       'PREREQ_PM' => {
                                        'Test::Spelling' => '0',
                                        'English' => '0',
                                        'Test::More' => '0',
                                        'File::Find' => '0',
                                        'File::Temp' => '0',
                                        'Pod::Wordlist::hanekomu' => '0',
                                        'Dist::Zilla::Plugin::InlineFiles' => '0',
                                        'Moose' => '0'
                                      },
                       'LICENSE' => 'perl'
                     );


delete $WriteMakefileArgs{LICENSE}
  unless eval { ExtUtils::MakeMaker->VERSION(6.31) };

WriteMakefile(%WriteMakefileArgs);



