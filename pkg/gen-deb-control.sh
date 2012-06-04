#! /bin/sh

if test x"$2" = x"" ; then
	echo "Usage: $0 IN OUT" >&2
	exit 1
fi

in="$1"
out="$2"

echo "generating $out" >&2

rm -f "$out"
if test x"$in" = x"" ; then
	echo "Package: $PKGNAME" >>"$out"
	echo "Version: $PKGVER" >>"$out"
	echo "Architecture: $PKGTARGET" >>"$out"
	echo "Section: $SECTION" >>"$out"
	echo "Priority: $PRIORITY" >>"$out"
	if ! test x"$DEPENDS" = x"" ;then
		true
	fi
	if ! test x"$BUILD_DEPENDS" = x"" ;then
		true
	fi
	echo "Description: $SHORTDESC" >>"$out"	
	if ! test x"$DESC" = x"" ;then
		echo "$DESC" | sed \
			-e s'!^[ ]*!!g' \
			-e s'!^! !g' \
			-e s'!^[ ]*$! .!g' \
			>>"$out"
	fi
	if ! test x"$HOMEPAGE" = x"" ;then
		echo "Homepage: $HOMEPAGE" >>"$out"
	fi
else
	echo "Warning: generating a debian/control from a template is deprecated" >&2
	cat "$in" | sed \
		-e 's!%package%!$PKGNAME!g' \
		-e 's!%version%!$PKGVER!g' \
		-e 's!%arch%!$PKGTARGET!g' \
		> "$out"
fi
