import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import 'models.dart';

class ViewPort extends CustomPainter {
  Color color;
  List<Color> colors;
  List<GameObject> gameObjects;

  ViewPort({
    bool addShadow,
    Color color,
    List<GameObject> gameObjects,
    this.colors,
  }) : this.color = color ?? Colors.white,
        this.gameObjects = gameObjects ?? [];

  @override
  void paint(Canvas canvas, Size size) async {
    Paint paint = Paint();
    paint.color = color;
    paint.filterQuality = FilterQuality.high;

    _drawBackgroundColor(canvas, paint, size);

    for (var gameObject in gameObjects) {
      gameObject?.draw(canvas, size);
    }
  }

  @override
  bool shouldRepaint(covariant ViewPort oldDelegate) {
    return true;
  }

  void _drawBackgroundColor(Canvas canvas, Paint paint, Size size) {
    canvas.drawVertices(ui.Vertices(
      VertexMode.triangleFan,
      [
        Offset(0.0, 0.0), // top left
        Offset(0.0, size.height), // bottom left
        Offset(size.width, size.height), // bottom right
        Offset(size.width, 0.0), // top right
      ], // top right
      indices: [0, 1, 2, 3],
      colors: colors,
    ), BlendMode.color, paint);
  }
}