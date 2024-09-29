import 'package:flutter/material.dart';
import 'package:game_app/games/tetris_game/tetris_board.dart';
import 'package:game_app/games/tetris_game/values.dart';

class Piece {
  //grid dimensions
  int rowlength = 10;
  int collength = 15;
  //type of trtries piece
  Tetromino type;
  Piece({required this.type});

  //the piece is just a list of integers
  List<int> position = [];

  //color of tetris piece
  Color get color {
    return tetrominoColors[type] ??
        const Color(0xFFFFFFFF); //default to white if no color is found
  }

  //generate the integers
  void initializepiece() {
    switch (type) {
      case Tetromino.L:
        position = [-26, -16, -6, -5];
        break;
      case Tetromino.J:
        position = [-25, -15, -5, -6];
        break;
      case Tetromino.I:
        position = [-4, -5, -6, -7];
        break;
      case Tetromino.O:
        position = [-15, -16, -5, -6];
        break;
      case Tetromino.S:
        position = [-15, -14, -6, -5];
        break;
      case Tetromino.Z:
        position = [-17, -16, -6, -5];
        break;
      case Tetromino.T:
        position = [-26, -16, -6, -15];
        break;
      default:
    }
  }

  //move piece
  void movepiece(Direction direction) {
    switch (direction) {
      case Direction.down:
        for (int i = 0; i < position.length; i++) {
          position[i] += rowlength;
        }
        break;
      case Direction.left:
        for (int i = 0; i < position.length; i++) {
          position[i] -= 1;
        }
        break;
      case Direction.right:
        for (int i = 0; i < position.length; i++) {
          position[i] += 1;
        }
        break;
      default:
    }
  }

  //rotate piece
  int rotationstate = 1;

