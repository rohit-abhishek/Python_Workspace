""" Take any positive integer and divide by 2 if even otherwise multiply it by 3 and 1. 
Keep doing this iteratively. 
the number will show the pattern of 4,2,1"""


def collatz(number):

    if number % 2 == 0:
        print (number // 2)
        return number // 2
    else: 
        print (3*number+1)
        return 3*number+1
    
number = input("Enter any positive number: ")

try:
    number = abs(int(number))
    print (number)
    while True: 
        number = collatz(number)
        if number == 1:
            break 
except Exception as e:
    print ("Invalid input. Must be integer")