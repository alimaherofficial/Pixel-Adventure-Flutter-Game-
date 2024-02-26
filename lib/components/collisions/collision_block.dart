import 'package:flame/components.dart';
import 'package:pixel_adventure_game/main.dart';

/// A class that represents a collision block.
class CollisionBlock extends PositionComponent {
  /// Constructor
  CollisionBlock({
    required Vector2 position,
    required Vector2 size,
    this.isPlatform = false,
  }) : super(
          position: position,
          size: size,
        ) {
    debugMode = isDebug;
  }

  /// Whether the block is a platform or not.
  final bool isPlatform;
}
