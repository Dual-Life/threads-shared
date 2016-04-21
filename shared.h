/* Macros from Perl 5.8.8 */

#ifndef _SHARED_H_
#define _SHARED_H_

#ifndef SvRV_set
#  define SvRV_set(sv, val)                             \
    STMT_START {                                        \
        (((XRV*)SvANY(sv))->xrv_rv = (val));            \
    } STMT_END
#endif

#ifndef SvSTASH_set
#  define SvSTASH_set(sv, val)                          \
    STMT_START {                                        \
        (((XPVMG*)  SvANY(sv))->xmg_stash = (val));     \
    } STMT_END
#endif

#ifndef HvNAME_get
#  define HvNAME_get(hv)        (0 + ((XPVHV*)SvANY(hv))->xhv_name)
#endif

#endif
/* EOF */
