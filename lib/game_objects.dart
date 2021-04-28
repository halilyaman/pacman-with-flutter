import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:vector_math/vector_math.dart' as v;
import 'dart:ui' as ui;

abstract class GameObject {
  v.Vector2 location = v.Vector2(.0, .0);
  v.Vector2 velocity = v.Vector2(10.0, 10.0);
  double width = .0;
  double height = .0;
  Color color = Colors.black;
  ui.Image currentImage;
  // indexes: 0=up, 1=right, 2=bottom, 3=left
  List<ui.Image> images = [];
  bool rigidBody = false;
  bool isFood = false;
  bool isPlayer = false;
  bool isEnemy = false;
  bool isWall = false;

  void draw(Canvas canvas, Size size);
}

//////////////////////////////////////////////////////////////////////////

class Actor extends GameObject{
  void moveRight(double deltaTime) {
    if (images.length > 1) {
      setCurrentImage(images[1]);
    }
    this.location.x += this.velocity.x * deltaTime;
  }

  void moveLeft(double deltaTime) {
    if (images.length > 3) {
      setCurrentImage(images[3]);
    }
    this.location.x -= this.velocity.x * deltaTime;
  }

  void moveUp(double deltaTime) {
    if (images.length > 0) {
      setCurrentImage(images[0]);
    }
    this.location.y -= this.velocity.y * deltaTime;
  }

  void moveDown(double deltaTime) {
    if (images.length > 2) {
      setCurrentImage(images[2]);
    }
    this.location.y += this.velocity.y * deltaTime;
  }

  Future<void> addNewImage(String path, bool setImmediately) async {
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
  double _radius = .0;

  void setRadius(double radius) {
    _radius = radius;
    height = radius * 2;
    width = radius * 2;
  }

  double get radius => _radius;

  @override
  void draw(Canvas canvas, Size size) {
    final center = Offset(location.x, location.y);
    Paint paint = Paint();
    paint.color = color;
    canvas.drawRect(Rect.fromCircle(center: center, radius: radius), paint);

    final Paint imagePaint = Paint();
    imagePaint.isAntiAlias = true;
    imagePaint.colorFilter = ColorFilter.mode(color, BlendMode.overlay);
    // imagePaint.imageFilter = ui.ImageFilter.blur(sigmaY: .4, sigmaX: .4);
    if (currentImage != null) {
      canvas.drawImage(
        currentImage,
        Offset(center.dx - radius, center.dy - radius),
        imagePaint,
      );
    }
  }
}

//////////////////////////////////////////////////////////////////////////

class RectActor extends Actor {

  v.Vector2 get center => v.Vector2(location.x + width/2, location.y + height/2);

  @override
  void draw(Canvas canvas, Size size) {
    Paint paint = Paint()..color = color;
    var center = Offset(location.x + width/2, location.y + height/2);
    var rect = Rect.fromCenter(center: center, width: width, height: height);
    canvas.drawRect(rect, paint);

    final Paint imagePaint = Paint();
    imagePaint.isAntiAlias = true;
    // imagePaint.imageFilter = ui.ImageFilter.blur(sigmaY: .4, sigmaX: .4);
    if (currentImage != null) {
      canvas.drawImage(
        currentImage,
        Offset(location.x, location.y),
        imagePaint,
      );
    }
  }
}

//////////////////////////////////////////////////////////////////////////

class Particle extends RectActor {
  double totalTime = 0.2;
  double timeALive = 0.0;
  double yVel = 0.0;
  double xVel = 0.0;
}
