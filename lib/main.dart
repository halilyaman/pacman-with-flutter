import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_game/ai_system.dart';
import 'package:flutter_game/collision_system.dart';
import 'package:flutter_game/game_controllers.dart';
import 'package:flutter_game/map_generator.dart';

import 'game_base.dart';
import 'game_objects.dart';
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
  List<Actor> enemies = [];
  GameControllerState controllerState = GameControllerState();
  DateTime currentTime = DateTime.now();
  DateTime oldTime;
  final mapGenerator = MapGenerator();
  final aiController = EnemyAI();

  @override
  void initState() {
    startGameLoop();
    loadGameComponents();
    super.initState();
  }

  void loadGameComponents() async {
    await Future.delayed(Duration(seconds: 1));

    mapGenerator.generateMap(context, player);

    createPlayer();
    await createEnemies();
    gameObjects.add(player);
    gameObjects.addAll(mapGenerator.map);
    gameObjects.addAll(enemies);
    setState(() {});
  }

  void createPlayer() async {
    player = CircleActor();
    player.location = mapGenerator.playerLocation;
    player.setRadius(15.0);
    player.color = Colors.transparent;
    player.velocity = v.Vector2(300, 300);
    player.rigidBody = true;
    player.isPlayer = true;

    // load assets
    await player.addNewImage("assets/pac-man-up.png", false);
    await player.addNewImage("assets/pac-man-right.png", false);
    await player.addNewImage("assets/pac-man-down.png", false);
    await player.addNewImage("assets/pac-man-left.png", false);
    player.setCurrentImage(player.images[3]);
    setState(() {});
  }

  Future<void> createEnemies() async {
    for (final location in mapGenerator.enemyLocations) {
      final enemy = RectActor();
      enemy.location = location;
      enemy.width = 30.0;
      enemy.height = 30.0;
      enemy.color = Colors.black;
      enemy.velocity = v.Vector2(200, 200);
      enemy.rigidBody = true;
      enemy.isEnemy = true;

      // load assets
      await enemy.addNewImage("assets/enemy-left.png", false);
      await enemy.addNewImage("assets/enemy-right.png", false);
      enemy.setCurrentImage(enemy.images[0]);

      aiController.addEnemy(enemy);
      enemies.add(enemy);
      setState(() {});
    }
  }

  void startGameLoop() {
    Timer.periodic(Duration(milliseconds: 1), (timer) {
      oldTime = currentTime;
      currentTime = DateTime.now();
      final deltaTime = (currentTime.millisecondsSinceEpoch - oldTime.millisecondsSinceEpoch) / 1000;

      if (timer.tick > 5000) {
        handlePlayerMovement(deltaTime);
        aiController.moveEnemies(deltaTime, gameObjects);
        setState(() {});
      } else {
        // optimize rendering in first 2000 tick
        player?.moveRight(deltaTime);
        player?.moveLeft(deltaTime);
      }
    });
  }

  void handlePlayerMovement(double deltaTime) {
    if (CollisionDetector.checkActorCollisions(player, gameObjects)) {
      return;
    }

    if (controllerState.isLeftPressed) {
      player.moveLeft(deltaTime);
      setState(() {});
    }
    if (controllerState.isRightPressed) {
      player.moveRight(deltaTime);
      setState(() {});
    }
    if (controllerState.isUpPressed) {
      player.moveUp(deltaTime);
      setState(() {});
    }
    if (controllerState.isDownPressed) {
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
            backgroundColor: Colors.black,
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
