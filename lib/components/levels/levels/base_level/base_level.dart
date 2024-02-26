import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:pixel_adventure_game/components/collisions/collision_block.dart';
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

  /// List of collision blocks
  final List<CollisionBlock> _collisionBlocks = [];

  @override
  FutureOr<void> onLoad() async {
    level = await TiledComponent.load(assetPath, Vector2.all(16));
    final spawnPoints = level.tileMap.getLayer<ObjectGroup>('spawn_points');
    if (spawnPoints != null) {
      for (final point in spawnPoints.objects) {
        switch (point.class_) {
          case 'player':
            player.position = Vector2(point.x, point.y);

          // ignore: no_default_cases
          default:
        }
      }
    }

    final collisionsLayer = level.tileMap.getLayer<ObjectGroup>('collisions');

    if (collisionsLayer != null) {
      for (final element in collisionsLayer.objects) {
        switch (element.class_) {
          case 'platform':
            final platform = CollisionBlock(
              position: Vector2(element.x, element.y),
              size: Vector2(element.width, element.height),
              isPlatform: true,
            );
            _collisionBlocks.add(platform);

          default:
            final block = CollisionBlock(
              position: Vector2(element.x, element.y),
              size: Vector2(element.width, element.height),
            );
            _collisionBlocks.add(block);
        }
      }
    }
    player.collisionBlocks.addAll(_collisionBlocks);
    await addAll([
      level,
      player,
      ..._collisionBlocks,
    ]);
    return super.onLoad();
  }
}
