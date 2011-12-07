/*
 * ux_frotz.h
 *
 * Unix interface, declarations, definitions, and defaults
 *
 */

#define CURSES_INTERFACE

#include "../common/frotz.h"
#include "../blorb/blorb.h"
#include "ux_setup.h"

#define MASTER_CONFIG		"frotz.conf"
#define USER_CONFIG		".frotzrc"

#define ASCII_DEF		1
#define ATTRIB_ASSIG_DEF	0
#define ATTRIB_TEST_DEF		0
#define COLOR_DEF		1
#define ERROR_HALT_DEF		0
#define EXPAND_DEF		0
#define PIRACY_DEF		0
#define TANDY_DEF		0
#define OBJ_MOVE_DEF		0
#define OBJ_LOC_DEF		0
#define BACKGROUND_DEF		BLUE_COLOUR
#define FOREGROUND_DEF		WHITE_COLOUR
#define HEIGHT_DEF		-1	/* let curses figure it out */
#define CONTEXTLINES_DEF	0
#define WIDTH_DEF		80
#define TWIDTH_DEF		80
#define SEED_DEF		-1
#define SLOTS_DEF		MAX_UNDO_SLOTS
#define LMARGIN_DEF		0
#define RMARGIN_DEF		0
#define ERR_REPORT_DEF		ERR_REPORT_ONCE
#define	QUETZAL_DEF		1
#define SAVEDIR_DEF		"if-saves"
#define ZCODEPATH_DEF		"/usr/games/zcode:/usr/local/games/zcode"


#define LINELEN		256	/* for getconfig()	*/
#define COMMENT		'#'	/* for config files	*/
#define PATHSEP		':'	/* for pathopen()	*/
#define DIRSEP		'/'	/* for pathopen()	*/

#define EDITMODE_EMACS	0
#define EDITMODE_VI	1

#define PIC_NUMBER	0
#define PIC_WIDTH	2
#define PIC_HEIGHT	4
#define PIC_FLAGS	6
#define PIC_DATA	8
#define PIC_COLOUR	11


/* Paths where z-files may be found */
#define	PATH1		"ZCODE_PATH"
#define PATH2		"INFOCOM_PATH"

#define NO_SOUND
#ifdef OSS_SOUND
# undef NO_SOUND
#endif

/* Some regular curses (not ncurses) libraries don't do this correctly. */
#ifndef getmaxyx
#define getmaxyx(w, y, x)	(y) = getmaxy(w), (x) = getmaxx(w)
#endif

extern bool color_enabled;		/* ux_text */

extern char stripped_story_name[FILENAME_MAX+1];
extern char semi_stripped_story_name[FILENAME_MAX+1];
extern char *progname;
extern char *gamepath;	/* use to find sound files */

extern f_setup_t f_setup;
extern u_setup_t u_setup;

typedef struct sampledata_struct {
	unsigned short channels;
	unsigned long samples;
	unsigned short bits;
	double rate;
} sampledata_t;

/*** Blorb related stuff ***/

/*
typedef struct blorb_data_struct {
	bb_map_t	map;
	bb_result_t	result;
} blorb_data_t;
*/

bb_err_t	blorb_err;
bb_map_t	*blorb_map;
bb_result_t	blorb_res;

/* uint32 *findchunk(uint32 *data, char *chunkID, int length); */
/*
char *findchunk(char *pstart, char *fourcc, int n);
unsigned short ReadShort(const unsigned char *bytes);
unsigned long ReadLong(const unsigned char *bytes);
double ReadExtended(const unsigned char *bytes);
#define UnsignedToFloat(u) (((double)((long)(u - 2147483647L - 1))) + 2147483648.0)
*/



/*** Functions specific to the Unix port of Frotz ***/

bool 	unix_init_pictures(void);	/* ux_pic.c */
void	unix_init_scrollback(void);	/* ux_screen.c */
void	unix_save_screen(int);		/* ux_screen.c */
void	unix_do_scrollback(void);	/* ux_screen.c */
int	unix_init_blorb(void);		/* ux_init.c */
int     getconfig(char *);
int     geterrmode(char *);
int     getcolor(char *);
int     getbool(char *);
FILE	*pathopen(const char *, const char *, const char *, char *);
void	sigwinch_handler(int);
void	sigint_handler(int);
void	redraw(void);


#ifdef NO_MEMMOVE
void *memmove(void *, void *);
#endif
