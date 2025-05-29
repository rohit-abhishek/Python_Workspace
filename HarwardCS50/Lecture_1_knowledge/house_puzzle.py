from logic import * 

# Put the names of people 
people = ["Gilderoy", "Pomona", "Minerva", "Horace"]

# Put the houses 
houses = ["Gryffindor", "Hufflepuff", "Ravenclaw", "Slytherin"]

symbols = [] 
knowledge = And()

# create a person to house combination 
for person in people:
    for house in houses:
        symbols.append(Symbol(f"{person}-{house}"))

# each person belongs to a house 
for person in people:
    knowledge.add(Or(
        Symbol(f"{person}-Gryffindor"),
        Symbol(f"{person}-Hufflepuff"),
        Symbol(f"{person}-Ravenclaw"),
        Symbol(f"{person}-Slytherin"),
        )
    )

# only one house per person 
for person in people:
    for h1 in houses:
        for h2 in houses:
            if h1 != h2:
                knowledge.add(
                    Implication(Symbol(f"{person}-{h1}"), Not(Symbol(f"{person}-{h2}")))
                )

# only one person per house 
for house in houses: 
    for p1 in people:
        for p2 in people:
            if p1 != p2:
                knowledge.add(
                    Implication(Symbol(f"{p1}-{house}"), Not(Symbol(f"{p2}-{house}")))
                )

# add additional knowledge collected 

# Gilderoy is either in Gryffindor or Ravenclaw
knowledge.add(
    Or(Symbol('Gilderoy-Gryffindor'), Symbol('Gilderoy-Ravenclaw'))
)

# Pomana is not Slytherin
knowledge.add(
    Not(Symbol("Pomona-Slytherin"))
)

# Minerva is in Gryffindor 
knowledge.add(
    Symbol("Minerva-Gryffindor")
)

# iterate and check which person belogns to which house
for symbol in symbols:
    if model_check(knowledge, symbol):
        print(symbol)