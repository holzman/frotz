#!/usr/pkg/bin/bash

# This thing is intended to determine which interface is being used
# without having to resort to autoconf.
#
# Please do not consider this an attempt at good programming.

if [ -z $1 ] ; then
	echo "$0: ERROR!  Sourcecode directory undefined."
	echo "Error in Makefile where $0 is called.";
	exit 2
fi

OUTFILE="$1/interface_check.h"
rm -f $OUTFILE

if [ -z $2 ] ; then
	echo "$0: ERROR!  Interface type undefined.";
	echo "Error in Makefile where $0 is called.";
	exit 3
fi

echo "I see we're using the $2 interface..."
echo

cat << EOF > $OUTFILE
/*
 * This file is intended to allow the build to figure out which
 * interface is being used without having to resort to autoconf.
 *
 */

EOF

if [ $2 = "curses" ] ; then
	echo "#ifndef INTERFACE_CURSES" >> $OUTFILE
	echo "#define INTERFACE_CURSES" >> $OUTFILE
	echo "#endif" >> $OUTFILE
	exit 0
fi

if [ $2 = 'xlib' ] ; then
	echo "#ifndef INTERFACE_XLIB" >> $OUTFILE
	echo "#define INTERFACE_XLIB" >> $OUTFILE
	echo "#endif" >> $OUTFILE
	exit 0
fi

#if [ $2 = 'gtk2' ] ; then
#	echo "#ifndef INTERFACE_GTK2" >> $OUTFILE
#	echo "#define INTERFACE_GTK2" >> $OUTFILE
#	echo "#endif" >> $OUTFILE
#	exit 0;
#fi


echo "Unknown interface type ($2)."
rm -f $OUTFILE
exit 9
