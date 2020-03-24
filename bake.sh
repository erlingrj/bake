#!/bin/bash

BOOM_SRCS="/home/erling/chipyard/generators/boom/src/main/scala"
eval "ssh $VUBUNTU ls -R --full-time $BOOM_SRCS > .tmp"
cdir=""
while IFS="" read -r p || [ -n "$p" ]
do
	if [[ ${p::1} == "/" ]]; then cdir=${p::-1};
	elif [[ ${p::1} == "-" ]]; 
	then
		name="$cdir/$(echo $p | awk '{print $9}')"
		rtimestamp=$(date -d "$(echo $p | awk {'printf ("%s %s\n", $6,$7)'})" +"%s")

		# Now compare it to the local version of that file
		if [ ! -f $name ]; then
      echo "$name does not exist locally. Copy"
			eval "scp $VUBUNTU:$name $name"
		else
			# File exist. Compare timestamps
			ltimestamp=$(date -d "$(ls --full-time $name | awk {'printf("%s %s\n",
      $6, $7)'})" +"%s")
			if [ $rtimestamp -ge $ltimestamp ];
			then
				eval "scp $VUBUNTU:$name $name"
			fi
		fi
	fi	
done < .tmp
eval "rm .tmp"

