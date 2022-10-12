#!/bin/bash

export LANG=en_US.UTF-8

traverse(){
    local path=$1
    local prefix=$2
    local files=( $( ls $path ) )
    local n=${#files[@]}
    local i


    for (( i=0; i<n; i++ ))
    do
        local el=${files[$i]}
        
        if [[ $i -eq $(( n-1 )) ]]; then
            local local_prefix="\u0020\u0020\u0020\u0020"
            local pointer="\u2514\u2500\u2500\u0020"
        else 
            local local_prefix="\u2502\u00A0\u00A0\u0020"
            local pointer="\u251c\u2500\u2500\u0020"
        fi

        printf "${prefix}${pointer}"

		file=0
		for char in $(grep -o . <<< "$el")
		do
			if [ "$char" = "." ]
			then
				file=1
			fi
		done

        if [[ $file -eq 0 ]] && [[ -d "$path/$el" ]]; then
            count_dir=$(( count_dir +1 ))
            if ! [[ -r "$path/$el" ]]; then
                echo "$el  [error opening dir]"
            else 
                echo "$el"
            fi
            traverse "$path/$el" "$prefix$local_prefix"
        else
            echo "${el##*/}"
            count_files=$(( count_files +1 ))
        fi

    done

}

count_dir=0
count_files=0

direct=$1
if [[ "$direct" = "" ]]; then 
    direct="."
fi

printf "$direct\n"

count_dir=0
count_files=0
traverse "$direct" ""

printf "\n"

if [[ $count_dir -eq 1 ]]; then
    printf "1 directory, "
else
    printf "$count_dir directories, "
fi
if [[ $count_files -eq 1 ]]; then
    printf "1 file\n"
else
    printf "$count_files files\n"
fi
