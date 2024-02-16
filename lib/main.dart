import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pixel_adventure_game/pixel_adventure.dart';

void main() {
  initializeFunction();
  final game = PixelAdventure();
  runApp(GameWidget(game: kDebugMode ? PixelAdventure() : game));
}

/// This function run before the game starts.
/// It ensures that the game runs in full screen and landscape mode
void initializeFunction() {
  WidgetsFlutterBinding.ensureInitialized();
  Flame.device.fullScreen();
  Flame.device.setLandscape();
}
