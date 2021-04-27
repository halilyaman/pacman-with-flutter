import 'package:flutter_game/collision_system.dart';
import 'package:flutter_game/game_objects.dart';

class EnemyAI {
  List<Actor> _enemies = [];

  void addEnemy(Actor enemy) {
    _enemies.add(enemy);
  }

  VectorDirection _decideMoveDirection() {
    return VectorDirection.east;
  }

  void moveEnemies(double deltaTime, List<GameObject> gameObjects) {
    for (final enemy in _enemies) {
      if (CollisionDetector.checkActorCollisions(enemy, gameObjects)) {
        continue;
      }
      final moveDirection = _decideMoveDirection();
      switch(moveDirection) {
        case VectorDirection.north:
          enemy.moveUp(deltaTime);
          break;
        case VectorDirection.west:
          enemy.moveLeft(deltaTime);
          break;
        case VectorDirection.south:
          enemy.moveDown(deltaTime);
          break;
        case VectorDirection.east:
          enemy.moveRight(deltaTime);
          break;
      }
    }
  }
}