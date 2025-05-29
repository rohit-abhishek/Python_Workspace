""" Move your cursor at regular interval for not getting locked """

import sys
import time
from datetime import datetime 
import pyautogui

pyautogui.FAILSAFE = False 
num_min = None 

# set number of movements 
if ((len(sys.argv) < 2) or sys.argv[1].isalpha() or int(sys.argv[1]) < 1):
    num_min = 3 
else:
    num_min = int(sys.argv[1])

# loop 
while True:
    x = 0 

    # sleep for 90 seconds 
    while (x < num_min):
        time.sleep(30)
        x += 1 

    # move the cursor down 
    for i in range(0, 40): 
        pyautogui.moveTo(1, i*4)
    
    # reset the position
    pyautogui.moveTo(1, 1)

    for i in range(0, 10):
        pyautogui.press("shift")
    
    print(f"Movement made at {datetime.now().time()}")