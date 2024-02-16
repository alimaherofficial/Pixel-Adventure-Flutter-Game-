import 'dart:async';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:pixel_adventure_game/levels/base_level/base_level.dart';

/// The main game class. This is where the game logic and assets are defined.
class PixelAdventure extends FlameGame {
  @override
  Color backgroundColor() => const Color(0xFF211f30);

  /// The first level of the game.
  final level = BaseLevel();

  /// The camera component.
  late final CameraComponent cam;

  @override
  FutureOr<void> onLoad() async {
    cam = CameraComponent.withFixedResolution(
      width: 640,
      height: 360,
      world: level,
    );
    cam.viewfinder.anchor = Anchor.topLeft;

    await addAll([cam, level]);
    return super.onLoad();
  }
}
