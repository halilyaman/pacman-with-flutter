import 'package:flutter/material.dart';

import 'game_viewport.dart';
import 'game_objects.dart';

class GameBase extends StatefulWidget {
  final Color backgroundColor;
  final List<GameObject> gameObjects;

  const GameBase({Key key, this.backgroundColor, this.gameObjects}) : super(key: key);

  @override
  _GameBaseState createState() => _GameBaseState();
}

class _GameBaseState extends State<GameBase> {

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: ViewPort(
        color: widget.backgroundColor,
        gameObjects: widget.gameObjects,
      ),
      child: Container(),
      willChange: true,
      isComplex: true,
    );
  }
}