import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';
import 'package:pixel_adventure_game/actors/player.dart';
import 'package:pixel_adventure_game/core/utils/assets.dart';
import 'package:pixel_adventure_game/levels/levels/level_01.dart';

/// The main game class. This is where the game logic and assets are defined.
class PixelAdventure extends FlameGame
    with HasKeyboardHandlerComponents, DragCallbacks {
  @override
  Color backgroundColor() => const Color(0xFF211f30);

  /// joystick component
  late JoystickComponent joystick;

  /// The first level of the game.
  final level1 = Level01(
    assetPath: Assets.level01,
    player: Player(
      character: 'Pink Man',
      playerState: PlayerState.idle,
    ),
  );

  /// The camera component.
  late final CameraComponent cam;

  @override
  FutureOr<void> onLoad() async {
    await images.loadAllImages();
    cam = CameraComponent.withFixedResolution(
      width: 640,
      height: 360,
      world: level1,
    );
    cam.viewfinder.anchor = Anchor.topLeft;

    await addAll([
      cam,
      level1,
    ]);
   await addJoyStick();

    return super.onLoad();
  }

  // @override
  // void update(double dt) {
  //   updateJoystick(dt);
  //   super.update(dt);
  // }

  /// Add joystick to the game
  Future<void> addJoyStick() async {
    joystick = JoystickComponent(
      knob: SpriteComponent(
        sprite: Sprite(images.fromCache(Assets.joystickKnob)),
      ),
      background: SpriteComponent(
        sprite: Sprite(images.fromCache(Assets.joystick)),
      ),
      margin: const EdgeInsets.only(left: 20, bottom: 20),
    );
    await add(joystick);
  }

  void updateJoystick(double dt) {}
}
