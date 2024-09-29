import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:game_app/pages/home_page.dart';

class SnakeGame extends StatelessWidget {
  const SnakeGame({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: const SnakeGame_page(),
    );
  }
}

class SnakeGame_page extends StatefulWidget {
  const SnakeGame_page({super.key});

  @override
  State<SnakeGame_page> createState() => _SnakeGame_pageState();
}

enum Direction { up, down, left, right }

class _SnakeGame_pageState extends State<SnakeGame_page> {
  int row = 20, column = 20;
  List<int> borderList = [];
  List<int> snakeposition = [];
  int snakeHead = 0;
  int score = 0;
  late Direction direction;
  late int foodposition = 0;

  @override
  void initState() {
    startgame();
    super.initState();
  }

  void startgame() {
    makeborder();
    generatefood();
    direction = Direction.right;
    snakeposition = [45, 44, 43];
    snakeHead = snakeposition.first;
    Timer.periodic(const Duration(milliseconds: 300), (timer) {
      updatesnke();
      if (checkcollision()) {
        timer.cancel();
        showgameoverdialog();
      }
      ;
    });
  }

  void showgameoverdialog() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            title: const Text("Game Over"),
            content: const Text("muduchuvitinga..ponga"),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    startgame();
                    score = 0;
                  },
                  child: const Text(("Restart")))
            ],
          );
        });
  }

  bool checkcollision() {
    if (borderList.contains(snakeHead)) return true;

    if (snakeposition.sublist(1).contains(snakeHead)) return true;
    return false;
  }

  void generatefood() {
    foodposition = Random().nextInt(row * column);
    if (borderList.contains(foodposition)) {
      generatefood();
    }
  }

  void updatesnke() {
    setState(() {
      switch (direction) {
        case Direction.up:
          snakeposition.insert(0, snakeHead - column);
          break;
        case Direction.down:
          snakeposition.insert(0, snakeHead + column);
          break;
        case Direction.right:
          snakeposition.insert(0, snakeHead + 1);
          break;
        case Direction.left:
          snakeposition.insert(0, snakeHead - 1);
          break;
      }
    });

    if (snakeHead == foodposition) {
      score++;
      generatefood();
    } else {
      snakeposition.removeLast();
    }
    snakeHead = snakeposition.first;
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.only(
              top: 60,
            ),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => Home()));
                  },
                  child: Icon(
                    Icons.arrow_back_ios_new_outlined,
                    color: Color(0xffc199cd),
                  ),
                ),
                SizedBox(
                  width: width / 3.3,
                ),
                Text(
                  "Snake Game",
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
          Expanded(child: _buildGameView()),
          buildGameControls()
        ],
      ),
    );
  }

  Widget _buildGameView() {
    return GridView.builder(
      gridDelegate:
          SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: column),
      itemBuilder: (context, index) {
        return Container(
          margin: EdgeInsets.all(1),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: fillboxColor(index)),
        );
      },
      itemCount: row * column,
    );
  }

  Widget buildGameControls() {
    return Container(
      padding: const EdgeInsets.all(10),
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("score : $score"),
          IconButton(
            onPressed: () {
              if (direction != Direction.down) {
                direction = Direction.up;
              }
            },
            icon: const Icon(Icons.arrow_circle_up),
            iconSize: 80,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: () {
                  if (direction != Direction.right) {
                    direction = Direction.left;
                  }
                },
                icon: const Icon(Icons.arrow_circle_left_outlined),
                iconSize: 80,
              ),
              SizedBox(
                width: 100,
              ),
              IconButton(
                onPressed: () {
                  if (direction != Direction.left) {
                    direction = Direction.right;
                  }
                },
                icon: const Icon(Icons.arrow_circle_right_outlined),
                iconSize: 80,
              ),
            ],
          ),
          IconButton(
            onPressed: () {
              if (direction != Direction.up) {
                direction = Direction.down;
              }
            },
            icon: const Icon(Icons.arrow_circle_down_outlined),
            iconSize: 80,
          ),
        ],
      ),
    );
  }

  Color fillboxColor(int index) {
    if (borderList.contains(index)) {
      return Colors.yellow;
    } else {
      if (snakeposition.contains(index)) {
        if (snakeHead == index) {
          return Colors.green;
        } else {
          return Colors.white.withOpacity(0.5);
        }
      } else {
        if (index == foodposition) {
          return Colors.red;
        }
      }
    }
    return Colors.grey.withOpacity(0.05);
  }

  makeborder() {
    for (int i = 0; i < column; i++) {
      if (!borderList.contains(i)) borderList.add(i);
    }

    for (int i = 0; i < row * column; i += column) {
      if (!borderList.contains(i)) borderList.add(i);
    }

    for (int i = column - 1; i < row * column; i += column) {
      if (!borderList.contains(i)) borderList.add(i);
    }

    for (int i = (row * column) - column; i < row * column; i += 1) {
      if (!borderList.contains(i)) borderList.add(i);
    }
  }
}
