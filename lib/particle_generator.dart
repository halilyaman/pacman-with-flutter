import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_game/game_objects.dart';
import 'package:vector_math/vector_math.dart' as v;

class ParticleGenerator {
  List<GameObject> gameObjects;
  List<Particle> activeParticles = [];
  List<Particle> deadParticles = [];
  int amount;
  int lastUsedParticle = 0;
  Actor actor;
  bool showParticles = false;

  ParticleGenerator(int amount, Actor actor, List<GameObject> gameObjects) {
    this.amount = amount;
    this.actor = actor;
    this.gameObjects = gameObjects;

    for (int i = 0; i < amount; i++) {
      final particle = Particle();
      particle.location = v.Vector2(actor.location.x, actor.location.y);
      particle.xVel = Random().nextDouble() * 200 - 100;
      particle.yVel = Random().nextDouble() * 200 - 100;
      particle.width = 3;
      particle.height = 3;
      particle.color = Colors.red;

      deadParticles.add(particle);
    }
  }

  void update(double deltaTime) {
    if (!showParticles) {
      for (int i = 0; i < activeParticles.length; i++) {
        final particle = activeParticles[i];
        gameObjects.remove(particle);
      }
      return;
    }

    if (activeParticles.length < amount) {
      final particle = deadParticles.removeLast();
      gameObjects.add(particle);
      activeParticles.add(particle);
    }

    for (int i = 0; i < activeParticles.length; i++) {
      final particle = activeParticles[i];
      if (particle.timeALive <= particle.totalTime) {
        particle.location.y -= particle.yVel * deltaTime;
        particle.location.x += particle.xVel * deltaTime;
      } else {
        _resetParticle(particle);
      }
      particle.timeALive += deltaTime;
    }
  }

  void _resetParticle(Particle particle) {
    activeParticles.remove(particle);
    gameObjects.remove(particle);
    particle.location = v.Vector2(actor.location.x, actor.location.y);
    particle.timeALive = 0.0;
    particle.xVel = Random().nextDouble() * 200 - 100;
    particle.yVel = Random().nextDouble() * 200 - 100;
    deadParticles.add(particle);
  }
}