import math 
import colorama

def progress_bar(progress, total, color=colorama.Fore.YELLOW):
    percent = 100 * (progress / float(total))
    bar = '🁢' * int(percent) + "-"*(100-int(percent))
    print(color + f"\r|{bar}| {int(percent)}%", end="\r")

    if progress == total:
        print(colorama.Fore.GREEN +  f"\r|{bar}| {int(percent)}%", end="\r")

numbers = [x*5 for x in range(2000, 3000)]
results = [] 

progress_bar(0, len(numbers))

for i, x in enumerate(numbers):
    results.append(math.factorial(x))
    progress_bar(i+1, len(numbers))

print(colorama.Fore.RESET)