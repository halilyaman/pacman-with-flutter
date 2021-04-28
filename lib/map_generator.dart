import 'package:flutter/material.dart';
import 'package:flutter_game/maps.dart';

import 'game_objects.dart';
import 'package:vector_math/vector_math.dart' as v;

class MapGenerator {
  v.Vector2 playerLocation;
  List<v.Vector2> enemyLocations = [];
  List<RectActor> map = [];

  RectActor buildRectangle(
      {double posX,
      double posY,
      double width,
      double height,
      Color color,
      bool rigidBody,
      bool isFood,
      bool isWall,
      String assetPath})
  {
    final rect = RectActor();
    rect.location = v.Vector2(posX, posY);
    rect.color = color;
    rect.width = width;
    rect.height = height;
    rect.rigidBody = rigidBody;
    rect.isFood = isFood;
    rect.isWall = isWall;
    if (assetPath != null) {
      rect.addNewImage(assetPath, true);
    }

    return rect;
  }

  void generateMap(BuildContext context, Actor player) {
    final size = MediaQuery.of(context).size;

    final bottomPadding = 35.0;
    final boxW = (size.height / Maps.map1.length) - (bottomPadding / Maps.map1.length);
    final boxH = (size.height / Maps.map1.length) - (bottomPadding / Maps.map1.length);

    for (int row = 0; row < Maps.map1.length; row++) {
      int boxIndexInRow = 0;
      for (int val in Maps.map1[row]) {
        if (val == 1) {
          // put a wall
          map.add(
              buildRectangle(
                  posX: boxIndexInRow * boxW,
                  posY: row * boxH,
                  width: boxW,
                  height: boxH,
                  color: Color(0xff5523cc),
                  rigidBody: true,
                  isFood: false,
                  isWall: true,
              ));
        }
        if (val == 3) {
          // put player
          playerLocation = v.Vector2((boxIndexInRow * boxW) + (boxH / 3), (row * boxH) + (boxW / 3));
        }
        if (val == 4) {
          // put enemy locations
          enemyLocations.add(v.Vector2((boxIndexInRow * boxW) + (boxH / 10), (row * boxH) + (boxW / 10)));
        }
        if (val == 0) {
          // put a food
          final foodH = boxW / 6;
          final foodW = boxW / 6;
          map.add(
              buildRectangle(
                posX: (boxIndexInRow * boxW) + (boxW / 2) - (foodW / 2),
                posY: (row * boxH) + (boxH / 2) - (foodH / 2),
                height: foodH,
                width: foodW,
                color: Colors.yellow,
                rigidBody: true,
                isFood: true,
                isWall: false,
              ));
        }
        boxIndexInRow++;
      }
    }
  }
}