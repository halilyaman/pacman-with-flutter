import 'package:flutter/material.dart';
import 'package:flutter_game/maps.dart';

import 'models.dart';
import 'package:vector_math/vector_math.dart' as v;

class MapGenerator {
  RectActor buildRectangle(
      double posX,
      double posY,
      double width,
      double height,
      Color color,
      bool rigidBody,
      bool isFood)
  {
    final rect = RectActor();
    rect.location = v.Vector2(posX, posY);
    rect.color = color;
    rect.width = width;
    rect.height = height;
    rect.rigidBody = rigidBody;
    rect.isFood = isFood;
    return rect;
  }

  List<RectActor> generateMap(BuildContext context, CircleActor player) {
    List<RectActor> map = [];

    final size = MediaQuery.of(context).size;

    final boxW = size.width / 13;
    final boxH = size.height / 9;
    for (int row = 0; row < Maps.map1.length; row++) {
      int boxIndexInRow = 0;
      for (int val in Maps.map1[row]) {
        if (val == 1) {
          // put a wall
          map.add(buildRectangle(boxIndexInRow * boxW, row * boxH, boxW, boxH, Colors.black, true, false));
        }
        if (val == 3) {
          // put player
          player.location = v.Vector2((boxIndexInRow * boxW) + (boxH / 3), (row * boxH) + (boxW / 3));
        }
        if (val == 0) {
          // put a food
          final foodH = boxW / 6;
          final foodW = boxW / 6;
          map.add(
              buildRectangle(
                (boxIndexInRow * boxW) + (boxW / 2) - (foodW / 2),
                (row * boxH) + (boxH / 2) - (foodH / 2),
                foodH,
                foodW,
                Colors.yellow,
                true,
                true,
              ));
        }
        boxIndexInRow++;
      }
    }

    return map;
  }
}