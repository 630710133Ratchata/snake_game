import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

import 'package:snake_game/screen/black_pixel.dart';
import 'package:snake_game/screen/food_pixel.dart';
import 'package:snake_game/screen/snake_pixel.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

enum snake_Direction { UP, DOWN, LEFT, RIGHT }

class _HomePageState extends State<HomePage> {
  //ช่อง
  int rowSize = 10;
  int totalNumberofSquares = 100;

  //คะแนน
  int currentScore = 0;

  // ตำแหน่งงู
  List<int> snakePos = [
    0,
    1,
    2,
  ];

  //ไปทางขวาเป็นทิศเริ่มต้น
  var currentDirection = snake_Direction.RIGHT;

  //ตำแหน่งอาหาร
  int foodPos = 55;

  bool ResetButtonVisible = true;
  bool PlayButtonVisible = true;

  //start the game!
  void startGame() {
    PlayButtonVisible = false;
    Timer.periodic(Duration(milliseconds: 300), (timer) {
      setState(() {
        // keep the snake moving
        moveSnake();

        // เช็คว่าแพ้ไหม
        if (gameOver()) {
          ResetButtonVisible = false;
          timer.cancel();
          //หน้าจอแสดงเมื่อแพ้
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Center(child: Text('คุณแพ้แล้ว')),
                  content: Text('คะแนนของคุณ: ' + currentScore.toString()),
                );
              });
        }
      });
    });
  }

  void eatFood() {
    currentScore++;
    while (snakePos.contains(foodPos)) {
      foodPos = Random().nextInt(totalNumberofSquares);
    }
  }

  void moveSnake() {
    switch (currentDirection) {
      case snake_Direction.RIGHT:
        {
          if (snakePos.last % rowSize == 9) {
            snakePos.add(snakePos.last + 1 - rowSize);
          } else {
            snakePos.add(snakePos.last + 1);
          }
        }
        break;
      case snake_Direction.LEFT:
        {
          //add a head
          //if snake is at the right wall, need to re-adjust
          if (snakePos.last % rowSize == 0) {
            snakePos.add(snakePos.last - 1 + rowSize);
          } else {
            snakePos.add(snakePos.last - 1);
          }
          break;
        }
      case snake_Direction.UP:
        {
          //add a head
          if (snakePos.last < rowSize) {
            snakePos.add(snakePos.last - rowSize + totalNumberofSquares);
          } else {
            snakePos.add(snakePos.last - rowSize);
          }
        }
        break;
      case snake_Direction.DOWN:
        {
          if (snakePos.last + rowSize > totalNumberofSquares) {
            snakePos.add(snakePos.last + rowSize - totalNumberofSquares);
          } else {
            snakePos.add(snakePos.last + rowSize);
          }
        }
        break;
      default:
    }
    //งูกินอาหาร
    if (snakePos.last == foodPos) {
      eatFood();
    } else {
      //remove tail
      snakePos.removeAt(0);
    }
  }

  bool gameOver() {
    List<int> bodySnake = snakePos.sublist(0, snakePos.length - 1);

    if (bodySnake.contains(snakePos.last)) {
      return true;
    }
    return false;
  }

  void resetGame() {
    startGame();
    currentScore = 0;
    snakePos = [0, 1, 2];
    currentDirection = snake_Direction.RIGHT;
    foodPos = Random().nextInt(totalNumberofSquares);
    ResetButtonVisible = true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
              BackButton(),
              //คะแนน
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  //user current score
                  Text('คะแนน',
                      style:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
                  Text(currentScore.toString(),
                      style:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                ],
              ),
              SizedBox(width: 50),
            ],
          ),),


          //ช่อง
          Expanded(
            flex: 4,
            child: GestureDetector(
              onVerticalDragUpdate: (details) {
                if (details.delta.dy > 0 &&
                    currentDirection != snake_Direction.UP) {
                  currentDirection = snake_Direction.DOWN;
                } else if (details.delta.dy < 0 &&
                    currentDirection != snake_Direction.DOWN) {
                  currentDirection = snake_Direction.UP;
                }
              },
              onHorizontalDragUpdate: (details) {
                if (details.delta.dx > 0 &&
                    currentDirection != snake_Direction.LEFT) {
                  currentDirection = snake_Direction.RIGHT;
                } else if (details.delta.dx < 0 &&
                    currentDirection != snake_Direction.RIGHT) {
                  currentDirection = snake_Direction.LEFT;
                }
              },
              child: GridView.builder(
                  itemCount: totalNumberofSquares,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: rowSize),
                  itemBuilder: (context, index) {
                    if (snakePos.contains(index)) {
                      return const SnakePixel();
                    } else if (foodPos == index) {
                      return const FoodPixel();
                    } else {
                      return const BlankPixel();
                    }
                  }),
            ),
          ),
          //ปุ่มเล่น
          Visibility(
              visible: PlayButtonVisible,
              child: Expanded(
                  child: Container(
                      child: Center(
                          child: MaterialButton(
                child: Text(
                  'PLAY',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.black),
                ),
                color: Colors.white,
                onPressed: startGame,
              ))))),
          Visibility(
              visible: ResetButtonVisible == false,
              child: Expanded(
                  child: Container(
                      child: Center(
                          child: MaterialButton(
                child: Text(
                  'RESET',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.black),
                ),
                color: Colors.white,
                onPressed: resetGame,
              )))))
        ],
      ),
    );
  }
}
