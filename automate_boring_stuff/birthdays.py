""" 
ask user to enter the name and get the user's bday. if user not found - add the bday
"""

import os 
import sys 

# create dictionary of bdays 
birthdays = {
    "Tom" : '05-Mar-1984', 
    "Dick" : '29-Sept-1981',
    "Harry" : '01-01-1951'
}

while True: 
    name = input("Enter the name of the person (blank to quit): ")
    if name.strip() == "":
        break

    name = name.strip()

    if name in birthdays:
        print(f"Birthday of {name} is {birthdays[name]}")
    else: 
        selection = input(f"Birthday of {name} is not found. Do you want to add the entry? (Y/N): ")
        if selection.strip().upper() == "Y":
            bday = input(f"Enter the birthday of {name}: ")
            birthdays[name] = bday
            print("Dictionary updated successfully!")