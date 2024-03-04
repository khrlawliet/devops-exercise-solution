#!/bin/bash

################################################################################
# Script Name: exercise-2.sh
# Description: Perform various operations on a list of 6 consecutive numbers.
# Author: Kervin Rey H. Balibagoso
# Usage: ./exercise-2.sh <num1> <num2> <num3> <num4> <num5> <num6>
################################################################################

# Set final total of number arguments in command line
declare -r TOTAL_NUM_ARGS=6

#Set error message
declare -r ERROR_MSG="Error: Please provide exactly 6 consecutive numbers as command line arguments."

# Set the provided number arguments as an array and immutable
declare -ar NUM_ARGS=("$@")

# Check if 6 numbers are provided as command line arguments
if [[ "${#NUM_ARGS[@]}" -ne $TOTAL_NUM_ARGS ]]; then
    echo $ERROR_MSG
    exit 1
fi

# Check if the provided numbers are consecutive
is_consecutive() {
    local i
    for ((i = 1; i < ${#NUM_ARGS[@]}; i++)); do
        if [ $((NUM_ARGS[i] - NUM_ARGS[i - 1])) -ne 1 ]; then
            return 1
        fi
    done
    return 0
}

# If the numbers are not consecutive, exit the program
if ! is_consecutive; then
    echo $ERROR_MSG
    exit 1
fi

# Main selection
selection() {
    echo "=================================================="
    echo "Select number to perform the following operations:"
    echo "=================================================="
    echo "1. Perform subtraction"
    echo "2. Perform multiplication"
    echo "3. Perfom random number generation"
    echo "4. Print sorted numbers (highest to lowest)"
    echo "5. Print sorted numbers (lowest to highest)"
    echo "6. Exit"

    # Read user input
    read -p "Enter selected number to perform: " operation

    #Perform the selected operation
    case $operation in
    1) subtraction ;;
    2) multiplication ;;
    3) random_number ;;
    4) sort_numbers "desc" ;;
    5) sort_numbers "asc" ;;
    6)
        echo "Exit program."
        exit
        ;;
    *) echo "Invalid operation. Please enter a number from 1 to 6." ;;
    esac

    # selection
}

subtraction() {
    local i
    for ((i = 0; i < ${#NUM_ARGS[@]} - 1; i++)); do
        cur=${NUM_ARGS[i]}
        next=${NUM_ARGS[i + 1]}
        diff=$((cur - next))
        result+=" ${cur} - ${next} = ${diff}, "
    done
    # result=$((${NUM_ARGS[0]} - ${NUM_ARGS[1]} - ${NUM_ARGS[2]} - ${NUM_ARGS[3]} - ${NUM_ARGS[4]} - ${NUM_ARGS[5]}))
    echo "Result = $result"
}

multiplication() {
    product=$((${NUM_ARGS[0]} * ${NUM_ARGS[1]} * ${NUM_ARGS[2]} * ${NUM_ARGS[3]} * ${NUM_ARGS[4]} * ${NUM_ARGS[5]}))
    echo "{\"InputNumber1\": ${NUM_ARGS[0]}, \
    \"InputNumber2\": ${NUM_ARGS[1]}, \
    \"InputNumber3\": ${NUM_ARGS[2]}, \
    \"InputNumber4\": ${NUM_ARGS[3]}, \
    \"InputNumber5\": ${NUM_ARGS[4]}, \
    \"InputNumber6\": ${NUM_ARGS[5]}, \
    \"Multiplication\": $product } " | tr -d ' ' >multiplication_result.json
    echo "Generated multiplication_result.json file"
}

random_number() {
    length=${#NUM_ARGS[@]}
    index=$((RANDOM % length))
    echo "Result = ${NUM_ARGS[$index]}"
}

sort_numbers() {
    local action=$1
    if [ "$action" = "asc" ]; then
        sorted_numbers=($(printf '%s\n' "${NUM_ARGS[@]}" | sort -n))
    elif [ "$action" = "desc" ]; then
        sorted_numbers=($(printf '%s\n' "${NUM_ARGS[@]}" | sort -nr))
    else
        echo "Error: Invalid argument. Please specify action eg 'asc' or 'desc'."
        exit 1
    fi
    result=$(printf '%s ' "${sorted_numbers[@]}")
    echo "Result = ${result}"
}

selection
