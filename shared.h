#ifndef _SHARED_H_
#define _SHARED_H_

#ifndef HvNAME_get
#  define HvNAME_get(hv)        (0 + ((XPVHV*)SvANY(hv))->xhv_name)
#endif

#endif
