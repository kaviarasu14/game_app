iswhite(index) {
  int x = index ~/ 8;
  int y = index % 8;

  bool iswhite = (x + y) % 2 == 0;
  return iswhite;
}

bool isinboard(int row, int col) {
  return row >= 0 && row < 8 && col >= 0 && col < 8;
}
