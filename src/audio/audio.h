/*
 * audio.h - Audio declarations and definitions for Frotz.
 */

#include "../common/frotz.h"

#include "../interface_check.h"

#ifndef __UNIX_PORT_FILE
#define __UNIX_PORT_FILE
#endif

#ifndef NO_SOUND
#define NO_SOUND
#endif

#ifdef ESD_SOUND
#undef NO_SOUND
#endif


#ifdef INTERFACE_XLIB
#include <X11/Xlib.h>
extern Display *dpy;
Display *dpy;
#endif


/* These values may need changing later on. */
#define VOLUME_1        12.5
#define VOLUME_2        25.0
#define VOLUME_3        37.5
#define VOLUME_4        50.0
#define VOLUME_5        62.5
#define VOLUME_6        75.0
#define VOLUME_7        87.5
#define VOLUME_8        99.0	/* 100.0 causes crackles */

