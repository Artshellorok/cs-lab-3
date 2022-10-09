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
        
        # if [[ $( basename $el ) -eq "\*" ]]; then
        #     continue
        # fi
        if [[ $i -eq $(( n-1 )) ]]; then
            local local_prefix="\u0020\u0020\u0020\u0020"
            local pointer="\u2514\u2500\u2500\u0020"
        else 
            local local_prefix="\u2502\u00A0\u00A0\u0020"
            local pointer="\u251c\u2500\u2500\u0020"
        fi
        # echo $prefix $pointer $el
        printf "${prefix}${pointer}"
        # if [[ -L $el ]]; then
        #     if [[ -d "$el" ]]; then
        #         count_dir=$(( count_dir + 1 ))
        #     else
        #         count_files=$(( count_files + 1 )) 
        #     fi
        #     echo "${el##*/} -> $( realpath $el )"
        #     continue
        # fi

        if [[ -d "$path/$el" ]]; then
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

if [[ $# -eq 0 ]]; then
    traverse '.' ''
fi

for path in "$@"
do
    if ! [[ -d "$path" ]]; then
        echo "$path  [error opening dir]"
    else
        count_dir=0
        count_files=0
        echo $path
        traverse "$path" ""
    fi
done

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
# printf "\n$count_dir directories, $count_files files\n"