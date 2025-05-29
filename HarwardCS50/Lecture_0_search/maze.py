import sys

# create a Node class for node object to instantiate 
class Node():
    def __init__(self, state, parent, action):
        self.state = state
        self.parent = parent
        self.action = action 

# Frontier defined for Stack - LIFO (DFS Seach algo)
class StackFrontier():
    def __init__(self):
        self.frontier = [] 
    
    def add(self, node):
        self.frontier.append(node)

    def contains_state(self, state):
        return any(node.state == state for node in self.frontier)

    def isempty(self):
        return len(self.frontier) == 0
    
    def remove(self): 
        if self.isempty():
            raise Exception("empty frontier")
        else:
            node = self.frontier[-1]
            self.frontier = self.frontier[:-1]
            return node

# similarly create Queue frontier - FIFO (BFS search algo) overriding remove method
class QueueFrontier(StackFrontier):
    def remove(self):
        if self.isempty():
            raise Exception("empty frontier")
        else: 
            node = self.frontier[0]
            self.frontier = self.frontier[1:]
            return node
        

class Maze():
    def __init__(self, filename):
        with open(filename, 'r') as fp:
            contents = fp.read()

        # validate start and goal position 
        if contents.count("A") != 1:
            raise Exception("Maze should have exactly one start point")
        if contents.count("B") != 1:
            raise Exception("Maze should have exactly one goal")
        
        # get the maze height and width 
        contents = contents.splitlines()
        self.height = len(contents)
        self.width = max(len(line) for line in contents)

        # get wall details 
        self.walls = [] 
        for i in range(self.height):
            row = [] 
            for j in range(self.width):
                try:
                    # if value is starting point 
                    if contents[i][j] == "A":
                        self.start=(i, j)
                        row.append(False)
                    # if value is goal point 
                    elif contents[i][j] == "B":
                        self.goal=(i, j)
                        row.append(False)
                    # if value is path (not wall)
                    elif contents[i][j] == " ": 
                        row.append(False)
                    
                    # if value is wall 
                    else:
                        row.append(True)
                except IndexError:
                    row.append(False)
            
            # store the wall information in Boolean values to list
            self.walls.append(row)

        # solution is None for now 
        self.solution = None 
    
    # print the solution
    def print(self): 

        # check for solution value 
        solution = self.solution[1] if self.solution is not None else None 
        print ()

        # iterate over walls 
        for i, row in enumerate(self.walls):
            for j, col in enumerate(row):
                if col:
                    print("█", end="")
                elif (i,j) == self.start:
                    print ("A", end="")
                elif (i,j) == self.goal:
                    print ("B", end="")
                elif solution is not None and (i, j) in solution:
                    print("*", end="")
                else: 
                    print (" ", end="")
            print()
        print ()

    # get the neighbor details 
    def neighbors(self, state):
        row, col = state

        candidates = [
            ("up", (row-1, col)),
            ("down", (row+1, col)), 
            ("left", (row, col-1)),
            ("right", (row, col+1))
        ]

        result = []

        # check if action to move yield path 
        for action, (r,c) in candidates:
            if 0 <= r < self.height and 0 <= c < self.width and not self.walls[r][c]:
                result.append((action, (r,c)))

        return result
    

    def solve(self):
        
        # keep track of number of state explored 
        self.num_explored = 0 

        # initialize the frontier to start position 
        start = Node(state=self.start, parent=None, action=None)
        
        # use stack frontiner - LIFO 
        # frontier = StackFrontier()

        # use queue frontier - FIFO 
        frontier = QueueFrontier()

        # add start state to frontier
        frontier.add(start)

        # initialize empty explored set 
        self.explored = set()

        # keep looping until solution is found 
        while True:

            # if nothing in frontier, exit saying no solution found 
            if frontier.isempty():
                raise Exception("No Solution")
            
            # get the node from the frontier 
            node = frontier.remove()
            self.num_explored+=1

            # if node is the goal - return solution 
            if node.state == self.goal:
                actions = []
                cells = []

                while node.parent is not None:
                    actions.append(node.action)
                    cells.append(node.state)
                    node = node.parent
                
                actions.reverse()
                cells.reverse()

                self.solution = (actions, cells)
                return
            
            # mark node as explored 
            self.explored.add(node.state)

            # add neighbors to frontier
            for action, state in self.neighbors(node.state):
                if not frontier.contains_state(state) and state not in self.explored:
                    child = Node(state=state, parent=node, action=action)
                    frontier.add(child)

    
    # create image output 
    def create_image(self, filename, show_solution=True, show_explored=True):
        from PIL import Image, ImageDraw

        cell_size = 50 
        cell_border = 2

        # create blank canvas 
        img = Image.new(
            "RGBA", (self.width * cell_size, self.height * cell_size), 
            "black"
        )

        # draw the image
        draw = ImageDraw.Draw(img)

        # put the solution 
        solution = self.solution[1] if self.solution is not None else None 

        for i, row in enumerate(self.walls):
            for j, col in enumerate(row):
                if col:
                    fill = (40, 40, 40)
                
                # start 
                elif (i, j) == self.start:
                    fill = (255, 0, 0)

                # goal 
                elif (i, j) == self.goal:
                    fill = (0, 171, 28)
                
                # solution 
                elif solution is not None and show_solution and (i, j) in solution:
                    fill = (220, 235, 113)

                # explored 
                elif solution is not None and show_explored and (i, j) in self.explored:
                    fill = (212, 97, 85)

                else: 
                    fill = (237, 240, 252)

                # draw cell 
                draw.rectangle(
                    ([(j* cell_size + cell_border, i*cell_size+cell_border), 
                      ((j+1) * cell_size - cell_border, (i+1)*cell_size-cell_border)]),
                      fill=fill
                )
        img.save(filename)

import os

if len(sys.argv) != 2:
    sys.exit("Usage: python maze.py maze.txt")

m = Maze(sys.argv[1])
print("Maze:")
m.print()
print("Solving...")
m.solve()
print("States Explored:", m.num_explored)
print("Solution:")
m.print()
m.create_image(os.path.join('data/Lecture_0_search', os.path.basename(sys.argv[1])+'.png'), show_explored=True)