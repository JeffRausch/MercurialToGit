
for path in /cygdrive/c/Temp/Mercurial/*; do
	[ -d "${path}" ] || continue # if not a directory, skip
	dirname="$(basename "${path}")"
	
	echo "${dirname}..."
	cd ${path}
	
	#hg log | grep user: | sort | uniq | sed 's/user: *//' >> ../../authors
	hg log | grep user: >> ../../authors
done

sort -u /cygdrive/c/Temp/authors | sed 's/user: *//' > /cygdrive/c/Temp/Authors.txt