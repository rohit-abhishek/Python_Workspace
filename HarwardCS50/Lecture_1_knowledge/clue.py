from logic import * 
import termcolor

# create people 
mustard = Symbol("Col Mustard")
scarlet = Symbol("Scarlet")
plum = Symbol("Dr Plum")
people = [mustard, scarlet, plum, 'new']

# create rooms
ballroom = Symbol("Ballroom")
library = Symbol("Library")
kitchen = Symbol("Kitchen")
rooms = [ballroom, library, kitchen, 'new']

# create weapons 
knife = Symbol("Knife")
pistol = Symbol("Pistol")
wrench = Symbol("Wrench")
weapons = [knife, pistol, wrench, 'new']

symbols = people + rooms + weapons

# iterate and check knowledge
def check_knowledge(knowledge):
    for symbol in symbols:
        if symbol == "new":
            print("\n")
            continue 

        if model_check(knowledge, symbol):
            termcolor.cprint(f"{symbol}: YES", "green")
        elif not model_check(knowledge, Not(symbol)):
            print(f"{symbol}: MAYBE")

knowledge = And (
    Or (mustard, scarlet, plum),                # one of the person is killer
    Or (ballroom, library, kitchen),            # murder took place in one of the room 
    Or (knife, pistol, wrench),                 # murder weapon is one of the them
)

# it is not mustrard - you got to know this 
knowledge.add(Not(mustard))
# not in library 
knowledge.add(Not(library))
# not by pistol 
knowledge.add(Not(pistol)) 

# can be either scarlet, or in kitchen or wrench
knowledge.add(Or(
    Not(scarlet), Not(kitchen), Not(wrench)
))

# now you know its not plum either 
knowledge.add(Not(plum))

# and its not ballroom 
knowledge.add(Not(ballroom))

print(knowledge.formula())
check_knowledge(knowledge)