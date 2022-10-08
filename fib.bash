fib() {
    if [[ $1 -eq 0 ]]; then
        echo 0
    elif [[ $1 -eq 1 ]]  || [[ $1 -eq 2 ]]; then
        echo 1
    else 
        first=$(fib $(( $1 -2 )) )
        second=$(fib $(( $1 -1 )) )
        echo $(( first + second ))
    fi
}

fib $1
