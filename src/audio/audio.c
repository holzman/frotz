/*
 * audio.c - Unix interface, sound support
 *
 *	Esound
 *
 * This file is part of Frotz.
 *
 * Frotz is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * Frotz is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA
 */

#ifdef ESD_SOUND	/* compile this if we're using Esound */


#define __UNIX_PORT_FILE

#include <signal.h>


#ifdef INTERFACE_CURSES
#ifdef USE_NCURSES_H
#include <ncurses.h>
#else
#include <curses.h>
#endif
#endif

#include <esd.h>

#include "audio.h"


/*
 * os_beep
 *
 * Play a beep sound. Ideally, the sound should be high- (number == 1)
 * or low-pitched (number == 2).
 *
 */

void os_beep (int number)
{
#ifdef INTERFACE_XLIB
	XKeyboardState old_values;
	XKeyboardControl new_values;

	XGetKeyboardControl(dpy, &old_values);
	new_values.bell_pitch = (number == 2 ? 400 : 800);
	new_values.bell_duration = 100;
	XChangeKeyboardControl(dpy, KBBellPitch | KBBellDuration,
		&new_values);
	XBell(dpy, 100);
	new_values.bell_pitch = old_values.bell_pitch;
	new_values.bell_duration = old_values.bell_duration;
	XChangeKeyboardControl(dpy, KBBellPitch | KBBellDuration,
		&new_values);
#endif /* INTERFACE_XLIB */

#ifdef INTERFACE_CURSES
	beep();
#endif /* INTERFACE_CURSES */

}/* os_beep */

/*
 * os_prepare_sample
 *
 * Load the sample from the disk.
 *
 */

