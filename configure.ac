dnl Process this file with autoconf to produce a configure script.
AC_INIT(db/source/driver/ljet4.xml)

dnl If the user didn't specify the $sysconfdir on the command line, let it
dnl be /etc, not /usr/local/etc or /usr/etc
if [[ x$sysconfdir = 'x${prefix}/etc' ]]; then
  sysconfdir=/etc
fi

dnl Checks for programs.
AC_PROG_INSTALL
AC_PROG_MAKE_SET

SBINSEARCHPATH=/usr/sbin:/sbin:/usr/local/sbin:/etc/sbin
BINSEARCHPATH=/usr/bin:/bin:/usr/local/bin
DATASEARCHPATH=/usr/share:/usr/local/share:/usr/lib:/usr/local/lib:/opt
BSB=$BINSEARCHPATH:$SBINSEARCHPATH
AC_PATH_DIRS(CUPS_PPDS,cups/model,CUPS_PPDS_NOT_FOUND,$DATASEARCHPATH)
AC_PATH_PROG(GZIP,gzip,GZIP_NOT_FOUND,$BSB)

dnl disable PPD file compression
AC_MSG_CHECKING(PPD file gzip compression)
AC_ARG_ENABLE( gzip-ppds,
[  --disable-gzip-ppds     disable gzipping of custom PPD files],
[
if test "$enableval" = "yes" ; then
	GZIP_PPDS=yes;
else
	GZIP_PPDS=no;
fi
],
[
if test "$GZIP" != "GZIP_NOT_FOUND" ; then
	GZIP_PPDS=yes;
else
	GZIP_PPDS=no;
fi
],
)
AC_MSG_RESULT($GZIP_PPDS)
AC_SUBST(GZIP_PPDS)

dnl disable linking custom PPD files to CUPS PPDs (/usr/share/cups/model)
AC_MSG_CHECKING(making PPD files available to CUPS)
AC_ARG_ENABLE( ppds-to-cups,
[  --disable-ppds-to-cups  disable making custom PPDs available to CUPS],
[
if test "$enableval" = "yes" ; then
	PPDS_TO_CUPS=yes;
else
	PPDS_TO_CUPS=no;
fi
],
[
if test "$CUPS_PPDS" != "CUPS_PPDS_NOT_FOUND" ; then
	PPDS_TO_CUPS=yes;
else
	PPDS_TO_CUPS=no;
fi
],
)
AC_MSG_RESULT($PPDS_TO_CUPS)
AC_SUBST(PPDS_TO_CUPS)

dnl AC_OUTPUT(Makefile src/Makefile)
AC_OUTPUT(Makefile)

dnl Finished
echo "Finished configuring."
dnl echo "Type 'make' to build the package"
dnl echo "then 'make install' to install it."
echo "Type 'make install' to install the package."
