import 'package:flutter/material.dart';

enum chesspieceType { pawn, rook, king, queen, knight, bishop }

class chesspiece {
  final chesspieceType type;
  final bool iswhite;
  final String imagepath;

  chesspiece({
    required this.type,
    required this.iswhite,
    required this.imagepath,
  });
}
