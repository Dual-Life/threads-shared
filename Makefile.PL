# Module makefile for threads::shared (using ExtUtils::MakeMaker)

require 5.008;

use strict;
use warnings;

use ExtUtils::MakeMaker;

WriteMakefile(
    'NAME'              => 'threads::shared',
    'AUTHOR'            => 'Arthur Bergman <arthur AT contiller DOT se>',
    'VERSION_FROM'      => 'shared.pm',
    'ABSTRACT_FROM'     => 'shared.pm',
    'PM' => {
        'shared.pm'     => '$(INST_LIBDIR)/shared.pm',
    },
    'INSTALLDIRS'       => 'perl',
    ((ExtUtils::MakeMaker->VERSION() > 6.30) ?
        ('LICENSE'  => 'perl')         : ()),
);

# EOF
