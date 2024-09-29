import 'package:flutter/material.dart';
import 'package:game_app/games/chess_game/components/piece.dart';
import 'package:game_app/games/chess_game/components/square.dart';
import 'package:game_app/games/chess_game/helper/helper_methods.dart';
import 'package:game_app/games/chess_game/values/colors.dart';
import 'package:game_app/pages/home_page.dart';
import 'components/dead_piece.dart';

class GameBoard extends StatefulWidget {
  const GameBoard({super.key});

  @override
  State<GameBoard> createState() => _GameBoardState();
}

class _GameBoardState extends State<GameBoard> {
  //A 2-dimensional list represending the chesboard
//with each position possibly containing a chess piece
  late List<List<chesspiece?>> board;

  //the currently select on the chess board,
  //if no piece is selected,  this is null
  chesspiece? selectedpiece;

  //the row index of the selected piece
  //default value -1 indicated no piece is currently selected
  int selectedRow = -1;

  //the col index of the selected piece
  //default value -1 indicated no piece is currently selected
  int selectedcol = -1;

  //a list of valid moves for the currently selected piece
  //each move is represented as a list with 2 elements: row and col
  List<List<int>> validmoves = [];

  //a list of white pieces that taken by the black player
  List<chesspiece> whitepiecetaken = [];
  //a list of black pieces that taken by the white player
  List<chesspiece> blackpiecetaken = [];

  //a booleon to indicate whose turn it is
  bool iswhiteturn = true;

  //initial position of king(keep track of this to make it easier later to see if king is in change)
  List<int> whitekingposition = [7, 3];
  List<int> blackkingposition = [0, 4];
  bool checkstatus = false;

  @override
  void initState() {
    super.initState();
    _initializedBoard();
  }

//initialize board
  void _initializedBoard() {
    //initialize the board with nulls, means no pieces in those position
    List<List<chesspiece?>> newboard =
        List.generate(8, (index) => List.generate(8, (index) => null));

    //place pawns
    for (int i = 0; i < 8; i++) {
      newboard[1][i] = chesspiece(
          type: chesspieceType.pawn,
          iswhite: false,
          imagepath: "assets/images/pawn1.png");

      newboard[6][i] = chesspiece(
          type: chesspieceType.pawn,
          iswhite: true,
          imagepath: "assets/images/pawn1.png");
    }

    //place rooks
    newboard[0][0] = chesspiece(
        type: chesspieceType.rook,
        iswhite: false,
        imagepath: "assets/images/rook.png");

    newboard[0][7] = chesspiece(
        type: chesspieceType.rook,
        iswhite: false,
        imagepath: "assets/images/rook.png");

    newboard[7][0] = chesspiece(
        type: chesspieceType.rook,
        iswhite: true,
        imagepath: "assets/images/rook.png");
    newboard[7][7] = chesspiece(
        type: chesspieceType.rook,
        iswhite: true,
        imagepath: "assets/images/rook.png");

    //place knights
    newboard[0][1] = chesspiece(
        type: chesspieceType.knight,
        iswhite: false,
        imagepath: "assets/images/knight.png");

    newboard[0][6] = chesspiece(
        type: chesspieceType.knight,
        iswhite: false,
        imagepath: "assets/images/knight.png");

    newboard[7][1] = chesspiece(
        type: chesspieceType.knight,
        iswhite: true,
        imagepath: "assets/images/knight.png");

    newboard[7][6] = chesspiece(
        type: chesspieceType.knight,
        iswhite: true,
        imagepath: "assets/images/knight.png");

    //place bishops
    newboard[0][2] = chesspiece(
        type: chesspieceType.bishop,
        iswhite: false,
        imagepath: "assets/images/bishop.png");

    newboard[0][5] = chesspiece(
        type: chesspieceType.bishop,
        iswhite: false,
        imagepath: "assets/images/bishop.png");

    newboard[7][2] = chesspiece(
        type: chesspieceType.bishop,
        iswhite: true,
        imagepath: "assets/images/bishop.png");

    newboard[7][5] = chesspiece(
        type: chesspieceType.bishop,
        iswhite: true,
        imagepath: "assets/images/bishop.png");

    //place queens
    newboard[0][3] = chesspiece(
        type: chesspieceType.queen,
        iswhite: false,
        imagepath: "assets/images/queen.png");

    newboard[7][4] = chesspiece(
        type: chesspieceType.queen,
        iswhite: true,
        imagepath: "assets/images/queen.png");

    //place kings
    newboard[0][4] = chesspiece(
        type: chesspieceType.king,
        iswhite: false,
        imagepath: "assets/images/king.png");

    newboard[7][3] = chesspiece(
        type: chesspieceType.king,
        iswhite: true,
        imagepath: "assets/images/king.png");
    board = newboard;
  }

//user selected piece
  void pieceselected(int row, int col) {
    setState(() {
      //no piece selected yet, this is the first delection
      if (selectedpiece == null && board[row][col] != null) {
        if (board[row][col]!.iswhite == iswhiteturn) {
          selectedpiece = board[row][col];
          selectedRow = row;
          selectedcol = col;
        }
      }

      //there is a piece already selected,but user can select another one of their pieces
      else if (board[row][col] != null &&
          board[row][col]!.iswhite == selectedpiece!.iswhite) {
        selectedpiece = board[row][col];
        selectedRow = row;
        selectedcol = col;
      }

      //if there is a piece selected and user taps on a square that is a valid move, move there
      else if (selectedpiece != null &&
          validmoves.any((element) => element[0] == row && element[1] == col)) {
        movepiece(row, col);
      }

      //if piece is selected calculated valid moves
      validmoves = calculateRealValidMoves(
          selectedRow, selectedcol, selectedpiece, true);
    });
  }

