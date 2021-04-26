import 'dart:async';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_game/collision_system.dart';
import 'package:vector_math/vector_math.dart' as v;
import 'dart:ui' as ui;

abstract class GameObject {
  v.Vector2 location = v.Vector2(0.0, 0.0);
  v.Vector2 velocity = v.Vector2(10.0, 10.0);
  double width = .0;
  double height = .0;
  Color color = Colors.black;
  bool rigidBody = false;
  bool isFood = false;
  ui.Image currentImage;
  List<ui.Image> images = [];

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

  Future<void> addNewTexture(String path, bool setImmediately) async {
    final data = await rootBundle.load(path);
    final codec = await ui.instantiateImageCodec(
        data.buffer.asUint8List(),
        targetHeight: height.toInt(),
        targetWidth: width.toInt(),
        allowUpscaling: true);
    final frame = await codec.getNextFrame();
    images.add(frame.image);
    if (setImmediately) {
      currentImage = frame.image;
    }
  }

  void setCurrentImage(ui.Image image) {
    currentImage = image;
  }

  @override
  void draw(Canvas canvas, Size size) {}
}

//////////////////////////////////////////////////////////////////////////

class CircleActor extends Actor {
  double _radius = 0.0;

  void setRadius(double radius) {
    _radius = radius;
    height = radius * 2;
    width = radius * 2;
  }

  double get radius => _radius;

  @override
  void draw(Canvas canvas, Size size) {
    final center = Offset(location.x, location.y);
    final Paint imagePaint = Paint();
    imagePaint.isAntiAlias = true;
    // imagePaint.imageFilter = ui.ImageFilter.blur(sigmaY: .4, sigmaX: .4);
    if (currentImage != null) {
      canvas.drawImage(
          currentImage,
          Offset(center.dx - radius, center.dy - radius),
          imagePaint,
      );
      return;
    }
    Paint paint = Paint();
    paint.color = color;
    canvas.drawCircle(center, radius, paint);
  }
}

//////////////////////////////////////////////////////////////////////////

class RectActor extends Actor {

  @override
  void draw(Canvas canvas, Size size) {
    final Paint imagePaint = Paint();
    imagePaint.isAntiAlias = true;
    // imagePaint.imageFilter = ui.ImageFilter.blur(sigmaY: .4, sigmaX: .4);
    if (currentImage != null) {
      canvas.drawImage(
        currentImage,
        Offset(location.x, location.y),
        imagePaint,
      );
      return;
    }

    Paint paint = Paint()..color = color;
    var center = Offset(location.x + width/2, location.y + height/2);
    var rect = Rect.fromCenter(center: center, width: width, height: height);
    canvas.drawRect(rect, paint);
  }
}




