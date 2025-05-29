def create_board(board):
    print("Current State of the board: \n\n")

    # iterate over all 9 cells of tic-tac-toe 
    for i in range(0, 9): 
        
        # create rows 
        if i > 0 and i % 3 == 0:
            print ("\n")

        # check if board values are populated as 0 
        if board[i] == 0:
            print("- ", end=" ")
        
        # check if board is populated by max player O
        if board[i] == 1:
            print("O ", end=" ")
        
        # check if board is populated by min player X
        if board[i] == -1:
            print("X ", end=" ")
    
    print("\n\n")


def get_user_1_turn(board):
    pos = input("Enter X's position from [1...9]: ")
    pos = int(pos)

    # check if the position is already filled 
    if board[pos-1] != 0:
        print ("Wrong Move. Try Again")
        return get_user_1_turn(board)
    
    # set the board position to X
    board[pos-1] = -1


def get_user_2_turn(board): 
    pos = input("Enter O's position from [1...9]: ")
    pos = int(pos)

    # check if the position is already filled 
    if board[pos-1] != 0:
        print ("Wrong Move. Try Again")
        return get_user_2_turn(board)
    
    # set the board position to X
    board[pos-1] = 1

def analyze_board(board):
    winning_values = [
        # horizonal win 
        [0, 1, 2], [3, 4, 5], [6, 7, 8], 
        # vertical win 
        [0, 3, 6], [1, 4, 7], [2, 5, 8], 
        # diagonal win 
        [0, 4, 8], [2, 4, 6]
    ]

    # iterate over and check the terminal condition
    for i in range(0, 8):
        if board[winning_values[i][0]] != 0 and board[winning_values[i][0]] == board[winning_values[i][1]] and board[winning_values[i][0]] == board[winning_values[i][2]]:
            return board[winning_values[i][2]]
    
    return 0

def minimax_algo(board, player):

    board_values = analyze_board(board)

    # if non winning state
    if board_values != 0:
        return board_values * player 

    # set position and value for next move
    pos = -1 
    value = -2  
    for i in range(0, 9):
        
        # check the board value is empty
        if board[i] == 0:

            # set the value of the current cell to player
            board[i] = player
            
            # calculate the score recurcively considering player as opponent 
            score = -minimax_algo(board, player*-1)

            # evaluate the score 
            if score > value:
                value = score 
                pos = i 
            
            # undo the move 
            board[i] = 0 

    # validate the score and return the score  
    if pos == -1:
        return 0
        
    
    return value 


# if player is computer 
def computer_player(board):

    pos = -1 
    value = -2 

    # iterate over all cells 
    for i in range(0, 9):

        # if cell is empty 
        if board[i] == 0:

            # set the value to maximizing 
            board[i] = 1

            # calculate score iteratively considering as opponent 
            score = -minimax_algo(board, -1)

            # undo the assignment 
            board[i] = 0

            # validate the score 
            if score > value:   
                value = score 
                pos = i
    
    # set the value based on score 
    board[pos] = 1
            

def main():
    choice=input("Enter 1 for single player, 2 for multiplayer: ")
    choice=int(choice)

    # initialize the board 
    board=[0,0,0,0,0,0,0,0,0]

    # if single player - i.e. playing against computer. Computer is maximizing player and opponent is minimizing player
    if choice == 1:
        print("Computer : O Vs. You : X")
        player= input("Enter to play 1(st) or 2(nd) :")
        player = int(player)

        # iterate over the cell 
        for i in range(0, 9):
            
            # if game is unfinished 
            if analyze_board(board) != 0:
                break 

            # validate if computer turn 
            if (i + player) % 2 == 0:
                computer_player(board)
            
            # Otherwise its player's turn
            else: 
                create_board(board)
                get_user_1_turn(board)

    # if multiplayer chosen 
    else: 
        for i in range(0, 9):
            if analyze_board(board) != 0:
                break 
            
            create_board(board)
            if i%2 == 0:
                get_user_1_turn(board)
            else:
                get_user_2_turn(board)
    
    # get the result 
    x = analyze_board(board)

    if x == 0:
        create_board(board)
        print ("Draw!")
    
    if x == -1:
        create_board(board)
        print ("X Won! ")

    if x == 1: 
        create_board(board)
        print("O Won!")

if __name__ == "__main__":
    main()