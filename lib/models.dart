import 'package:flutter/material.dart';
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

  @override
  void draw(Canvas canvas, Size size) {
    Paint paint = Paint();
    paint.color = color;
    canvas.drawCircle(Offset(location.x, location.y), radius, paint);
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




