import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';

/// Base level class for all levels
class BaseLevel extends World {
  /// The level
  late TiledComponent level;
  @override
  FutureOr<void> onLoad() async {
    level = await TiledComponent.load('level-01.tmx', Vector2.all(16));
    add(level);
    return super.onLoad();
  }
}