  //calculate raw valid moves
  List<List<int>> calculateRawValidmoves(int row, int col, chesspiece? piece) {
    List<List<int>> candidateMoves = [];
    if (piece == null) {
      return [];
    }
    //different direction based on their color
    int direction = piece.iswhite ? -1 : 1;

    switch (piece.type) {
      case chesspieceType.pawn:
        //pawn can move forward if the square is not occupaid
        if (isinboard(row + direction, col) &&
            board[row + direction][col] == null) {
          candidateMoves.add([row + direction, col]);
        }

        //pawns can move 2 Squars forward if they are at the initial position
        if ((row == 1 && !piece.iswhite) || (row == 6 && piece.iswhite)) {
          if (isinboard(row + 2 * direction, col) &&
              board[row + 2 * direction][col] == null) {
            candidateMoves.add([row + 2 * direction, col]);
          }
        }

        //pawn can kill digonally
        if (isinboard(row + direction, col - 1) &&
            board[row + direction][col - 1] != null &&
            board[row + direction][col - 1]!.iswhite != piece.iswhite) {
          candidateMoves.add([row + direction, col - 1]);
        }
        if (isinboard(row + direction, col + 1) &&
            board[row + direction][col + 1] != null &&
            board[row + direction][col + 1]!.iswhite != piece.iswhite) {
          candidateMoves.add([row + direction, col + 1]);
        }
        break;
      case chesspieceType.rook:
        //horizondal and vertical direction
        var directions = [
          [-1, 0], //up
          [1, 0], //down
          [0, -1], //left
          [0, 1] //right
        ];

        for (var direction in directions) {
          var i = 1;
          while (true) {
            var newrow = row + i * direction[0];
            var newcol = col + i * direction[1];
            if (!isinboard(newrow, newcol)) {
              break;
            }
            if (board[newrow][newcol] != null) {
              if (board[newrow][newcol]!.iswhite != piece.iswhite) {
                candidateMoves.add([newrow, newcol]); //kill
              }
              break; //blocked
            }
            candidateMoves.add([newrow, newcol]);
            i++;
          }
        }
        break;
      case chesspieceType.knight:
        //all eight possible L shape the knight can move
        var knightMoves = [
          [-2, -1], //up 2 left 1
          [-2, 1], //up 2 right 1
          [-1, -2], //up 1 left 2
          [-1, 2], //up 1 right 2
          [1, -2], //down 1 left 2
          [1, 2], //down 1 right 2
          [2, -1], //down 2 left 1
          [2, 1], //down 2 right 1
        ];

        for (var move in knightMoves) {
          var newrow = row + move[0];
          var newcol = col + move[1];
          if (!isinboard(newrow, newcol)) {
            continue;
          }
          if (board[newrow][newcol] != null) {
            if (board[newrow][newcol]!.iswhite != piece.iswhite) {
              candidateMoves.add([newrow, newcol]); //capture
            }
            continue;
          }
          candidateMoves.add([newrow, newcol]);
        }
        break;
      case chesspieceType.bishop:
        //diagonal directions
        var directions = [
          [-1, -1], //up left
          [-1, 1], //up right
          [1, -1], //down left
          [1, 1], //down right
        ];

        for (var direction in directions) {
          var i = 1;
          while (true) {
            var newrow = row + i * direction[0];
            var newcol = col + i * direction[1];
            if (!isinboard(newrow, newcol)) {
              break;
            }
            if (board[newrow][newcol] != null) {
              if (board[newrow][newcol]!.iswhite != piece.iswhite) {
                candidateMoves.add([newrow, newcol]); //capture
              }
              break; //block
            }
            candidateMoves.add([newrow, newcol]);
            i++;
          }
        }
        break;
      case chesspieceType.queen:
        //all 8 directions:up down left right and 4 diagonals
        var directions = [
          [-1, 0], //up
          [1, 0], //down
          [0, -1], //left
          [0, 1], //right
          [-1, -1], //up left
          [-1, 1], //up right
          [1, -1], //down left
          [1, 1], //down right
        ];

        for (var direction in directions) {
          var i = 1;
          while (true) {
            var newrow = row + i * direction[0];
            var newcol = col + i * direction[1];
            if (!isinboard(newrow, newcol)) {
              break;
            }
            if (board[newrow][newcol] != null) {
              if (board[newrow][newcol]!.iswhite != piece.iswhite) {
                candidateMoves.add([newrow, newcol]); //captured
              }
              break;
            }
            candidateMoves.add([newrow, newcol]);
            i++;
          }
        }
        break;
      case chesspieceType.king:
        //all 8
        var directions = [
          [-1, 0], //up
          [1, 0], //down
          [0, -1], //left
          [0, 1], //right
          [-1, -1], //up left
          [-1, 1], //up right
          [1, -1], //down left
          [1, 1], //down right
        ];

        for (var direction in directions) {
          var newrow = row + direction[0];
          var newcol = col + direction[1];
          if (!isinboard(newrow, newcol)) {
            continue;
          }
          if (board[newrow][newcol] != null) {
            if (board[newrow][newcol]!.iswhite != piece.iswhite) {
              candidateMoves.add([newrow, newcol]); //capture
            }
            continue; //blocked
          }
          candidateMoves.add([newrow, newcol]);
        }

        break;
      default:
    }
    return candidateMoves;
  }

//calculate the realvalid moves
  List<List<int>> calculateRealValidMoves(
      int row, int col, chesspiece? piece, bool checksimulation) {
    List<List<int>> realvalidmoves = [];
    List<List<int>> candidatemoves = calculateRawValidmoves(row, col, piece);

    //after generating all candidate moves, filter out any that would resuld in a check
    if (checksimulation) {
      for (var move in candidatemoves) {
        int endrow = move[0];
        int endcol = move[1];

        //this will simulate the future move to see if it's safe
        if (simulateMoveInsafe(piece!, row, col, endrow, endcol)) {
          realvalidmoves.add(move);
        }
      }
    } else {
      realvalidmoves = candidatemoves;
    }
    return realvalidmoves;
  }

//move piece
  void movepiece(int newrow, int newcol) {
    //if the new spot has enemy piece
    if (board[newrow][newcol] != null) {
      //add the captured piece to the appropriate list
      var capturedpiece = board[newrow][newcol];
      if (capturedpiece!.iswhite) {
        whitepiecetaken.add(capturedpiece);
      } else {
        blackpiecetaken.add(capturedpiece);
      }
    }
    //check if the piece being moved in a king
    if (selectedpiece!.type == chesspieceType.king) {
      //update the appropriate king position
      if (selectedpiece!.iswhite) {
        whitekingposition = [newrow, newcol];
      } else {
        blackkingposition = [newrow, newcol];
      }
    }

    //move the piece and clear the old spot
    board[newrow][newcol] = selectedpiece;
    board[selectedRow][selectedcol] = null;

    //see if any kings are under attack
    if (iskingIncheck(!iswhiteturn)) {
      checkstatus = true;
    } else {
      checkstatus = false;
    }

    //clear selection
    setState(() {
      selectedpiece = null;
      selectedRow = -1;
      selectedcol = -1;
      validmoves = [];
    });

    //check if it's check mate
    if (isCheckMate(!iswhiteturn)) {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: const Text(("CHECK MATE")),
                actions: [
                  //play again button
                  TextButton(
                      onPressed: resetgame, child: const Text("play Again")),
                ],
              ));
    }

    //change turns
    iswhiteturn = !iswhiteturn;
  }

  //is king in check?
  bool iskingIncheck(bool iswhiteking) {
    //get the position of the king
    List<int> kingposition =
        iswhiteking ? whitekingposition : blackkingposition;

    //check if any enemy piece can attack the king
    for (int i = 0; i < 8; i++) {
      for (int j = 0; j < 8; j++) {
        //skip empty squares and pieces of the same color as the king
        if (board[i][j] == null || board[i][j]!.iswhite == iswhiteking) {
          continue;
        }

        List<List<int>> pieceValidMoves =
            calculateRealValidMoves(i, j, board[i][j], false);

        //check if the king's position is in the piece valid moves
        if (pieceValidMoves.any((move) =>
            move[0] == kingposition[0] && move[1] == kingposition[1])) {
          return true;
        }
      }
    }
    return false;
  }

