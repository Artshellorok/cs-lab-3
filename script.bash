export LANG=en_US.UTF-8

printLevel() {
    local i
    lim=$1
    if [[ $2 -eq 1 ]]; then
        lim=$(( $1 - 1 ))
    fi
    for (( i=0; i<$lim; i++ ))
    do
        printf "\u2502\u00A0\u00A0\u0020"
    done
    if [[ $2 -eq 1 ]]; then
        printf "\u00A0\u00A0\u00A0\u0020"
    fi
}
printEntity() {
    if [[ $2 -eq $(( $3 -1 )) ]]; then
       printf "\u2514\u2500\u2500\u0020 $1\n"
    else
       printf "\u251c\u2500\u2500\u0020 $1\n" 
    fi
}
printDir() {
    local list
    local len
    local i 
    list=( $( ls -1 $1 | tr '\n' ' ' ) )
    len=${#list[@]}
    for (( i=0; i < $len; i++ ))
    do
        if [[ -d "${list[$i]}" ]]; then
            count_dir=$((count_dir+1))
            printLevel $2 $3
            printEntity ${list[$i]} $i $len
            cd ${list[$i]}
            if [[ $i -eq $(( $len -1 )) ]]; then
                printDir . $(( $2 +1 )) 1
            else
                printDir . $(( $2 +1 )) 0
            fi
        else
            count_files=$((count_files+1))
            printLevel $2 $3
            printEntity ${list[$i]} $i $len
        fi
    done
    if [[ $2 -ne 0 ]]; then
        cd ..
    fi
}


echo "$1"
cd $1

count_dir=0
count_files=0

printDir . 0 0

printf "\n$count_dir directories, $count_files files"