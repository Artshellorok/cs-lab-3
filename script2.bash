printLevel() {
    local i
    lim=$1
    if [[ $2 -eq 1 ]]; then
        lim=$(( $1 - 1 ))
    fi
    for (( i=0; i<$lim; i++ ))
    do
        printf "\u2502\u01A0\u00A0\u0020"
    done
    if [[ $2 -eq 1 ]]; then
        printf "\u00A0\u00A0\u00A0\u0020"
    fi
}
printEntity() {
    if [[ $2 -eq $(( $3 -1 )) ]]; then
       printf "\u2514\u2500\u2500\u0020$1\n"
    else
       printf "\u251c\u2500\u2500\u0020$1\n" 
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
            printLevel $2 $3
            printEntity ${list[$i]} $i $len
            cd ${list[$i]}
            if [[ $i -eq $(( $len -1 )) ]]; then
                printDir . $(( $2 +1 )) 1
            else
                printDir . $(( $2 +1 )) 0
            fi
        else
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

printDir . 0 0
