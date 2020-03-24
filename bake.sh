#!/bin/bash

BOOM_SRCS="/home/erling/chipyard/generators/boom/src/main/scala"
REMOTE_SRCS="chipyard/generators/boom/src/main/scala/"
eval "ssh $NUBUNTU ls -R --full-time $REMOTE_SRCS > .tmp"
cdir=""
while IFS="" read -r p || [ -n "$p" ]
do
	if [[ ${p::1} == "c" ]]; then cdir=$p;
	elif [[ ${p::1} == "-" ]]; 
	then
		name="/home/erling/$cdir/$(echo $p | awk '{print $9}')"
		rtimestamp=$(date -d "$(echo $p | awk {'printf ("%s %s\n", $6,$7)'})" +"%s")
		echo $name $rtimestamp

		# Now compare it to the local version of that file
		if [ ! -f $name]; then
			echo "scp $VUBUNTU:$name $name"
		else
			# File exist. Compare timestamps
			ltimestamp=$(date -d "$(ls --full-time $name | awk {'printf("%s %s\n", $6, $7'})" +"%s")
			if [ $rtimestamp -ge $ltimestamp ];
			then
				echo "scp $VUBUNTU:$name $name"
			fi
		fi
	fi	
done < .tmp
echo "rm .tmp"

