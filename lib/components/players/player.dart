import 'dart:async';

import 'package:flame/components.dart';
import 'package:flutter/services.dart';
import 'package:pixel_adventure_game/components/collisions/collision_block.dart';
import 'package:pixel_adventure_game/core/utils/assets.dart';
import 'package:pixel_adventure_game/core/utils/collisions_helper.dart';
import 'package:pixel_adventure_game/main.dart';
import 'package:pixel_adventure_game/pixel_adventure.dart';

/// The player state
enum PlayerState {
  /// The player is double jumping
  doubleJump,

  /// The player is falling
  fall,

  /// The player is getting hit
  hit,

  /// The player is idle
  idle,

  /// The player is jumping
  jump,

  /// The player is running
  run,

  /// The player is wall jumping
  wallJump,
}

/// Player class to store player name and score
class Player extends SpriteAnimationGroupComponent<dynamic>
    with HasGameRef<PixelAdventure>, KeyboardHandler {
  /// Constructor to initialize the player
  Player({
    required this.character,
    required this.playerState,
    super.position,
  });

  /// The player's Character name
  final String character;

  /// The player's state
  PlayerState playerState;

  /// movement speed
  double movementSpeed = 100;

  /// velocity (speed and direction)
  final velocity = Vector2.zero();

  /// The time it takes to go through each frame of the animation
  final stepTime = 0.05;

  /// The horizontal movement
  double horizontalMovement = 0;

  /// The collision blocks
  final List<CollisionBlock> collisionBlocks = [];

  /// The gravity, jump velocity, and terminal velocity
  final double _gravity = 9.8;

  /// The jump velocity
  final double _jumpVelocity = 460;

  /// The terminal velocity
  final double _terminalVelocity = 300;

  /// On ground flag
  bool isOnGround = false;

  /// The idle animation
  late final SpriteAnimation doubleJumpAnimation,
      // ignore: avoid_multiple_declarations_per_line
      fallAnimation,
      hitAnimation,
      idleAnimation,
      jumpAnimation,
      runAnimation,
      wallJumpAnimation;

  @override
  FutureOr<void> onLoad() async {
    _loadAnimation();

    /// debug mode
    debugMode = isDebug;

    return super.onLoad();
  }

  @override
  void update(double dt) {
    _updatePlayerState();
    _updatePlayerMovement(dt);
    _checkHorizontalCollision();
    _checkVerticalCollision();
    _applyGravity(dt);
    super.update(dt);
  }

  @override
  bool onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    horizontalMovement = 0;
    final isLeft = keysPressed.contains(LogicalKeyboardKey.arrowLeft) ||
        keysPressed.contains(LogicalKeyboardKey.keyA);
    final isRight = keysPressed.contains(LogicalKeyboardKey.arrowRight) ||
        keysPressed.contains(LogicalKeyboardKey.keyD);

    horizontalMovement = isRight && isLeft
        ? 0
        : isRight
            ? 1
            : isLeft
                ? -1
                : 0;

    return super.onKeyEvent(event, keysPressed);
  }

  void _loadAnimation() {
    doubleJumpAnimation =
        _animationMethod(Assets.playerDoubleJump(character), 6);

    fallAnimation = _animationMethod(Assets.playerFall(character), 1);

    hitAnimation = _animationMethod(Assets.playerHit(character), 7);

    idleAnimation = _animationMethod(Assets.playerIdle(character), 11);

    jumpAnimation = _animationMethod(Assets.playerJump(character), 1);

    runAnimation = _animationMethod(Assets.playerRun(character), 12);

    wallJumpAnimation = _animationMethod(Assets.playerWallJump(character), 5);

    animations = {
      PlayerState.doubleJump: doubleJumpAnimation,
      PlayerState.fall: fallAnimation,
      PlayerState.hit: hitAnimation,
      PlayerState.idle: idleAnimation,
      PlayerState.jump: jumpAnimation,
      PlayerState.run: runAnimation,
      PlayerState.wallJump: wallJumpAnimation,
    };

    current = playerState;
  }

  SpriteAnimation _animationMethod(
    String asset,
    int amount,
  ) {
    return SpriteAnimation.fromFrameData(
      game.images.fromCache(asset),
      SpriteAnimationData.sequenced(
        amount: amount,
        stepTime: stepTime,
        textureSize: Vector2.all(32),
      ),
    );
  }

  void _updatePlayerMovement(double dt) {
    velocity.x = horizontalMovement * movementSpeed;
    position += velocity * dt;
  }

  void _updatePlayerState() {
    if (velocity.x < 0 && scale.x > 0) {
      flipHorizontallyAroundCenter();
    } else if (velocity.x > 0 && scale.x < 0) {
      flipHorizontallyAroundCenter();
    }
    if (horizontalMovement != 0) {
      current = PlayerState.run;
    } else {
      current = PlayerState.idle;
    }
  }

  void _checkHorizontalCollision() {
    for (final block in collisionBlocks) {
      if (CollisionsHelper.checkCollision(this, block)) {
        if (block.isPlatform) {
        } else {
          if (velocity.x > 0) {
            velocity.x = 0;
            position.x = block.x - width;
            break;
          }
          if (velocity.x < 0) {
            velocity.x = 0;
            position.x = block.x + block.width + width;
            break;
          }
        }
      }
    }
  }

  void _applyGravity(double dt) {
    velocity.y += _gravity;
    velocity.y = velocity.y.clamp(-_jumpVelocity, _terminalVelocity);
    position.y += velocity.y * dt;
  }

  void _checkVerticalCollision() {
    for (final block in collisionBlocks) {
      if (CollisionsHelper.checkCollision(this, block)) {
        if (block.isPlatform) {
        } else {
          if (velocity.y > 0) {
            velocity.y = 0;
            position.y = block.y - width;
            isOnGround = true;
            break;
          }
          if (velocity.y < 0) {
            velocity.y = 0;
            position.y = block.y + block.height + width;
            break;
          }
        }
      }
    }
  }
}