//simulate a future move to see if it's safe(does't put your king under attack!)
  bool simulateMoveInsafe(
      chesspiece piece, int startrow, int startcol, int endrow, int endcol) {
    //save the current board state
    chesspiece? originalDestinationpiece = board[endrow][endcol];

    //if the piece is the king, save it's current position and update to the new one
    List<int>? originalkingposition;
    if (piece.type == chesspieceType.king) {
      originalkingposition =
          piece.iswhite ? whitekingposition : blackkingposition;

      //update the king position
      if (piece.iswhite) {
        whitekingposition = [endrow, endcol];
      } else {
        blackkingposition = [endrow, endcol];
      }
    }

    //simulate the move
    board[endrow][endcol] = piece;
    board[startrow][startcol] = null;

    //check if our own king is under attack
    bool kingIncheck = iskingIncheck(piece.iswhite);

    //restore board to original state
    board[startrow][startcol] = piece;
    board[endrow][endcol] = originalDestinationpiece;

    //if the piece was the king, restore the original position
    if (piece.type == chesspieceType.king) {
      if (piece.iswhite) {
        whitekingposition = originalkingposition!;
      } else {
        blackkingposition = originalkingposition!;
      }
    }
    //if king is in check=true, means it's not a safe move, safe move=false
    return !kingIncheck;
  }

