import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:pixel_adventure_game/components/players/player.dart';

/// Base level class for all levels
abstract class BaseLevel extends World {
  /// constructor
  BaseLevel({
    required this.assetPath,
    required this.player,
  });

  /// The level
  late TiledComponent level;

  /// Asset path for the [level]
  String assetPath;

  /// The player
  Player player;

  @override
  FutureOr<void> onLoad() async {
    level = await TiledComponent.load(assetPath, Vector2.all(16));
    final spawnPoints = level.tileMap.getLayer<ObjectGroup>('spawn_points');
    for (final point in spawnPoints!.objects) {
      switch (point.class_) {
        case 'player':
          player.position = Vector2(point.x, point.y);

        // ignore: no_default_cases
        default:
      }
    }

    await addAll([level, player]);
    return super.onLoad();
  }
}
