import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_game/collision_system.dart';
import 'package:flutter_game/game_controllers.dart';
import 'package:flutter_game/map_generator.dart';

import 'game_base.dart';
import 'models.dart';
import 'package:vector_math/vector_math.dart' as v;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeRight,
    DeviceOrientation.landscapeLeft,
  ]);

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
  List<GameObject> gameObjects = [];
  CircleActor player;
  GameControllerState controllerState = GameControllerState();
  DateTime currentTime = DateTime.now();
  DateTime oldTime;
  final mapGenerator = MapGenerator();

  @override
  void initState() {
    startGameLoop();
    loadGameComponents();
    super.initState();
  }

  void loadGameComponents() async {
    await Future.delayed(Duration(seconds: 1));
    final screenSize = MediaQuery.of(context).size;

    // create player
    player = CircleActor();
    player.radius = 15;
    player.color = Colors.blue;
    player.velocity = v.Vector2(300, 300);
    player.rigidBody = true;

    final circle = CircleActor();
    circle.radius = 20.0;
    circle.location = v.Vector2(screenSize.width/2 + 100, screenSize.height/2 + 100);
    circle.color = Colors.black;
    circle.velocity = v.Vector2(100, 100);
    circle.rigidBody = true;

    gameObjects.add(player);
    gameObjects.addAll(mapGenerator.generateMap(context, player));

    setState(() {});
  }

  void startGameLoop() {
    Timer.periodic(Duration(milliseconds: 1), (timer) {
      oldTime = currentTime;
      currentTime = DateTime.now();
      final deltaTime = (currentTime.millisecondsSinceEpoch - oldTime.millisecondsSinceEpoch) / 1000;

      handlePlayerMovement(deltaTime);
    });
  }

  void handlePlayerMovement(double deltaTime) {
    if (controllerState.isLeftPressed) {
      if (CollisionDetector.checkCollisionsWithPlayer(player, gameObjects)) {
        return;
      }
      player.moveLeft(deltaTime);
      setState(() {});
    }
    if (controllerState.isRightPressed) {
      if (CollisionDetector.checkCollisionsWithPlayer(player, gameObjects)) {
        return;
      }
      player.moveRight(deltaTime);
      setState(() {});
    }
    if (controllerState.isUpPressed) {
      if (CollisionDetector.checkCollisionsWithPlayer(player, gameObjects)) {
        return;
      }
      player.moveUp(deltaTime);
      setState(() {});
    }
    if (controllerState.isDownPressed) {
      if (CollisionDetector.checkCollisionsWithPlayer(player, gameObjects)) {
        return;
      }
      player.moveDown(deltaTime);
      setState(() {});
    }
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
