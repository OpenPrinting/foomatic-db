dnl Process this file with autoconf to produce a configure script.
AC_INIT(db/source/driver/ljet4.xml)

# If the user didn't specify the $sysconfdir on the command line, let it
# be /etc, not /usr/local/etc or /usr/etc
if [[ x$sysconfdir = 'x${prefix}/etc' ]]; then
  sysconfdir=/etc
fi

# Checks for programs.
AC_PROG_INSTALL
AC_PROG_MAKE_SET

SBINSEARCHPATH=/usr/sbin:/sbin:/usr/local/sbin:/etc/sbin
BINSEARCHPATH=/usr/bin:/bin:/usr/local/bin
DATASEARCHPATH=/usr/share:/usr/local/share:/usr/lib:/usr/local/lib:/opt
BSB=$BINSEARCHPATH:$SBINSEARCHPATH
FM_PATH_DIRS(CUPS_PPDS,cups/model,CUPS_PPDS_NOT_FOUND,$DATASEARCHPATH)
AC_PATH_PROG(GZIP,gzip,GZIP_NOT_FOUND,$BSB)

# disable PPD file compression
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

# disable linking custom PPD files to CUPS PPDs (/usr/share/cups/model)
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

# look for driver XMLs to include...
AC_ARG_WITH(drivers,
[  --with-drivers=LIST     Drivers to include, separated by commas.
                          Either list the drivers or use aliases:
                          ALL      = all drivers
                          NOOBSOLETES =
			             no drivers marked obsolete
                          NOEMPTYCMDLINE =
			             no drivers without invocation
				     command line
			  ONLYRECOMMENDED =
				     no drivers which are not
				     recommended for at least one
				     printer
                          You can mix both variants, e.g.
                          --with-drivers=ALL,NOOBSOLETES,gutenprint
			  would include all drivers except obsoletes, but
			  "gutenprint" is included even being obsolete
			  (list is treated from the left to the right).
                          Aliases must be uppercase (a 3rd party driver
			  might have the same name).
                          Default: NOOBSOLETES],
			  drivers="$withval",drivers="NOOBSOLETES")

AC_ARG_WITH(driversfile,
[  --with-driversfile=FILE Drivers to support from file, separated by newlines.],
driversfile="$withval",driversfile="")

if test "x$driversfile" != x; then
	# Add drivers from file...
	drivers="`tr '\n' ',' <$driversfile`"
fi

# If first item in the driver list is an excluding alias, assume that
# we want to exclude these items from all drivers
if `echo $drivers | egrep '^\s*(NO|ONLY)' > /dev/null`; then
   drivers="ALL,$drivers"
fi

# Check which driver XML files we will install
DRIVERXMLS="";

while test -n "$drivers"; do
	if echo $drivers |grep "," >/dev/null; then
		THIS="`echo $drivers |sed -e 's/,.*//'`"
		drivers="`echo $drivers |sed -e \"s/$THIS,//\"`"
	else
		THIS=$drivers
		drivers=""
	fi
	case "$THIS" in
	ALL)
		# ALL = PRINTERS + FILES...
		DRIVERXMLS=`cd db/source/driver/; ls -1 *.xml`
		;;
	NOOBSOLETES)
		OBSOLETEXMLS=`cd db/source/driver/; grep -li '< *obsolete.*/ *>' *.xml`
		while test -n "$OBSOLETEXMLS"; do
		    if echo $OBSOLETEXMLS |grep " " >/dev/null; then
		        REMOVE="`echo $OBSOLETEXMLS |sed -e 's/ .*//'`"
		        OBSOLETEXMLS="`echo $OBSOLETEXMLS |sed -e \"s/$REMOVE //\"`"
		    else
		        REMOVE=$OBSOLETEXMLS
		        OBSOLETEXMLS=""
		    fi
		    DRIVERXMLS=`echo $DRIVERXMLS | sed -e "s/$REMOVE *//"`
		done
		;;
	NOEMPTYCMDLINE)
		EMPTYCMDLINEXMLS=`cd db/source/driver/; grep -li '< *prototype *> *< */prototype *>' *.xml`
		EMPTYCMDLINEXMLS="$EMPTYCMDLINEXMLS `cd db/source/driver/; grep -li '< *prototype */ *>' *.xml`"
		EMPTYCMDLINEXMLS="$EMPTYCMDLINEXMLS `cd db/source/driver/; grep -Li '< *prototype' *.xml`"
		while test -n "$EMPTYCMDLINEXMLS"; do
		    if echo $EMPTYCMDLINEXMLS |grep " " >/dev/null; then
		        REMOVE="`echo $EMPTYCMDLINEXMLS |sed -e 's/ .*//'`"
		        EMPTYCMDLINEXMLS="`echo $EMPTYCMDLINEXMLS |sed -e \"s/$REMOVE //\"`"
		    else
		        REMOVE=$EMPTYCMDLINEXMLS
		        EMPTYCMDLINEXMLS=""
		    fi
		    DRIVERXMLS=`echo $DRIVERXMLS | sed -e "s/$REMOVE *//"`
		done
		;;
	ONLYRECOMMENDED)
		DRIVERXMLS2='';
		RECOMMENDEDXMLS=`grep '<driver>' db/source/printer/*.xml | perl -p -e 's:^.*<driver>(.*?)</driver>.*$:$1.xml:' | grep -v ':' | grep -v '^\.xml' | sort | uniq`
		while test -n "$RECOMMENDEDXMLS"; do
		    if echo $RECOMMENDEDXMLS |grep " " >/dev/null; then
		        KEEP="`echo $RECOMMENDEDXMLS |sed -e 's/ .*//'`"
		        RECOMMENDEDXMLS="`echo $RECOMMENDEDXMLS |sed -e \"s/$KEEP //\"`"
		    else
		        KEEP=$RECOMMENDEDXMLS
		        RECOMMENDEDXMLS=""
		    fi
		    if echo $DRIVERXMLS | grep $KEEP >/dev/null; then
		        DRIVERXMLS2="$DRIVERXMLS2 $KEEP"
		    fi
		done
		DRIVERXMLS=$DRIVERXMLS2
		;;
	*)
		# It's a driver name (or a user messup)
		DRIVERXMLS="$DRIVERXMLS $THIS.xml"
		;;
	esac
done
AC_SUBST(DRIVERXMLS)

AC_CONFIG_FILES(Makefile)
AC_OUTPUT

# Finished
echo "Finished configuring."
echo "Type 'make install' to install the package."
