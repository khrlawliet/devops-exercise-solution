#!/bin/bash

# Set final numbers of arguments in command line
declare -r TOTAL_NUM_ARGS=6

#Set error message
declare -r ERROR_MSG="Error: Please provide exactly 6 consecutive numbers as command line arguments."

# Set the provided numbers as an array and immutable
readonly numbers=("$@")

# Check if 6 numbers are provided as command line arguments
if [ "${#numbers[@]}" -ne $TOTAL_NUM_ARGS ]; then
    echo $ERROR_MSG
    exit 1
fi

# Check if the provided numbers are consecutive
is_consecutive() {
    local i
    for ((i = 1; i < ${#numbers[@]}; i++)); do
        if [ $((numbers[i] - numbers[i - 1])) -ne 1 ]; then
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
    for ((i = 0; i < ${#numbers[@]} - 1; i++)); do
        cur=${numbers[i]}
        next=${numbers[i + 1]}
        diff=$((cur - next))
        result+=" ${cur} - ${next} = ${diff}, "
    done
    # result=$((${numbers[0]} - ${numbers[1]} - ${numbers[2]} - ${numbers[3]} - ${numbers[4]} - ${numbers[5]}))
    echo "Result = $result"
}

multiplication() {
    result=$((${numbers[0]} * ${numbers[1]} * ${numbers[2]} * ${numbers[3]} * ${numbers[4]} * ${numbers[5]}))
    echo "{\"InputNumber1\": ${numbers[0]}, \
    \"InputNumber2\": ${numbers[1]}, \
    \"InputNumber3\": ${numbers[2]}, \
    \"InputNumber4\": ${numbers[3]}, \
    \"InputNumber5\": ${numbers[4]}, \
    \"InputNumber6\": ${numbers[5]}, \
    \"Multiplication\": $result } " | tr -d ' ' >multiplication_result.json
    echo "Generated multiplication_result.json file"
}

random_number() {
    length=${#numbers[@]}
    index=$((RANDOM % length))
    echo "Result = ${numbers[$index]}"
}

sort_numbers() {
    local arg=$1
    if [ "$arg" = "asc" ]; then
        sorted_numbers=($(printf '%s\n' "${numbers[@]}" | sort -n))
    elif [ "$arg" = "desc" ]; then
        sorted_numbers=($(printf '%s\n' "${numbers[@]}" | sort -nr))
    else
        echo "Error: Invalid argument. Please specify 'asc' or 'desc'."
        exit 1
    fi
    result=$(printf '%s ' "${sorted_numbers[@]}")
    echo "Result = ${result}"
}

selection
