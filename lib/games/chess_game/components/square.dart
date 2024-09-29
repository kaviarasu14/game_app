import 'package:flutter/material.dart';
import 'package:game_app/games/chess_game/components/piece.dart';
import 'package:game_app/games/chess_game/values/colors.dart';

class Square extends StatelessWidget {
  final bool iswhite;
  final chesspiece? piece;
  final bool isselected;
  final void Function()? onTap;
  final bool isvalidmove;
  const Square(
      {super.key,
      required this.iswhite,
      required this.piece,
      required this.isselected,
      required this.onTap,
      required this.isvalidmove});

  @override
  Widget build(BuildContext context) {
    Color? squarecolor;
    //if selected, square isgreen
    if (isselected) {
      squarecolor = const Color.fromARGB(255, 116, 221, 120);
    } else if (isvalidmove) {
      squarecolor = Colors.green[300];
    }
    //otherwise,it's white or black
    else {
      squarecolor = iswhite ? foregroundcolor : backgroundcolor;
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        color: squarecolor,
        margin: EdgeInsets.all(isvalidmove ? 5 : 0),
        child: piece != null
            ? Image.asset(
                piece!.imagepath,
                color: piece!.iswhite ? Colors.white : Colors.black,
              )
            : null,
      ),
    );
  }
}