void os_prepare_sample (int number, int *result)
{
	bb_result_t	result;

	if (bb_load_resource_snd(map, bb_method_Memory, &result,
		number, NULL) == bb_err_None) {

		uint32* data = (uint32 *)result.data.ptr;
		int length = result.length;
		unsigned int id = map->chunks[result.chunknum].type;

		if (id = bb_make_id('F','O','R','M'))
			play_aiff(data, length, repeat);

		else if (id == bb_make_id('M','O','D',' ')) {

}/* os_prepare_sample */

/*
 * os_start_sample
 *
 * Play the given sample at the given volume (ranging from 1 to 8 and
 * 255 meaning a default volume). The sound is played once or several
 * times in the background (255 meaning forever). In Z-code 3 the
 * repeats value is always 0 and the number of repeats is taken from
 * the sound file itself. The end_of_sound function is called as soon
 * as the sound finishes.
 *
 */

/* AFAIK, I don't need to worry about eos here. */

void os_start_sample (int number, int volume, int repeats, zword eos)
{

}/* os_start_sample */

/*
 * os_stop_sample
 *
 * Turn off the current sample.
 *
 */

void os_stop_sample (int number)
{

    /* Not implemented */

}/* os_stop_sample */

/*
 * os_finish_with_sample
 *
 * Remove the current sample from memory (if any).
 *
 */

void os_finish_with_sample (number)
{

    /* Not implemented */

}/* os_finish_with_sample */

/*
 * os_wait_sample
 *
 * Stop repeating the current sample and wait until it finishes.
 *
 */

void os_wait_sample (void)
{

    /* Not implemented */

}/* os_wait_sample */


int blorb_play_aiff(uint32 *data, int length, int repeats, int volume)
{
	uint32	*ChunkCoMM, *ChunkSSND;

	sampledata_t sampledata;

	if (data == NULL) {
		return = BLORB_ERR_PLAY;
	}

	/* Check for AIFF header */
	if (strncmp((char*)data, "FORM", 4) != 0) {
		return BLORB_ERR_PLAY;
	}

	if (strncmp((char*) data + 8, "AIFF", 4) != 0) {
		return = BLORB_ERR_PLAY;
	}

	ChunkCOMM = (uint32 *)findchunk((char *)data, "COMM", length);
	if (ChunkCOMM == NULL) {
		return = BLORB_ERR_PLAY;
	}

	sampledata.channels = ReadShort((unsigned char *)ChunkCOMM);
	sampledata.samples = ReadLong((unsigned char *)ChunkCOMM+2);
	sampledata.bits = ReadShort((unsigned char *)ChunkCOMM+6);
	sampledata.rate = ReadExtended((unsigned char *)ChunkCOMM+8);

	if (ChunkSSND == NULL) {
		return BLORB_ERR_PLAY;
	}

	/* Recaclulate length based on what this chunk says */
	length = ReadLong( (unsigned char *)ChunkSSND-sizeof(long) ) - 8 ;

	/* kluge to get rid of popping noises that Esound sometimes */
	/* adds to the beginning of samples. */
	/* May cause heisenbug segfaults */
	/* ChunkSSND = ChunkSSND + sizeof(long) * 7; */

	return play_aiff_esd(ChunkSSND, length, sampledata, repeats, volume);
}


int play_aiff_esd(uint32 *data, int, sampledata_t, int, int);
/*
 * Here is where we actually write to the sound device.  Return 0 if
 * there's an error.
 *
 * Perhaps that annoying buzz with high-pitched sounds can be remedied
 * with a low-pass filter of some sort.  More research...
 *
 */


int play_aiff_esd(uint32 *data, int length, sampledata_t sampledata,
		int repeats, int volume)
{

	return repeats;
}


#ifdef CRAPOLA
int play_aiff_esd_bad(uint32 *data, int length, sampledata_t sampledata,
	int repeats, int myvolume)
{
	int sock;
	int bits;
	int channels;
	int mode;
	int func;
	int rate;
	int i;
	int num;
	char *src;
	float volume_esd;
	esd_format_t    format = 0;

	switch (myvolume) {
	case 1: volume_esd = VOLUME_1;
		break;
	case 2: volume_esd = VOLUME_2;
		break;
	case 3: volume_esd = VOLUME_3;
		break;
	case 4: volume_esd = VOLUME_4;
		break;
	case 5: volume_esd = VOLUME_5;
		break;
	case 6: volume_esd = VOLUME_6;
		break;
	case 7: volume_esd = VOLUME_7;
		break;
	case 8: volume_esd = VOLUME_8;
		break;
	case 256: volume_esd = VOLUME_8;
		break;
	default: return 0;
		break;
	}

	if (sampledata.bits == 16) {
		bits = ESD_BITS16;
	} else if (sampledata.bits == 8) {
		bits = ESD_BITS8;
	} else {
		fprintf(stderr, "I can't deal with a bit rate of %d.\n", bits);
		return 0;
	}

	if (sampledata.channels == 1) {
		channels = ESD_MONO;
	} else if (sampledata.channels == 2) {
		channels = ESD_STEREO;
	} else {
		fprintf(stderr, "I can't deal with %d channels.\n",
			sampledata.channels);
		return 0;
	}

	mode = ESD_STREAM;
	func = ESD_PLAY;

	rate = (int) rint(sampledata.rate);

	format = bits | channels | mode | func;
	if ((sock = esd_play_stream(format, rate, NULL, "frotz")) <= 0) {
		return 0;
	}

	/*
	 * Noticed we removed the redundant buffer allocation and
	 * copying as it improves latency, simplifies error handling
	 * and removes a chance for a possible failure.  Of course, it
	 * makes us slightly more memory friendly too.
	 *	;)  -Greg Copeland
	 */

	/* Forcefully convert data in-place */
	/* and adjust volume at the same time. */
	src = (signed char *)data ;
	for(i = 0; i < length; i++ ) {
		src[i] *= volume_esd / 100;
		src[i] -= 127;
	}

	for (num = 0; num < repeats; num++) {
		if (write(sock, data, length) <= 0) {
			fprintf(stderr, "Trouble playing sound:\n");
			perror("esd: ");
			close(sock);
			return 0;
		}
	}
	close(sock);
	return 0;
}
#endif


#endif /* ESD_SOUND */
