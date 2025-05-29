""" Flip unbaised coints and store the outcome. check the winning streak 6 times head or tail in a row """

import random, time, copy 

number_of_streaks = 0 
counter = 1

# set current and previous values to None 
current, previous = None, None 

# first store all the coin flips in a list 
for experiment in range(0, 1000): 
    head_tail = [] 

    for i in range(0, 100):
        flip = random.choice(["H", "T"])
        head_tail.append(flip)
    
    for index, value in enumerate(head_tail):
        previous = current
        current = head_tail[index]

        if current == previous:
            counter += 1
            if counter == 6: 
                number_of_streaks += 1
                counter = 1 
                current = None  
        elif current != previous:
            counter = 1

print(f"Chance of Streak: {number_of_streaks/100}%")