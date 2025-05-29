TEXT = {
    "agree" : "Yes I agree. Sounds fine to me", 
    "busy"  : "Sorry, can we do this later next week", 
    "upsell": "Plase consider making monthly donations"
}

import sys
import pyperclip 

keyphrase = input("Enter the keyphrase: ")
if keyphrase in TEXT: 
    pyperclip.copy(TEXT[keyphrase])
    print (f"Text for {keyphrase} is copied to clipboard")
else: 
    print(f"No text found for {keyphrase}")