#!/bin/bash

# Check if 6 numbers are provided as command line arguments
if [ "$#" -ne 6 ]; then
    echo "Error: Please provide exactly 6 consecutive numbers as command line arguments."
    exit 1
fi

numbers=("$@")

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
if ! is_consecutive "${numbers[@]}"; then
    echo "Error: Please provide 6 consecutive numbers as command line arguments."
    exit 1
fi

# Main selection
selection() {
    echo "=================================================="
    echo "Select number to perform the following operations:"
    echo "1. Perform subtraction"
    echo "2. Perform multiplication"
    echo "3. Perfom random number generation"
    echo "4. Print sorted numbers (highest to lowest)"
    echo "5. Print sorted numbers (lowest to highest)"
    echo "6. Select 6 to exit"

    # Read user input
    read -p "Enter selected number to perform: " operation

    #Perform the selected operation
    case $operation in
    1) subtraction ;;
    2) multiplication ;;
    3) random_number ;;
    4) sort_desc ;;
    5) sort_asc ;;
    6)
        echo "Exit program."
        exit
        ;;
    *) echo "Invalid operation. Please enter a number from 1 to 6." ;;
    esac

    selection
}

subtraction() {
    result=$((${numbers[0]} - ${numbers[1]} - ${numbers[2]} - ${numbers[3]} - ${numbers[4]} - ${numbers[5]}))
    echo "result=$result"
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
    echo "generated multiplication_result.json"
}

random_number() {
    index=$((RANDOM % 6))
    echo "result=${numbers[$index]}"
}

sort_desc() {
    sorted_numbers=($(printf '%s\n' "${numbers[@]}" | sort -nr))
    printf '%s ' "result=${sorted_numbers[@]}"
    echo
}

sort_asc() {
    sorted_numbers=($(printf '%s\n' "${numbers[@]}" | sort -n))
    printf '%s ' "result=${sorted_numbers[@]}"
    echo
}

selection
