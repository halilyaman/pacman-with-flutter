import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_game/game_controllers.dart';

import 'game_base.dart';
import 'models.dart';
import 'package:vector_math/vector_math.dart' as v;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Game',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  CircleActor player;

  GameControllerState controllerState = GameControllerState();
  DateTime currentTime = DateTime.now();
  DateTime oldTime;

  List<GameObject> gameObjects = [];

  @override
  void initState() {
    startGameLoop();
    loadGameComponents();
    super.initState();
  }

  void startGameLoop() {
    Timer.periodic(Duration(milliseconds: 1), (timer) {
      oldTime = currentTime;
      currentTime = DateTime.now();
      final deltaTime = (currentTime.millisecondsSinceEpoch - oldTime.millisecondsSinceEpoch) / 1000;

      if (controllerState.isLeftPressed) {
        if (checkCollisions()) {
          return;
        }
        player.moveLeft(deltaTime);
        setState(() {});
      }
      if (controllerState.isRightPressed) {
        if (checkCollisions()) {
          return;
        }
        player.moveRight(deltaTime);
        setState(() {});
      }
      if (controllerState.isUpPressed) {
        if (checkCollisions()) {
          return;
        }
        player.moveUp(deltaTime);
        setState(() {});
      }
      if (controllerState.isDownPressed) {
        if (checkCollisions()) {
          return;
        }
        player.moveDown(deltaTime);
        setState(() {});
      }
    });
  }

  void loadGameComponents() async {
    await Future.delayed(Duration(seconds: 1));
    final screenSize = MediaQuery.of(context).size;

    // create player
    player = CircleActor();
    player.radius = 20.0;
    player.location = v.Vector2(screenSize.width/2, screenSize.height/2);
    player.color = Colors.blue;
    player.velocity = v.Vector2(300, 300);
    player.rigidBody = true;

    // create temporary wall
    final wall = RectActor();
    wall.location = v.Vector2(100.0, 100.0);
    wall.width = 500.0;
    wall.height = 5.0;
    wall.rigidBody = true;

    final circle = CircleActor();
    circle.radius = 20.0;
    circle.location = v.Vector2(screenSize.width/2 + 100, screenSize.height/2 + 100);
    circle.color = Colors.black;
    circle.velocity = v.Vector2(100, 100);
    circle.rigidBody = true;

    gameObjects.add(player);
    gameObjects.add(wall);
    gameObjects.add(circle);

    setState(() {});
  }

  bool checkCollisions() {
    bool collisionDetected = false;
    for (int i = 1; i < gameObjects.length; i++) {
      var obj = gameObjects[i];

      if (obj.rigidBody == false) {
        return false;
      }

      if (obj is RectActor) {
        if (applyCircleRectangleCollisionCheck(obj)) {
          collisionDetected = true;
        }
      }

      if (obj is CircleActor) {
        if (applyCircleCircleCollisionCheck(obj)) {
          collisionDetected = true;
        }
      }
    }

    return collisionDetected;
  }

  bool applyCircleCircleCollisionCheck(CircleActor obj) {
    final dist = player.location.distanceTo(obj.location);
    final collisionDetected = dist < player.radius + obj.radius;

    if (collisionDetected) {
      final diff = obj.location - player.location;
      final vectorDir = calcVectorDirection(diff);
      // horizontal collision
      if (vectorDir == VectorDirection.west ||vectorDir == VectorDirection.east) {
        double penetration = player.radius - diff.x.abs();
        if (vectorDir == VectorDirection.west) {
          player.location.x += penetration;
        } else {
          player.location.x -= penetration;
        }
      }
      // vertical collision
      else {
        double penetration = player.radius - diff.y.abs();
        if (vectorDir == VectorDirection.north) {
          player.location.y += penetration;
        } else {
          player.location.y -= penetration;
        }
      }
    }
    return collisionDetected;
  }

  bool applyCircleRectangleCollisionCheck(RectActor obj) {
    // calculate rectangle's half extent and center
    final objHalfExtent = v.Vector2(obj.width/2, obj.height/2);
    final objCenter = v.Vector2(obj.location.x + obj.width/2, obj.location.y + obj.height/2);

    // get difference between both centers
    v.Vector2 diff = player.location - objCenter;
    final clamped = v.Vector2(diff.x, diff.y);
    clamped.clamp(-objHalfExtent, objHalfExtent);
    // add clamped value to objCenter and we get the value of box closest to circle
    final closest = objCenter + clamped;
    // retrieve vector between center circle and closest point obj and check if length <= radius
    diff = closest - player.location;

    if (diff.length < player.radius) {
      final vectorDir = calcVectorDirection(diff);

      // horizontal collision
      if (vectorDir == VectorDirection.west ||vectorDir == VectorDirection.east) {
        double penetration = player.radius - diff.x.abs();
        if (vectorDir == VectorDirection.west) {
          player.location.x -= penetration;
        } else {
          player.location.x += penetration;
        }
      }
      // vertical collision
      else {
        double penetration = player.radius - diff.y.abs();
        if (vectorDir == VectorDirection.north) {
          player.location.y -= penetration;
        } else {
          player.location.y += penetration;
        }
      }
      return true;
    }

    return false;
  }

  VectorDirection calcVectorDirection(v.Vector2 diff) {
    final compass = [
      v.Vector2(0.0, 1.0),
      v.Vector2(1.0, 0.0),
      v.Vector2(0.0, -1.0),
      v.Vector2(-1.0, 0.0),
    ];

    double max = 0.0;
    int bestMatch = -1;
    for (int i = 0; i < 4; i++) {
      double dotProduct = diff.normalized().dot(compass[i]);
      if (dotProduct > max) {
        max = dotProduct;
        bestMatch = i;
      }
    }

    if (bestMatch == -1) {
      return null;
    }

    return VectorDirection.values[bestMatch];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GameBase(
            backgroundColor: Colors.redAccent,
            gameObjects: gameObjects,
          ),

          GameControllers(
            state: controllerState,
            // onUpPressed: () {
            // },
            // onDownPressed: () {
            // },
            // onLeftPressed: () {
            // },
            // onRightPressed: () {
            // },
          )
        ],
      )
    );
  }
}

enum VectorDirection {
  north, west, south, east
}
