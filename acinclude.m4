dnl FM_PATH_DIR(VARIABLE, DIR-TO-CHECK-FOR [, VALUE-IF-NOT-FOUND [, PATH]])
AC_DEFUN([FM_PATH_DIR],
[# Extract the first word of "$2", so it can be a program name with args.
set dummy $2; ac_word=[$]2
AC_MSG_CHECKING([for $ac_word/])
AC_CACHE_VAL(ac_cv_path_$1,
[case "[$]$1" in
  /*)
  ac_cv_path_$1="[$]$1" # Let the user override the test with a path.
  ;;
  ?:/*)			 
  ac_cv_path_$1="[$]$1" # Let the user override the test with a dos path.
  ;;
  *)
  IFS="${IFS= 	}"; ac_save_ifs="$IFS"; IFS=":"
dnl $ac_dummy forces splitting on constant user-supplied paths.
dnl POSIX.2 word splitting is done only on the output of word expansions,
dnl not every word.  This closes a longstanding sh security hole.
  ac_dummy="ifelse([$4], , $PATH, [$4])"
  for ac_dir in $ac_dummy; do 
    test -z "$ac_dir" && ac_dir=.
    if test -d $ac_dir/$ac_word; then
      ac_cv_path_$1="$ac_dir/$ac_word"
      break
    fi
  done
  IFS="$ac_save_ifs"
dnl If no 3rd arg is given, leave the cache variable unset,
dnl so AC_PATH_PROGS will keep looking.
ifelse([$3], , , [  test -z "[$]ac_cv_path_$1" && ac_cv_path_$1="$3"
])dnl
  ;;
esac])dnl
$1="$ac_cv_path_$1"
if test -n "[$]$1"; then
  AC_MSG_RESULT([$]$1)
else
  AC_MSG_RESULT(no)
fi
AC_SUBST($1)dnl
])

dnl FM_PATH_DIRS(VARIABLE, DIRSS-TO-CHECK-FOR [, VALUE-IF-NOT-FOUND
dnl              [, PATH]])
AC_DEFUN([FM_PATH_DIRS],
[for ac_dir in $2
do
FM_PATH_DIR($1, [$]ac_dir, , $4)
test -n "[$]$1" && break
done
ifelse([$3], , , [test -n "[$]$1" || $1="$3"
])])

