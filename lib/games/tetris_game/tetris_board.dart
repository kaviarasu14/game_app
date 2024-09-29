import 'dart:async';
import 'dart:ffi';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:game_app/games/tetris_game/piece.dart';
import 'package:game_app/games/tetris_game/pixel.dart';
import 'package:game_app/games/tetris_game/values.dart';
import 'package:game_app/pages/home_page.dart';

class tetris extends StatelessWidget {
  const tetris({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: TetrisBoard(),
    );
  }
}

/*

Game board
this a 2*2 grid with null representing an empty space.
A non empty space will have the color to represet the landed piece

 */

//create game board
List<List<Tetromino?>> gameboard =
    List.generate(collength, (i) => List.generate(rowlength, (j) => null));

class TetrisBoard extends StatefulWidget {
  const TetrisBoard({super.key});

  @override
  State<TetrisBoard> createState() => _TetrisBoardState();
}

class _TetrisBoardState extends State<TetrisBoard> {
  //current tetris piece
  Piece currentpiece = Piece(type: Tetromino.L);

  //current score
  int currentscore = 0;

  //gane over status
  bool gameOver = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    //start game when app starts
    startgame();
  }

  void startgame() {
    currentpiece.initializepiece();

    //frame refresh rate
    Duration framerate = const Duration(milliseconds: 800);
    gameloop(framerate);
  }

  void gameloop(Duration framerate) {
    Timer.periodic(framerate, (timer) {
      setState(() {
        //clear lines
        clearlines();

        //check landing
        checklanding();

        //check if game is over
        if (gameOver == true) {
          timer.cancel();
          showgameoverdialog();
        }

        //move current piece down
        currentpiece.movepiece(Direction.down);
      });
    });
  }

  //game over dialog
  void showgameoverdialog() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text("Ammbututhe"),
              content: Text("Your score is: $currentscore"),
              actions: [
                TextButton(
                    onPressed: () {
                      //reset the game
                      resetgame();

                      Navigator.pop(context);
                    },
                    child: Text("Play Again"))
              ],
            ));
  }

  void resetgame() {
    // clear the game board
    gameboard =
        List.generate(collength, (i) => List.generate(rowlength, (j) => null));

    //new game
    gameOver = false;
    currentscore = 0;

    //create new piece
    createNewpiece();

    //start game again
    startgame();
  }

  //check for collision in a future position
  //return true-> there is a collision
  //return false-> there is a no collision
  bool checkcollision(Direction direction) {
    //loop through each position of the current piece
    for (int i = 0; i < currentpiece.position.length; i++) {
      //calculate the row and col of the current position
      int row = (currentpiece.position[i] / rowlength).floor();
      int col = currentpiece.position[i] % rowlength;

      //adjust the row and col based on the position
      if (direction == Direction.left) {
        col -= 1;
      } else if (direction == Direction.right) {
        col += 1;
      } else if (direction == Direction.down) {
        row += 1;
      }

      //check if the piece is out of bounds(either too low or too right or too left)
      if (row >= collength || col < 0 || col >= rowlength) {
        return true;
      }
      if (row >= 0 && gameboard[row][col] != null) {
        // Assuming 0 means empty
        return true;
      }
    }

    //if no collisions are detected,return false
    return false;
  }

  void checklanding() {
    //if going down is occupied
    if (checkcollision(Direction.down)) {
      //mark position as occupied on the game board
      for (int i = 0; i < currentpiece.position.length; i++) {
        int row = (currentpiece.position[i] / rowlength).floor();
        int col = currentpiece.position[i] % rowlength;
        if (row >= 0 && col >= 0) {
          gameboard[row][col] = currentpiece.type;
        }
      }
      //once landed,created the next piece
      createNewpiece();
    }
  }

  void createNewpiece() {
    //create a random object to generate random tetromino types
    Random rand = Random();

    //create a new piece with random type
    Tetromino randomType =
        Tetromino.values[rand.nextInt(Tetromino.values.length)];
    currentpiece = Piece(type: randomType);
    currentpiece.initializepiece();

    /*
   Since our game over condition is if there is a piece at the top level,
   you want to check if the gane is over when you create a new piece instead of
   checking every frame, because new pieces are allowed to go through the top level 
   but if there is already a piece in the top level when the new piece is created, 
   then game is over

     */

    if (isgameover()) {
      gameOver = true;
    }
  }

  //move left
  void moveleft() {
    //make sure the move is valid before moving there
    if (!checkcollision(Direction.left)) {
      setState(() {
        currentpiece.movepiece(Direction.left);
      });
    }
  }

  //rotate piece
  void rotatepiece() {
    setState(() {
      currentpiece.rotatepiece();
    });
  }

  //move right
  void moveright() {
    if (!checkcollision(Direction.right)) {
      setState(() {
        currentpiece.movepiece(Direction.right);
      });
    }
  }

  //clear lines
  void clearlines() {
    //step-1: loop through each row of the game board from bottom to top
    for (int row = collength - 1; row >= 0; row--) {
      //step-2:Initialize a variable to track if the row is full
      bool rowisfull = true;

      //step-3:check if row is full(all columns in the row are filled with pieces)
      for (int col = 0; col < rowlength; col++) {
        //if there's in a empty column, set row is full to false and break the loop
        if (gameboard[row][col] == null) {
          rowisfull = false;
          break;
        }
      }

      //step-4:if the row is full,clear the row and shift rows down
      if (rowisfull) {
        //step-5:move all rows above the cleared row down by one position
        for (int r = row; r > 0; r--) {
          //copy the above row to the current row
          gameboard[r] = List.from(gameboard[r - 1]);
        }

        //step-6:set the top row to empty
        gameboard[0] = List.generate(row, (index) => null);

        //step-7:increase the score!
        currentscore++;
      }
    }
  }

  //game over
  bool isgameover() {
    //check if any column in the top row are filled
    for (int col = 0; col < rowlength; col++) {
      if (gameboard[0][col] != null) {
        return true;
      }
    }
    //if the top row is empty, the game is not over
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 30, right: 350),
            child: IconButton(
                onPressed: () {
                  Navigator.pushReplacement(
                      context, MaterialPageRoute(builder: (context) => Home()));
                },
                icon: Icon(
                  Icons.arrow_back_ios_new_outlined,
                  color: Colors.blue,
                )),
          ),
          Expanded(
            child: GridView.builder(
                itemCount: rowlength * collength,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: rowlength),
                itemBuilder: (context, index) {
                  //get row and col of each index
                  int row = (index / rowlength).floor();
                  int col = index % rowlength;

                  //current piece
                  if (currentpiece.position.contains(index)) {
                    return Pixel(
                      color: currentpiece.color,
                    );
                  }

                  //landed pieces
                  else if (gameboard[row][col] != null) {
                    final Tetromino? tetrominoType = gameboard[row][col];
                    return Pixel(
                      color: tetrominoColors[tetrominoType],
                    );
                  }

                  //blank pixel
                  else {
                    return Pixel(
                      color: Colors.grey[900],
                    );
                  }
                }),
          ),

          //score
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Text(
              "score: $currentscore",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          ),

          //game controls
          Padding(
            padding: const EdgeInsets.only(bottom: 40),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                //left
                IconButton(
                  onPressed: moveleft,
                  color: Colors.white,
                  icon: Icon(Icons.arrow_back_ios_new),
                  iconSize: 40,
                ),
                //rotate
                IconButton(
                  onPressed: rotatepiece,
                  color: Colors.white,
                  icon: Icon(Icons.rotate_right),
                  iconSize: 40,
                ),
                //right
                IconButton(
                  onPressed: moveright,
                  color: Colors.white,
                  icon: Icon(Icons.arrow_forward_ios),
                  iconSize: 40,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
