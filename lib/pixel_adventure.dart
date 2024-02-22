import 'dart:async';
import 'dart:developer';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flutter/painting.dart';
import 'package:pixel_adventure_game/components/levels/levels/levels/level_01.dart';
import 'package:pixel_adventure_game/components/players/player.dart';
import 'package:pixel_adventure_game/core/utils/assets.dart';

/// The main game class. This is where the game logic and assets are defined.
class PixelAdventure extends FlameGame
    with HasKeyboardHandlerComponents, DragCallbacks {
  /// joystick component
  late JoystickComponent joystick;
  @override
  Color backgroundColor() => const Color(0xFF211f30);

  /// The player of the game.
  static Player player = Player(
    character: 'Pink Man',
    playerState: PlayerState.idle,
  );

  /// The first level of the game.
  static Level01 level1 = Level01(
    assetPath: Assets.level01,
    player: player,
  );

  /// The camera component.
  late final CameraComponent cam;

  /// Show joystick only on mobile
  bool showJoystick = false;

  @override
  FutureOr<void> onLoad() async {
    try {
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
      if (showJoystick) {
        await addJoyStick();
      }
    } catch (e) {
      log(e.toString());
    }

    return super.onLoad();
  }

  @override
  void update(double dt) {
    if (showJoystick) {
      updateJoystick(dt);
    }
    super.update(dt);
  }

  /// Add joystick to the game
  Future<void> addJoyStick() async {
    joystick = JoystickComponent(
      knob: SpriteComponent(
        sprite: Sprite(
          images.fromCache(Assets.joystickKnob),
        ),
      ),
      background: SpriteComponent(
        sprite: Sprite(
          images.fromCache(Assets.joystick),
        ),
      ),
      margin: const EdgeInsets.only(left: 32, bottom: 32),
    );

    await add(joystick);
  }

  /// Handle Joystick movement
  void updateJoystick(double dt) {
    switch (joystick.direction) {
      case JoystickDirection.left:
      case JoystickDirection.upLeft:
      case JoystickDirection.downLeft:
        player.horizontalMovement = -1;

      case JoystickDirection.right:
      case JoystickDirection.upRight:
      case JoystickDirection.downRight:
        player.horizontalMovement = 1;

      // ignore: no_default_cases
      default:
        player.horizontalMovement = 0;
    }
  }
}
