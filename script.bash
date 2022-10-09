#!/bin/bash

export LANG=en_US.UTF-8

dc=0
fc=0

tree ()
{
	dir=$1
	parent=$2
	subdirs=( $(ls $dir) )
	
	dc=0
	fc=0
	
	i=0
	for name in ${subdirs[@]}
	do
		(( i++ ))
		child="\u251c\u2500\u2500\u0020"
	
		last=0
		if [[ $i -eq ${#subdirs[@]} ]]
		then
			child="\u2514\u2500\u2500\u0020"
			if [[ $3 -eq 1 ]] || [[ $4 -eq 0 ]]
			then
				last=1
			fi
		fi
		
		if [ -d "$dir/$name" ] && [[ $i -ne ${#subdirs[@]} ]]
		then
			nextparent="$parent\u2502\u00A0\u00A0\u0020"
		else 
			nextparent="$parent\u0020\u0020\u0020\u0020"
		fi
		
		if [[ $last -eq 1 ]]
		then
			parent=""
			for i in $(seq 1 $4)
			do
				parent="$parent\u0020\u0020\u0020\u0020"
			done
			nextparent="$parent\u0020\u0020\u0020\u0020"
		fi
		
		file=0
		for char in $(grep -o . <<< "$name")
		do
			if [ "$char" = "." ]
			then
				file=1
			fi
		done
		
		printf "$parent$child$name\n"
		
		if [ $file -eq 0 ] && [ -d "$dir/$name" ]
		then
			(( dc++ ))
			subdirschild=( $(ls $dir/$name) )
			if [ ${#subdirschild[@]} -ne 0 ]
			then
				printf "$(tree "$dir/$name" $nextparent $last $(( $4 + 1 )))\n"
			fi
		else
			(( fc++ ))
		fi
	done
	printf "+$dc $fc\n"
}

direct=$1
if [ "$direct" = "" ]
then
	direct="."
fi


printf "$direct\n"

res=$(tree $direct "" 0 0)
IFS=$'\n' y=($res)

for line in ${y[@]}
do
	if [ "${line:0:1}" = "+" ]
	then
		nums=${line#*_}
		IFS=$'\u0020' arr=($nums)
		dc=$(( $dc + ${arr[0]} ))
		fc=$(( $fc + ${arr[1]} ))
	else
		printf "$line\n"
	fi
done


printf "\n"

if [ $dc -eq 1 ]
then
	printf "1 directory, "
else
	printf "$dc directories, "
fi

if [ $fc -eq 1 ]
then
	printf "1 file\n"
else
	printf "$fc files\n"
fi
