import 'package:flame/components.dart';

/// A helper class to check for collisions
class CollisionsHelper {
  /// Check if the player is colliding with a block
  static bool checkCollision(
    PositionComponent player,
    PositionComponent block,
  ) {
    final playerX = player.position.x;
    final playerY = player.position.y;
    final playerWidth = player.width;
    final playerHeight = player.height;

    final blockX = block.x;
    final blockY = block.y;
    final blockWidth = block.width;
    final blockHeight = block.height;

    final playerXFix = player.scale.x < 0 ? playerX - playerWidth : playerX;

    return playerY + playerHeight > blockY &&
        playerY < blockY + blockHeight &&
        playerXFix + playerWidth > blockX &&
        playerXFix < blockX + blockWidth;
  }
}
