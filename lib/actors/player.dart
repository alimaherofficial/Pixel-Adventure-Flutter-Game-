import 'dart:async';

import 'package:flame/components.dart';
import 'package:flutter/services.dart';
import 'package:pixel_adventure_game/core/utils/assets.dart';
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

/// player direction
enum PlayerDirection {
  /// The player is facing left
  left,

  /// The player is facing right
  right,

  /// The player is not moving
  none,
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

  /// The player's direction
  PlayerDirection playerDirection = PlayerDirection.none;

  /// isFacingRight
  bool isFacingRight = true;

  /// movement speed
  double movementSpeed = 100;

  /// velocity (speed and direction)
  final velocity = Vector2.zero();

  /// The time it takes to go through each frame of the animation
  final stepTime = 0.05;

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

    return super.onLoad();
  }

  @override
  void update(double dt) {
    _updatePlayerMovement(dt);
    super.update(dt);
  }

  @override
  // ignore: deprecated_member_use
  bool onKeyEvent(RawKeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    final isLeft = keysPressed.contains(LogicalKeyboardKey.arrowLeft) ||
        keysPressed.contains(LogicalKeyboardKey.keyA);
    final isRight = keysPressed.contains(LogicalKeyboardKey.arrowRight) ||
        keysPressed.contains(LogicalKeyboardKey.keyD);
    // final isJump = keysPressed.contains(LogicalKeyboardKey.space) ||
    //     keysPressed.contains(LogicalKeyboardKey.arrowUp) ||
    //     keysPressed.contains(LogicalKeyboardKey.keyW);

    if (isLeft && isRight) {
      playerDirection = PlayerDirection.none;
    } else if (isLeft) {
      playerDirection = PlayerDirection.left;
    } else if (isRight) {
      playerDirection = PlayerDirection.right;
    } else {
      playerDirection = PlayerDirection.none;
    }

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
    var dirX = 0.0;
    switch (playerDirection) {
      case PlayerDirection.left:
        if (isFacingRight) {
          flipHorizontallyAroundCenter();
          isFacingRight = false;
        }
        current = PlayerState.run;

        dirX -= movementSpeed;

      case PlayerDirection.right:
        if (!isFacingRight) {
          flipHorizontallyAroundCenter();
          isFacingRight = true;
        }
        current = PlayerState.run;
        dirX += movementSpeed;
      case PlayerDirection.none:
        current = PlayerState.idle;
    }
    velocity.x = dirX;
    position += velocity * dt;
  }
}