//is it check mate?

  bool isCheckMate(bool isWhiteKing) {
    //if the king is not in check, then it's not checkmate
    if (!iskingIncheck(isWhiteKing)) {
      return false;
    }

    //if there is at least one legal move for any of the player's pieces,then it's not checkmate
    for (int i = 0; i < 8; i++) {
      for (int j = 0; j < 8; j++) {
        //skip empty squares and pieces of the other color
        if (board[i][j] == null || board[i][j]!.iswhite != isWhiteKing) {
          continue;
        }
        List<List<int>> pieceValidmoves =
            calculateRealValidMoves(i, j, board[i][j], true);
        //if this piece has any valid moves,then it's not check mate

        if (pieceValidmoves.isNotEmpty) {
          return false;
        }
      }
    }

    //if none of the above conditions are met, then there are no legal moves left to make
    //it's check mate!
    return true;
  }

  //reset to new game
  void resetgame() {
    Navigator.pop(context);
    _initializedBoard();
    checkstatus = false;
    whitepiecetaken.clear();
    blackpiecetaken.clear();
    whitekingposition = [7, 3];
    blackkingposition = [0, 4];
    iswhiteturn = true;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: foregroundcolor,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 40, right: 350, bottom: 0),
            child: IconButton(
              onPressed: () {
                Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (context) => Home()));
              },
              icon: Icon(
                Icons.arrow_back_ios_new_rounded,
                color: Colors.black,
              ),
              color: Colors.black,
            ),
          ),
          //white piece taken
          Expanded(
              child: GridView.builder(
            itemCount: whitepiecetaken.length,
            gridDelegate:
                SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 8),
            itemBuilder: (context, index) => Deadpiece(
              imagepath: whitepiecetaken[index].imagepath,
              iswhite: true,
            ),
          )),

          //Game status
          Text(checkstatus ? "CHECK!" : ""),

          //chess board
          Expanded(
            flex: 5,
            child: GridView.builder(
                itemCount: 8 * 8,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 8),
                itemBuilder: (context, index) {
                  int row = index ~/ 8;
                  int col = index % 8;

                  //check if this square is selected
                  bool isselected = selectedRow == row && selectedcol == col;

                  //check if this square is valid move
                  bool isvalidmove = false;
                  for (var position in validmoves) {
                    //compare row and col
                    if (position[0] == row && position[1] == col) {
                      isvalidmove = true;
                    }
                  }

                  return Square(
                    iswhite: iswhite(index),
                    piece: board[row][col],
                    isselected: isselected,
                    isvalidmove: isvalidmove,
                    onTap: () => pieceselected(row, col),
                  );
                }),
          ),

          //black piece taken
          Expanded(
              child: GridView.builder(
            itemCount: blackpiecetaken.length,
            gridDelegate:
                SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 8),
            itemBuilder: (context, index) => Deadpiece(
              imagepath: blackpiecetaken[index].imagepath,
              iswhite: false,
            ),
          )),
        ],
      ),
    );
  }
}
