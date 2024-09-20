import 'package:flutter/material.dart';
import 'package:game_app/games/snake_game.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
        backgroundColor: Color.fromARGB(255, 119, 169, 255),
        body: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 40),
              child: Center(
                child: Text("Game Park",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 30,
                    )),
              ),
            ),
            Container(
              child: Material(
                  elevation: 5,
                  borderRadius: BorderRadiusDirectional.circular(10),
                  child: Container(
                    height: height * 0.9,
                    padding: EdgeInsets.all(18),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10)),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                            // width: width / 6,
                            height: 60,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(100),
                              child: Image.asset(
                                "assets/snake.jpeg",
                              ),
                            )),
                        SizedBox(
                          width: 10,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SnakeGame()));
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Text(
                              "Snake game",
                              style: TextStyle(
                                  fontSize: 30, color: Colors.greenAccent),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )),
            )
          ],
        ));
  }
}
