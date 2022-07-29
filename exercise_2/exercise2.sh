#!/bin/bash

# Please write a program in any language of your choice, based on the requirement below.
# Firstly, the script must take 6 consecutive numbers from command line arguments (each number is one argument).  Secondly, the script must present to the user, through standard output, the following simple choice menu and operate accordingly in the background with the numbers the user entered previously:

# - Perform subtraction and show output on screen comma separated.
# - Perform multiplication and store result in a JSON file (i.e. {"InputNumber1": x, "InputNumber2": y, "InputNumber3": a, "InputNumber4": b, "InputNumber5": c, "InputNumber6": d, "Multiplication": X }, where x, y, a, b, c and d are user line arguments and X is the multiplication result)
# - Pick randomly a number and show it on screen.
# - Print sorted (highest to lowest) array/list numbers.
# - Print sorted (lowest to highest) array/list numbers



if [ "$#" -ne 6 ]; then
    echo "Usage: $0 InputNumber1 InputNumber2 InputNumber3 InputNumber4 InputNumber5 InputNumber6" >&2
    exit 1
fi

args=("$@")

InputNumber1=${args[0]}
InputNumber2=${args[1]}
InputNumber3=${args[2]}
InputNumber4=${args[3]}
InputNumber5=${args[4]}
InputNumber6=${args[5]}

declare -a NUMBERS=($InputNumber1 $InputNumber2 $InputNumber3 $InputNumber4 $InputNumber5 $InputNumber6)

Subtraction()
{
    Subtract=$(( $InputNumber1 - $InputNumber2 - $InputNumber3 - $InputNumber4 - $InputNumber5 - $InputNumber6 ))
    
    echo "\"InputNumber1\": $InputNumber1, \"InputNumber2\": $InputNumber2, \"InputNumber3\": $InputNumber3, \"InputNumber4\": $InputNumber4, \"InputNumber5\": $InputNumber5, \"InputNumber6\": $InputNumber6, \"Subtraction\": $Subtract"
}

Multiplication() {
    
    multiplier=$(( $InputNumber1 * $InputNumber2 * $InputNumber3 * $InputNumber4 * $InputNumber5 * $InputNumber6 ))
    
    printf "
{
    \"InputNumber1\": $InputNumber1,
    \"InputNumber2\": $InputNumber2,
    \"InputNumber3\": $InputNumber3,
    \"InputNumber4\": $InputNumber4,
    \"InputNumber5\": $InputNumber5,
    \"InputNumber6\": $InputNumber6,
    \"Multiplication\": $multiplier
}
    " > Multiplication.json
    
}

Randon_Number (){
    echo ${NUMBERS[ $RANDOM % ${#NUMBERS[@]} ]}
    sleep 1 # The RANDOM is based on timestamp, so we need to wait a second to get a different number
}

Sorted_High_to_Lowest () {
    printf "%s\n" "${NUMBERS[@]}" | sort -nr
}

Sorted_Lowest_to_High () {
    printf "%s\n" "${NUMBERS[@]}" | sort -n
}

PS3="Please, select an option:"
select i in "Subtraction" "Multiplication" "Randon number" "Sorted (highest to lowest)" "Sorted (lowest to highest)"
do
    case $i in
        "Subtraction") # Subtraction
            Subtraction
            break
        ;;
        "Multiplication") # Multiplication
            Multiplication
            break
        ;;
        "Randon number") # Randon number
            Randon_Number
            break
        ;;
        "Sorted (highest to lowest)") # Sorted (highest to lowest
            Sorted_High_to_Lowest
            break
        ;;
        "Sorted (lowest to highest)") # Sorted (lowest to highest)
            Sorted_Lowest_to_High
            break
        ;;
        *)
            exit 1
        ;;
    esac
done