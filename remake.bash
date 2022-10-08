export LANG=en_US.UTF-8

printLevel() {
    local i 
    local j
    for (( j=0; j<$2; j++ ))
    do
        printf "\u0020\u0020\u0020\u0020"
    done 
    for (( i=0; i<$(( $1 - $2 )); i++ ))
    do
        printf "\u2502\u00A0\u00A0\u0020"
    done
}
printEntity() {
    if [[ $2 -eq $(( $3 -1 )) ]]; then
       printf "\u2514\u2500\u2500\u0020$( basename ${1} )\n"
    else
        printf "\u251c\u2500\u2500\u0020$( basename ${1} )\n" 
    fi
}
printDir() {
    local list
    local len
    local i 
    # list=( $( ls -1 $1 | tr '\n' ' ' ) )
    # list=($1/*)
    # list=($1/* "adas")
    list=($1/*)
    len=${#list[@]}

    for (( i=0; i < $len; i++ ))
    do
        if [[ -d "${list[$i]}" ]]; then
            count_dir=$((count_dir+1))
            printLevel $2 $3
            printEntity ${list[$i]} $i $len
            # cd ${list[$i]}
            count_sp=$3
            if [[ $i -eq $(( $len -1 )) ]]; then
                count_sp=$(( count_sp + 1 ))
            fi
            printDir "${list[$i]}" $(( $2 +1 )) $count_sp
        else
            count_files=$((count_files+1))
            printLevel $2 $3
            printEntity ${list[$i]} $i $len
        fi
    done
    # if [[ $2 -ne 0 ]]; then
    #     cd ..
    # fi
}

count_dir=0
count_files=0
count_arg=0
for path in "$@"
do
    count_arg=$(( count_arg + 1 ))
    if ! [[ -d "$path" ]]; then
        echo "$path  [error opening dir]"
    else
        echo "$path"
        if [[ $count_arg -eq $# ]]; then
            printDir $path 0 0
        else
            printDir $path 0 0
        fi
    fi
done


printf "\n$count_dir directories, $count_files files\n"