  void rotatepiece() {
    //new position
    List<int> newposition = [];

    //rotate the piece based on it's type
    switch (type) {
      case Tetromino.L:
        switch (rotationstate) {
          case 0:
            /*0
            0
            0 0
            */

            //get the new position
            newposition = [
              position[1] - rowlength,
              position[1],
              position[1] + rowlength,
              position[1] + rowlength + 1,
            ];

            //check that this new position is a valid move before assigning it to the real position
            if (piecepositonisvalid(newposition)) {
              //update position
              position = newposition;
              //update rotation state
              rotationstate = (rotationstate + 1) % 4;
            }
            break;

          case 1:
            /*
            0 0 0
            0
            */

            //get the new position
            newposition = [
              position[1] - 1,
              position[1],
              position[1] + 1,
              position[1] + rowlength - 1,
            ];

            //check that this new position is a valid move before assigning it to the real position
            if (piecepositonisvalid(newposition)) {
              //update position
              position = newposition;
              //update rotation state
              rotationstate = (rotationstate + 1) % 4;
            }
            break;

          case 2:
            /*
            0 0
              0
              0
            */

            //get the new position
            newposition = [
              position[1] + rowlength,
              position[1],
              position[1] - rowlength,
              position[1] - rowlength - 1,
            ];

            //check that this new position is a valid move before assigning it to the real position
            if (piecepositonisvalid(newposition)) {
              //update position
              position = newposition;
              //update rotation state
              rotationstate = (rotationstate + 1) % 4;
            }
            break;

          case 3:
            /* 
                0
            0 0 0
            */

            //get the new position
            newposition = [
              position[1] - rowlength + 1,
              position[1],
              position[1] + 1,
              position[1] - 1,
            ];

            //check that this new position is a valid move before assigning it to the real position
            if (piecepositonisvalid(newposition)) {
              //update position
              position = newposition;
              //update rotation state
              rotationstate = (rotationstate + 1) % 4;
            }
            break;
        }
        break;

      case Tetromino.J:
        switch (rotationstate) {
          case 0:
            /*

               0
               0
             0 0
           
            */

            //get the new position
            newposition = [
              position[1] - rowlength,
              position[1],
              position[1] + rowlength,
              position[1] + rowlength - 1,
            ];

            //check that this new position is a valid move before assigning it to the real position
            if (piecepositonisvalid(newposition)) {
              //update position
              position = newposition;
              //update rotation state
              rotationstate = (rotationstate + 1) % 4;
            }
            break;

          case 1:
            /*
              0
              0 0 0
            */

            //get the new position
            newposition = [
              position[1] - rowlength - 1,
              position[1],
              position[1] - 1,
              position[1] + 1,
            ];

            //check that this new position is a valid move before assigning it to the real position
            if (piecepositonisvalid(newposition)) {
              //update position
              position = newposition;
              //update rotation state
              rotationstate = (rotationstate + 1) % 4;
            }
            break;

          case 2:
            /*
                0 0
                0
                0
          
            */

            //get the new position
            newposition = [
              position[1] + rowlength,
              position[1],
              position[1] - rowlength,
              position[1] - rowlength + 1,
            ];

            //check that this new position is a valid move before assigning it to the real position
            if (piecepositonisvalid(newposition)) {
              //update position
              position = newposition;
              //update rotation state
              rotationstate = (rotationstate + 1) % 4;
            }
            break;

          case 3:
            /* 
            0 0 0
                0
            */

            //get the new position
            newposition = [
              position[1] + 1,
              position[1],
              position[1] - 1,
              position[1] + rowlength + 1,
            ];

            //check that this new position is a valid move before assigning it to the real position
            if (piecepositonisvalid(newposition)) {
              //update position
              position = newposition;
              //update rotation state
              rotationstate = (rotationstate + 1) % 4;
            }
            break;
        }

        break;

      case Tetromino.I:
        switch (rotationstate) {
          case 0:
            /*

              0 0 0 0
           
            */

            //get the new position
            newposition = [
              position[1] - 1,
              position[1],
              position[1] + 1,
              position[1] + 2,
            ];

            //check that this new position is a valid move before assigning it to the real position
            if (piecepositonisvalid(newposition)) {
              //update position
              position = newposition;
              //update rotation state
              rotationstate = (rotationstate + 1) % 4;
            }
            break;

          case 1:
            /*
              0
              0
              0
              0
            */

            //get the new position
            newposition = [
              position[1] - rowlength,
              position[1],
              position[1] + rowlength,
              position[1] + 2 * rowlength,
            ];

            //check that this new position is a valid move before assigning it to the real position
            if (piecepositonisvalid(newposition)) {
              //update position
              position = newposition;
              //update rotation state
              rotationstate = (rotationstate + 1) % 4;
            }
            break;

          case 2:
            /*
               0 0 0 0
            */

            //get the new position
            newposition = [
              position[1] + 1,
              position[1],
              position[1] - 1,
              position[1] - 2,
            ];

            //check that this new position is a valid move before assigning it to the real position
            if (piecepositonisvalid(newposition)) {
              //update position
              position = newposition;
              //update rotation state
              rotationstate = (rotationstate + 1) % 4;
            }
            break;

          case 3:
            /* 
              0
              0
              0
              0
            */

            //get the new position
            newposition = [
              position[1] + rowlength,
              position[1],
              position[1] - rowlength,
              position[1] - 2 * rowlength,
            ];

            //check that this new position is a valid move before assigning it to the real position
            if (piecepositonisvalid(newposition)) {
              //update position
              position = newposition;
              //update rotation state
              rotationstate = (rotationstate + 1) % 4;
            }
            break;
        }

        break;

      case Tetromino.O:
        /*the o tetromino does not need to be rotate

         0  0
         0  0

         */
        break;

      case Tetromino.S:
        switch (rotationstate) {
          case 0:
            /*

                 0  0
              0  0     
           
            */

            //get the new position
            newposition = [
              position[1],
              position[1] + 1,
              position[1] + rowlength - 1,
              position[1] + rowlength,
            ];

            //check that this new position is a valid move before assigning it to the real position
            if (piecepositonisvalid(newposition)) {
              //update position
              position = newposition;
              //update rotation state
              rotationstate = (rotationstate + 1) % 4;
            }
            break;

          case 1:
            /*
              0
              0 0
                0
            */

            //get the new position
            newposition = [
              position[0] - rowlength,
              position[0],
              position[0] + 1,
              position[0] + rowlength + 1,
            ];

            //check that this new position is a valid move before assigning it to the real position
            if (piecepositonisvalid(newposition)) {
              //update position
              position = newposition;
              //update rotation state
              rotationstate = (rotationstate + 1) % 4;
            }
            break;

          case 2:
            /*
                0 0
              0 0
                
          
            */

            //get the new position
            newposition = [
              position[1],
              position[1] + 1,
              position[1] + rowlength - 1,
              position[1] + rowlength,
            ];

            //check that this new position is a valid move before assigning it to the real position
            if (piecepositonisvalid(newposition)) {
              //update position
              position = newposition;
              //update rotation state
              rotationstate = (rotationstate + 1) % 4;
            }
            break;

          case 3:
            /* 
              0
              0 0
                0
            */

            //get the new position
            newposition = [
              position[0] - rowlength,
              position[0],
              position[0] + 1,
              position[0] + rowlength + 1,
            ];

            //check that this new position is a valid move before assigning it to the real position
            if (piecepositonisvalid(newposition)) {
              //update position
              position = newposition;
              //update rotation state
              rotationstate = (rotationstate + 1) % 4;
            }
            break;
        }

        break;

      case Tetromino.Z:
        switch (rotationstate) {
          case 0:
            /*

               0 0
                 0 0
           
            */

            //get the new position
            newposition = [
              position[0] + rowlength - 2,
              position[1],
              position[2] + rowlength - 1,
              position[3] + 1,
            ];

            //check that this new position is a valid move before assigning it to the real position
            if (piecepositonisvalid(newposition)) {
              //update position
              position = newposition;
              //update rotation state
              rotationstate = (rotationstate + 1) % 4;
            }
            break;

          case 1:
            /*
                 0
               0 0
               0
            */

            //get the new position
            newposition = [
              position[0] - rowlength + 2,
              position[1],
              position[2] - rowlength + 1,
              position[3] - 1,
            ];

            //check that this new position is a valid move before assigning it to the real position
            if (piecepositonisvalid(newposition)) {
              //update position
              position = newposition;
              //update rotation state
              rotationstate = (rotationstate + 1) % 4;
            }
            break;

          case 2:
            /*
                0 0
                  0 0
          
            */

            //get the new position
            newposition = [
              position[0] + rowlength - 2,
              position[1],
              position[2] + rowlength - 1,
              position[3] + 1,
            ];

            //check that this new position is a valid move before assigning it to the real position
            if (piecepositonisvalid(newposition)) {
              //update position
              position = newposition;
              //update rotation state
              rotationstate = (rotationstate + 1) % 4;
            }
            break;

          case 3:
            /* 
                 0
               0 0
               0  
            */

            //get the new position
            newposition = [
              position[0] - rowlength + 2,
              position[1],
              position[2] - rowlength + 1,
              position[3] - 1,
            ];

            //check that this new position is a valid move before assigning it to the real position
            if (piecepositonisvalid(newposition)) {
              //update position
              position = newposition;
              //update rotation state
              rotationstate = (rotationstate + 1) % 4;
            }
            break;
        }

        break;

      case Tetromino.T:
        switch (rotationstate) {
          case 0:
            /*

               0
               0 0
               0
           
            */

            //get the new position
            newposition = [
              position[2] - rowlength,
              position[2],
              position[2] + 1,
              position[2] + rowlength,
            ];

            //check that this new position is a valid move before assigning it to the real position
            if (piecepositonisvalid(newposition)) {
              //update position
              position = newposition;
              //update rotation state
              rotationstate = (rotationstate + 1) % 4;
            }
            break;

          case 1:
            /*
              0 0 0
                0
            */

            //get the new position
            newposition = [
              position[1] - 1,
              position[1],
              position[1] + 1,
              position[1] + rowlength,
            ];

            //check that this new position is a valid move before assigning it to the real position
            if (piecepositonisvalid(newposition)) {
              //update position
              position = newposition;
              //update rotation state
              rotationstate = (rotationstate + 1) % 4;
            }
            break;

          case 2:
            /*
                0 
              0 0
                0
          
            */

            //get the new position
            newposition = [
              position[1] - rowlength,
              position[1] - 1,
              position[1],
              position[1] + rowlength,
            ];

            //check that this new position is a valid move before assigning it to the real position
            if (piecepositonisvalid(newposition)) {
              //update position
              position = newposition;
              //update rotation state
              rotationstate = (rotationstate + 1) % 4;
            }
            break;

          case 3:
            /* 
              0
            0 0 0
                
            */

            //get the new position
            newposition = [
              position[1] - rowlength,
              position[1] - 1,
              position[1],
              position[1] + 1,
            ];

            //check that this new position is a valid move before assigning it to the real position
            if (piecepositonisvalid(newposition)) {
              //update position
              position = newposition;
              //update rotation state
              rotationstate = (rotationstate + 1) % 4;
            }
            break;
        }

        break;

      default:
    }
  }

