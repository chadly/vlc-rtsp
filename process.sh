#!/bin/bash -e

folder=$1
camName=$2
basePath=$3

#http://stackoverflow.com/q/11448885
threshold=`date -d "5 minutes ago" +%Y%m%d%H%M%S`

#http://unix.stackexchange.com/a/84859/50868
shopt -s nullglob

for path in $basePath/raw/$folder/record/*.mkv ; do
	file=$(basename $path)

	#http://stackoverflow.com/a/5257398/316108
	parts=(${file//_/ })

	#http://www.catonmat.net/blog/bash-one-liners-explained-part-two/
	date=${parts[1]:0:4}-${parts[1]:4:2}-${parts[1]:6:2}
	time=${parts[2]:0:2}:${parts[2]:2:2}:${parts[2]:4:2}

	vidTimestamp=${parts[1]:0:4}${parts[1]:4:2}${parts[1]:6:2}${parts[2]:0:2}${parts[2]:2:2}${parts[2]:4:2}

	if test "$vidTimestamp" -lt "$threshold"
	then
		mkdir -p $basePath/processed/$date/.cams/$camName
		mv $path $basePath/processed/$date/.cams/$camName/$time.mkv
	fi	
done

./merge.sh $camName $basePath