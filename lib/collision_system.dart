import 'package:vector_math/vector_math.dart' as v;

import 'game_objects.dart';

enum VectorDirection {
  north, west, south, east
}

class CollisionDetector {
  static bool checkActorCollisions(Actor actor, List<GameObject> gameObjects) {
    bool collisionDetected = false;
    for (int i = 0; i < gameObjects.length; i++) {
      var obj = gameObjects[i];

      if (obj.location == actor.location) {
        continue;
      }

      if (obj.rigidBody == false) {
        continue;
      }

      if (obj.isFood && actor.isEnemy) {
        continue;
      }

      if (obj.isEnemy && actor.isPlayer) {
        continue;
      }

      if (obj is RectActor && actor is CircleActor) {
        if (_applyCircleRectangleCollisionCheck(actor, obj)) {
          if (obj.isFood && actor.isPlayer) {
            gameObjects.removeWhere((element) =>
            element.location.x == obj.location.x
                && element.location.y == obj.location.y);
            continue;
          }
          collisionDetected = true;
        }
      }

      if (obj is CircleActor && actor is CircleActor) {
        if (_applyCircleCircleCollisionCheck(actor, obj)) {
          collisionDetected = true;
        }
      }

      if (obj is RectActor && actor is RectActor) {
        if (_applyRectRectCollisionCheck(actor, obj)) {
          collisionDetected = true;
        }
      }
    }

    return collisionDetected;
  }

  static bool _applyRectRectCollisionCheck(RectActor obj1, RectActor obj2) {
    if (obj1.location.x < obj2.location.x + obj2.width
        && obj1.location.x + obj1.width > obj2.location.x
        && obj1.location.y + obj1.height > obj2.location.y
        && obj1.location.y < obj2.location.y + obj2.height) {

      final diff = obj2.center - obj1.center;
      final vectorDir = _calcVectorDirection(diff);

      // horizontal collision
      if (vectorDir == VectorDirection.west || vectorDir == VectorDirection.east) {
        double penetration = obj1.width/2 + obj2.width/2 - diff.x.abs();
        if (vectorDir == VectorDirection.west) {
          obj1.location.x -= penetration;
        } else {
          obj1.location.x += penetration;
        }
      }
      // vertical collision
      else {
        double penetration = obj1.height/2 + obj2.height/2 - diff.y.abs();
        if (vectorDir == VectorDirection.north) {
          obj1.location.y -= penetration;
        } else {
          obj1.location.y += penetration;
        }
      }

      return true;
    }
    return false;
  }

  static bool _applyCircleCircleCollisionCheck(CircleActor obj1, CircleActor obj2) {
    final dist = obj1.location.distanceTo(obj2.location);
    final collisionDetected = dist < obj1.radius + obj2.radius;

    if (collisionDetected) {
      final diff = obj1.location - obj2.location;
      final vectorDir = _calcVectorDirection(diff);
      // horizontal collision
      if (vectorDir == VectorDirection.west || vectorDir == VectorDirection.east) {
        double penetration = obj1.radius - diff.x.abs();
        if (vectorDir == VectorDirection.west) {
          obj1.location.x -= penetration/3;
        } else {
          obj1.location.x += penetration/3;
        }
      }
      // vertical collision
      else {
        double penetration = obj1.radius - diff.y.abs();
        if (vectorDir == VectorDirection.north) {
          obj1.location.y -= penetration/3;
        } else {
          obj1.location.y += penetration/3;
        }
      }
    }
    return collisionDetected;
  }

  static bool _applyCircleRectangleCollisionCheck(CircleActor circleObj, RectActor rectObj) {
    // calculate rectangle's half extent and center
    final rectHalfExtent = v.Vector2(rectObj.width/2, rectObj.height/2);
    final rectCenter = rectObj.center;

    // get difference between both centers
    v.Vector2 diff = circleObj.location - rectCenter;
    final clamped = v.Vector2(diff.x, diff.y);
    clamped.clamp(-rectHalfExtent, rectHalfExtent);
    // add clamped value to objCenter and we get the value of box closest to circle
    final closest = rectCenter + clamped;
    // retrieve vector between center circle and closest point obj and check if length <= radius
    diff = closest - circleObj.location;

    if (diff.length < circleObj.radius) {
      final vectorDir = _calcVectorDirection(diff);

      // horizontal collision
      if (vectorDir == VectorDirection.west || vectorDir == VectorDirection.east) {
        double penetration = circleObj.radius - diff.x.abs();
        if (vectorDir == VectorDirection.west) {
          circleObj.location.x -= penetration;
        } else {
          circleObj.location.x += penetration;
        }
      }
      // vertical collision
      else {
        double penetration = circleObj.radius - diff.y.abs();
        if (vectorDir == VectorDirection.north) {
          circleObj.location.y -= penetration;
        } else {
          circleObj.location.y += penetration;
        }
      }
      return true;
    }

    return false;
  }

  static VectorDirection _calcVectorDirection(v.Vector2 vec) {
    final compass = [
      v.Vector2(0.0, 1.0),
      v.Vector2(1.0, 0.0),
      v.Vector2(0.0, -1.0),
      v.Vector2(-1.0, 0.0),
    ];

    double max = 0.0;
    int bestMatch = -1;
    for (int i = 0; i < 4; i++) {
      double dotProduct = vec.normalized().dot(compass[i]);
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
}

