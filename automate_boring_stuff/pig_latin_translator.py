""" Change the english text to Pig Latin """

message = input("Enter the English text you want to translate: ")
VOWELS = ('a', 'e', 'i', 'o', 'u')
pig_latin = [] 

for word in message.split():
    prefix_non_letter = "" 

    while len(word) > 0 and not word[0].isalpha():
        prefix_non_letter += word[0]
        word = word[1:]

    if len(word) == 0:
        pig_latin.append(prefix_non_letter)
        continue 

    # separate non-letters at the end of the word 
    suffix_non_letter = ""
    while not word[-1].isalpha():
        suffix_non_letter += word[-1]
        word = word[:-1]

    # check the case of the word 
    is_upper = word.isupper()
    is_title = word.istitle()
    
    word = word.lower()

    # Separate consonants from the start of the word 
    prefix_consonant = "" 
    while len(word) > 0 and not word[0] in VOWELS:
        prefix_consonant += word[0]
        word = word[1:]

    # add pig latin at the ending of the word
    if prefix_consonant != "":
        word += prefix_consonant + 'ay' 
    else:
        word += 'yay'

    # set the word back to its case
    if is_upper:
        word = word.upper()
    elif is_title:
        word = word.title()
    

    # add the word to pig lating list 
    pig_latin.append(prefix_consonant + word + suffix_non_letter)

print(" ".join(pig_latin))