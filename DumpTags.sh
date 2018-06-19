
for path in /cygdrive/c/Temp/Mercurial/*; do
	[ -d "${path}" ] || continue # if not a directory, skip
	dirname="$(basename "${path}")"
	
	echo "${dirname}..."
	cd ${path}
	
	#hg log | grep user: | sort | uniq | sed 's/user: *//' >> ../../authors
	hg tags -q >> ../../tags
done

sort -u /cygdrive/c/Temp/tags > /cygdrive/c/Temp/Tags.txt