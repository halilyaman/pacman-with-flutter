import 'package:vector_math/vector_math.dart' as v;

import 'models.dart';

enum VectorDirection {
  north, west, south, east
}

class CollisionDetector {
  static bool checkCollisionsWithPlayer(CircleActor player, List<GameObject> gameObjects) {
    bool collisionDetected = false;
    for (int i = 1; i < gameObjects.length; i++) {
      var obj = gameObjects[i];

      if (obj.rigidBody == false) {
        return false;
      }

      if (obj is RectActor) {
        if (_applyCircleRectangleCollisionCheck(player, obj)) {
          collisionDetected = true;
        }
      }

      if (obj is CircleActor) {
        if (_applyCircleCircleCollisionCheck(player, obj)) {
          collisionDetected = true;
        }
      }
    }

    return collisionDetected;
  }

  static bool _applyCircleCircleCollisionCheck(CircleActor obj1, CircleActor obj2) {
    final dist = obj1.location.distanceTo(obj2.location);
    final collisionDetected = dist < obj1.radius + obj2.radius;

    if (collisionDetected) {
      final diff = obj2.location - obj1.location;
      final vectorDir = _calcVectorDirection(diff);
      // horizontal collision
      if (vectorDir == VectorDirection.west ||vectorDir == VectorDirection.east) {
        double penetration = obj1.radius - diff.x.abs();
        if (vectorDir == VectorDirection.west) {
          obj1.location.x += penetration;
        } else {
          obj1.location.x -= penetration;
        }
      }
      // vertical collision
      else {
        double penetration = obj1.radius - diff.y.abs();
        if (vectorDir == VectorDirection.north) {
          obj1.location.y += penetration;
        } else {
          obj1.location.y -= penetration;
        }
      }
    }
    return collisionDetected;
  }

  static bool _applyCircleRectangleCollisionCheck(CircleActor circleObj, RectActor rectObj) {
    // calculate rectangle's half extent and center
    final objHalfExtent = v.Vector2(rectObj.width/2, rectObj.height/2);
    final objCenter = v.Vector2(rectObj.location.x + rectObj.width/2, rectObj.location.y + rectObj.height/2);

    // get difference between both centers
    v.Vector2 diff = circleObj.location - objCenter;
    final clamped = v.Vector2(diff.x, diff.y);
    clamped.clamp(-objHalfExtent, objHalfExtent);
    // add clamped value to objCenter and we get the value of box closest to circle
    final closest = objCenter + clamped;
    // retrieve vector between center circle and closest point obj and check if length <= radius
    diff = closest - circleObj.location;

    if (diff.length < circleObj.radius) {
      final vectorDir = _calcVectorDirection(diff);

      // horizontal collision
      if (vectorDir == VectorDirection.west ||vectorDir == VectorDirection.east) {
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

