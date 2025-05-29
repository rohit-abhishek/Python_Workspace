"""
Store cart names and print all the cats  
"""

cat_name = [] 
name = "" 

while True: 
    name = input("Enter name of your " + str(len(cat_name) + 1) + ' cat: ')
    # check if name entered
    if name == "": 
        break

    cat_name += [name]


# print cat names 
print ("Your cats are ", ', '.join(cat_name))