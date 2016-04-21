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
    ((ExtUtils::MakeMaker->VERSION() lt '6.25') ?
        ('PL_FILES' => { })            : ()),
    ((ExtUtils::MakeMaker->VERSION() gt '6.30') ?
        ('LICENSE'  => 'perl')         : ()),
);


# Add additional target(s) to Makefile for use by module maintainer
sub MY::postamble
{
    return <<'_EXTRAS_';
ppport:
	@( cd /tmp; perl -e 'use Devel::PPPort; Devel::PPPort::WriteFile("ppport.h");' )
	@if ! cmp -s ppport.h /tmp/ppport.h; then \
	    diff ppport.h /tmp/ppport.h ; \
	    echo; \
	    perl /tmp/ppport.h; \
	fi
_EXTRAS_
}

# EOF