  //check if valid position
  bool positionIsvalid(int position) {
    //get the row and col of position
    int row = (position / rowlength).floor();
    int col = position % rowlength;

    //if the position is taken, return false
    if (row < 0 || col < 0 || gameboard[row][col] != null) {
      return false;
    }

    //otherwise position is valid , return true
    else {
      return true;
    }
  }

  //check if piece is valid position
  bool piecepositonisvalid(List<int> pieceposition) {
    bool firstColOccupied = false;
    bool lastColOccupied = false;

    for (int pos in pieceposition) {
      //return false if any position is alredy taken
      if (!positionIsvalid(pos)) {
        return false;
      }

      //get the col of position
      int col = pos % rowlength;

      //check if the first or last col are occupied
      if (col == 0) {
        firstColOccupied = true;
      }
      if (col == rowlength - 1) {
        lastColOccupied = true;
      }
    }

    //if there is a piece in the first col and last col, it is going through the wall
    return !(firstColOccupied && lastColOccupied);
  }
}

const Map<Tetromino, Color> tetrominoColors = {
  Tetromino.L: Color(0xFFFFA500), //orange
  Tetromino.J: Color.fromARGB(255, 0, 102, 255), //blue
  Tetromino.I: Color.fromARGB(255, 242, 0, 255), //pink
  Tetromino.O: Color(0xFFFFFF00), //yellow
  Tetromino.S: Color(0xFF008000), //green
  Tetromino.Z: Color(0xFFFF0000), //red
  Tetromino.T: Color.fromARGB(255, 144, 0, 255), //purple
};
