export LANG=en_US.UTF-8

printEntity() {
    filepath=$1
    ind=$2
    n=$3
    if [[ $ind -eq $(( n -1 )) ]]; then
       printf "\u2514"
    else
        printf "\u251c"
    fi
    printf "\u2500\u2500\u0020$( basename ${filepath} )\n"
}

traverse(){
    local path=$1
    local prefix=$2
    local files=($path/*)
    local n=${#files[@]}
    local i


    for (( i=0; i<n; i++ ))
    do
        local el=${files[$i]}

        if [[ $i -eq $(( n-1 )) ]]; then
            local local_prefix="\u0020\u0020\u0020\u0020"
        else 
            local local_prefix="\u2502\u00A0\u00A0\u0020"
        fi

        printf "$prefix"
        printEntity $el $i $n

        if [[ -d $el ]]; then
            count_dir=$(( count_dir +1 ))
            traverse $el "$prefix$local_prefix"
        else
            count_files=$(( count_files +1 ))
        fi

    done

}

count_dir=0
count_files=0

for path in "$@"
do
    if ! [[ -d "$path" ]]; then
        echo "$path  [error opening dir]"
    else
        count_dir=0
        count_files=0
        echo $path
        traverse $path ""
    fi
done

printf "\n$count_dir directories, $count_files files\n"
