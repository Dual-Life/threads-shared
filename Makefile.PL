# Module makefile for threads::shared (using ExtUtils::MakeMaker)

require 5.008;

use strict;
use warnings;

use ExtUtils::MakeMaker;


# Build options for different environments
my @conditional_params;
if (grep { $_ eq 'PERL_CORE=1' } @ARGV) {
    # Core
    push(@conditional_params, 'MAN3PODS' => {});
} else {
    # CPAN
    push(@conditional_params, 'DEFINE'   => '-DHAS_PPPORT_H');
}


WriteMakefile(
    'NAME'              => 'threads::shared',
    'AUTHOR'            => 'Artur Bergman <sky AT crucially DOT net>',
    'VERSION_FROM'      => 'shared.pm',
    'ABSTRACT_FROM'     => 'shared.pm',
    'PM' => {
        'shared.pm'     => '$(INST_LIBDIR)/shared.pm',
    },
    'INSTALLDIRS'       => 'perl',

    ((ExtUtils::MakeMaker->VERSION() lt '6.25') ?
        ('PL_FILES' => { })            : ()),
    ((ExtUtils::MakeMaker->VERSION() gt '6.30') ?
        ('LICENSE'  => 'perl')         : ()),

    @conditional_params
);

# EOF
