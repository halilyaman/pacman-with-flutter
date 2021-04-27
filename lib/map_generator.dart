import 'package:flutter/material.dart';
import 'package:flutter_game/maps.dart';

import 'game_objects.dart';
import 'package:vector_math/vector_math.dart' as v;

class MapGenerator {
  v.Vector2 playerLocation;
  List<v.Vector2> enemyLocations = [];
  List<RectActor> map = [];

  RectActor buildRectangle(
      double posX,
      double posY,
      double width,
      double height,
      Color color,
      bool rigidBody,
      bool isFood,
      [String assetPath])
  {
    final rect = RectActor();
    rect.location = v.Vector2(posX, posY);
    rect.color = color;
    rect.width = width;
    rect.height = height;
    rect.rigidBody = rigidBody;
    rect.isFood = isFood;
    if (assetPath != null) {
      rect.addNewImage(assetPath, true);
    }

    return rect;
  }

  void generateMap(BuildContext context, Actor player) {
    final size = MediaQuery.of(context).size;

    final boxW = size.width / 13;
    final boxH = size.height / 9;
    for (int row = 0; row < Maps.map1.length; row++) {
      int boxIndexInRow = 0;
      for (int val in Maps.map1[row]) {
        if (val == 1) {
          // put a wall
          map.add(
              buildRectangle(
                  boxIndexInRow * boxW,
                  row * boxH,
                  boxW,
                  boxH,
                  Color(0xff5523cc),
                  true,
                  false,
                  // "assets/wall.jpg"
              ));
        }
        if (val == 3) {
          // put player
          playerLocation = v.Vector2((boxIndexInRow * boxW) + (boxH / 3), (row * boxH) + (boxW / 3));
        }
        if (val == 4) {
          enemyLocations.add(v.Vector2((boxIndexInRow * boxW) + (boxH / 10), (row * boxH) + (boxW / 10)));
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
  }
}