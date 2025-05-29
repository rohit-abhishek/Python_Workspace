""" Validate if chess board is valid or not """

chess_board = {
    "1h" : "bking",
    "6c" : "wqueen",
    "2g" : "bbishop",
    "5h" : "bqueen",
    "3e" : "wking"
}

def board_is_valid(board):

    valid_pieces = {} 
    piece_sum = 0 

    for k, v in board.items(): 

        # validate position is within 1a and 8h
        if int(k[0:1]) not in range(1,9) and ord(k[1:2]) not in range(ord('a'), ord('h')+1): 
            print ("Invalid Position")
            return False 

        # default the dictionary separating pieces color and types
        # create a {"b" : {"king" : 0, "queen" : 0, ...}}
        valid_pieces.setdefault(v[0:1], {})
        valid_pieces[v[0:1]].setdefault("king", 0)
        valid_pieces[v[0:1]].setdefault("queen", 0)
        valid_pieces[v[0:1]].setdefault("bishop", 0)
        valid_pieces[v[0:1]].setdefault("rook", 0)
        valid_pieces[v[0:1]].setdefault("knight", 0)
        valid_pieces[v[0:1]].setdefault("pawn", 0)
        valid_pieces[v[0:1]].setdefault(v[1:], 0)
        valid_pieces[v[0:1]][v[1:]] += 1

    # check if black and white are present in the board 
    if 'b' not in valid_pieces.keys() and 'w' not in valid_pieces.keys():
        print("Invalid Color")
        return False 
    
    # iterate over valid_pieces
    for k, v in valid_pieces.items():
        
        # if total number of pieces are more than 16 for each color return error 
        if sum(list(v.values())) > 16: 
            print ("Invalid Number of pieces")
            return False 
        
        # validate the pieces combinations that are present for each color 
        if v['king'] > 1 or v['queen'] > 1 or v['bishop'] > 2 or v['rook'] > 2 or v['knight'] > 2 or v['pawn'] > 8:
            print ("Invalid Combination")
            return False 
        
        # validate if any invalid piece included
        for a, b in v.items():
            if a not in ("king", "queen", "bishop", "rook", "knight", "pawn"): 
                print ("Invalid Piece")
                return False 

    print(valid_pieces)
    
    return True
    

a = board_is_valid(chess_board)
print (a)