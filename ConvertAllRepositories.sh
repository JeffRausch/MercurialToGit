
for path in /cygdrive/c/Temp/Mercurial/*; do
	[ -d "${path}" ] || continue # if not a directory, skip
	dirname="$(basename "${path}")"
		
	cd /cygdrive/c/Temp/Git/
	
	if [ -d ${dirname} ]; then
		echo ${dirname} "already exists."
		continue
	fi
	
	
	echo "${dirname}..."
	git init ${dirname} &> _Logs/Convert_${dirname}.log
	cd ${dirname}
	
	git config core.ignoreCase false
	
	../../fast-export/hg-fast-export.sh -r ../../Mercurial/${dirname}/ -A ../../Authors.txt &>>../_Logs/Convert_${dirname}.log
	
	#Remove all the branches	
	git branch | grep -v \* | xargs git branch -D &>> ../_Logs/Convert_${dirname}.log
	
	#Checkout the head to pull all the files into the main directory
	git checkout HEAD
	
	#Rename the ignore file
#	if [ -f .hgignore ]; then
#		mv .hgignore .gitignore
#	fi
	
	#echo "Finished."
	#sleep 5
done