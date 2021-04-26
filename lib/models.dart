import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_game/collision_system.dart';
import 'package:vector_math/vector_math.dart' as v;

abstract class GameObject {
  v.Vector2 location = v.Vector2(0.0, 0.0);
  v.Vector2 velocity = v.Vector2(10.0, 10.0);
  double width = .0;
  double height = .0;
  Color color = Colors.black;
  bool rigidBody = false;
  bool isFood = false;

  void draw(Canvas canvas, Size size);
}

//////////////////////////////////////////////////////////////////////////

class Actor extends GameObject{
  void moveRight(double deltaTime) {
    this.location.x += this.velocity.x * deltaTime;
  }

  void moveLeft(double deltaTime) {
    this.location.x -= this.velocity.x * deltaTime;
  }

  void moveUp(double deltaTime) {
    this.location.y -= this.velocity.y * deltaTime;
  }

  void moveDown(double deltaTime) {
    this.location.y += this.velocity.y * deltaTime;
  }

  @override
  void draw(Canvas canvas, Size size) {}
}

//////////////////////////////////////////////////////////////////////////

class CircleActor extends Actor {
  double radius = 0.0;
  var currentDirection = VectorDirection.west;

  @override
  void draw(Canvas canvas, Size size) {
    Paint paint = Paint();
    paint.color = color;

    canvas.drawCircle(Offset(location.x, location.y), radius, paint);

    Paint facePaint = Paint();
    facePaint.color = Colors.black;
    facePaint.strokeWidth = 2.0;

    switch(currentDirection) {
      case VectorDirection.north:
        drawUpFace(canvas, facePaint);
        break;
      case VectorDirection.west:
        drawLeftFace(canvas, facePaint);
        break;
      case VectorDirection.south:
        drawDownFace(canvas, facePaint);
        break;
      case VectorDirection.east:
        drawRightFace(canvas, facePaint);
        break;
    }
  }

  void drawRightFace(Canvas canvas, Paint paint) {
    canvas.drawLine(Offset(location.x, location.y), Offset(location.x + (radius / sqrt(2)), location.y - (radius / sqrt(2))), paint);
    canvas.drawLine(Offset(location.x, location.y), Offset(location.x + (radius / sqrt(2)), location.y + (radius / sqrt(2))), paint);
    canvas.drawCircle(Offset(location.x, location.y - (radius / 2)), radius/5, paint);
    canvas.drawCircle(Offset(location.x, location.y), 1, paint);
  }

  void drawLeftFace(Canvas canvas, Paint paint) {
    final firstLineEnd = Offset(location.x - (radius / sqrt(2)), location.y - (radius / sqrt(2)));
    final secondLineEnd = Offset(location.x - (radius / sqrt(2)), location.y + (radius / sqrt(2)));

    canvas.drawLine(Offset(location.x, location.y), firstLineEnd, paint);
    canvas.drawLine(Offset(location.x, location.y), secondLineEnd, paint);
    canvas.drawCircle(Offset(location.x, location.y - (radius / 2)), radius/5, paint);
    canvas.drawCircle(Offset(location.x, location.y), 1, paint);
  }

  void drawUpFace(Canvas canvas, Paint paint) {
    canvas.drawLine(Offset(location.x, location.y), Offset(location.x - (radius / sqrt(2)), location.y - (radius / sqrt(2))), paint);
    canvas.drawLine(Offset(location.x, location.y), Offset(location.x + (radius / sqrt(2)), location.y - (radius / sqrt(2))), paint);
    canvas.drawCircle(Offset(location.x - (radius / 2), location.y), radius/5, paint);
    canvas.drawCircle(Offset(location.x, location.y), 1, paint);
  }

  void drawDownFace(Canvas canvas, Paint paint) {
    canvas.drawLine(Offset(location.x, location.y), Offset(location.x - (radius / sqrt(2)), location.y + (radius / sqrt(2))), paint);
    canvas.drawLine(Offset(location.x, location.y), Offset(location.x + (radius / sqrt(2)), location.y + (radius / sqrt(2))), paint);
    canvas.drawCircle(Offset(location.x - (radius / 2), location.y), radius/5, paint);
    canvas.drawCircle(Offset(location.x, location.y), 1, paint);
  }
}

//////////////////////////////////////////////////////////////////////////

class RectActor extends Actor {

  @override
  void draw(Canvas canvas, Size size) {
    Paint paint = Paint()..color = color;
    var center = Offset(location.x + width/2, location.y + height/2);
    var rect = Rect.fromCenter(center: center, width: width, height: height);
    canvas.drawRect(rect, paint);
  }
}




