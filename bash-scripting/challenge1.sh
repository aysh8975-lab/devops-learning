#!/bin/bash

# A script that takes 2 numbers as imput and calculates +,-,*,/ the output

echo "Please enter the first number"
read num1 

echo "Please enter the second number"
read num2


#calculate the addition result
result=$((num1 + num2))
# Display the result
echo "The result of $num1 plus $num2 is: $result"

#calculate the subtraction result
result=$((num1 - num2))
# Display the result
echo "The result of $num1 minus $num2 is: $result"

#calculate the muliplication result
result=$((num1 * num2))
# Display the result
echo "The result of $num1 multiplied by $num2 is: $result"


#calculate the muliplication result
if [[ "$num2" -ne 0 ]]; then
 result=$((num1 / num2))

 # Display the result
echo "The result of $num1 divided by $num2 is: $result"

 else

 echo "Division by 0 is not allowed!"

 fi




