# read the shakespear.txt file understand the languange modelling 
import markovify
import sys

# read the file
with open("shakespeare.txt", 'r') as f:
    text = f.read()

# Train model
text_model = markovify.Text(text)

# Generate sentences
print()
for i in range(5):
    print(text_model.make_sentence())
    print()