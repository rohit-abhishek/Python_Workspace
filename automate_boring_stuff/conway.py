""" Generate random patterns using # on console """

import random, time, copy

WIDTH = 60 
HEIGHT = 20 

next_cell = [] 

# iterate over width 
for i in range (0, WIDTH):
    column = [] 

    for u in range(HEIGHT):
        if random.randint(0, 1) == 0:
            column.append("#")
        else:
            column.append(" ")

    next_cell.append(column)

# Iterate over main loop 
while True: 
    print ("\n\n\n\n\n\n")

    current_cells = copy.deepcopy(next_cell)

    # print the current cells on the screen 
    for y in range(HEIGHT):
        for x in range(WIDTH):
            print (current_cells[x][y], end="")
        print()
    
    # get neighbors coordinates 
    for x in range(WIDTH):
        for y in range(HEIGHT):

            left_cord = (x-1) % WIDTH
            right_cord = (x+1) % WIDTH

            above_cord = (y-1) % HEIGHT
            below_cord = (y+1) % HEIGHT

            # count the number of living coordinate 
            num_of_neighbors = 0
            if current_cells[left_cord][above_cord] == "#":
                num_of_neighbors += 1
            
            if current_cells[x][above_cord] == "#":
                num_of_neighbors += 1
            
            if current_cells[right_cord][above_cord] == "#":
                num_of_neighbors += 1

            if current_cells[left_cord][y] == "#":
                num_of_neighbors += 1
            
            if current_cells[right_cord][y] == "#":
                num_of_neighbors += 1
            
            if current_cells[x][below_cord] == "#": 
                num_of_neighbors += 1

            if current_cells[right_cord][below_cord] == "#":
                num_of_neighbors += 1

            # remove the cells if number of neighbors are more than 2 or 3
            if current_cells[x][y] == "#" and (num_of_neighbors in (2,3)):
                next_cell[x][y] = "#" 
            elif current_cells[x][y] == " " and num_of_neighbors == 3: 
                next_cell[x][y] = "#"
            else:
                next_cell[x][y] = " "
    
    time.sleep(0.5)