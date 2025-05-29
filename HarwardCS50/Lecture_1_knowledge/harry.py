from logic import * 

# these are symbols
rain = Symbol("rain")               # It is raining
hagrid = Symbol("Hagrid")           # Harry visited Hagrid 
dumbledore = Symbol("Dumbledore")   # Harry visited Dumbledore 
hermoine = Symbol("Hermoine")
sunny = Symbol("sunny")

# create knowledge base 
knowledge = And(
    Implication(Not(rain), hagrid),    # If it is not raining. Harry will visit Hagrid
    Or(hagrid, dumbledore),            # Harry will vist Hagrid or Dumbledore
    Not(And(hagrid, dumbledore)),      # but not both 
    dumbledore,                        # Harry visited Dumbledore
    Implication(Not(rain), sunny),     # if it is not raining its sunny day
    And(sunny, hermoine)               # Harry will visit Hermoine if it is sunny
)

print(knowledge.formula())

# check if it is raining 
print(model_check(knowledge, rain))             

# check if harry visited hagrid
print(model_check(knowledge, hagrid))

# check if harry visited hermoine and dumbledore
print(model_check(knowledge, And(hermoine, dumbledore)))

