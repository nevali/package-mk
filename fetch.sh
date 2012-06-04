#! /bin/sh

file=$1
name=$2
shift ; shift
dir="$file"

if test "$name" = "-" ; then
	file='INVALID'
	name='INVALID'
fi

status=254
if test x"$1" = x"" ; then
	echo "Failed to fetch $name because no distribution URLs are defined" >&2
	exit 255
fi
for url ; do   
	case "$url" in
		*\|*)
			name=`echo $url | cut -f1 -d\|`
			url=`echo $url | cut -f2 -d\|`
			file="$dir/$name"
			;;
		*)
		    url="${url}${name}"
			;;
	esac
	if test -r "$file" ; then
		status=0
		continue
	fi
	echo "Attempting to fetch $name from $url" >&2
	if $CURL -L -o ${file}.tmp "${url}" ; then
		mv ${file}.tmp ${file}
	fi
	status=$?
done
if test $status -gt 0 ; then
	echo "Failed to fetch $name" >&2
fi
exit $status


	
